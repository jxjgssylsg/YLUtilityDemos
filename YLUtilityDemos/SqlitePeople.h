//
//  People.h
//  SqliteManager
//
//  Created by pg on 16/5/10.
//  Copyright © 2016年 person. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteManager.h"

// 学校
@interface SqliteSchool : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@end

// 个人
@interface SqlitePeople : NSObject <SqliteManagerDelegate>

@property (nonatomic, copy) NSString *uniId; // 主键

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL isOld;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, strong) SqliteSchool *school;
@end

@interface SqlitePeople (test)

@property (nonatomic, copy) NSString *desc;  // 分类不能增加属性

@end