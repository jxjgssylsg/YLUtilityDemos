//
//  NSOperationViewController.m
//  YLExperimentForOC
//
//  Created by Mr_db on 16/9/19.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#import "NSOperationViewController.h"
#define kURL @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"
@interface NSOperationViewController ()

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self
                                                                           selector:@selector(downloadImage:)
                                                                             object:kURL];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}
- (void)downloadImage:(NSString *)url {
    NSLog(@"url:%@", url);
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSData *data = [[NSData alloc]initWithContentsOfURL:nsUrl];
    UIImage * image = [[UIImage alloc]initWithData:data];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}

-(void)updateUI:(UIImage*)image {
    NSLog(@"download finish and updateUI");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
