//
//  YLViewController.h
//  YLUtilityDemos
//
//  Created by yilin on 16/4/20.
//  Copyright © 2016年 yilin. All rights reserved.
//
/*****************
   NOTE:搜索需要Demo的关键字,在YLViewController.m中调用即可.
 ******************/
#import <UIKit/UIKit.h>

@interface YLViewController : UIViewController

//方法1:boundingRectWithSize Demo 1.算出来了具有属性的文字所占有的空间 2.ParagraphStyle属性,例如字体行间距,首行缩进
- (void)testBoundingRectWithSizeMethods_2016_3_27;

//方法2:简单使用NSDictionary和NSMutableDictionary, 包括初始化,遍历,删除,修改等,建议单步或者断点调试着看
- (void)testNSDictionary_2016_4_3;

//方法3:二维码制作,根据给定的字符串
- (void)creatQRCode_2016_4_27;

//方法4:制作简单的一个月的日历
- (void)creatSimpleCalendar_2016_4_29;

//方法5:NSDate常用的方法集合,建议断点调试着看
- (void)testNSDate_2016_4_30;

//方法6:NSTimeZone常用的方法集合,建议断点调试着看
- (void)testNSTimeZone_2016_5_1;

//方法7:NSLocale常用的方法集合,建议断点调试着看
- (void)testNSLocale_2016_5_3;

//方法8:NSDateFormatter常用的方法集合
- (void)testNSDateFormatter_2016_5_7;

//方法9:testNSDateComponents常用的方法集合
- (void)testNSDateComponents_2016_5_20;
@end

