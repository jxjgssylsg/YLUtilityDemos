//
//  CustomCellForCode.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/16.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "CustomCellForCode.h"
#import "DataModel.h"
#import "DataModelFrame.h"
#import "DataModelGroup.h"

#define NameFont [UIFont systemFontOfSize:17]
#define TextFont [UIFont systemFontOfSize:14]

@interface CustomCellForCode ()

@property (nonatomic, weak) UIImageView *iconImageView; // UI
@property (nonatomic, weak) UILabel *nameLabel;         //
@property (nonatomic, weak) UIImageView *vipImageView;  //
@property (nonatomic, weak) UILabel *text_label;        //
@property (nonatomic, weak) UIImageView *pictureImageView;

@end

@implementation CustomCellForCode

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSLog(@"syl_____ %s",__func__);
        // avatar
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView]; // 这里理解为强引用
        self.iconImageView = iconImageView; // 这里是 weak
        iconImageView.backgroundColor = [UIColor redColor]; // 可以从颜色看出重用机制
 
        // member icon
        UIImageView *vipImageView = [[UIImageView alloc] init];
        vipImageView.image = [UIImage imageNamed:@"vip"];
        vipImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:vipImageView];
        self.vipImageView = vipImageView;
        
        // illustration
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        pictureImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:pictureImageView];
        self.pictureImageView = pictureImageView;
        
        // name
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NameFont;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // content
        UILabel *text_label = [[UILabel alloc] init];
        text_label.numberOfLines = 0;
        text_label.font = TextFont;
        [self.contentView addSubview:text_label];
        self.text_label = text_label;
    }
    return self;
}

// 注意调用 layoutSubviews 的各种时机,既什么情况下会调用 layoutSubviews 方法
- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = _frameModel.iconFrame;
    _text_label.frame = _frameModel.textFrame;
    _nameLabel.frame = _frameModel.nameFrame;
    _vipImageView.frame = _frameModel.vipFrame;
    _pictureImageView.frame = _frameModel.pictureFrame;
    
}

- (void)setModel:(DataModel *)model { // 把内容赋值上去了, 若 label 的字有属性要注意~
    _model = model;
    if (model.picture) {
        _pictureImageView.image = [UIImage imageNamed:model.picture];
    }
    _nameLabel.text = _model.name;
    if (_model.vip) {
        _vipImageView.hidden = NO;
    } else {
        _vipImageView.hidden = YES;
    }
    _text_label.text = _model.text;
    _iconImageView.image = [UIImage imageNamed:model.icon];
    
}

@end
