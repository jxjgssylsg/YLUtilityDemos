//
//  ViewController.h
//  DemoLocalNotification
//
//  Created by zj－db0465 on 15/9/22.
//  Copyright © 2015年 icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalNotificationViewController : UIViewController


@end

/* 
 http://www.cnblogs.com/cy568searchx/p/5142638.html
 # 1.创建一个本地通知，添加到系统： #
 
 // 初始化本地通知对象
 UILocalNotification *notification = [[UILocalNotification alloc] init];
 if (notification) {
 // 设置通知的提醒时间
 NSDate *currentDate   = [NSDate date];
 notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
 notification.fireDate = [currentDate dateByAddingTimeInterval:5.0];
 
 // 设置重复间隔
 notification.repeatInterval = kCFCalendarUnitDay;
 
 // 设置提醒的文字内容
 notification.alertBody   = @"Wake up, man";
 notification.alertAction = NSLocalizedString(@"起床了", nil);
 
 // 通知提示音 使用默认的
 notification.soundName = UILocalNotificationDefaultSoundName;
 
 // 设置应用程序右上角的提醒个数
 notification.applicationIconBadgeNumber++;
 
 // 设定通知的userInfo，用来标识该通知
 NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
 aUserInfo[kLocalNotificationID] = @"LocalNotificationID";
 notification.userInfo = aUserInfo;
 
 // 将通知添加到系统中
 [[UIApplication sharedApplication] scheduleLocalNotification:notification];
 }
 
 repeatInterval 表示通知的重复间隔.
 注. 这里比较不好的一点是该值不能自定义（很遗憾，NSCalendarUnit 是个枚举类型），例如你不能塞个 10.0 给它从而希望它每十秒重复一次。所以如果你想每 20 分钟发送一次通知，一小时内发送 3 次，那么只能同时设定三个通知了
 
 # 2.收到通知后委托内的自定义实现：#
 -(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
 NSLog(@"Application did receive local notifications");
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"welcome" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 }
 
 # 3.如何取消（删除本地通知） #
 注. 有一点需要注意，如果我们的应用程序给系统发送的本地通知是周期性的，那么即使把程序删了重装，之前的本地通知在重装时依然存在（没有从系统中移除）。
 
 因此我们需要取消通知的方法，当然该对象也会在 scheduledLocalNotifications 数组中移除。
 
 取消方法分为两种：
 1. 第一种比较暴力，直接取消所有的本地通知：
 [[UIApplication sharedApplication]  cancelAllLocalNotifications];
 注. 这个适合在 App 重装时第一次启动的时候，或还原程序默认设置等场合下使用。
 2. 第二种方法是针对某个特定通知的：
 - (void)cancelLocalNotification:(UILocalNotification *)notification
 
 # 4.如何标识一个本地通知 #
 需要通知有一个标识，这样我们才能定位是哪一个通知。可以在 notification 的 userInfo（一个字典）中指定
 -  (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
 NSLog(@"Application did receive local notifications");
 
 // 取消某个特定的本地通知
 for (UILocalNotification *noti in [[UIApplication sharedApplication]  scheduledLocalNotifications]) {
 NSString *notiID = noti.userInfo[kLocalNotificationID];
 NSString *receiveNotiID = notification.userInfo[kLocalNotificationID];  // 这句可以拿到循环外吧
 if ([notiID isEqualToString:receiveNotiID]) {
 [[UIApplication sharedApplication]  cancelLocalNotification:notification];
 return;
 }
 }
 
 UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Hello" message:@"welcome" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 }
 
 当然使用上述本地通知的前提是，应用获取到了系统的通知权限，需要注册通知：
 1.开发配置文件 provisioning profile，也就是 .mobileprovision 后缀的文件的 App id 不能使用通配 id ，必须使用指定APP id 并且生成配置文件中选择 Push Notifications 服务，一般的开发配置文件无法完成注册；
 2. 应用 程序的 Bundle identifier 必须和生成配置文件使用的 APP id 完全一致
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 UIDevice *device = [UIDevice currentDevice];
 float sysVersion = [device.systemVersion floatValue];
 if (sysVersion >= 8.0f) {
 UIUserNotificationSettings *setting = [[UIApplication sharedApplication]  currentUserNotificationSettings];
 if (UIUserNotificationTypeNone != setting.types) {
 [self addLocalNotification];
 NSLog(@"已经允许了通知");
 } else {
 [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
 [[UIApplication sharedApplication] registerForRemoteNotifications];
 }
 } else {  // 8.0 以下版本
 UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
 if(UIRemoteNotificationTypeNone != type) { // 这里怎么变成了 remote 了.. 黑线... 似乎 8.0 以下本地通知是默认允许的，所以只需要注册远程通知了
 NSLog(@"已经允许了通知");
 } else {
 [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
 }
 }
 
 // [self registerRemoteNotification];
 return YES;
 }
 
 #pragma mark 调用过用户注册通知方法之后执行（也就是调用完 registerUserNotificationSettings:方法之后执行）
 -(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
 if (notificationSettings.types!=UIUserNotificationTypeNone) {
 // [self addLocalNotification];
    NSLog(@"允许了通知");
 }
 }
 
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 NSLog(@"注册成功");
 }
 
 - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败");
 }
 
 注：
 1. 在使用通知之前必须注册通知类型，如果用户不允许应用程序发送通知，则以后就无法发送通知，除非用户手动到iOS 设置中打开通知。
 2. 本地通知是有操作系统统一调度的，只有在应用退出到后台或者关闭才能收到通知。(注意：这一点对于后面的推送通知也是完全适用的。 ）
 3. 通知的声音是由 iOS 系统播放的，格式必须是 Linear PCM、MA4（IMA/ADPCM）、µLaw、aLaw 中的一种，并且播放时间必须在 30s 内，否则将被系统声音替换，同时自定义声音文件必须放到 boundle 中。
 4. 本地通知的数量是有限制的，最近的本地通知最多只能有 64 个，超过这个数量将被系统忽略。
 5. 如果想要移除本地通知可以调用 UIApplication 的 cancelLocalNotification: 或 cancelAllLocalNotifications 移除指定通知或所有通知。
 
 # 从上面的程序可以看到userInfo这个属性我们设置了参数，那么这个参数如何接收呢？ #
 1. 如果应用程序已经完全退出那么此时会调用 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 方法；
 2. 如果此时应用程序还在运行（无论是在前台还是在后台）则会调用 -(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 方法接收消息参数。
 
 当然如果是后者自然不必多说，因为参数中已经可以拿到 notification 对象，只要读取 userInfo 属性即可。如果是前者的话则可以访问 launchOptions 中键为 UIApplicationLaunchOptionsLocalNotificationKey 的对象，这个对象就是发送的通知，由此对象再去访问 userInfo。为了演示这个过程在下面的程序中将 userInfo 的内容写入文件以便模拟关闭程序后再通过点击通知打开应用获取 userInfo 的过程。
 
 #pragma mark - 应用代理方法
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 // 添加通知
 [self addLocalNotification];
 
 //接收通知参数
 UILocalNotification *notification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
 NSDictionary *userInfo= notification.userInfo;
 
 [userInfo writeToFile:@"/Users/kenshincui/Desktop/didFinishLaunchingWithOptions.txt" atomically:YES];
 NSLog(@"didFinishLaunchingWithOptions:The userInfo is %@.",userInfo);
 
 return YES;
 }
 
 上面的程序可以分为两种情况去运行：
 
 1. 一种是启动程序关闭程序，等到接收到通知之后点击通知重新进入程序；
 2. 另一种是启动程序后，进入后台（其实在前台也可以，但是为了明显的体验这个过程建议进入后台），接收到通知后点击通知进入应用。
 
 两种情况会分别按照前面说的情况调用不同的方法接收到 userInfo 写入本地文件系统。有了 userInfo 一般来说就可以根据这个信息进行一些处理，例如可以根据不同的参数信息导航到不同的界面，假设是更新的通知则可以导航到更新内容界面等。
 
 http://www.saitjr.com/ios/ios-uiocalnotification.html
 # 五、注册本地通知 #
 
 - (void)scheduleLocalNotification {
 
 // 初始化本地通知
 UILocalNotification *localNotification = [[UILocalNotification alloc] init];
 
 // 通知触发时间
 localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
 // 触发后，弹出警告框中显示的内容
 localNotification.alertBody = @"弹出警告框中显示的内容";
 // 触发时的声音（这里选择的系统默认声音）
 localNotification.soundName = UILocalNotificationDefaultSoundName;
 // 触发频率（repeatInterval是一个枚举值，可以选择每分、每小时、每天、每年等）
 localNotification.repeatInterval = NSCalendarUnitDay;
 // 需要在App icon上显示的未读通知数（设置为1时，多个通知未读，系统会自动加1，如果不需要显示未读数，这里可以设置0）
 localNotification.applicationIconBadgeNumber = 1;
 // 设置通知的id，可用于通知移除，也可以传递其他值，当通知触发时可以获取
 localNotification.userInfo = @{@"id" : @"notificationId1"};
 
 // 注册本地通知
 [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
 }
 
 # 七、移除本地通知 #
 移除本地通知的方法有两种:
 1. 一种是全部移除：
 [[UIApplication sharedApplication] cancelAllLocalNotifications];
 
 2. 一种是按照 id 来移除，这个 id  就是在注册通知时，写的 id：
 - (void)removeLocalNotification {
 
 // 取出全部本地通知
 NSArray *notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
 // 设置要移除的通知id
 NSString *notificationId = @"notificationId1";
 
 // 遍历进行移除
 for (UILocalNotification *localNotification in notifications) {
 
 // 将每个通知的id取出来进行对比
 if ([[localNotification.userInfo objectForKey:@"id"] isEqualToString:notificationId]) {
 
 // 移除某一个通知
 [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
 }
 }
 }
 
 # 八、注意事项  #
 1. 如果需要做一个闹钟或备忘录之类的应用，则将时间作为 fireDate，触发之后可以进行移除；
 2. 一个 App 中，本地通知数量最多 64 个，不用的通知要及时移除；
 3. 如果通知的时间是后台返回的，那每次需要将通知全部移除，再添加新的。
 
 */