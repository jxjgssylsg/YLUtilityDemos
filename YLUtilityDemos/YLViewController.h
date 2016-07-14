//
//  YLViewController.h
//  YLUtilityDemos
//
//  Created by yilin on 16/4/20.
//  Copyright © 2016年 yilin. All rights reserved.
//

/*****************
   NOTE:搜索需要 Demo 的关键字,在 YLViewController.m 中调用即可.
 ******************/
#import <UIKit/UIKit.h>
// 优化控制台输出
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"文件名:%s:第%d行输出\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

@interface YLViewController : UIViewController

// 方法1:boundingRectWithSize Demo 1.算出来了具有属性的文字所占有的空间 2.ParagraphStyle 属性,例如字体行间距,首行缩进
- (void)testBoundingRectWithSizeMethods;

// 方法2:简单使用 NSDictionary 和 NSMutableDictionary, 包括初始化,遍历,删除,修改等,建议单步或者断点调试着看
- (void)testNSDictionary;

// 方法3:二维码制作,根据给定的字符串
- (void)creatQRCode;

// 方法4:制作简单的一个月的日历
- (void)creatSimpleCalendar;

// 方法5:NSDate 常用的方法集合,建议断点调试着看
- (void)testNSDate;

// 方法6:NSTimeZone 常用的方法集合,建议断点调试着看
- (void)testNSTimeZone;

// 方法7:NSLocale 常用的方法集合,建议断点调试着看
- (void)testNSLocale;

// 方法8:NSDateFormatter 常用的方法集合
- (void)testNSDateFormatter;

// 方法9:NSDateComponents 常用的方法集合
- (void)testNSDateComponents;

// 方法10:NSCalendar 常用的方法集合, 可以参考方法4:制作简单的一个月的日历
- (void)testNSCalendar;

// 方法11:最基本的 UITableView,展示最基本的原理,如 UITableViewDataSource, UITableViewDelegate
- (void)creatUITableViewOne;

// 方法12:TableView 基本功能:增加,删除,排序,点击等
- (void)creatUITableViewTwo;

// 方法13:TableView 添加搜索功能 <1> 逻辑相对复杂
- (void)creatUITableViewThree;

// 方法14:TableView 搜索功能 <2> 利用UISearchController, 原UISearchDisplayController Deprecated 弃用了
- (void)creatUITableViewFour;

// 方法15:自定义 TableViewcell,通过xib形式
- (void)creatUITableViewFive;

// 方法16:自定义 TableViewcell,通过代码形式
- (void)creatUITableViewSix;

// 方法17:自定义 TableViewcell 侧滑多按钮等功能
- (void)creatUITableViewSeven;







































@end

