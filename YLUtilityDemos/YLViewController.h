//
//  ViewController.h
//  YLUtilityDemos
//
//  Created by yilin on 16/4/20.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLViewController : UIViewController

//方法1:boundingRectWithSize Demo 1.算出来了具有属性的文字所占有的空间 2.ParagraphStyle属性,例如字体行间距,首行缩进
- (void)testBoundingRectWithSizeMethods;
//方法2:简单使用NSDictionary和NSMutableDictionary, 包括初始化,遍历,删除,修改等,建议单步或者断点调试着看
- (void)testNSDictionary;
@end

