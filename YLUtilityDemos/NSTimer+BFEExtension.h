//  YLExperimentForOC
//
//  Created by syl on 16/4/26.
//  Copyright © 2016年 yilin. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSTimer (BFEExtension)

 // 间隔时间后调用的Block
typedef void (^TimeOut)(void);

// 参数 interval:间隔 repeats:是否重复 callback:回调
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                   callback:(TimeOut)callback;

// 参数 count:调用次数
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      count:(NSInteger)count
                                   callback:(TimeOut)callback;
// 开启
- (void)fireTimer;

// 暂停
- (void)unfireTimer;

// 设置成无效
- (void)invalid;

@end
