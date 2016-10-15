//
//  SecondViewController.m
//  关于NSNotificationCenter的探讨
//
//  Created by yifan on 15/9/16.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "NotificationCenterSecondViewController.h"
#import "NotificationObserver.h"

static NSString *TEST_NOTIFICATION1 = @"TEST_NOTIFICATION1";
@interface NotificationCenterSecondViewController ()

@end

@implementation NotificationCenterSecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createObserver];
     [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION1 object:nil];
}
- (void)createObserver {
    // 这个对象犹豫被通知中心引用了，所以他没有被卸载
    NotificationObserver *observer = [[NotificationObserver alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
