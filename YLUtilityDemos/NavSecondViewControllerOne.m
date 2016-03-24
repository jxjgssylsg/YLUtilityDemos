//
//  SecondViewController.m
//  NavigationControllerDemo
//
//  Created by liumingbo on 12-12-27.
//  Copyright (c) 2012年 com.chinahayrek. All rights reserved.
//

#import "NavSecondViewControllerOne.h"

@interface NavSecondViewControllerOne () {
    UIToolbar *_toolBar;
}

@end

@implementation NavSecondViewControllerOne

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setToolbarHidden:YES animated:YES];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCamera target:self action:@selector(goThirdView:)];
     _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - _toolBar.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];
    
    [_toolBar setBarStyle:UIBarStyleDefault];
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_toolBar setItems:[NSArray arrayWithObject:addButton]];
    [self.view addSubview:_toolBar];

}

- (void)goThirdView:(id)sender {
    NSLog(@"hahahhaha third ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
