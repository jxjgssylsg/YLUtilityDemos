//
//  ScrollViewController.m
//  learnMasonry
//
//  Created by huangyibiao on 15/11/28.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    // 注. 注意理解 container 的作用,限制了 ScrollView 的大小. 若直接加在 self.view 会全屏
    UIView *container = UIView.new;
    container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100);
    [self.view addSubview:container];
    
    [container addSubview:self.scrollView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UILabel *lastLabel = nil;
    for (NSUInteger i = 0; i < 20; ++i) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.layer.borderColor = [UIColor greenColor].CGColor;
        label.layer.borderWidth = 2.0;
        label.text = [self randomText];
        
        // We must preferredMaxLayoutWidth property for adapting to iOS6.0
        label.preferredMaxLayoutWidth = screenWidth - 30;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [self randomColor];
        [self.scrollView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.view).offset(-15);
            
            if (lastLabel) {
                make.top.mas_equalTo(lastLabel.mas_bottom).offset(20);
            } else { // first
                make.top.mas_equalTo(self.scrollView).offset(20);
            }
        }];
        
        lastLabel = label;
    }
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView.superview); // .insets(UIEdgeInsetsMake(20, 20, 20, 20));
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(lastLabel.mas_bottom).offset(20);
    }];
}

- (UIColor *)randomColor {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (NSString *)randomText {
  CGFloat length = arc4random() % 50 + 5;
  
  NSMutableString *str = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i < length; ++i) {
    [str appendString:@"测试数据很长，"];
  }
  
  return str;
}

@end
