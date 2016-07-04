//
//  TableViewControllerSix.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/16.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "TableViewControllerSix.h"
#import "CustomCellForCode.h"
#import "DataModel.h"
#import "DataModelGroup.h"
#import "DataModelFrame.h"


static NSString *CustomCellIdentifier = @"CustomCellIdentifier";

@interface TableViewControllerSix ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray; // 数据源
@property(nonatomic, strong) NSMutableArray *frameArray; // cell高度
@property(nonatomic, strong) UITableView *tab; // tableView
@end

@implementation TableViewControllerSix
#pragma mark ------------------ 获取数据源（模型数据源、模型高度数据源） ------------------

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [DataModelGroup DataModelGroupWithNameOfContent:@"statuses.plist"];
        _frameArray = [DataModelFrame DataModelFrameWithArray:_dataArray];
    }
    return _dataArray;
}
#pragma mark ------------------ viewDidLoad ------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabelView];
}
#pragma mark ------------------ 创建tableView ------------------

- (void)setUpTabelView
{
    UITableView *vi = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    vi.delegate = self;
    vi.dataSource = self;
    [self.view addSubview:vi];
    [vi registerClass:[CustomCellForCode class] forCellReuseIdentifier:CustomCellIdentifier];
    self.tab = vi;
}


#pragma mark ------------------ tableViewDelegate ------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellForCode *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier ];
    // 发现当cell队列没用可重用的时候,会自动去调用 initWithStyle:reuseIdentifier: 方法,cell似乎不会为空,但还是建议做空处理,至少没有坏处吧,且规范.
    if (!cell) {
        NSLog(@"cell kong kong kong kong kong kong kong");
        cell = [[CustomCellForCode alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
    cell.model = [_dataArray objectAtIndex:indexPath.row];
    cell.frameModel = [_frameArray objectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModelFrame *mo = [_frameArray objectAtIndex:indexPath.row];
    return mo.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellForCode *selCell = (CustomCellForCode *)_dataArray[indexPath.row];
    NSLog(@"%@",selCell);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
