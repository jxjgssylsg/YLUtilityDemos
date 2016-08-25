//
//  HYBBaseController.m
//  learnMasonry
//
//  Created by huangyibiao on 15/11/27.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "HYBBaseController.h"

@implementation HYBBaseController

- (instancetype)initWithTitle:(NSString *)title {
  if (self = [super init]) {
    self.title = title;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (kIOSVersion >= 7.0) {
    self.automaticallyAdjustsScrollViewInsets = NO; // automaticallyAdjustsScrollViewInsets 根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset, 这里不需要
    self.edgesForExtendedLayout = UIRectEdgeNone; // 默认的 UIRectEdgeAll 布局将从 NavigationBar 的顶部开始,所有的UI元素都往上漂移了44pt。
  }
  
  self.view.backgroundColor = [UIColor whiteColor];
}

@end
