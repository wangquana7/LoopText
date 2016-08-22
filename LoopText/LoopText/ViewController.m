//
//  ViewController.m
//  LoopText
//
//  Created by zhangju on 16/8/22.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "ViewController.h"
#import "TextFlowView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TextFlowView * flowView = [[TextFlowView alloc]initWithFrame:CGRectMake(0, 100, 414, 30) Text:@"6月14日消息,在今天苹果WWDC开发者大会上,苹果带来了新的iOS系统——iOS 10。1. 新的屏幕通知查看方式:苹果为iOS 10带来了全新..."];
    
    
    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 414, 250)];
    scroll.contentSize = CGSizeMake(0, 400);
    [self.view addSubview:scroll];
    
    [scroll addSubview:flowView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
