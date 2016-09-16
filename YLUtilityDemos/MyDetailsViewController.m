//
//  MKDetailsViewController.m
//  CollectionViewTest
//
//  Created by Mugunth on 4/9/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training. All rights reserved.
//

#import "MyDetailsViewController.h"

@interface MyDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MyDetailsViewController

-(IBAction) doneTapped:(id) sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:@"image"];
}

@end
