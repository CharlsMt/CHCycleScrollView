//
//  ViewController.m
//  CHCycleScrollView
//
//  Created by 陈浩 on 2018/4/16.
//  Copyright © 2018年 charls. All rights reserved.
//

#import "ViewController.h"
#import "CHCycleScrollView.h"
@interface ViewController ()<CHCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    CHCycleScrollView *cycleScrollView = [[CHCycleScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) imageGroups:@[@"h1",@"h2",@"h3",@"h4"]];
    
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
}


-(void)cycleScrollView:(CHCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"index = %ld",index);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
