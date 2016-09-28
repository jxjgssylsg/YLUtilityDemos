//
//  ViewController.h
//  NSThreadDemo
//
//  Created by rongfzh on 12-9-23.
//  Copyright (c) 2012年 rongfzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSThreadViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end


/*
  http://www.jianshu.com/p/8ed06312d8bd
 
 + (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(nullable id)argument;
 - (instancetype)initWithTarget:(id)target selector:(SEL)selector object:(nullable id)argument NS_AVAILABLE(10_5, 2_0);
 
 //①
 - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array;
 //②
 - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
 
 //③
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array NS_AVAILABLE(10_5, 2_0);
 //④
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait NS_AVAILABLE(10_5, 2_0);
 
 ①：将selector丢给主线程执行，可以指定runloop mode
 ②：将selector丢给主线程执行，runloop mode默认为common mode
 ③：将selector丢个指定线程执行，可以指定runloop mode
 ④：将selector丢个指定线程执行，runloop mode默认为default mode
 所以我们一般用③④方法将任务丢给辅助线程，任务执行完成之后再使用①②方法将结果传回主线程。
 
 注意：perform方法只对拥有runloop的线程有效，如果创建的线程没有添加runloop，perform的selector将无法执行。
 
 
 http://www.jianshu.com/p/9f06ac281a74
 
 二、线程同步
 
 1.实质：为了防止多个线程抢夺统一资源造成的数据安全问题
 
 2.实现：给代码加一个互斥锁（同步锁）
 
 @synchronized(self){
 
 //被锁住的代码
 
 }
 
 http://www.2cto.com/kf/201408/327231.html
 
 -(void )threadOneMethod{
 @synchronized(@"lock"){
 for (int i= 0; i<10; i++) { //循环10次，每次输出一个标识，然后线程沉睡一秒
 NSLog(@"111");
 sleep(1);
 }
 }
 NSLog(@"thread1 end");
 }
 ///////////////////////
 
 -(void )threadTwoMethod{
 @synchronized(@"lock"){
 for (int i= 0; i<5; i++) { //循环5次，每次输出一个标识222，然后线程沉睡1秒
 NSLog(@"222");
 sleep(1);
 }
 }
 NSLog(@"thread2 end");
 }
 上面的例子是结合第一种线程构建方法的，两个线程几乎同时开启，但是第一个更快一些，执行后效果是，第一个方法循环输出10次“111”结束后，第二个方法才输出“222”。因为第一个方法开始进入@synchronized(@"lock")里面之后，第二个方法在执行到@synchronized(@"lock")这里就进不去了，会等到前面一个线程从里面出来，它才能继续向下进行，这就是线程锁的作用。有些时候多个线程会同时操作用同一个数据或对象，可能会出现意想不到的糟糕情况，会使用线程锁让某个线程在操作的时候，其他线程无法操作，从而保证线程安全。
 @synchronized(@"lock")是使用括号里面的对象来区分的，如果把第二个方法里的对象改掉，变成@synchronized(@"111111"),就不会起到锁的作用了，因为这是它们就是两个完全不相关的锁了。
 
 
 */