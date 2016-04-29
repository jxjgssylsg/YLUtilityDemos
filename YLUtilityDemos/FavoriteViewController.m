//
//  FavoriteViewController.m
//  NavigationAndTabbar
//
//  Created by Muhamad Rifki on 8/27/13.
//  Copyright (c) 2013 Rifkilabs. All rights reserved.
//

#import "FavoriteViewController.h"
#import "UITabBar+badge.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

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
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.navigationItem.title = @"syl 1"; //
    self.title = @"syl 2"; // 上两个都能设置, 可以换位置试试
   
    // 显示小红点
    [self.tabBarController.tabBar showBadgeOnItemIndex:1 barItemNum:5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
