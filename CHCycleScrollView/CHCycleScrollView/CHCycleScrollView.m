//
//  CHCycleScrollView.m
//  无限滚动demo
//
//  Created by 陈浩 on 2018/4/16.
//  Copyright © 2018年 陈浩. All rights reserved.
//

#import "CHCycleScrollView.h"
#define UIScreenW [UIScreen mainScreen].bounds.size.width

@interface CHCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) NSTimer *timer;    //   定时器
@property (nonatomic,assign) CGFloat oldContentOffsetX;
@property (nonatomic,strong) NSArray *imgArr;//图片数组

@end
@implementation CHCycleScrollView


-(instancetype)initWithFrame:(CGRect)frame imageGroups:(NSArray<NSString *> *)imageGroups{
    if (self = [super initWithFrame:frame]) {
    
        _imgArr = imageGroups;
        
        [self initView];
        
    }
    return self;
}

-(void)initView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;

    for (int i = 0; i< _imgArr.count +1; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenW *i), 0, UIScreenW, self.frame.size.height)];
        imgView.tag = i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [imgView addGestureRecognizer:tap];
        // 2. 设置图片
        NSString *imageName ;
        if (i == _imgArr.count) {
            
            imageName = _imgArr[0];
        }else
        {
            imageName = _imgArr[i];
            
        }
        
        imgView.image = [UIImage imageNamed:imageName];
        
        // 3. 添加imageView 到 scrollView上
        [self.scrollView addSubview:imgView];
        
    }
    // 设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * (_imgArr.count + 1), 0);
    
    // 隐藏水平滚动指示器
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置分页属性
    // 分页是通过 scrollView的width 来确定，这样的话，当滑动的时候，图片被滑动一半的时候，图片会立即切换成新的图片
    self.scrollView.pagingEnabled = YES;
    
    [self addSubview:self.scrollView];
    // UIPageControl
    
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.center = CGPointMake(UIScreenW/2, self.frame.size.height -10);
    // 设置显示几个点
    self.pageControl.numberOfPages = _imgArr.count;
    
    // 当前在第几个点
    self.pageControl.currentPage = 0;
    
    // 指示器的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:240/255.0 alpha:1];
    
    // 设置 当前页码指示器颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.pageControl];
   
    // 创建一个定时器
    [self startTimer];
    
    
}

- (void)startTimer {
    // scheduled 计划
    /**
     scheduledTimerWithTimeInterval 间隔
     target     通过谁调用下面的方法
     selector   方法
     userInfo  : 传递的参数
     repeats : 是否重复执行 方法
     */
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                              target:self
                                            selector:@selector(changeImage)
                                            userInfo:nil
                                             repeats:YES];
    
    // 调整timer 的优先级
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    
    [mainLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}



-(void)tapGesture:(UITapGestureRecognizer *)tap{

    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:tap.view.tag];
    }
}


- (void)changeImage {
    [self.scrollView setContentOffset:CGPointMake((self.pageControl.currentPage+1)*UIScreenW, 0) animated:YES];
}
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point = scrollView.contentOffset;
    
    BOOL isRight = self.oldContentOffsetX < point.x;
    self.oldContentOffsetX = point.x;
    // 开始显示最后一张图片的时候切换到第二个图
    if (point.x > UIScreenW*(_imgArr.count-1)+UIScreenW*0.5 && !self.timer) {//从最后一个图片会到第一个图片
        self.pageControl.currentPage = 0;
    }else if (point.x > UIScreenW*(_imgArr.count -1) && self.timer && isRight){
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = (point.x + UIScreenW*0.5) / UIScreenW;
    }
    // 开始显示第一张图片的时候切换到倒数第二个图
    if (point.x >= UIScreenW *_imgArr.count) {
        //kScrollViewWidth+point.x-kScrollViewWidth*(self.count+1)
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else if (point.x < 0) {
        [scrollView setContentOffset:CGPointMake(point.x+UIScreenW*_imgArr.count, 0) animated:NO];
    }
    
}

/**
 手指开始拖动的时候, 就让计时器停止
 invalidate  无效
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 让计时器无效
    //    [_timer invalidate];
    [self stopTimer];
}

/**
 手指离开屏幕的时候, 就让计时器开始工作
 */

//scrollViewDidEndDragging应该是用这个方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // 让计时器开始工作
    // fire , 马上执行, 方法, 不会等间隔时间
    // 如果 timer 调用了 invalidate 方法, time就不存在了, 需要再次创建
    //    [_timer fire];
    [self startTimer];
    
}



@end
