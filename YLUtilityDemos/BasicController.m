//
//  BasicController.m
//  learnMasonry
//
//  Created by huangyibiao on 15/11/27.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "BasicController.h"

@implementation BasicController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor lightGrayColor];
  
  UIView *greenView = UIView.new;
  greenView.backgroundColor = UIColor.greenColor;
  greenView.layer.borderColor = UIColor.blackColor.CGColor;
  greenView.layer.borderWidth = 2;
  [self.view addSubview:greenView];
  
  UIView *redView = UIView.new;
  redView.backgroundColor = UIColor.redColor;
  redView.layer.borderColor = UIColor.blackColor.CGColor;
  redView.layer.borderWidth = 2;
  [self.view addSubview:redView];
  
  UIView *blueView = UIView.new;
  blueView.backgroundColor = UIColor.blueColor;
  blueView.layer.borderColor = UIColor.blackColor.CGColor;
  blueView.layer.borderWidth = 2;
  [self.view addSubview:blueView];
  
    
  // 先上左下右,再其他条件的写吧, autoLayOut 可是错误不好找,可能要全部重写
  CGFloat padding = 10;
  [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.mas_equalTo(padding); // 步骤 1
    make.bottom.mas_equalTo(blueView.mas_top).offset(-padding); // 步骤 2
    make.right.mas_equalTo(redView.mas_left).offset(-padding);  // 步骤 3
  }];
  
  [redView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(padding); // 步骤 4
      make.left.mas_equalTo(greenView.mas_right).offset(padding); // 步骤 5
      make.bottom.mas_equalTo(blueView.mas_top).offset(-padding); // 步骤 6
      make.right.mas_equalTo(-padding);  // 步骤 7
      make.width.mas_equalTo(greenView); // 步骤 12
  }];
  
  [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(greenView.mas_bottom).offset(padding);// 步骤 8
    make.left.mas_equalTo(padding);     // 步骤 9
    make.bottom.mas_equalTo(-padding);  // 步骤 10
    make.right.mas_equalTo(-padding);   // 步骤 11
    make.height.mas_equalTo(@[greenView,redView]); // 步骤 13
  }];
}

@end
