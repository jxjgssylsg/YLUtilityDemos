//
//  TableViewControllerFour.m
//  YLExperimentForOC
//
//  Created by Mr_db on 16/6/5.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#import "TableViewControllerFour.h"
#define kSearchbarHeight 44

@interface TableViewControllerFour()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>{
    UITableView *_tableView;
    // UISearchDisplayController  Deprecated 弃用了
    UISearchController *_searchController;
    NSArray *_cities;
    NSMutableArray *_searchCities;//符合条件的搜索联系人
   // BOOL _isSearching;
}
@end

@implementation TableViewControllerFour

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //添加搜索框
    [self addSearchBar];
    
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_searchController.active) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.active) {
        return _searchCities.count;
    }
    return _cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = nil;
    if (_searchController.active) {
        text = _searchCities[indexPath.row];
    } else {
        text = _cities[indexPath.row];
    }
    
    static NSString *cellIdentifier = @"UITableViewCellIdentifierKey1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = text;
    return cell;
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 加载数据
-(void)initData{
    _cities = @[@"shandong",@"guangxi",@"taibei",@"上海",@"广州",@"天津",@"北京",@"shanghai",@"guangzhou",@"tianjing",@"南昌",@"xinjiang"];
}

#pragma mark 添加搜索栏
-(void)addSearchBar{
    _searchController =  [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = YES; // 是否有阴影
    _searchController.hidesNavigationBarDuringPresentation = YES; // 是否隐藏navigate bar
    _searchController.searchBar.frame = CGRectMake(_searchController.searchBar.frame.origin.x,_searchController.searchBar.frame.origin.y, _searchController.searchBar.frame.size.width, kSearchbarHeight);
    _tableView.tableHeaderView = _searchController.searchBar;
 
}

#pragma mark searchController 代理方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [_searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchString];
    if (_searchCities != nil) {
        [_searchCities removeAllObjects];
    }
    //过滤数据
    _searchCities = [NSMutableArray arrayWithArray:[_cities filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [_tableView reloadData];
}

@end
