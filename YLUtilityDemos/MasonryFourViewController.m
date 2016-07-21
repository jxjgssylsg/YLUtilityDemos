//
//  ViewController3.m
//  MasonryDemo
//
//  Created by TangJR on 15/4/29.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "MasonryFourViewController.h"
#import "Masonry.h"

@interface MasonryFourViewController ()

@end

@implementation MasonryFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化黑色 view
    UIView *blackView = [UIView new];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
    // 给黑色 view 添加约束
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左、上边距约束
        make.left.and.top.mas_equalTo(20);
        // 添加右边距约束
        make.right.mas_equalTo(-20);
    }];
    
    // 初始化灰色 view
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:grayView];
    
    // 给灰色 view 添加约束
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加右、下边距约束
        make.bottom.and.right.mas_equalTo(-20);
        // 添加高度约束，让高度等于黑色 view
        make.height.equalTo(blackView);
        // 添加上边距约束（上边距 = 黑色view的下边框 + 偏移量20）
        make.top.equalTo(blackView.mas_bottom).offset(20);
        // 添加左边距（左边距 = 父容器纵轴中心 + 偏移量0）
        make.left.equalTo(self.view.mas_centerX).offset(0);
    }];
}

@end
