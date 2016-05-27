
//  YLExperimentForOC
//
//  Created by syl on 16/4/26.
//  Copyright © 2016年 yilin. All rights reserved.
//


#import "NSTimer+BFEExtension.h"

@implementation NSTimer (BFEExtension)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                   callback:(TimeOut)callback {
  NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                          target:self
                                        selector:@selector(onTimerUpdateBlock:)
                                        userInfo:[callback copy]
                                         repeats:repeats];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // runloopMode
  return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      count:(NSInteger)count
                                   callback:(TimeOut)callback {
  if (count <= 0) {
    return [self scheduledTimerWithTimeInterval:interval repeats:YES callback:callback];
  }
  
  NSDictionary *userInfo = @{@"callback"     : [callback copy],
                             @"count"        : @(count)};
  NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                          target:self
                                        selector:@selector(onTimerUpdateCountBlock:)
                                        userInfo:userInfo
                                         repeats:YES];
 [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // runloopMode
    return timer;
}

+ (void)onTimerUpdateBlock:(NSTimer *)timer {
  TimeOut block = timer.userInfo;
  
  if (block) {
    block();
  }
}

+ (void)onTimerUpdateCountBlock:(NSTimer *)timer {
  static NSUInteger currentCount = 0;
  
  NSDictionary *userInfo = timer.userInfo;
  TimeOut callback = userInfo[@"callback"];
  NSNumber *count = userInfo[@"count"];
  
  if (currentCount < count.integerValue) {
    currentCount++;
    if (callback) {
      callback();
    }
  } else {
    currentCount = 0;
    [timer unfireTimer];
  }
}

- (void)fireTimer {
  [self setFireDate:[NSDate distantPast]];
}

- (void)unfireTimer {
  [self setFireDate:[NSDate distantFuture]];
}

- (void)invalid {
  if (self.isValid) {
    [self invalidate];
  }
}

@end
