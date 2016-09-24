//
//  PthreadViewController.m
//  YLExperimentForOC
//
//  Created by Mr_db on 16/9/14.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#import "PthreadViewController.h"
#import <pthread.h>

@interface PthreadViewController ()

@end

@implementation PthreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/// 点击屏幕创建一个线程
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    pthread_t thread; //创建线程
    NSString *str = @"helloWorld"; //创建参数
    // 参数1  线程编号的地址
    // 参数2  线程的属性
    // 参数3  线程要执行的函数（函数指针）（第三个参数可以，demo，*demo, 一般用&demo）
    // 参数4  线程要执行的函数的参数
    int result = pthread_create(&thread, NULL, &demo, (__bridge void *)(str));
    // __bridge  oc类型到c语言类型的一个转换
    // void *p = (__bridge void *)(str);
    
    // 扩展：打印PThread类型的栈空间的大小
    size_t stack_size = pthread_get_stacksize_np(thread);
    NSLog(@"stack_size: %zu", stack_size);
    NSLog(@"over %d",result);
}

/// 线程要执行的函数  传参数
void *(demo)(void *param) {
    NSString *str = (__bridge NSString *)(param);
    NSLog(@"%@",str);
    
    NSLog(@"%@", [NSThread currentThread]);
    pthread_exit(0);
    return NULL;
}

@end
