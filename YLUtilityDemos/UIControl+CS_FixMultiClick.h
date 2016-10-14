//
//  UIControl+CS_FixMultiClick.h
//  DemoRuntime
//
//  Created by Chris Hu on 16/06/28.
//  Copyright © 2015年 icetime17. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIButton (CS_FixMultiClick)

@property (nonatomic, assign) NSTimeInterval cs_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval cs_acceptEventTime;

@end