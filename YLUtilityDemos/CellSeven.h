//
//  CellSeven.h
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/27.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellSeven;
extern NSString *const  CellSevenEnclosingTableViewDidBeginScrollingNotification;

@protocol CellSevenDelegate <NSObject>

-(void)cellDidSelectDelete:(CellSeven *)cell;
-(void)cellDidSelectMore:(CellSeven *)cell;

@end
@interface CellSeven : UITableViewCell

@property (nonatomic, weak) id<CellSevenDelegate> delegate;
@property (nonatomic, weak) UILabel *scrollViewLabel;

@end
