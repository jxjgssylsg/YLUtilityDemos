//
//  MyCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by JieYuanZhuang on 15/3/11.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "UIColor+RandomColor.h"

@implementation MyCollectionViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor blackColor];
    
    self.backgroundColor = [UIColor randomColor];
}

@end
