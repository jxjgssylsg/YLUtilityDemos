//
//  ViewController.h
//  gcdTest
//
//  Created by rongfzh on 12-8-7.
//  Copyright (c) 2012年 rongfzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end


/*
http://www.cnblogs.com/wendingding/p/3806821.html#undefined
 
 （1）使用 dispatch_queue_create 函数创建串行队列
 
 dispatch_queue_t  dispatch_queue_create(const char *label,  dispatch_queue_attr_t attr); // 队列名称， 队列属性，一般用 NULL 即可
 
 示例：
 
 dispatch_queue_t queue = dispatch_queue_create("wendingding", NULL); // 创建
 
 dispatch_release(queue); // 非 ARC 需要释放手动创建的队列
 
 （2）使用主队列（跟主线程相关联的队列）
 
 主队列是 GCD 自带的一种特殊的串行队列,放在主队列中的任务，都会放到主线程中执行
 
 使用 dispatch_get_main_queue() 获得主队列
 
 示例：
 
 dispatch_queue_t queue = dispatch_get_main_queue();
 
 dispatch_queue_t dispatch_get_global_queue(dispatch_queue_priority_t priority,unsigned long flags);
 
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 获得全局并发队列
 
       全局并发队列 手动创建串行队列  主队列
 同步:  没有,串行    没有,串行      没有,串行
 异步:  有,并发      有,串行       没有,串行
 
 
 （6）小结
 
 说明：同步函数不具备开启线程的能力，无论是什么队列都不会开启线程；异步函数具备开启线程的能力，开启几条线程由队列决定（串行队列只会开启一条新的线程，并发队列会开启多条线程）。
 
 同步函数
 
 （1）并发队列：不会开线程
 
 （2）串行队列：不会开线程
 
 异步函数
 
 （1）并发队列：能开启 N 条线程
 
 （2）串行队列：开启 1 条线程
 
 补充：
 
 凡是函数中，各种函数名中带有 create\copy\new\retain 等字眼，都需要在不需要使用这个数据的时候进行 release。
 GCD 的数据类型在 ARC 的环境下不需要再做release。
 CF（core Foundation）的数据类型在 ARC 环境下还是需要做 release。
 异步函数具备开线程的能力，但不一定会开线程
 
 注: 主队列一定不会开启新线程的!
 
 http://www.cnblogs.com/wendingding/p/3807265.html 文顶顶
 一、主队列介绍
 
 主队列：是和主线程相关联的队列，主队列是 GCD 自带的一种特殊的串行队列，放在主队列中得任务，都会放到主线程中执行。
 提示：如果把任务放到主队列中进行处理，那么不论处理函数是异步的还是同步的都不会开启新的线程。
 获取主队列的方式：
 dispatch_queue_t queue = dispatch_get_main_queue();
 注. 主队列使用同步函数 dispatch_sync，在主线程中会发生死循环！任务无法往下执行。


// 从子线程回到主线程:
 
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     // 执⾏耗时的异步操作...
 
     dispatch_async(dispatch_get_main_queue(), ^{
 
      // 回到主线程,执⾏ UI 刷新操作
 
     });
     });
 
 https://zonble.gitbooks.io/kkbox-ios-dev/content/threading/gcd.html
 如果我們想要讓好幾件工作都在背景執行，而每件工作並非平行執行，而是一件工作做完之後，再繼續下一件，我們便可以使用 serial 的 queue。像這樣
     dispatch_queue_t serialQueue = \
     dispatch_queue_create("com.kkbox.queue", DISPATCH_QUEUE_SERIAL);
     
     dispatch_async(serialQueue, ^{
     [someObject doSomethingHere];
     });
     
     dispatch_async(serialQueue, ^{
     [someObject doSomethingHereAsWell];
     });
 
 https://cnbin.github.io/blog/2015/05/26/ios-gcdshi-yong-ji-qiao/
 dispatch queue 分成以下三种：
 
 运行在主线程的 Main queue，通过 dispatch_get_main_queue 获取。
 
 并行队列 global dispatch queue，通过 dispatch_get_global_queue 获取，由系统创建三个不同优先级的 dispatch queue。并行队列的执行顺序与其加入队列的顺序相同。
 
 串行队列 serial queues 一般用于按顺序同步访问，可创建任意数量的串行队列，各个串行队列之间是并发的。 当想要任务按照某一个特定的顺序执行时，串行队列是很有用的。串行队列在同一个时间只执行一个任务。我们可以使用串行队列代替锁去保护共享的数据。和锁不同，一个串行队列可以保证任务在一个可预知的顺序下执行。serial queues 通过 dispatch_queue_create 创建，可以使用函数dispatch_retain 和 dispatch_release 去增加或者减少引用计数。
 
 //  后台执行：
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 // something
 });
 
 // 主线程执行：
 dispatch_async(dispatch_get_main_queue(), ^{
 // something
 });
 
 // 一次性执行：
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 // code to be executed once
 });
 
 // 延迟 2 秒执行：
 double delayInSeconds = 2.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 // code to be executed on the main queue after delay
 });
 
 // 自定义 dispatch_queue_t
 dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", DISPATCH_QUEUE_SERIAL);
 dispatch_async(urls_queue, ^{
 　 　// your code
 });
 dispatch_release(urls_queue);
 
 // 合并汇总结果
 dispatch_group_t group = dispatch_group_create();
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
 // 并行执行的线程一
 });
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
 // 并行执行的线程二
 });
 dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
 // 汇总结果
 });
 
 串行队列
 dispatch_queue_t queue = dispatch_queue_create("com.example.MyQueue", DISPATCH_QUEUE_SERIAL);
 // 并行队列
 dispatch_queue_t queue = dispatch_queue_create("com.example.MyQueue", DISPATCH_QUEUE_CONCURRENT);
 
 注. dispatch_after 是延迟提交，不是延迟运行
 
 http://blog.devtang.com/2012/02/22/use-gcd/
 
 - (void)applicationDidEnterBackground:(UIApplication *)application {
   [self beingBackgroundUpdateTask];
   // 在这里加上你需要长久运行的代码
   NSLog(@"hahahah jin houtai 后台 ");
   [self endBackgroundUpdateTask];
 }
 
 - (void)beingBackgroundUpdateTask {
   self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
   NSLog(@"hahhahahah 过期了!");
   [self endBackgroundUpdateTask];
  }];
 }
 
 - (void)endBackgroundUpdateTask
 {
 [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
 self.backgroundUpdateTask = UIBackgroundTaskInvalid;
 NSLog(@"ending 啦啦啦");
 }
 
 http://www.jianshu.com/p/d4d6a0338b54
 一个 dispatch barrier 允许在一个并发队列中创建一个同步点。当在并发队列中遇到一个barrier, 他会延迟执行 barrier 的 block,等待所有在 barrier 之前提交的 blocks 执行结束。 这时，barrier block 自己开始执行。 之后，队列继续正常的执行操作。
 
 调用这个函数总是在 barrier block 被提交之后立即返回，不会等到 block 被执行。当 barrier block 到并发队列的最前端，他不会立即执行。相反，队列会等到所有当前正在执行的 blocks 结束执行。到这时，barrier 才开始自己执行。所有在 barrier block 之后提交的 blocks 会等到 barrier block 结束之后才执行。
 
 这里指定的并发队列应该是自己通过 dispatch_queue_create 函数创建的。如果你传的是一个串行队列或者全局并发队列，这个函数等同于dispatch_async函数。
 
 https://github.com/ming1016/study/wiki/%E7%BB%86%E8%AF%B4GCD%EF%BC%88Grand-Central-Dispatch%EF%BC%89%E5%A6%82%E4%BD%95%E7%94%A8  // 字典级详细
 
 dispatch_barrier_async 使用 Barrier Task 方法 Dispatch Barrier 解决多线程并发读写同一个资源发生死锁
 
 Dispatch Barrier 确保提交的闭包是指定队列中在特定时段唯一在执行的一个。在所有先于 Dispatch Barrier 的任务都完成的情况下这个闭包才开始执行。轮到这个闭包时 barrier 会执行这个闭包并且确保队列在此过程不会执行其它任务。闭包完成后队列恢复。
 注. dispatch_barrier_async 只在自己创建的队列上有这种作用，在全局并发队列和串行队列上，效果和 dispatch_sync 一样
 
 // 创建队列
 self.isolationQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
 //改变setter
 - (void)setCount:(NSUInteger)count forKey:(NSString *)key
 {
    key = [key copy];
    // 确保所有 barrier 都是 async 异步的
    dispatch_barrier_async(self.isolationQueue, ^(){
 if (count == 0) {
    [self.counts removeObjectForKey:key];
 } else {
    self.counts[key] = @(count);
 }
 });
 }
 - (void)dispatchBarrierAsyncDemo {
 // 防止文件读写冲突，可以创建一个串行队列，操作都在这个队列中进行，没有更新数据读用并行，写用串行。
 dispatch_queue_t dataQueue = dispatch_queue_create("com.starming.gcddemo.dataqueue", DISPATCH_QUEUE_CONCURRENT);
 dispatch_async(dataQueue, ^{
    [NSThread sleepForTimeInterval:2.f];
    NSLog(@"read data 1");
 });
 dispatch_async(dataQueue, ^{
    NSLog(@"read data 2");
 });
 // 等待前面的都完成，在执行 barrier 后面的
 dispatch_barrier_async(dataQueue, ^{
    NSLog(@"write data 1");
    [NSThread sleepForTimeInterval:1];
 });
 dispatch_async(dataQueue, ^{
    [NSThread sleepForTimeInterval:1.f];
    NSLog(@"read data 3");
 });
 dispatch_async(dataQueue, ^{
    NSLog(@"read data 4");
 });
 }
 
 http://blog.csdn.net/zhangao0086/article/details/38904923
 
 // 暂停
 dispatch_suspend(globalQueue)
 // 恢复
 dispatch_resume(globalQueue)
 
 http://www.beauty-soft.net/blog/ceiba/object-c/20130513/639.html
 
 一、线程管理常用方法
 
 1.performSelector(InBackground or MainThread)
 这个方法比较方便，但是问题在于参数传递只能支持一个对象（传多个参数，我是将其打包在一个NSDictionary里面）
 2.NSOperationQueue
 这个方法稍微复杂，提供了每个任务的封装 (NSOperation)。可以继承 NSOperation之后，在 main 函数中写一些同步执行的代码，然后放到一个 Queue 之中，Queue 自动管理 Operation 的执行和调度（在UI线程以外）。对于异步执行的代码，需要重载 NSOperation 的好几个函数才能正常工作（告诉Queue关于这个任务的进度以及执行情况）。
 3.NSThread
 轻量级的线程管理机制
 4.GCD
 在UI线程和其它线程之间切换很方便，可以和NSOperationQueue搭配使用。本文着重介绍这个方法。
 
 5,pthread
 
 */