//
//  YLViewController.m
//  YLUtilityDemos
//
//  Created by yilin on 16/4/20.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "YLViewController.h"
#import "QREncoding.h"
#import "CalendarViewController.h"
#import "TableViewControllerOne.h"
#import "TableViewControllerTwo.h"
#import "TableViewControllerThree.h"
#import "TableViewControllerFour.h"
#import "TableViewControllerFive.h"
#import "TableViewControllerSix.h"
#import "TableViewControllerSeven.h"

@interface YLViewController ()

@end

@implementation YLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self testBoundingRectWithSizeMethods_2016_3_27];
    // [self testNSDictionary_2016_4_3];
    // [self creatQRCode_2016_4_27];
    // [self creatSimpleCalendar_2016_4_29];
    // [self testNSDate_2016_4_30];
    // [self testNSTimeZone_2016_5_1];
    // [self testNSLocale_2016_5_3];
    // [self testNSDateFormatter_2016_5_7];
    // [self testNSDateComponents_2016_5_20];
    // [self testNSCalendar_2016_5_23];
    // [self creatUITableViewOne_2016_5_25];
    // [self creatUITableViewTwo_2016_5_26];
    // [self creatUITableViewThree_2016_6_1];
    // [self creatUITableViewFour_2016_6_3];
    // [self creatUITableViewFive_2016_6_5];
    // [self creatUITableViewSix_2016_6_7];
       [self creatUITableViewSeven_2016_6_13];
    
}
-(void)creatUITableViewSeven_2016_6_13 {
    TableViewControllerSeven *tableViewSeven = [[TableViewControllerSeven alloc] init];
    [tableViewSeven.view setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self addChildViewController:tableViewSeven];
    [self.view addSubview:tableViewSeven.view];
    
    self.navigationItem.leftBarButtonItem = tableViewSeven.navigationItem.leftBarButtonItem;
    // 这里必须设置成 tableView 的 navigationItem 才会有效果,因为是tableview 变成 editing animation,
    self.navigationItem.rightBarButtonItem = tableViewSeven.navigationItem.rightBarButtonItem;
   // self.navigationItem.rightBarButtonItem = self.editButtonItem; // 这样设置是无效的
    self.navigationItem.title = @"Table View";
    
    UINavigationController *Navi =  [[UINavigationController alloc] initWithRootViewController:self];
    [Navi.view setFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 40)];
   // self.navigationController.navigationBar.hidden = NO;
   // [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.view.backgroundColor =[UIColor redColor];
    [self.view addSubview:Navi.view];
   
}
-(void)creatUITableViewSix_2016_6_7 {
    TableViewControllerSix *tableViewSix = [[TableViewControllerSix alloc] init];
    [tableViewSix.view setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self addChildViewController:tableViewSix];
    [self.view addSubview:tableViewSix.view];
}

-(void)creatUITableViewFive_2016_6_5 {
    TableViewControllerFive *tableViewFive = [[TableViewControllerFive alloc] init];
    [tableViewFive.view setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self addChildViewController:tableViewFive];
    [self.view addSubview:tableViewFive.view];
}

- (void)creatUITableViewFour_2016_6_3 {
    TableViewControllerFour *tableViewFour = [[TableViewControllerFour alloc] init];
    [tableViewFour.view setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self addChildViewController:tableViewFour];
    [self.view addSubview:tableViewFour.view];
}

- (void)creatUITableViewThree_2016_6_1 {
    TableViewControllerThree *tableViewThree = [[TableViewControllerThree alloc] init];
    [tableViewThree.view setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self addChildViewController:tableViewThree];
    [self.view addSubview:tableViewThree.view];
}

- (void)creatUITableViewTwo_2016_5_26 {
    TableViewControllerTwo *tableViewTwo = [[TableViewControllerTwo alloc] init];
    [tableViewTwo.view setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self addChildViewController:tableViewTwo];
    [self.view addSubview:tableViewTwo.view];
}

- (void)creatUITableViewOne_2016_5_25 {
    TableViewControllerOne *tableViewOne = [[TableViewControllerOne alloc] init];
    [tableViewOne.view setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self addChildViewController:tableViewOne];
    [self.view addSubview:tableViewOne.view];
}

