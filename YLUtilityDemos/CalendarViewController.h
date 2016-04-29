//
//  calendarViewController.h
//  calendar
//
//  Created by syl on 16/4/26.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController
{
    NSCalendar *myCalendar;
    NSRange monthRange;
    NSInteger   currentDayIndexOfMonth;
    NSInteger   firstDayIndexOfWeek;
}
@end
