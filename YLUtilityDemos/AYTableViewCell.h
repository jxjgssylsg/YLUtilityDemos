//
//  AYTableViewCell.h
//  CellAutoLayoutDemo
//
//  Created by Andy on 16/3/15.
//  Copyright © 2016年 Andy. All rights reserved.
// ❤️

#import <UIKit/UIKit.h>

typedef void(^ReloadCellBlock)(NSIndexPath *);

#pragma mark - UserModel

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) BOOL isClick;

@end

@interface AYTableViewCell : UITableViewCell

@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) ReloadCellBlock block;

- (void)configCellWithModel:(UserModel *)model;
+ (CGFloat)getHeightWidthModel:(UserModel *)model;

@end
