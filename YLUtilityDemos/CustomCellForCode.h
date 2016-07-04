//
//  CustomCellForCode.h
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/16.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@class DataModelFrame;
@class DataModelGroup;

@interface CustomCellForCode : UITableViewCell

@property(nonatomic,strong) DataModel *model; // 数据
@property(nonatomic,strong) DataModelFrame *frameModel; // 数据frame

@end