- (void)testNSCalendar_2016_5_23 {
    // 当前时间对应的月份中有几天
    NSInteger daysOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length;
    NSLog(@"%ld",daysOfMonth);
    
    // 当前时间对应的月份中有几周（前面说到的firstWeekday会影响到这个结果）
    NSInteger weeksOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length;
    NSLog(@"%ld",weeksOfMonth);
    
    // 当前时间对应的周是当前年中的第几周
    NSInteger  weekOfYear = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:[NSDate date]];
    NSLog(@"%ld",weekOfYear);
    
    // 当前时间是当前月的哪一周
    NSInteger weekOfMonth = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSLog(@"%ld",weekOfMonth);
    
    // 当前时间是这一年的哪一天
    NSInteger dayOfYear = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
    NSLog(@"%ld",dayOfYear);
    
    // 判断时间段和起始时间
    NSDate *startDateOfYear;
    NSDate *startDateOfMonth;
    NSDate *startDateOfWeek;
    NSDate *startDateOfDay;
    NSTimeInterval TIOfYear;
    NSTimeInterval TIOfMonth;
    NSTimeInterval TIOfWeek;
    NSTimeInterval TIOfDay;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitYear startDate:&startDateOfYear interval:&TIOfYear forDate:[NSDate date]];
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDateOfMonth interval:&TIOfMonth forDate:[NSDate date]];
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDateOfWeek interval:&TIOfWeek forDate:[NSDate date]];
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDateOfDay interval:&TIOfDay forDate:[NSDate date]];
    NSLog(@"\nFirstDateOfYear:%@, \nFirstDateOfMonth:%@, \nFirstDateOfWeek:%@, \nFirstDateOfDay:%@", startDateOfYear, startDateOfMonth, startDateOfWeek, startDateOfDay);
    NSLog(@"\n一年的时间(秒):%f\n一月的时间(秒):%f\n一个星期的时间(秒):%f\n一天的时间(秒):%f", TIOfYear, TIOfMonth, TIOfWeek, TIOfDay);
    
    // 日历标示符
    NSCalendar *calendarOne = [NSCalendar currentCalendar];
    NSLog(@"%@",calendarOne.calendarIdentifier);
    // 设置每周的第一天从星期几开始(1是周日，2是周一,依次类推),可以参考方法4:制作简单的一个月的日历
    [calendarOne setFirstWeekday:2];
    NSLog(@"%lu",(unsigned long)calendarOne.firstWeekday);
    
    // 还有一些其他方法:例如设置时区< - (void)setTimeZone:(NSTimeZone *)tz >,设置本地化 < - (void)setLocale:(NSLocale *)locale >就不一一演示了,可以参见 http://www.cnblogs.com/wayne23/archive/2013/03/25/2981009.html http://my.oschina.net/yongbin45/blog/156181?fromerr=c07GCztc
    
}
- (void)testNSDateComponents_2016_5_20 {
    // 例一:从日期中提取日期组件
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:date];
    NSLog(@"%@",dateComponents);
    
    // 例二:用Components来创建日期
    [dateComponents setYear:1987];
    [dateComponents setMonth:3];
    [dateComponents setDay:17];
    [dateComponents setHour:14];
    [dateComponents setMinute:20];
    NSDate *dateTwo = [calendar dateFromComponents:dateComponents];
    NSLog(@"%@",dateTwo);
    
    
    // 例三:计算相对日期
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfMonth:1];//一周
    [components setHour:2];
    // 注意输出的是UTC时间
    NSLog(@"1 week and two hours from now :%@",[calendar dateByAddingComponents:components toDate:date options:0]);
  
    // 根据两个时间点，定义NSDateComponents对象，从而获取这两个时间点的时差
    dateComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:[NSDate date] options:0];
    NSLog(@"number of years:%li", (long)dateComponents.year);
    
