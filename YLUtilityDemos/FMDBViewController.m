//
//  ViewController.m
//  FmdbTest
//
//  Created by Tang Qiao on 12-4-22.
//  Copyright (c) 2012年 blog.devtang.com All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "MacroUtils.h"

@interface FMDBViewController()

@property (nonatomic, retain) NSString * dbPath;

@end

@implementation FMDBViewController

@synthesize dbPath;

#pragma mark - SQL Operations

- (IBAction)createTable:(id)sender {
    debugMethod();
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                debugLog(@"error when creating db table");
            } else {
                debugLog(@"succ to creating db table");
            }
            [db close];
        } else {
            debugLog(@"error when open db");
        }
    }
}


- (IBAction)insertData:(id)sender {
    static int idx = 1;
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"insert into user (name, password) values(?, ?) ";
        NSString * name = [NSString stringWithFormat:@"tangqiao%d", idx++];
        BOOL res = [db executeUpdate:sql, name, @"boy"];
        if (!res) {
            debugLog(@"error to insert data");
        } else {
            debugLog(@"succ to insert data");
        }
        [db close];
    }
}


- (IBAction)queryData:(id)sender {
    debugMethod();
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"select * from user";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int userId = [rs intForColumn:@"id"];
            NSString * name = [rs stringForColumn:@"name"];
            NSString * pass = [rs stringForColumn:@"password"];
            debugLog(@"user id = %d, name = %@, pass = %@", userId, name, pass);
        }
        [db close];
    }
}

- (IBAction)clearAll:(id)sender {
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"delete from user";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to delete db data");
        } else {
            debugLog(@"succ to deleta db data");
        }
        [db close];
    }
}

- (IBAction)multithread:(id)sender {
    // 创建，最好放在一个单例的类中
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSLog(@"current thread = %@", [NSThread currentThread]);
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue111 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"boy"];
                if (!res) {
                    debugLog(@"error to add db data: %@", name);
                } else {
                    debugLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
    
    // 并不会创建新线程, 只是一个串行队列
    [queue inDatabase:^(FMDatabase *db) {
        NSLog(@"current thread = %@", [NSThread currentThread]);
        NSString * sql = @"insert into user (name, password) values(?, ?) ";
        NSString * name = [NSString stringWithFormat:@"queue111 %d", 100000];
        BOOL res = [db executeUpdate:sql, name, @"boy"];
        if (!res) {
            debugLog(@"error to add db data: %@", name);
        } else {
            debugLog(@"succ to add db data: %@", name);
        }
    }];
    /* 事务
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSLog(@"current thread = %@", [NSThread currentThread]);
        NSString * sql = @"insert into user (name, password) values(?, ?) ";
        NSString * name = [NSString stringWithFormat:@"queue111 %d", 123450];
        BOOL res = [db executeUpdate:sql, name, @"boy"];
        if (!res) {
            debugLog(@"error to add db data: %@", name);
        } else {
            debugLog(@"succ to add db data: %@", name);
        }
    }];
     */
    
    dispatch_async(q2, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue222 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"boy"];
                if (!res) {
                    debugLog(@"error to add db data: %@", name);
                } else {
                    debugLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"FMDBuser.sqlite"];
    self.dbPath = path;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
