//
//  Person.m
//  iOS_KVO
//
//  Created by yuewang on 16/2/20.
//  Copyright © 2016年 yuewang. All rights reserved.
//

#import "PersonForKVO.h"

@implementation PersonForKVO

- (BOOL)validateName:(NSString **)name error:(NSError * __autoreleasing *)outError {
    if ((*name).length == 0) {
        (*name) = @"佚名";
        NSLog(@"%@", (*name));
        return NO;
    }
    return YES;
}

// 如果这个方法没现实就会执行上面的方法
- (BOOL)validateValue:(inout id *)name forKey:(NSString *)inKey error:(out NSError **)outError {
    if ([(*name) length] == 0) {
        (*name) = @"佚名";
        NSLog(@"%@", (*name));
        return NO;
    }
    return YES;
}

@end
