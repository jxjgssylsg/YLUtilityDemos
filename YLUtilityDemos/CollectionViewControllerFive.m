//
//  BWViewController1.m
//  CollectionDemo
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 banwang. All rights reserved.
//

#import "CollectionViewControllerFive.h"
#import "CollectionViewDataSource.h"
#import "AppDelegate.h"
#import "CircleLayout.h"
@interface CollectionViewControllerFive ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionViewDataSource *cvDataSource;
@property (nonatomic, strong) UIButton *changeLayout;
@property (nonatomic, strong) UIButton *batchUpload;

@end

@implementation CollectionViewControllerFive

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLetters];
    self.view.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeLayout];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.batchUpload];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.collectionView];

}
- (void)setLetters {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.letterArray = [NSMutableArray array]; // set 方法
    NSMutableArray *letterArray = [self getLetterArray];
    
    for(int i = 0; i < 26; i++){
        [letterArray addObject:[NSString stringWithFormat:@"%C",(unichar)(65+i)]];
    }
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CircleLayout *layout = [[CircleLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor grayColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LetterCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"FirstSupplementary" withReuseIdentifier:@"ReuseID"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"SecondSupplementary" withReuseIdentifier:@"ReuseID"];
        
        _cvDataSource = [[CollectionViewDataSource alloc] init];
        _collectionView.dataSource = _cvDataSource;
        _collectionView.delegate = _cvDataSource;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [_collectionView addGestureRecognizer:tapRecognizer];
    }
    return _collectionView;
}


- (UIButton *)changeLayout {
    if (_changeLayout == nil) {
        _changeLayout = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeLayout.frame = CGRectMake(0, 0, 100, 40);
        [_changeLayout setTitle:@"改变布局" forState:UIControlStateNormal];
        [_changeLayout setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_changeLayout addTarget:self action:@selector(changeLayoutClickHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeLayout;
}


- (UIButton *)batchUpload {
    if (_batchUpload == nil) {
        _batchUpload = [UIButton buttonWithType:UIButtonTypeCustom];
        _batchUpload.frame = CGRectMake(0, 0, 100, 40);
        [_batchUpload setTitle:@"更新布局" forState:UIControlStateNormal];
        [_batchUpload setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_batchUpload addTarget:self action:@selector(batchUploadClickHandler) forControlEvents:UIControlEventTouchUpInside];

    }
    return _batchUpload;
}


- (void)changeLayoutClickHandler {
    if([_collectionView.collectionViewLayout isKindOfClass:[CircleLayout class]]){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView.collectionViewLayout = layout;
    }
    else {
        CircleLayout *layout = [[CircleLayout alloc] init];
        _collectionView.collectionViewLayout = layout;
    }
}

- (void)batchUploadClickHandler {
    // 这里有个细节需要注意，最好是将删除操作放在添加操作前面，因为无论你顺序如何，始终都会先执行删除操作。
    // 如果代码顺序是先添加后删除，但实际执行顺序是先删除后添加，可能会因为索引不对影响代码逻辑。
    [_collectionView performBatchUpdates:^{
        NSMutableArray *letterArray = [self getLetterArray];
        // 删除四个元素
        NSIndexPath *path1 = [NSIndexPath indexPathForItem:0 inSection:0];
        NSIndexPath *path2 = [NSIndexPath indexPathForItem:1 inSection:0];
        NSIndexPath *path3 = [NSIndexPath indexPathForItem:2 inSection:0];
        NSIndexPath *path4 = [NSIndexPath indexPathForItem:3 inSection:0];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)];
        
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSLog(@"%lu", (unsigned long)idx);
        }];
        
        [letterArray removeObjectsAtIndexes:indexSet];
        
        NSArray *array = [NSArray arrayWithObjects:path1, path2, path3, path4, nil];
        [_collectionView deleteItemsAtIndexPaths:array];
        
        // 添加一个元素
        [letterArray addObject:@"1"];
        
        [_collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:letterArray.count-1 inSection:0]]];
    } completion:nil];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_collectionView];
    NSIndexPath *tappedCellPath = [_collectionView indexPathForItemAtPoint:point];
    
    NSMutableArray *letterArray = [self getLetterArray];
    if(tappedCellPath) {
        // 删除点击的cell
        [letterArray removeObjectAtIndex:tappedCellPath.item];
        [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:tappedCellPath]];
    }
    else {
        // 如果点击空白处，在末尾添加一个随机小写字母
        unichar asciiX = (unichar)[self getRandomNumber:97 to:97+26];
        [letterArray addObject:[NSString stringWithFormat:@"%C",asciiX]];
        NSIndexPath *path = [NSIndexPath indexPathForItem:letterArray.count - 1 inSection:0];
        [_collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:path]];
    }
}

- (NSMutableArray *)getLetterArray {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.letterArray;
}

- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to-from)));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
