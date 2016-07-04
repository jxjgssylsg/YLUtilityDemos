//
//  DataModelFrame.h
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/17.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface DataModelFrame : NSObject

@property(nonatomic,assign) CGRect nameFrame;
@property(nonatomic,assign) CGRect iconFrame;
@property(nonatomic,assign) CGRect textFrame;
@property(nonatomic,assign) CGRect vipFrame;
@property(nonatomic,assign) CGRect pictureFrame;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) DataModel *model;

+ (NSMutableArray *)DataModelFrameWithArray:(NSMutableArray *)arr;
+ (instancetype)DataModelFrameWithModel:(DataModel *)model;
@end
