
//
//  SqliteManager.m
//  SqliteManager
//
//  Created by pg on 16/5/10.
//  Copyright © 2016年 person. All rights reserved.
//

#import "SqliteManager.h"
#import <sqlite3.h>
#import <objc/runtime.h>

#define tb_dic_name  @"db.sqlite"
#define tb_primary_key @"uniId"

static char *dispatch = "sqliteManager";

@interface SqliteManager () {
    sqlite3  *sqliteManager;
    dispatch_queue_t sql_exec_queue;
}
@end

@implementation SqliteManager

+ (SqliteManager *)shareManager {
    static SqliteManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SqliteManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        sql_exec_queue = dispatch_queue_create(dispatch, DISPATCH_QUEUE_SERIAL);
        [self open];
    }
    return self;
}

// 获取缓存路径
- (NSString *)cachePath {
    NSArray *pathcaches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory
                                                                 , NSUserDomainMask
                                                                 , YES);
    NSString* pathcache  = [pathcaches objectAtIndex:0];
    return pathcache;
}

// 增加自定义文件夹
- (NSString *)datasourcePath {
    NSString *cachePath = [self cachePath];
    return [cachePath stringByAppendingPathComponent:tb_dic_name];
}


// 是否存在文件
- (BOOL)isExistFileAtPath:(NSString *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

// 成员变量列表
- (NSArray *)getIvarsOfClass:(Class)cls {
    unsigned int outCount = 0; // 指定类实例变量的数目
    NSMutableArray *data = [[NSMutableArray alloc]init];
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (const Ivar *p=ivars; p < ivars+outCount; p++) {
        Ivar const ivar= *p;
        const char *name = ivar_getName(ivar);
        [data addObject:[NSString stringWithUTF8String:name]];
    }
    free(ivars); //
    return data;
}

#pragma mark - create

- (void)dropTB:(NSString *)tbName {
    NSString *sql = [NSString stringWithFormat:@"drop table %@", tbName];
    [self execSql:sql];
}

- (void)cleanTB:(NSString *)tbName {
    NSString *sql = [NSString stringWithFormat:@"delete from %@", tbName];
    [self execSql:sql];
}

- (void)createTBWithClass:(Class)clss {
    NSString *tbName = NSStringFromClass(clss);
    NSArray *properties = [self getIvarsOfClass:clss];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS  %@ (",tbName];
    for (NSString *property in properties) {
        NSString *desc = [NSString stringWithFormat:@" %@ TEXT DEFAULT '',",property];
        if ([property isEqualToString:tb_primary_key]) {
            desc = [NSString stringWithFormat:@" %@ TEXT PRIMARY KEY,",property];
        }
        sql = [sql stringByAppendingString:desc];
    }
    sql = [sql stringByReplacingCharactersInRange:NSMakeRange(sql.length - 1, 1) withString:@")"];
    [self execSql:sql];
}

// 单条插入
- (void)insertModel:(id)model {
    [self execSql:[self sqlOfInsertModel:model]];
}

// 多条插入
- (void)insertModels:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    NSMutableArray *sqlArray = [[NSMutableArray alloc]init];
    for (id model in array) {
        [sqlArray addObject:[self sqlOfInsertModel:model]];
    }
    [self execInsertTransactionSql:sqlArray];
}

- (NSString *)sqlOfInsertModel:(id)model {
    NSString *tbName = NSStringFromClass([model class]);
    NSArray *properties = [self getIvarsOfClass:[model class]];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO  %@ (",tbName];
    for (NSString *property in properties) {
        NSString *desc = [NSString stringWithFormat:@" '%@' ,",property];
        sql = [sql stringByAppendingString:desc];
    }
    sql = [sql stringByReplacingCharactersInRange:NSMakeRange(sql.length - 1, 1) withString:@") VALUES ("];
    for (NSString *property in properties ) {
        NSString *desc = [NSString stringWithFormat:@"'%@',", [model valueForKey:property]];
        sql = [sql stringByAppendingString:desc];
    }
    sql = [sql stringByReplacingCharactersInRange:NSMakeRange(sql.length - 1, 1) withString:@")"];
    return sql;
}

// 更新数据
- (void)updateWithModel:(id)model {
    NSArray *properties = [self getIvarsOfClass:[model class]];
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    for (NSString *property in properties) {
        [info setObject:[model valueForKey:property] forKey:property];
    }
    [self updateWithModel:model updateInfo:info];
}

- (void)updateWithModel:(id)model updateInfo:(NSDictionary *)info {
    NSString *tbName = NSStringFromClass([model class]);
    NSString *sql = [NSString stringWithFormat:@"update %@  set ", tbName ];
    for (NSString *key in info.allKeys) {
        NSString *desc = [NSString stringWithFormat:@"%@ = '%@' ,", key, [info objectForKey:key]];
        sql = [sql stringByAppendingString:desc];
    }
    sql = [sql substringToIndex:sql.length -2];
    sql = [NSString stringWithFormat:@"%@ where _uniId = '%@'", sql, [model uniId]];
    [self execSql:sql];
}

- (void)deleteWithModel:(id)model {
    NSString *tbName = NSStringFromClass([model class]);
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where _uniId = '%@'", tbName, [model uniId]];
    [self execSql:sql];
}

// 查询单条记录
- (void)searchWithModel:(id)model result:(void(^)(id model))result {
    NSString *tbName = NSStringFromClass([model class]);
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where _uniId = '%@'",tbName, [model valueForKey:@"uniId"]];
    void (^success)(NSArray *model) = ^(NSArray *array) {
        if (array.count > 0) {
            result(array[0]);
        } else {
            result(nil);
        }
    };
    [self searchTB:tbName withSql:sql result:success];
}

- (void)searchWithClass:(Class)clss result:(void(^)(NSArray* model))result {
    NSString *tbName = NSStringFromClass(clss);
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tbName];
    [self searchTB:tbName withSql:sql result:result];
}

- (void)searchTB:(NSString *)tbName withSql:(NSString *)sql result:(void(^)(id model))result {
    __block typeof(self) weakSelf = self;
    dispatch_async(sql_exec_queue, ^{
        [weakSelf open];
        sqlite3_stmt * statement;
        Class clss = NSClassFromString(tbName);
        NSArray *properties = [self getIvarsOfClass:clss];
        NSMutableArray *modelArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(sqliteManager, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                id searchModel = [[clss alloc]init];
                for (int i = 0; i<properties.count; i++) {
                    char *textChar = (char*)sqlite3_column_text(statement, i);
                    NSString *textValue = [[NSString alloc]initWithUTF8String:textChar];
                    [searchModel setValue:textValue forKey:properties[i]];
                }
                [modelArray addObject:searchModel];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                result(modelArray);
            });
        }
        [weakSelf close];
    });
}

