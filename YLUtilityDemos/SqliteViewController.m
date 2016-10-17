//
//  ViewController.m
//  SqliteManager
//
//  Created by pg on 16/5/10.
//  Copyright © 2016年 person. All rights reserved.
//

#import "SqliteViewController.h"
#import "SqlitePeople.h"
#import "SqliteManager.h"

@interface SqliteViewController ()

@end

@implementation SqliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 创建表
    [[SqliteManager shareManager] createTBWithClass:[SqlitePeople class]];

    SqlitePeople *people1 = [[SqlitePeople alloc]init];
    people1.uniId = @"201100";
    people1.name = @"this is a test";
    people1.age = 17;
    people1.isOld = true;
    
    SqlitePeople *people2  = [[SqlitePeople alloc]init];
    people2.uniId = @"201112";
    people2.name = @"222";
    
    // 插入
    [[SqliteManager shareManager] insertModel:people1];
    [[SqliteManager shareManager] insertModel:people2];
    
    NSMutableArray *peoples = [[NSMutableArray alloc]init];
    for (int i = 0; i < 100; i++) {
        SqlitePeople *people = [[SqlitePeople alloc]init];
        people.uniId = [NSString stringWithFormat:@"20010%d",i];
        people.age = 17;
        people.isOld = 0;
        [peoples addObject:people];
    }
    [[SqliteManager shareManager] insertModels:peoples];
    
    // 更新
    [[SqliteManager shareManager]updateWithModel:people1 updateInfo:@{@"_age": @"20", @"_name": @"hello boy"}];
    
    // 删除
    [[SqliteManager shareManager]deleteWithModel:people2];
    
    SqlitePeople *newPe = [[SqlitePeople alloc] init];
    newPe.uniId = @"200102";
    [[SqliteManager shareManager] deleteWithModel:newPe];
    
    // 查询 遍历
    [[SqliteManager shareManager] searchWithClass:[SqlitePeople class] result:^(NSArray *model) {
        
    }];
    
    // 单条查询
    [[SqliteManager shareManager] searchWithModel:people1 result:^(id model) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(id)sender {
    for (int i = 0; i < 100; i++) {
        SqlitePeople *people = [[SqlitePeople alloc]init];
        people.uniId = [@"201100" stringByAppendingString:[@(i) description]];
        [[SqliteManager shareManager] searchWithModel:people result:^(id model) {
            NSLog(@"%@", [model description]);
        }];
    }
}
@end
