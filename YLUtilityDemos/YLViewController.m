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

@interface YLViewController ()

@end

@implementation YLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //[self testNSDictionary_2016_4_3];
    [self creatQRCode_2016_4_27];
   // [self creatSimpleCalendar_2016_4_29];
    [self testNSDate_2016_4_30];
    
}
- (void)testNSDate_2016_4_30
{
    //-------------------------------- NSDate ----> NSString ---------------------------------//
    
    //NSDate ----> NSString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"年月日,时分秒  yyyy - MM - dd HH:mm:ss"]; //似乎只要有对应的就行
    NSLog(@"%@",dateFormatter.timeZone);
    NSLog(@"%@",dateFormatter.locale);
    NSDate *dateOne = [NSDate date];
    NSLog(@"转换前 = %@", dateOne);
    NSString *strDate = [dateFormatter stringFromDate:dateOne];
    //转的时候会根据-时区-变化,加了8小时,参考NSTimeZone
    NSLog(@"转换后 = %@", strDate);
    
    //---------------------------- NSString -----> NSDate ------------------------------------//
    
    //NSString -----> NSDate
    NSDateFormatter *dateFormatterTwo = [[NSDateFormatter alloc] init];
    [dateFormatterTwo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatterTwo dateFromString:@"2016-04-29 17:46:03"];
    //转的时候会根据-时区-变化,减掉了8小时,,参考NSTimeZone
    NSLog(@"%@",date);//输出2016-04-29 09:46:03 +0000 对比 2016-04-29 17:46:03
    
    //--------------------------------------------------------------------------------------------//
    
    //日期创建方式
    NSDate *dateTwo = [NSDate date];
    NSString *str = [dateTwo description];
    NSLog(@"%@",str);
    NSDate *dateThree = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*7]; //负数代表过去
    NSLog(@"%@",dateThree);
    //日期是否相同
    BOOL isEqual = [dateTwo isEqual:dateThree];
    NSLog(@"%d",isEqual);
    
    // 从某时间开始经过某秒后的日期时间
    NSDate *dateFour = [dateThree  initWithTimeInterval:60*60*24*7 sinceDate:dateThree];
    NSDate *dateFive = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:dateThree];
    NSLog(@"%@",dateFour);
    NSLog(@"%@",dateFive);
    
    //某两个时间相隔多久
    NSInteger gap = [dateThree timeIntervalSinceDate:dateFive];
    NSLog(@"%ld",gap);
    
    //取得正确的时间,既UTC世界统一时间 + 8小时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dateTwo];
    NSDate *localDate = [dateTwo  dateByAddingTimeInterval: interval];
    NSLog(@"正确当前时间 localDate = %@",localDate);
    
    //时间比较
    BOOL later = [dateOne laterDate:localDate];
    NSLog(@"%d",later);
    BOOL early = ([localDate compare:dateOne] == NSOrderedAscending);
    NSLog(@"%d",early);
    
}

- (void)testBoundingRectWithSizeMethods_2016_3_27
{
    
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

- (void)testNSDictionary_2016_4_3
{
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
    BOOL isEqual = [dicThree isEqualToDictionary:dicTwo]; //两个字典是否相等
    NSLog(@"%ld,%@,%@,@%d",count,allKey,allValue,isEqual);
    //遍历
    for(NSString *key in dicThree)
    {
        NSLog(@"key:%@ value:%@",key,dicThree[key]);
    }
    
    NSDictionary *dictFour = @{@"name":@"Kate", @"tel":@"080-123-456",@"address":@"中国"};
    [dictFour enumerateKeysAndObjectsUsingBlock:^(id  key, id  obj, BOOL *  stop) {
        NSLog(@"key:%@ value:%@",key,obj);
    }];
    
    //NSMutableDictionary 简单使用
    NSMutableDictionary *dictFive = [NSMutableDictionary dictionary];
    //像字典中追加一个新的 key5 和 value5
    [dictFive setObject:@"value5" forKey:@"key5"];
    [dictFive addEntriesFromDictionary:dicThree];
    for(NSString *key in dictFive)
    {
        NSLog(@"key:%@ value:%@",key,dictFive[key]);
    }
    //将字典5的对象内容设置与字典1的对象内容相同
    [dictFive setDictionary:dicThree];
    for(NSString *key in dictFive)
    {
        NSLog(@"key:%@ value:%@",key,dictFive[key]);
    }
    //删除键所对应的键值对
    [dictFive removeObjectForKey:@"name"];
    //修改key对应的value的值
    dictFive[@"address"] = @"beijing";
    //删除数组中的所有key 对应的键值对
    NSArray *array = @[@"tel",@"address",@"key3"];
    [dictFive removeObjectsForKeys:array];
    //移除字典中的所有对象
    [dictFive removeAllObjects];

}
- (void)creatQRCode_2016_4_27
{
    CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.view.bounds.size.height * 0.5f - imageSize * 0.5f), imageSize, imageSize)];
    //生成二维码图片
    imageView.image = [QREncoding createQRcodeForString:@"http://www.alipay.com" withSize:imageView.bounds.size.width withRed:255 green:0 blue:0];
    //添加中心图片
    UIImageView *centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhifubao.png"]];
    centerImage.frame= CGRectMake(0, 0, 38.f, 38.f);
    centerImage.center = CGPointMake(CGRectGetWidth(imageView.frame)/2.f, CGRectGetHeight(imageView.frame)/2.f);
    [imageView addSubview:centerImage];
    [self.view addSubview:imageView];
    
}
- (void)creatSimpleCalendar_2016_4_29
{
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
