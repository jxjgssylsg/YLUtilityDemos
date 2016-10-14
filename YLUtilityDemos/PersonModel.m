//
//  PersonModel.m
//  DemoRuntime
//
//  Created by Chris Hu on 16/7/25.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "PersonModel.h"
#import <objc/runtime.h>

@implementation PersonModel

- (instancetype)initWithNSDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self prepareModel:dict];
    }
    return self;
}

- (void)prepareModel:(NSDictionary *)dict {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    u_int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *propertyCString = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:propertyCString encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    
    for (NSString *key in keys) {
        if ([dict valueForKey:key]) {
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
}

@end
