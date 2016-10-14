//
//  NSObject+AssociatedObject.m
//  RuntimeDemo
//
//  Created by Sam Lau on 7/5/15.
//  Copyright © 2015 Sam Lau. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self, @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