//---------------------------- 展示NSDateComponents属性集 ---------------------------------//
    
    // 先定义一个遵循某个历法的日历对象
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponentsTwo = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:[NSDate date]];
    NSLog(@"year(年份): %li", (long)dateComponentsTwo.year);
    NSLog(@"quarter(季度):%li", (long)dateComponentsTwo.quarter);
    NSLog(@"month(月份):%li", (long)dateComponentsTwo.month);
    NSLog(@"day(日期):%li", (long)dateComponentsTwo.day);
    NSLog(@"hour(小时):%li", (long)dateComponentsTwo.hour);
    NSLog(@"minute(分钟):%li", (long)dateComponentsTwo.minute);
    NSLog(@"second(秒):%li", (long)dateComponentsTwo.second);
    
    // Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Friday:5, Saturday:6  --例如 1 代表日历第一天是周日
    NSLog(@"weekday(星期):%li", (long)dateComponentsTwo.weekday);
    
    // 苹果官方不推荐使用week
    NSLog(@"week(该年第几周):%li", (long)dateComponentsTwo.week);
    NSLog(@"weekOfYear(该年第几周):%li", (long)dateComponentsTwo.weekOfYear);
    NSLog(@"weekOfMonth(该月第几周):%li", (long)dateComponentsTwo.weekOfMonth);
    
}
- (void)testNSDateFormatter_2016_5_7 {
        // 一个简单例子
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"一周第 e 天  zzzz:   YYYY-MM-dd  HH:mm:ss"];// e代表一周的第几天,从周日开始计算.zzzz表是时区地点
        NSDate *date = [NSDate date];
        NSString *correctDate = [formatter stringFromDate:date];
        NSLog(@"%@",correctDate);
        
        // 这个例子综合了各个参数,值得一看
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@" \n '公元前/后:'G ' \n 年份:'u'='yyyy'='yy ' \n 季度:'q'='qqq'='qqqq ' \n 月份:'M'='MMM'='MMMM ' \n 今天是今年第几周:'w ' \n 今天是本月第几周:'W  ' \n 今天是今年第几天:'D ' \n 今天是本月第几天:'d ' \n 星期:'c'='ccc'='cccc ' 上午/下午:'a ' \n 小时:'h'='H '分钟:'m '秒:'s '毫秒:'SSS  ' \n 这一天已过多少毫秒:'A  ' \n 时区名称:'zzzz'='vvvv '时区编号:'Z "];
        NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
        
        /*
         参数      代表意义
         
         a        AM/PM (上午/下午)
         K        0~11 有0時的12小時制
         h        1~12 12小時制
         H        0~23 有0時的24小时制
         k        1~24 24小時制
         m        0~59 分鐘
         s        0~59 秒數
         s        秒數的個位數
         A        0~86399999 一天當中的第幾微秒
         
         v~vvv    一般的GMT時區縮寫
         vvvv     一般的GMT時區名稱
         z~zzz    具體的GMT時區縮寫
         zzzz     具體的GMT時區名稱
         d        1~31 日期
         D        1~366 一年的第幾天
         e        1~7 一週的第幾天
         c/cc     1~7 一週的第幾天，星期日為第一天
         
         ccc      星期幾縮寫
         E~EEE    星期幾縮寫
         cccc     星期幾全名
         EEEE     星期幾全名
         
         F        1~5 每月第幾周，一周的第一天為周一
         w        1~5 每月第幾周，一周的第一天為周日
         w        1~53 一年的第幾周，從去年的最後一個周日算起，一周的第一天為周日
         
         L/LL     1~12 第幾個月
         M/MM     1~12 第幾個月
         LLL      月份縮寫
         MMM      月份縮寫
         LLLL     月份全名
         MMMM     月份全名
         
         q/qq     1~4 第幾季
         Q/QQ     1~4 第幾季
         qqq      季度縮寫
         QQQ      季度縮寫
         qqqq     季度全名
         QQQQ     季度全名
         
         u        完整年份
         y/yyyy   完整年份
         Y/YYYY   完整年份，從星期天開始的第一周算起
         yy/yyy   兩位數的年份
         YY/YYY   兩位數的年份，從星期天開始的第一周算起
         g        Julian Day Number，從4713 BC一月一日算起
         G~GGG    BC/AD 西元前後縮寫
         GGGG     西元前後全名
         
         */
}
- (void)testNSLocale_2016_5_3 {
    // 当前用户设置的本地化对象
    NSLocale *currentLocale= [NSLocale currentLocale];
    NSString *localeIdentifier = [currentLocale  objectForKey:NSLocaleIdentifier];
    NSString *localeLanguageCode = [currentLocale objectForKey:NSLocaleLanguageCode];
    NSLog(@"%@",currentLocale.localeIdentifier);
    NSLog(@"localeIdentifier:%@,localeLanguageCode:%@",localeIdentifier,localeLanguageCode);
    
    // 获取国际化信息的显示名称
    NSLocale *curLocal = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"];
    NSLog(@"%@",[curLocal displayNameForKey:NSLocaleIdentifier value:@"fr_FR"]);// 法文（法國）
    NSLog(@"%@",[curLocal displayNameForKey:NSLocaleIdentifier value:@"en-US"]);// 英文（美國)
    NSLog(@"%@",[curLocal displayNameForKey:NSLocaleIdentifier value:@"en_pl"]);// 英文（波蘭）
    
    // 会根据设备的设置，自动返回不同语言的数据。
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];// 参数试试fr_FR,en_us
    NSDateFormatter *secondDateFormatter = [[NSDateFormatter alloc] init];
    [secondDateFormatter setDateFormat:@"cccc"];
    secondDateFormatter.locale = locale;
    NSDate *date = [NSDate date];
    NSLog(@"%@", [secondDateFormatter stringFromDate:date]);
    
    // 获取系统所有本地化标识符数组列表
    NSArray *localeIdentifiers = [NSLocale availableLocaleIdentifiers];
    // 获取所有已知国家代码数组列表
    NSArray * countryCodes = [NSLocale ISOCountryCodes];
    // 获取所有已知ISO货币代码数组列表
    NSArray *currenyCodes  = [NSLocale ISOCurrencyCodes];
    // 获取所有已知ISO语言代码数组列表
    NSArray *languageCodes = [NSLocale ISOLanguageCodes];
    // 语言偏好设置列表，对应于IOS中Setting>General>Language弹出的面板中的语言列表。
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSLog(@"\n%@,\n%@,\n%@,\n%@,\n%@",localeIdentifiers,countryCodes,currenyCodes,languageCodes,preferredLanguages);

}
- (void)testNSTimeZone_2016_5_1 {
    //------------------------------ 取得各个时区时间  ---------------------------------//
    
    // 取得已知时区名称
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    NSDate *date = [NSDate date];
    // 几百个时区,建议断点调试着看
    for (NSString *name in timeZoneNames) {
        NSTimeZone *timezone = [[NSTimeZone alloc] initWithName:name];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 格式
        [formatter setDateFormat:@"YYYY-MM-d HH:mm:ss"];
        // 设置时区
        [formatter setTimeZone:timezone];
        // NSDate ----> NSString
        NSString *correctDate = [formatter stringFromDate:date];
        NSLog(@"地点：%@   当地时间：%@",[timezone name], correctDate);
        NSLog(
              @"\nlocalTimeZone = [%@]\nDisplay = [%@]\nGMT = [%d] hours",
              timezone,
              [timezone name],
              (int)[timezone secondsFromGMT] / 60 /60
              );
    }
    
    //-------------------方法timeZoneForSecondsFromGMT自定义时区---------------------------//
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    df.timeZone = [NSTimeZone systemTimeZone];// 系统所在时区
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    df.timeZone = [NSTimeZone defaultTimeZone];// 默认时区
    NSString *defaultTimeZoneStr = [df stringFromDate:date];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];// 直接指定时区
    NSString *plus8TZStr = [df stringFromDate:date];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0*3600];// 这就是GMT+0时区
    NSString *gmtTZStr = [df stringFromDate: date];
    NSLog(@"\n SysTime:%@\n DefaultTime:%@\n +8:%@\n GMT_time:%@",systemTimeZoneStr,defaultTimeZoneStr,plus8TZStr,gmtTZStr);
    
    //-------------------- 修改默认时区会影响时间 -----------------------------------------//
    
    // 只能够修改该程序的defaultTimeZone，不能修改系统的，更不能修改其他程序的。
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0900"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSLog(@"now:%@", [dateFormatter stringFromDate:now]);
    
    // 也可直接修改NSDateFormatter的timeZone变量
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSLog(@"now:%@", [dateFormatter stringFromDate:now]);
    
    //-------------------- 通过secondsFromGMTForDate方法获得localtime ---------------------//
    
    NSDate *currentDate = [NSDate date];
    NSLog(@"currentDate: %@",currentDate);
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:currentDate];
    NSDate *localDate = [currentDate dateByAddingTimeInterval:interval];
    NSLog(@"正确的当前时间localDate: %@",localDate);
    NSLog(@"当前时区和格林尼治时区差的秒数:%ld",[zone secondsFromGMT]);
    NSLog(@"当前时区的缩写:%@",[zone abbreviation]);
    
    //-------------------------------- 设置并获取时区的缩写 ---------------------------------//
    
    NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
    [abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];// 获得所有缩写
    [abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];// 增加一个
    [NSTimeZone setAbbreviationDictionary:abbs];// 设置NStimezone的缩写
    NSLog(@"abbs:%@", [NSTimeZone abbreviationDictionary]);
    
}

