//
//  CustomCell.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/15.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:_image]) {
        _image = [img copy];
        self.imageView.image = _image;
    }
}

- (void)setName:(NSString *)n {
    if (![n isEqualToString:_name]) {
        _name = [n copy];
        self.nameLabel.text = _name;
    }
}

- (void)setDec:(NSString *)d {
    if (![d isEqualToString:_dec]) {
        _dec = [d copy];
        self.decLabel.text = _dec;
    }
}

-(void)setLoc:(NSString *)l {
    if (![l isEqualToString:_loc]) {
        _loc = [l copy];
        self.locLabel.text = _loc;
    }
}

@end
