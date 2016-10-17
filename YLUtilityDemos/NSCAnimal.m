//
//  NSCAnimal.m
//  NSCoding
//
//  Created by Hannibal Yang on 12/6/14.
//  Copyright (c) 2014 Hannibal Yang. All rights reserved.
//

#import "NSCAnimal.h"

@implementation NSCAnimal

/*
 1> 能将任何遵守了 <NSCoding> 协议的对象塞进文件中
 2> - (void)encodeWithCoder:(NSCoder *)aCoder
 * 将对象归档的时候会调用（将对象写入文件之前会调用）
 // 在这个方法说清楚：
 // 1.哪些属性需要存储
 // 2.怎样存储这些属性
 
 3> - (id)initWithCoder:(NSCoder *)aDecoder
 * 当从文件中解析对象时调用
 // 在这个方法说清楚：
 // 1.哪些属性需要解析（读取）
 // 2.怎样解析（读取）这些属性

 4> 如果父类中也有属性需要归档或者读档，必须调用 super 的encodeWithCoder:和initWithCoder:方法
 */

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:_furColor forKey:@"color"];
    [aCoder encodeDouble:_weight forKey:@"weight"];
    [aCoder encodeBool:_isFly forKey:@"fly"];
    NSLog(@"NSCAnimal encodeWithCoder");
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {
        NSLog(@"NSCAnimal initWithCoder");
        _furColor = [aDecoder decodeObjectForKey:@"color"];
        _weight = [aDecoder decodeDoubleForKey:@"weight"];
        _isFly = [aDecoder decodeBoolForKey:@"fly"];
    }
    return self;
}

@end
