//
//  TableViewControllerThree.m
//  YLExperimentForOC
//
//  Created by Mr_db on 16/3/18.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#import "TableViewControllerThree.h"
#define kSearchbarHeight 44

@interface TableViewControllerThree()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    //UISearchDisplayController *_searchDisplayController;
    NSArray *_cities;
    NSMutableArray *_searchCities;//符合条件的搜索联系人
    BOOL _isSearching;
}
@end

@implementation TableViewControllerThree

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
    if (_isSearching) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearching) {
        return _searchCities.count;
    }
    return _cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = nil;
    if (_isSearching) {
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

#pragma mark - 代理方法
#pragma mark - 搜索框代理
#pragma mark  取消搜索
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _isSearching = NO;
    _searchBar.text = @"";
    [_tableView reloadData];
}

#pragma mark 输入搜索关键字
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([_searchBar.text isEqual:@""]){
        _isSearching=NO;
        [_tableView reloadData];
        return;
    }
    [self searchDataWithKeyWord:_searchBar.text];
}

#pragma mark 点击虚拟键盘上的搜索时
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchDataWithKeyWord:_searchBar.text];
    
    [_searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 加载数据
-(void)initData{
    _cities = @[@"shandong",@"guangxi",@"taibei",@"上海",@"广州",@"天津",@"北京",@"shanghai",@"guangzhou",@"tianjing",@"南昌",@"xinjiang"];
}

#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord{
    _isSearching=YES;
    _searchCities=[NSMutableArray array];
    [_cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *city=obj;
        if ([city.uppercaseString containsString:keyWord.uppercaseString]) {
            [_searchCities addObject:city];
        }
    }];
    
    //刷新表格
    [_tableView reloadData];
}

#pragma mark 添加搜索栏
-(void)addSearchBar{
    CGRect searchBarRect=CGRectMake(0, 0, self.view.frame.size.width, kSearchbarHeight);
    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
    _searchBar.placeholder = @"Please input key word...";
    _searchBar.keyboardType = UIKeyboardAppearanceDefault;//键盘类型
    //_searchBar.autocorrectionType=UITextAutocorrectionTypeNo;//自动纠错类型
    //_searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;//哪一次shitf被自动按下
    _searchBar.showsCancelButton = YES;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar.delegate = self;
    _tableView.tableHeaderView = _searchBar;
}

@end
