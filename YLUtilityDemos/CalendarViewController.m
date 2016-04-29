//
//  calendarViewController.m
//  calendar
//
//  Created by mingdffe on 16/4/26.
//  Copyright © 2016年 yilin. All rights reserved.

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置每周的第一天从星期几开始(1是周日，2是周一)
    [myCalendar setFirstWeekday:1];
    //设置每个月或者每年的第一周必须包含的最少天数
    [myCalendar setMinimumDaysInFirstWeek:1];
    //设置时区
    [myCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    //绘制日期当月日历
    [self drawCalendar:[NSDate date]];
    //title
     NSArray *weekArray = @[@"Mon",@"Tue",@"Wen",@"Thu",@"Fri",@"Sat",@"Sun"];
    for (int i = 0; i < 7; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15 + 40 * (i%7), 5, 30, 15);
        label.text  = weekArray[i];
        [label sizeToFit];
        [self.view addSubview:label];
    }
    
}

-(void)drawCalendar:(NSDate *)date
{
    
    //获取date所在月的天数
    monthRange = [myCalendar rangeOfUnit:NSCalendarUnitDay
                                          inUnit:NSCalendarUnitMonth
                                         forDate:date];
    NSLog(@"monthRange:%lu,%lu",(unsigned long)monthRange.location,(unsigned long)monthRange.length);
    //获取date在其所在的月份里的位置
    currentDayIndexOfMonth = [myCalendar ordinalityOfUnit:NSCalendarUnitDay
                                      inUnit:NSCalendarUnitMonth
                                     forDate:date]  ;
    NSLog(@"currentIndex:%ld",(long)currentDayIndexOfMonth);
    
    NSTimeInterval interval;
    NSDate *firstDayOfMonth;
    //注意观察firstDayOfMonth
    if ([myCalendar rangeOfUnit: NSCalendarUnitMonth startDate:&firstDayOfMonth interval:&interval forDate:date])
    {
        NSLog(@"%@",firstDayOfMonth);
        NSLog(@"%f",interval);
    }
    //获取date所在月的第一天在其所在周的位置，即第几天。
    firstDayIndexOfWeek = [myCalendar ordinalityOfUnit:NSCalendarUnitDay
                                               inUnit:NSCalendarUnitWeekOfMonth
                                              forDate:firstDayOfMonth];
    //绘制日历单元
    [self drawCalendarDayUnit];
    
}

-(void)drawCalendarDayUnit
{
    for (NSInteger i = firstDayIndexOfWeek - 1 ; i < monthRange.length + firstDayIndexOfWeek -1 ; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(5 + 40 * (i%7), 30 + 40*(i/7), 30, 30);
        btn.tag = i + 2 - firstDayIndexOfWeek;
        
        [btn setTitle:[NSString stringWithFormat:@"%ld",i + 2 - firstDayIndexOfWeek ]
             forState:UIControlStateNormal];
        
        [btn addTarget:self
                action:@selector(CalendarDayUnitpressed:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
}

-(void)CalendarDayUnitpressed:(UIButton *)btn
{
    NSLog(@"%ld",(long)btn.tag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
