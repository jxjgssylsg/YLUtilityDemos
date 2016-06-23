//
//  ViewController.m
//  MasonryDemo
//
//  Created by TangJR on 15/4/29.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "MasonryTwoViewController.h"
#import "Masonry.h"

@interface MasonryTwoViewController ()

@end

@implementation MasonryTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化view并设置背景
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    // 使用 mas_makeConstraints 添加约束
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(100, 100)); // size 优先级感觉很低
        // 添加居中约束（居中方式与 self 相同）
        make.center.equalTo(self.view);
    }];
 
/* syl
 
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        // add size constrains
        make.left.mas_equalTo(20); // 感觉 center 的优先级更高
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.top.mas_equalTo(self.view.mas_top).offset(10);
     
        make.size.mas_equalTo(CGSizeMake(100, 100)); // size 优先级感觉很低
    }];
 */
}

@end