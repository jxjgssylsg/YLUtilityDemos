//
//  SqliteManager.h
//  SqliteManager
//
//  Created by pg on 16/5/10.
//  Copyright © 2016年 person. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol SqliteManagerDelegate <NSObject>

@required

@property (nonatomic, copy) NSString *uniId;

@end

@interface SqliteManager : NSObject


+ (SqliteManager *)shareManager;

/**
 *  删除表
 *
 *  @param tbName <#tbName description#>
 */
- (void)dropTB:(NSString *)tbName;


/**
 *  清楚表中的记录
 *
 *  @param tbName <#tbName description#>
 */
- (void)cleanTB:(NSString *)tbName;


/**
 *  根据类名创建数据表
 *
 *  @param clss clss 属性必须是简单类型
 *
 *  @return <#return value description#>
 */
- (void)createTBWithClass:(Class)clss;

/**
 *  插入对象
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
- (void)insertModel:(id)model;

/**
 *  多条插入 建议
 *
 *  @param array <#array description#>
 */
- (void)insertModels:(NSArray *)array;

/**
 *  更新单条记录
 *
 *  @param model <#model description#>
 */
- (void)updateWithModel:(id)model;

/**
 *  更新记录
 *
 *  @param clss  <#clss description#>
 *  @param info  <#info description#>
 *  @param uniId <#uniId description#>
 */
- (void)updateWithModel:(id)model updateInfo:(NSDictionary *)info;

/**
 *  根据uniId查询
 *
 *  @param model uniId不能为空
 */
- (void)searchWithModel:(id)model result:(void(^)(id model))result;

/**
 *  查询表所有对象
 *
 *  @param clss   <#clss description#>
 *  @param result <#result description#>
 */
- (void)searchWithClass:(Class)clss result:(void(^)(NSArray* model))result;

/**
 *  删除某个对象
 *
 *  @param model <#model description#>
 */
- (void)deleteWithModel:(id)model;

@end

