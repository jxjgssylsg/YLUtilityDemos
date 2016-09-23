//
//  CellSeven.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/27.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "CellSeven.h"
#import "ScrollViewSeven.h"
#define kCatchWidth 180

NSString *const CellSevenEnclosingTableViewDidBeginScrollingNotification = @"CellSevenEnclosingTableViewDidBeginScrollingNotification";

@interface CellSeven () <UIScrollViewDelegate>

@property (nonatomic, weak) ScrollViewSeven *scrollView;

@property (nonatomic, weak) UIView *scrollViewContentView; // The cell content (like the label) goes in this view.
@property (nonatomic, weak) UIView *scrollViewButtonView;  // Contains our two buttons



@end

@implementation CellSeven 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"- - - -initWithStyle- - - -");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    self.scrollView.tableViewCell  = self;
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup {
    // Set up our contentView hierarchy
    //  层次关系: self.contentView ---->self.scrollView (UIScrollView 类型)---->  self.scrollViewButtonView (放button, UIView 类型) 和 self.scrollViewContentVie (放lable,UIView 类型)
    ScrollViewSeven *scrollView = [[ScrollViewSeven alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth, 0, kCatchWidth, CGRectGetHeight(self.bounds))];
    self.scrollViewButtonView = scrollViewButtonView;
    [self.scrollView addSubview:scrollViewButtonView];
    
    // Set up our two buttons
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
    moreButton.frame = CGRectMake(0, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:moreButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
    deleteButton.frame = CGRectMake(kCatchWidth / 2.0f, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:deleteButton];
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    UILabel *scrollViewLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.scrollViewContentView.bounds, 10, 0)];
    self.scrollViewLabel = scrollViewLabel;
    [self.scrollViewContentView addSubview:scrollViewLabel];
    
    // $$ 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:CellSevenEnclosingTableViewDidBeginScrollingNotification  object:nil];
}

- (void)enclosingTableViewDidScroll {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

 // 有必要! 原因是 CGRectGetWidth(self.bounds) 开始默认 320, 当加载到 tableview 时, 才会改变相应的宽度 (例如 6p宽度414)
-(void)layoutSubviews {
    [super layoutSubviews];

    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.scrollViewButtonView.frame = CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth, 0, kCatchWidth, CGRectGetHeight(self.bounds));
    self.scrollViewContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

#pragma mark - Private Methods

- (void)userPressedDeleteButton:(id)sender
{
    [self.delegate cellDidSelectDelete:self];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)userPressedMoreButton:(id)sender
{
    [self.delegate cellDidSelectMore:self];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    NSLog(@"cell setEditing "); // 注. 应该是 TableView 的先调用
    [super setEditing:editing animated:animated];
    self.scrollView.scrollEnabled = !self.editing; // scrollView 不可滚动
    // Corrects effect of showing the button labels while selected on editing mode (comment line, build, run, add new items to table, enter edit mode and select an entry)
    self.scrollViewButtonView.hidden = editing; // 在编辑状态下隐藏 buttonView , view 隐藏
    NSLog(@"edit's state is :%d", editing);
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.x > kCatchWidth) {
        targetContentOffset->x = kCatchWidth;
        // [self recursiveDescription]; 递归输出视图层级, 似乎只能在 lldb 中 po
    } else {
        *targetContentOffset = CGPointZero;
        //  Need to call this subsequently to remove flickering. Strange.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}
// 滑动过程中一直调用的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    self.scrollViewButtonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kCatchWidth), 0.0f, kCatchWidth, CGRectGetHeight(self.bounds));
}
// 自定 cell 的触摸事件处理
- (void)touchesBegan:(NSSet *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"cell touchesBegan method ");
    BOOL isSelect = self.selected;
    self.selected = !isSelect;
    
    UITableView *containerTableView = (UITableView *)self.superview.superview;
    // NSLog(@"父控件是:%@", containerTableView);
    NSIndexPath *indexOfTheCell = [containerTableView indexPathForCell:self];
    if (self.isSelected) {
        [containerTableView selectRowAtIndexPath:indexOfTheCell animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [containerTableView deselectRowAtIndexPath:indexOfTheCell animated:NO];
    }
    
}

@end
