//
//  AppDelegate.m
//  DemoLocalNotification
//
//  Created by zj－db0465 on 15/9/22.
//  Copyright © 2015年 icetime17. All rights reserved.
//

#import "AppDelegateForLocalNotification.h"

@interface AppDelegateForLocalNotification ()

@end

@implementation AppDelegateForLocalNotification


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 申请通知权限,这里没有考虑 iOS 8.0 以下版本的问题,参见文章
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    
    // 接收通知参数,当关闭应用重新进入时有通知会到这里操作
    UILocalNotification *notification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *userInfo = notification.userInfo;
     [userInfo writeToFile:@"/Users/mr_db/Desktop/didFinishLaunchingWithOptions.txt" atomically:YES];
    NSLog(@"didFinishLaunchingWithOptions:The userInfo is %@.",userInfo);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // appIcon 上的消息提示个数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    

#define kLocalNotificationTimeInterval_1Mins        (60 * 1)
#define kLocalNotificationTimeInterval_3Mins        (60 * 3)
    
    // 添加 1Mins 和 3Mins 的 localNotification
    [self setLocalNotification:kLocalNotificationTimeInterval_1Mins];
    [self setLocalNotification:kLocalNotificationTimeInterval_3Mins];
    
}

- (void)setLocalNotification:(NSTimeInterval)timeInterval {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置提醒时间为 20:00
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        dateComponents.hour = 20;
        dateComponents.minute = 0;
        NSDate *fireDate = [calendar dateFromComponents:dateComponents];
        // notification.repeatInterval = NSCalendarUnitDay; // 重复间隔
        fireDate = [NSDate date];
        
        notification.fireDate = [fireDate dateByAddingTimeInterval:timeInterval];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = [NSString stringWithFormat:@"Local Notification %f", timeInterval];
        notification.applicationIconBadgeNumber = 1;
        
#define LocalNotificationPeriod_1Mins   @"LocalNotificationPeriod_1Mins"
#define LocalNotificationPeriod_3Mins   @"LocalNotificationPeriod_3Mins"
        
        NSString *period;
        if (timeInterval == kLocalNotificationTimeInterval_1Mins) {
            period = LocalNotificationPeriod_1Mins;
        } else {
            period = LocalNotificationPeriod_3Mins;
        }
        
        notification.userInfo = @{
                                  @"id": period,
                                  };
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// APP 运行中收到 notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"notification : %@", notification);
    
    if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@"notification_1"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification" message:@"notification_1" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
