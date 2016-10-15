//
//  ViewController.m
//  iOS_KVO
//
//  Created by yuewang on 16/2/20.
//  Copyright © 2016年 yuewang. All rights reserved.
//

#import "KVOViewControllerTwo.h"
#import "PersonObserver.h"
#import "PersonForKVO.h"

@interface KVOViewControllerTwo ()

@end

@implementation KVOViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PersonForKVO *person = [[PersonForKVO alloc] init];
    person.name = @"张三";
    person.age = 20;
    person.sex = @"male";
    
    PersonObserver *pObserver = [[PersonObserver alloc] init];
    
    [person addObserver:pObserver forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"this is a context"];
    
//    NSString *name = @"";
    NSString *name = @"李四";
    NSString *key = @"name";
    BOOL isLegalName = [person validateValue:&name forKey:key error:nil];
    
    if (isLegalName) {
        NSLog(@"It's a legal name");
        [person setValue:name forKey:key];
    } else {
        NSLog(@"It's a illegal name");
    }
    
    [person removeObserver:pObserver forKeyPath:@"name"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
