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

// 方法18:UIScrollView 的基本功能
- (void)creatUIScrollViewOne;

// 方法19:通过 UIView 的旋转,放大,移动
- (void)creatUIScrollViewTwo;

// 方法20:UIScrollView 的循环图片浏览器
- (void)creatUIScrollViewThree;

// 方法21: 基本的 navigationController, toolbar
- (void)creatNavVCOne;

// 方法22: navigationController 各种例子; 透明,下拉放大
- (void)creatNavVCTwo;

// 方法23: navigationController 手势滑动, 系统方法或 runtime 机制 KVC

- (void)creatNavVCThree;

// 方法24:TabBarController NavigationController 混合使用
- (void)creatTabbarVCOne;

// 方法25:自定义 TabBar, 利用 KVC
- (void)creatTabbarVCTwo;

// 方法26:UIWindow,键盘保护
// 见 #import "AppDelegate.h", [[TestKeyWindow  sharedInstance] show];  密码保护

// 方法27:NSTimer, 去除循环引用
- (void)testNSTimer;

// 方法28:MasonryOne   ❤️
- (void)testMasonryOne;

// 方法29:MasonryTwo   ❤️ ❤️
- (void)testMasonryTwo;

// 方法30:MasonryThree ❤️ ❤️
- (void)testMasonryThree;

// 方法31:MasonryFour  ❤️ ❤️
- (void)testMasonryFour;

// 方法32:MasonryFive  ❤️ ❤️ ❤️, textField 跟随着键盘移动~
- (void)testMasonryFive;

// 方法33:MasonrySix  ❤️ ❤️ ❤️ ❤️, 各种类型例子
- (void)testMasonrySix;

// 方法34:基本的 CollectionView
- (void)creatUICollectionViewOne;

// 方法35:日历.课程表 自定义布局 CollectionView
- (void)creatUICollectionViewTwo;

// 方法36:基础 CollectionView, footer and header, 点击放大,缩小
- (void)creatUICollectionViewThree;

// 方法37:自定义布局 CollectionView
- (void)creatUICollectionViewFour;

// 方法38:自定义布局 CollectionView CircleLayout, Decoration View, supplementary View, 插入, 删除等
- (void)creatUICollectionViewFive;

// 方法39:Pthread
- (void)testPthread;

// 方法40:NSThread
- (void)testNSThread;

// 方法41:GCD
- (void)testGCD;

// 方法42:NSOperation
- (void)testNSOperation;

// 方法43:Runtime 常用方法 动态添加
- (void)testRuntime;

// 方法44:Runtime 常用方法
- (void)testRuntimeTwo;

// 方法45:KVC 常用方法
- (void)testKVC;

// 方法46:KVO 监听
- (void)testKVO;

// 方法47:KVO 监听
- (void)testKVOTwo;

// 方法48:RunLoop
- (void)testRunLoop;

// 方法49:NotificationCenter 使用
- (void)testNotificationCenter;

// 方法50:NotificationCenter post 线程转发
- (void)testNotificationCenterMultiThread;

// 方法51:LocalNotification 本地通知
- (void)testLocalNotification;

// 方法52:RemoteNotification 本地通知
- (void)testRemoteNotification;

// 方法53:NSUserDefaults 使用
- (void)testNSUserDefaults;

// 方法54:NSCoding 知识点
- (void)testNSCoding;

// 方法55:SQLite 知识点
- (void)testSQLite;

// 方法56:FDMB 知识点
- (void)testFMDB;

// 方法57:CoreData 知识点
- (void)testCoreData;




































@end

