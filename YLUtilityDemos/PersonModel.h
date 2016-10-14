//
//  PersonModel.h
//  DemoRuntime
//
//  Created by Chris Hu on 16/7/25.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *job;

- (instancetype)initWithNSDictionary:(NSDictionary *)dict;

@end
