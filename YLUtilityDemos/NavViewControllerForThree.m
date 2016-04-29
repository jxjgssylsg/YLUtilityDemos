//
//  ViewController.m
//  UIScreenEdgePanGestureRecognizer
//
//  Created by Jazys on 15/3/25.
//  Copyright (c) 2015年 Jazys. All rights reserved.
//

#import "NavViewControllerForThree.h"

@interface NavViewControllerForThree () <UINavigationControllerDelegate>
@end

@implementation NavViewControllerForThree

- (void)viewDidLoad {
     NSLog(@"view did load");
   // [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"%s", __func__);
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"%s", __func__);
}
@end
