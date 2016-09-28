//
//  ViewController.m
//  NSThreadDemo
//
//  Created by rongfzh on 12-9-23.
//  Copyright (c) 2012年 rongfzh. All rights reserved.
//

#import "NSThreadViewController.h"
#define kURL @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"
@interface NSThreadViewController ()

@end

@implementation NSThreadViewController

- (void)downloadImage:(NSString *)url {
    NSLog(@"%@",[NSThread currentThread]);
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    if(image == nil) {
        
    } else {
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES]; // 进程间通信 withObject:(id)arg, arg 为参数
        
       // [self performSelectorInBackground:@selector(updateUI:) withObject:image]; // 不显示创建线程的方法
    }
}

- (void)updateUI:(UIImage*)image {
    NSLog(@"%@",[NSThread currentThread]);
    self.imageView.image = image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[NSThread currentThread]);
    
 // [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:kURL];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:kURL];
    [thread start];
    
    thread.name = @"dabao";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
