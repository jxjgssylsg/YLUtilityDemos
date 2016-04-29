//
//  SettingViewController.m
//  NavigationAndTabbar
//
//  Created by Muhamad Rifki on 8/27/13.
//  Copyright (c) 2013 Rifkilabs. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
    NSString *passWordsss = [user1 objectForKey:@"userPassWord"];
    NSLog(@"%@", passWordsss);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 释放
- (void)dealloc {
    NSLog(@"hahahhaha----dealloc");
}

- (void)Timer:(NSTimer *)timer {
    //    self.number++;
    //    self.timeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.number];
    //
    //    // 修改NSTimer的 run loop
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    //    /*
    //     *或者
    //     *[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //     */
    NSLog(@"每一秒 执行一次噢");
}

@end
