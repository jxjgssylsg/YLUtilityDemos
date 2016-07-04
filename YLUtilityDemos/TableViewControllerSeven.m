//
//  TableViewControllerSeven.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/27.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "TableViewControllerSeven.h"
#import "CellSeven.h"

@interface TableViewControllerSeven () <UITableViewDelegate, UITableViewDataSource, CellSevenDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_cities;
    UIToolbar *_toolbar;
}
@end

@implementation TableViewControllerSeven

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.frame = CGRectMake(0, 0, 414, 500);
    
    [self.view addSubview:_tableView];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;  // Return an Edit|Done button
    //注. 当启用了下面两句的时候, editingStyleForRowAtIndexPath 方法就不会调用了! 要注意!
    // _tableView.allowsSelectionDuringEditing = YES; // 允许选择
    // _tableView.allowsMultipleSelectionDuringEditing = YES; // 允许多行选择
     _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 500, 414, 40)];
     _toolbar.backgroundColor = [UIColor redColor];
    [self setAppropriateToolbarItems];
    [self.view addSubview:_toolbar];
}
- (void)initData {
    _cities = [[NSMutableArray alloc] initWithArray: @[@"shandong",@"guangxi",@"taibei",@"上海",@"广州",@"天津",@"北京",@"shanghai",@"guangzhou",@"tianjing",@"南昌",@"xinjiang"]];
}
-(void)setAppropriateToolbarItems {
    NSArray *itemsArray;
    
    if (self.editing) {
        itemsArray = @[[[UIBarButtonItem alloc] initWithTitle:@"Trash" style:UIBarButtonItemStylePlain target:self action:@selector(userDidPressTrashButton:)],
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       [[UIBarButtonItem alloc] initWithTitle:@"....." style:UIBarButtonItemStylePlain target:self action:@selector(userDidPressMoveButton:)],
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       [[UIBarButtonItem alloc] initWithTitle:@"....." style:UIBarButtonItemStylePlain target:self action:@selector(userDidPressMarkButton:)]];
    }
    else {
        itemsArray = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(userDidPressAddButton:)]];
    }
    
    [_toolbar setItems:itemsArray animated:NO];
}
// toolbar 方法
- (void)userDidPressTrashButton:(id)sender {
    // $$ 被选中的 cell
    NSArray *indexPathsOfSelectedCells = [_tableView indexPathsForSelectedRows];
    // 对象排序
    NSArray *sortedArray;
    sortedArray = [indexPathsOfSelectedCells sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [(NSIndexPath *)a row];
        NSInteger second = [(NSIndexPath *)b row];
        NSLog(@"%ld  %ld", first, second);
        return first > second ;
        // return [first compare:second]; 如果是 nsobject
    }];
    // MUST be enumerated in reverse order otherwise the _objects indices become invalid.
    [sortedArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        [_cities removeObjectAtIndex:obj.row];
    }];
    
    [_tableView deleteRowsAtIndexPaths:indexPathsOfSelectedCells withRowAnimation:UITableViewRowAnimationAutomatic];
     [self setEditing:NO animated:YES];
}

- (void)userDidPressMoveButton:(id)sender {
    [self setEditing:NO animated:YES];
}

- (void)userDidPressMarkButton:(id)sender {
    [self setEditing:NO animated:YES];
}

- (void)userDidPressAddButton:(id)sender {
    if (!_cities) {
        _cities = [[NSMutableArray alloc] init];
    }
    [_cities insertObject:@"hahhahaha" atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // Need to call this whenever we scroll our table view programmatically
    [[NSNotificationCenter defaultCenter] postNotificationName:CellSevenEnclosingTableViewDidBeginScrollingNotification object:_tableView];
}
// 旋转屏幕的时候关闭侧滑
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // Need to do this to keep the view in a consistent state (layoutSubviews in the cell expects itself to be "closed")
    [[NSNotificationCenter defaultCenter] postNotificationName:CellSevenEnclosingTableViewDidBeginScrollingNotification object:_tableView];
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
    CellSeven *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[CellSeven alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.scrollViewLabel.text = text;
    cell.textLabel.hidden = YES;
    cell.delegate = self; // 注. 自己的代理需要别人设置噢
    return cell;
}
//// cell 高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 10.0;
//}

#pragma mark 点击行
// 这个不会调用的原因是触摸事件处理了①.被 uiscrollview 的触摸事件抢占了 ②.被自定义 cell 的触摸事件抢占了
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中状态
    // [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"你点击了 %ld  %ld",(long)indexPath.section,(long)indexPath.row);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self setAppropriateToolbarItems];
    NSLog(@" TableViewControllerSeven setEditing began ");
    [_tableView setEditing:!_tableView.isEditing animated:true]; // 设置 tableview 编辑模式,会先处理 cell 的编辑模式
    NSLog(@" TableViewControllerSeven setEditing Done ");
    
}
// 设置编辑时候的左边的样式 editingStyle
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"UITableViewCellEditingStyle editingStyleForRowAtIndexPath");
    static int i = 0;
    if (i++ < 3) {
        return UITableViewCellEditingStyleInsert;
    } else if (i++ < 5) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete; // 这种是多选
    }
}

#pragma mark - cellDidSelectDelete Methods

-(void)cellDidSelectDelete:(CellSeven *)cell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell]; // cell 对应的行,列
    
    [_cities removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)cellDidSelectMore:(CellSeven *)cell {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MORE" message:@"more点击了 " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"确定", nil];
    [alert show]; //显示窗口
}

#pragma UIScrollViewDelegate Methods

// 当 scrollview 有滑动的时候,取消侧滑
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:CellSevenEnclosingTableViewDidBeginScrollingNotification object:scrollView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
