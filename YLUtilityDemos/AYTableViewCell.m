//
//  AYTableViewCell.m
//  CellAutoLayoutDemo
//
//  Created by Andy on 16/3/15.
//  Copyright © 2016年 Andy. All rights reserved.
//  ❤️ low

#import "AYTableViewCell.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import <Masonry/Masonry.h>

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation UserModel


@end

@interface AYTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation AYTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    _backgroundImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor  = [UIColor lightGrayColor];
        [self.contentView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        imageView;
    });
    
    UITapGestureRecognizer *backGroundImageViewTap = ({
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_backgroundImageView addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        [_backgroundImageView addSubview:label];
        label.numberOfLines = 2;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(16);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
            make.top.equalTo(_backgroundImageView.mas_top).offset(16);
        }];
        label;
    });
    
    _picImageView = ({
        UIImageView *imageView = [UIImageView new];
        [_backgroundImageView addSubview:imageView];
        imageView.backgroundColor = [UIColor redColor];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(16);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        imageView;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        [_backgroundImageView addSubview:label];
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = kScreenWidth - 100 - 16 * 2 - 70 - 8; // syl 这个属性是表示label最大可布局的宽度
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:14.5];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(8 + 16 + 70);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.bottom.equalTo(_picImageView.mas_bottom);
        }];
        label;
    });
}

- (void)tapAction:(UIGestureRecognizer *)recognizer {
    _model.isClick = !_model.isClick;
    if (self.block) {
        self.block(self.indexPath);
    }
    
//    [self.contentView setNeedsUpdateConstraints];
//    [self.contentView updateConstraintsIfNeeded];
//    [UIView animateWithDuration:0.15 animations:^{
//        [self.contentView layoutIfNeeded];
//    }];
}

- (void)configCellWithModel:(UserModel *)model { // 点击
    self.model = model;
    _titleLabel.text = model.title;
    _picImageView.image = [UIImage imageNamed:model.picture];
    _contentLabel.text = model.content;
    
    if (model.isClick) {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(8 + 16 + 70);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
//            make.width.mas_equalTo(165);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
//            make.bottom.equalTo(_picImageView.mas_bottom);
        }];
    } else {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(8 + 16 + 70);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
//            make.width.mas_equalTo(164);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.bottom.equalTo(_picImageView.mas_bottom);
        }];
    }
}

+ (CGFloat)getHeightWidthModel:(UserModel *)model {
    AYTableViewCell *cell = [[AYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell configCellWithModel:model];
    [cell layoutIfNeeded];
    CGRect frame = cell.contentLabel.frame;
    CGFloat cellHeight = frame.origin.y + frame.size.height + 8 + 24;
    return cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
