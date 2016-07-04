//
//  ScrollViewSeven.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/27.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "ScrollViewSeven.h"

@implementation ScrollViewSeven
// 触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"- - - - ScrollView touchesBegan - - - -");
    // 可以接着调用 cell 的触摸事件
    // [self.tableViewCell touchesBegan: touches withEvent: event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"- - - -ScrollView touchesEnded - - - -");
    // [self.tableViewCell touchesEnded:touches withEvent: event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"- - - -ScrollView touchesMoved - - - -");
   // [self.tableViewCell touchesMoved:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"- - - ScrollView touchesCancelled - - - -");
    // [self.tableViewCell touchesCancelled:touches withEvent:event];
}

@end
