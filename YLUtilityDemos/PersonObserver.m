//
//  PersonObserver.m
//  iOS_KVO
//
//  Created by yuewang on 16/2/20.
//  Copyright © 2016年 yuewang. All rights reserved.
//

#import "PersonObserver.h"

@implementation PersonObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 因为 option 是 (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
    NSLog(@"old: %@", [change objectForKey:@"old"]);
    NSLog(@"new: %@", [change objectForKey:@"new"]);
    NSLog(@"context: %@", context);
}

@end
