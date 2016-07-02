//
//  TableViewControllerOne.m
//  YLExperimentForOC
//
//  Created by Mr_db on 16/6/4.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#import "TableViewControllerOne.h"

@interface TableViewControllerOne () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_cities;
}

@end

@implementation TableViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

}

- (void)initData {
    _cities = @[@"shandong",@"guangxi",@"taibei",@"上海",@"广州",@"天津",@"北京",@"shanghai",@"guangzhou",@"tianjing",@"南昌",@"xinjiang"];
}

#pragma mark - 数据源方法
// 多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cities.count;
}

// 每行是什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = nil;
    text = _cities[indexPath.row];
   
    // 重用cell
    static NSString *cellIdentifier = @"UITableViewCellIdentifierKey1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = text;
    return cell;
}

@end
