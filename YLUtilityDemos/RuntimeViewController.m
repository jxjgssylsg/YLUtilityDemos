//
//  ViewController.m
//  RuntimeDemo
//
//  Created by Sam Lau on 7/5/15.
//  Copyright © 2015 Sam Lau. All rights reserved.
//

#import "RuntimeViewController.h"
#import "Message.h"
#import "NSObject+AssociatedObject.h"

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Message *message = [Message new];
    [message sendMessage:@"Sam Lau"];
    
    NSObject *objc = [NSObject new];
    objc.associatedObject = @"Extend Category";
    NSLog(@"associatedObject is = %@", objc.associatedObject);
}

@end
