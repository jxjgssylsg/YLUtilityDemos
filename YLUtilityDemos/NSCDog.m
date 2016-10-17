//
//  NSCDog.m
//  NSCoding
//
//  Created by Hannibal Yang on 12/6/14.
//  Copyright (c) 2014 Hannibal Yang. All rights reserved.
//

#import "NSCDog.h"

@implementation NSCDog

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder]; // 调用父类的 encode 先
    [aCoder encodeInt:_legs forKey:@"legs"];
    NSLog(@"NSCDog encodeWithCoder");
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) { // 先对父类解码
        NSLog(@"NSCDog initWithCoder");
        _legs = [aDecoder decodeIntForKey:@"legs"];
    }
    return self;
}

@end
