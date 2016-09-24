//
//  CircleLayout.m
//  CollectionDemo
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 banwang. All rights reserved.
//

#import "CircleLayout.h"
#import "MyCollectionReusableView.h"
#import "AppDelegate.h"

@interface CircleLayout() {
    CGSize cvSize;
    CGPoint cvCenter;
    CGFloat radius;
    NSInteger cellCount;
}

@property (strong, nonatomic) NSMutableArray *indexPathsToAnimate;

@end

@implementation CircleLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    [self registerClass:[MyCollectionReusableView class] forDecorationViewOfKind:@"MyDecoration"];
    
    cvSize = self.collectionView.frame.size;
    cellCount = [self.collectionView numberOfItemsInSection:0];
    cvCenter = CGPointMake(cvSize.width / 2.0, cvSize.height / 2.0);
    radius = MIN(cvSize.width, cvSize.height) / 2.5;
}

- (CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray array];
    
    //add cells
    for (int i=0; i<cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [array addObject:attributes];
    }
    
    // add first supplementaryView
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"FirstSupplementary" atIndexPath:indexPath];
    [array addObject:attributes];
    
    // add second supplementaryView
    attributes = [self layoutAttributesForSupplementaryViewOfKind:@"SecondSupplementary" atIndexPath:indexPath];
    [array addObject:attributes];
    
    // add decorationView
    attributes = [self layoutAttributesForDecorationViewOfKind:@"MyDecoration" atIndexPath:indexPath];
    [array addObject:attributes];
    
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = CGSizeMake(20, 20);
    attributes.center = CGPointMake(cvCenter.x + radius * cosf(2 * indexPath.item * M_PI / cellCount),
                                    cvCenter.y + radius * sinf(2 * indexPath.item * M_PI / cellCount));
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    attributes.size = CGSizeMake(260, 40);
    if([elementKind isEqual:@"FirstSupplementary"]) {
        attributes.center = CGPointMake(cvSize.width / 2, 40);
    } else {
        attributes.center = CGPointMake(cvSize.width / 2, cvSize.height - 100);
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    
    attributes.size = CGSizeMake(140, 40);
    attributes.center = CGPointMake(cvSize.width / 2, cvSize.height / 2);
    
    return attributes;
}

// 当边界更改时是否更新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}

// 通知布局，collection view 里有元素即将改变，这里可以收集改变的元素 indexPath 和 action 类型。
-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for(UICollectionViewUpdateItem *updateItem in updateItems) {
        // UICollectionUpdateActionInsert,
        // UICollectionUpdateActionDelete,
        // UICollectionUpdateActionReload,
        // UICollectionUpdateActionMove,
        // UICollectionUpdateActionNone
        
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    
    self.indexPathsToAnimate = indexPaths;
}

// 当一个元素被插入 collection view 时，返回它的初始布局，这里可以加入一些动画效果。
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if([self.indexPathsToAnimate containsObject:itemIndexPath]) {
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(10,10),M_PI);
        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMidY(self.collectionView.bounds));
        [self.indexPathsToAnimate removeObject:itemIndexPath];
    }
    
    return attr;
}



- (NSArray *)getLetterArray {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.letterArray;
}

@end
