//
//  DataModel.h
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/17.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * icon;
@property (nonatomic,copy) NSString * text;
@property (nonatomic,assign) BOOL vip;
@property (nonatomic,copy) NSString * picture;

+ (instancetype)DataModelWithDict:(NSDictionary *)dict;
@end
