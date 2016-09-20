//
//  CustomCollectionViewLayout.h
//  CollectionViewDemo
//
//  Created by JieYuanZhuang on 15/3/12.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCollectionViewLayout;

@protocol CustomCollectionViewLayoutDelegate <NSObject> // 自定义布局代理 

@required
- (CGFloat)collectionView:(UICollectionView*)collectionView
                   layout:(CustomCollectionViewLayout*)layout
 heightForItemAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface CustomCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) NSUInteger numberOfColumns; // 理解为列数
@property (nonatomic, assign) CGFloat interItemSpacing;   // item 间距
@property (nonatomic, weak)  id<CustomCollectionViewLayoutDelegate> delegate;

@end