- (void)testNSDate_2016_4_30 {
    //-------------------------------- NSDate ----> NSString ---------------------------------//
    
    // NSDate ----> NSString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"年月日,时分秒  yyyy - MM - dd HH:mm:ss"]; // 似乎只要有对应的就行
    NSLog(@"%@",dateFormatter.timeZone);
    NSLog(@"%@",dateFormatter.locale);
    NSDate *dateOne = [NSDate date];
    NSLog(@"转换前 = %@", dateOne);
    NSString *strDate = [dateFormatter stringFromDate:dateOne];
    // 转的时候会根据-时区-变化,加了8小时,参考NSTimeZone
    NSLog(@"转换后 = %@", strDate);
    
    //---------------------------- NSString -----> NSDate ------------------------------------//
    
    // NSString -----> NSDate
    NSDateFormatter *dateFormatterTwo = [[NSDateFormatter alloc] init];
    [dateFormatterTwo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatterTwo dateFromString:@"2016-04-29 17:46:03"];
    // 转的时候会根据-时区-变化,减掉了8小时,,参考NSTimeZone
    NSLog(@"%@",date);//输出2016-04-29 09:46:03 +0000 对比 2016-04-29 17:46:03
    
    //--------------------------------------------------------------------------------------------//
    
    // 日期创建方式
    NSDate *dateTwo = [NSDate date];
    NSString *str = [dateTwo description];
    NSLog(@"%@",str);
    NSDate *dateThree = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*7]; // 负数代表过去
    NSLog(@"%@",dateThree);
    // 日期是否相同
    BOOL isEqual = [dateTwo isEqual:dateThree];
    NSLog(@"%d",isEqual);
    
    // 从某时间开始经过某秒后的日期时间
    NSDate *dateFour = [dateThree  initWithTimeInterval:60*60*24*7 sinceDate:dateThree];
    NSDate *dateFive = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:dateThree];
    NSLog(@"%@",dateFour);
    NSLog(@"%@",dateFive);
    
    // 某两个时间相隔多久
    NSInteger gap = [dateThree timeIntervalSinceDate:dateFive];
    NSLog(@"%ld",gap);
    
    // 取得正确的时间,既UTC世界统一时间 + 8小时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dateTwo];
    NSDate *localDate = [dateTwo  dateByAddingTimeInterval: interval];
    NSLog(@"正确当前时间 localDate = %@",localDate);
    
    // 时间比较
    BOOL later = [dateOne laterDate:localDate];
    NSLog(@"%d",later);
    BOOL early = ([localDate compare:dateOne] == NSOrderedAscending);
    NSLog(@"%d",early);
    
}