// 执行插入事务语句
- (void)execInsertTransactionSql:(NSMutableArray *)transactionSql {
    __block typeof(self) weakSelf = self;
    dispatch_async(sql_exec_queue, ^{
        [weakSelf open];
        // 使用事务，提交插入 sql 语句
        @try{
            char *errorMsg;
            if (sqlite3_exec(sqliteManager, "BEGIN", NULL, NULL, &errorMsg) == SQLITE_OK) {
                NSLog(@"启动事务成功");
                sqlite3_free(errorMsg);
                sqlite3_stmt *statement;
                for (int i = 0; i < transactionSql.count; i++) {
                    if (sqlite3_prepare_v2(sqliteManager,[[transactionSql objectAtIndex:i] UTF8String], -1, &statement,NULL) == SQLITE_OK) {
                        if (sqlite3_step(statement)!=SQLITE_DONE) sqlite3_finalize(statement);
                    }
                }
                if (sqlite3_exec(sqliteManager, "COMMIT", NULL, NULL, &errorMsg) == SQLITE_OK)   NSLog(@"提交事务成功");
                sqlite3_free(errorMsg);
            }
            else sqlite3_free(errorMsg);
        }
        @catch(NSException *e) {
            char *errorMsg;
            if (sqlite3_exec(sqliteManager, "ROLLBACK", NULL, NULL, &errorMsg) == SQLITE_OK)  NSLog(@"回滚事务成功");
            sqlite3_free(errorMsg);
        }
        @finally {
            [weakSelf close];
        }
    });
}

// 执行 sql 语句
- (void)execSql:(NSString *)sql {
    __block typeof(self) weakSelf = self;
    dispatch_async(sql_exec_queue, ^{
        [weakSelf open];
        char *err;
        if (sqlite3_exec(sqliteManager, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(sqliteManager);
            NSLog(@"数据库操作数据失败: %s", err);
        } else {
            NSLog(@"操作成功");
        }
        [weakSelf close];
    });
}

- (BOOL)open {
    NSString *dbPath = [self datasourcePath];
    if(sqlite3_open([dbPath UTF8String], &sqliteManager) == SQLITE_OK) {
        return YES;
    }
    return NO;
}

// 关闭数据库
- (void)close {
    if (NULL != sqliteManager) {
        sqlite3_close(sqliteManager);
    }
    sqliteManager = NULL;
}

@end
