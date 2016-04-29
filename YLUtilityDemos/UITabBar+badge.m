//
//  UITabBar+badge.m
//  NavigationAndTabbar
//
//  Created by mingdffe on 16/8/15.
//  Copyright © 2016年 Rifkilabs. All rights reserved.
//

#import "UITabBar+badge.h"
// #define TabbarItemNums 5.0  // tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (badge)
// 显示小红点
- (void)showBadgeOnItemIndex:(int)index barItemNum:(int)itemNum {
    // 移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    // 新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5; // 圆形
    badgeView.backgroundColor = [UIColor redColor]; // 颜色：红色
    CGRect tabFrame = self.frame;
    
    // 确定小红点的位置
    float percentX = (index + 0.6) / itemNum;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10); // 圆形大小为 10
    [self addSubview:badgeView];
}

// 隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index {
    // 移除小红点
    [self removeBadgeOnItemIndex:index];
}

// 移除小红点
- (void)removeBadgeOnItemIndex:(int)index {
    // 按照 tag 值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end