- (void)testBoundingRectWithSizeMethods_2016_3_27 {
    UILabel *lbTemp =[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 700)];
    lbTemp.backgroundColor = [UIColor brownColor];
    lbTemp.lineBreakMode =  NSLineBreakByCharWrapping;
    lbTemp.numberOfLines = 0;
    lbTemp.text = @"天天\n上课,还挂科,是在是蛋疼.....希望这个地球更加美丽漂亮,随便写些东西都不是容易的事情啊";
    NSRange allRange = [lbTemp.text rangeOfString:lbTemp.text];
    [self.view addSubview:lbTemp];
    
    
    NSMutableParagraphStyle *tempParagraph = [[NSMutableParagraphStyle alloc] init];
    tempParagraph.lineSpacing = 20;
    tempParagraph.firstLineHeadIndent = 20.f;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:lbTemp.text];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:tempParagraph} range:allRange];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    lbTemp.frame = CGRectMake(50, 50, rect.size.width, rect.size.height);
    lbTemp.attributedText = attrStr;
    
}

- (void)testNSDictionary_2016_4_3 {
    NSDictionary *dicOne = [NSDictionary dictionaryWithObject: @"hello"  forKey:@"key"];
    NSString *dicOneValue = dicOne[@"key"];
    NSLog(@"%@",dicOneValue);
    
    NSDictionary *dicTwo = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Kate", @"name",
                         @"080-123-456", @"tel",
                         @"東京都", @"address",nil];
    
    NSArray *key = [NSArray arrayWithObjects:@"name", @"tel", @"address", nil];
    NSArray *value = [NSArray arrayWithObjects:@"Kate", @"080-123-456", @"中国", nil];
    NSDictionary *dicThree = [NSDictionary dictionaryWithObjects:value
                                                         forKeys:key];
    NSInteger count = [dicThree count];
    NSLog(@"%ld",count);
    NSArray *allKey = [dicThree allKeys];
    NSLog(@"%@",allKey);
    NSArray *allValue = [dicThree allValues];
    NSLog(@"%@",allValue);
    BOOL isEqual = [dicThree isEqualToDictionary:dicTwo]; // 两个字典是否相等
    NSLog(@"%ld,%@,%@,@%d",count,allKey,allValue,isEqual);
    // 遍历
    for(NSString *key in dicThree)
    {
        NSLog(@"key:%@ value:%@",key,dicThree[key]);
    }
    
    NSDictionary *dictFour = @{@"name":@"Kate", @"tel":@"080-123-456",@"address":@"中国"};
    [dictFour enumerateKeysAndObjectsUsingBlock:^(id  key, id  obj, BOOL *  stop) {
        NSLog(@"key:%@ value:%@",key,obj);
    }];
    
    // NSMutableDictionary 简单使用
    NSMutableDictionary *dictFive = [NSMutableDictionary dictionary];
    // 像字典中追加一个新的 key5 和 value5
    [dictFive setObject:@"value5" forKey:@"key5"];
    [dictFive addEntriesFromDictionary:dicThree];
    for(NSString *key in dictFive)
    {
        NSLog(@"key:%@ value:%@",key,dictFive[key]);
    }
    // 将字典5的对象内容设置与字典1的对象内容相同
    [dictFive setDictionary:dicThree];
    for(NSString *key in dictFive)
    {
        NSLog(@"key:%@ value:%@",key,dictFive[key]);
    }
    // 删除键所对应的键值对
    [dictFive removeObjectForKey:@"name"];
    // 修改key对应的value的值
    dictFive[@"address"] = @"beijing";
    // 删除数组中的所有key 对应的键值对
    NSArray *array = @[@"tel",@"address",@"key3"];
    [dictFive removeObjectsForKeys:array];
    // 移除字典中的所有对象
    [dictFive removeAllObjects];

}
- (void)creatQRCode_2016_4_27 {
    CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.view.bounds.size.height * 0.5f - imageSize * 0.5f), imageSize, imageSize)];
    // 生成二维码图片
    imageView.image = [QREncoding createQRcodeForString:@"http://www.alipay.com" withSize:imageView.bounds.size.width withRed:255 green:0 blue:0];
    // 添加中心图片
    UIImageView *centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhifubao.png"]];
    centerImage.frame= CGRectMake(0, 0, 38.f, 38.f);
    centerImage.center = CGPointMake(CGRectGetWidth(imageView.frame)/2.f, CGRectGetHeight(imageView.frame)/2.f);
    [imageView addSubview:centerImage];
    [self.view addSubview:imageView];
    
}
- (void)creatSimpleCalendar_2016_4_29 {
    CalendarViewController *temp = [[CalendarViewController alloc] init];
    [temp.view setFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self addChildViewController:temp];
    [self.view addSubview:temp.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
