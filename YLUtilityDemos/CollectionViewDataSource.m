//
//  CollectionViewDataSource.m
//  CollectionDemo
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 banwang. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import <UIKit/UICollectionView.h>
#import "AppDelegate.h"

@interface CollectionViewDataSource()

@end

@implementation CollectionViewDataSource

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self getLetterArray].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LetterCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor yellowColor];
    UIView *subView = [cell viewWithTag:1050]; // 得到 tag = 1050 的子 View
    [subView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = 1050;
    label.text = [[self getLetterArray] objectAtIndex:indexPath.row];
    label.font = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    label.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
    [cell addSubview:label];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReuseID" forIndexPath:indexPath];
    
    view.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = kind;
    label.font = [UIFont systemFontOfSize:24];
    [label sizeToFit];
    label.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    [view addSubview:label];
    
    return view;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你选择了");
    
    //    [self.myArray removeObjectAtIndex:indexPath.row];
    //
    //    [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"canMoveItemAtIndexPath");
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSLog(@"moveItemAtIndexPath");
    
    NSMutableArray *data = [self getLetterArray];
    
    NSNumber *index = [data objectAtIndex:fromIndexPath.item];
    [data removeObjectAtIndex:fromIndexPath.item];
    [data insertObject:index atIndex:toIndexPath.item];
}

- (NSMutableArray *)getLetterArray {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.letterArray;
}

@end
