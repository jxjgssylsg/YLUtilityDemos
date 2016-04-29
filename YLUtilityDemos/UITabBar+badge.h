//
//  UITabBar+badge.h
//  NavigationAndTabbar
//
//  Created by mingdffe on 16/8/15.
//  Copyright © 2016年 Rifkilabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index barItemNum:(int)itemNum; // 显示小红点

- (void)hideBadgeOnItemIndex:(int)index;   // 隐藏小红点

@end