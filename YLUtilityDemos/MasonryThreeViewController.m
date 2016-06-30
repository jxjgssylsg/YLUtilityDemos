//
//  ViewController2.m
//  MasonryDemo
//
//  Created by TangJR on 15/4/29.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "MasonryThreeViewController.h"
#import "Masonry.h"

@interface MasonryThreeViewController ()

@end

@implementation MasonryThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化黑色view
    UIView *blackView = [UIView new];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView]; // 必须先要先加入父 View
    
    // 给黑色view添加约束
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(100, 100));
        // 添加左、上边距约束（左、上约束都是20, 注意
        make.left.and.top.mas_equalTo(20);
    }];
    
    
    // 初始化灰色view
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:grayView];
    
    // 给灰色 view 添加约束
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 大小、上边距约束与黑色 view 相同
        make.size.and.top.equalTo(blackView);
        // 添加右边距约束（这里的间距是有方向性的，左、上边距约束为正数，右、下边距约束为负数）
        make.right.mas_equalTo(-20);
    }];
    
}

@end