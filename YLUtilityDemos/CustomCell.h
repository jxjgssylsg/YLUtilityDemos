//
//  CustomCell.h
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/15.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell


@property (weak, nonatomic)  IBOutlet UIImageView *avatarimageView;
@property (weak, nonatomic)  IBOutlet UILabel *nameLabel;
@property (weak, nonatomic)  IBOutlet UILabel *decLabel;
@property (weak, nonatomic)  UILabel *locLabel;

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dec;
@property (copy, nonatomic) NSString *loc;

@end
