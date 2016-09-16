//
//  MyCollectionViewController.m
//  CollectionViewDemo
//
//  Created by JieYuanZhuang on 15/3/11.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "MyCollectionViewControllerThree.h"
#import "MyCollectionViewCell.h"
#import "Header.h"
#import "Footer.h"

const NSTimeInterval kAnimationDuration = 0.20;
static NSString *kCollectionViewHeaderIndentifier = @"Headers";
static NSString *kCollectionViewFooterIndentifier = @"Footers";

@interface MyCollectionViewControllerThree ()

@end

@implementation MyCollectionViewControllerThree

static NSString * const reuseIdentifier = @"Cell";

- (void)awakeFromNib {
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([Header class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeaderIndentifier];
    
    UINib *footerNib = [UINib nibWithNibName:NSStringFromClass([Footer class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:footerNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionViewFooterIndentifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -- dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.cellLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    
    return cell;
}


#pragma mark -- delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 放大缩小效果
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        selectedCell.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        selectedCell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"MainSegue" sender:indexPath]; // 跳转
    });
}

#pragma mark -- Footer and Header

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    NSString *resueIndentifier = kCollectionViewHeaderIndentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        resueIndentifier = kCollectionViewFooterIndentifier;
    }
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resueIndentifier forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        Header *header = (Header *)view;
        header.label.text = [NSString stringWithFormat:@"Section Header %lu",(unsigned long)indexPath.section + 1];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        Footer *footer = (Footer *)view;
        NSString *title = [NSString stringWithFormat:@"Section Footer %lu",(unsigned long)indexPath.section + 1];
        [footer.button setTitle:title forState:UIControlStateNormal];
    }
    return  view;
    
}

@end
