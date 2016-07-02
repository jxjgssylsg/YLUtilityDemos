//
//  TableViewControllerTwo.m
//  YLExperimentForOC
//
//  Created by Mr_db on 16/6/4.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#import "TableViewControllerTwo.h"

@interface TableViewControllerTwo ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_cities;
    UIToolbar *_toolbar;
    BOOL _isInsert;
}

@end

@implementation TableViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor redColor]; // cell 边框颜色 $$
    [self.view addSubview:_tableView];
    
    [self addToolbar];
}

-(void)initData {
    NSMutableArray *GroupOne = [[NSMutableArray alloc] initWithArray: @[@"shandong",@"guangxi",@"taibei",@"上海",@"广州",@"天津",@"北京",@"shanghai"]];
    NSArray *GroupTwo =[[NSMutableArray alloc] initWithArray:  @[@"heibei",@"beijingdaxue",@"jiangxicaijing",@"上海",@"广州",@"天津",@"北京",@"shanghai",@"guangzhou",@"tianjing",@"南昌",@"xinjiang"]
                        ];
    _cities = [[NSMutableArray alloc] initWithObjects:GroupOne, GroupTwo, nil];

}

#pragma mark - 数据源方法
// 多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"计算分组数");
    return _cities.count;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"组:%li 行数:%ld",(long)section,[_cities[section] count]);
    return [_cities[section] count];
}

// 每行是什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSIndexPath是一个对象，记录了组和行信息
    NSLog(@"生成单元格 (组：%li  行%li) ",(long)indexPath.section,(long)indexPath.row);
    NSString *text = nil;
    text = ((NSArray *)_cities[indexPath.section])[indexPath.row];
    
    // 重用cell
    static NSString *cellIdentifier = @"UITableViewCellIdentifierKey1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];// 注意UITableViewCellStyle 有多种,可点进去看看
    }
    if (0 == indexPath.section && 1 == indexPath.row) {
       UISwitch *accessSwitch = [[UISwitch alloc] init];// 附件可以是任何的view,注意 accessorView 和 accessoryType 区别
        accessSwitch.tag = indexPath.section;
        [accessSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
       cell.accessoryView = accessSwitch;
    } else if (0 == indexPath.section && 2 == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton; // 系统的附件,可以都试试.
    }
    cell.textLabel.text = text;
    return cell;
}

#pragma mark 返回每组头标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return @"第一组";
    } else {
        return @"第二组";
    }
}

#pragma mark 返回每组尾部说明
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (0 == section) {
        return @"第一组尾部咯";
    } else {
        return @"第二组尾部咯";
    }

}

#pragma mark - 代理方法
#pragma mark 设置分组头部标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 100;
    }
    return 30;
}

#pragma mark 设置尾部说明内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0){
        return 100;
    }
    return 30;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( (0 == indexPath.row % 2) && (1 == indexPath.section) ) {
        return 70;
    } else {
        return 30;
    }
        
}

#pragma mark 返回每组标题索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSLog(@"生成组索引");
    NSArray *indexs=@[@"1",@"2"];
    return indexs;
}

// 点击事件,刷新
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"你点击了 %ld  %ld",(long)indexPath.section,(long)indexPath.row);
    // 第一组整体刷新,第二组局部刷新
    if (0 == indexPath.section) {
        [_tableView reloadData];
    } else {
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark 切换开关转化事件
- (void)switchValueChange:(UISwitch *)sw {
    NSLog(@"section:%li,switch:%i",(long)sw.tag, sw.on);
    // 跳到指的row or section
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]
                        atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark 添加工具栏
- (void)addToolbar {
    CGRect frame = self.view.frame;
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    [self.view addSubview:_toolbar];
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(remove)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    NSArray *buttonArray = [NSArray arrayWithObjects:removeButton,flexibleButton,addButton, nil];
    _toolbar.items = buttonArray;
}

#pragma mark 删除操作和插入
// 实现了此方法向左滑动就会显示删除按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *group = ((NSMutableArray *)_cities[indexPath.section]);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除某行 cell
        [group removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        // 如果当前组中没有数据则移除组刷新整个表格
        if (group.count==0) {
            [_cities removeObject:_cities[indexPath.section]];
            [_tableView reloadData];
        }
    } else if(editingStyle == UITableViewCellEditingStyleInsert) {
         NSString *city = @"jinggangshan xinchengqu";
        [group insertObject:city atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];//注意这里没有使用reladData刷新
    }
}
#pragma mark 排序 只需要在编辑状态下就可以排序
// 只要实现这个方法在编辑状态右侧就有排序图标
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *group = ((NSMutableArray *)_cities[sourceIndexPath.section]);
    NSString *city = group[sourceIndexPath.row];
    [group removeObjectAtIndex:sourceIndexPath.row];
    
    NSMutableArray *destinationGroup = ((NSMutableArray *)_cities[destinationIndexPath.section]);
    [destinationGroup insertObject:city atIndex:destinationIndexPath.row];
    
    // 如果源数据已经没有了,重新加载
    if(group.count==0) {
        [_cities removeObject:group];
        [_tableView reloadData];
    }
}

#pragma mark 删除
-(void)remove {
    _isInsert = false;
    [_tableView setEditing:!_tableView.isEditing animated:true];//每次都取反
}

#pragma mark 添加
-(void)add {
    _isInsert = true;
    [_tableView setEditing:!_tableView.isEditing animated:true];
}


#pragma mark 取得当前操作状态，根据不同的状态左侧出现不同的操作按钮
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isInsert) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
