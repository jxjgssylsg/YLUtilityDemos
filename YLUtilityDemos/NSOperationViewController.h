//
//  NSOperationViewController.h
//  YLExperimentForOC
//
//  Created by Mr_db on 16/9/19.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOperationViewController : UIViewController

@end
/*
 http://www.cnblogs.com/wendingding/p/3809042.html
 2.NSOperation 的子类
 
 NSOperation 是个抽象类,并不具备封装操作的能力,必须使⽤它的子类
 
 使用 NSOperation ⼦类的方式有3种：
 （1）NSInvocationOperation
 （2）NSBlockOperation
 （3）自定义子类继承 NSOperation,实现内部相应的⽅法
 
 // 创建操作对象，封装要执行的任务
 // NSInvocationOperation 封装操作
 NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test) object:nil];
 
 // 执行操作
 [operation start];
 
 注意：操作对象默认在主线程中执行，只有添加到队列中才会开启新的线程。即默认情况下，如果操作没有放到队列中 queue 中，都是同步执行。只有将 NSOperation 放到一个 NSOperationQueue 中,才会异步执行操作
 
 // 创建 NSBlockOperation 操作对象
 NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
 //......
 }];
 
 //添加操作
 [operation addExecutionBlock:^{
 //....
 }];

 // 创建 NSBlockOperation 操作对象
 NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
 NSLog(@"NSBlockOperation------%@",[NSThread currentThread]);
 }];
 
 
 // 开启执行操作
 [operation start];
 
 // 创建 NSBlockOperation 操作对象
 NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
 NSLog(@"NSBlockOperation------%@",[NSThread currentThread]);
 }];
 
 // 添加操作
 [operation addExecutionBlock:^{
    NSLog(@"NSBlockOperation1------%@",[NSThread currentThread]);
 }];
 
 [operation addExecutionBlock:^{
    NSLog(@"NSBlockOperation2------%@",[NSThread currentThread]);
 }];
 
 // 开启执行操作
 [operation start];

 注意:只要 NSBlockOperation 封装的操作数 > 1,就会异步执行操作

 3.NSOperationQueue
 
 NSOperationQueue 的作⽤：NSOperation 可以调⽤ start ⽅法来执⾏任务,但默认是同步执行的
 
 如果将 NSOperation 添加到 NSOperationQueue(操作队列)中,系统会自动异步执行 NSOperation 中的操作添加操作到 NSOperationQueue 中，自动执行操作，自动开启线程

 // 创建 NSOperationQueue
 NSOperationQueue * queue=[[NSOperationQueue alloc]init];
 // 把操作添加到队列中
 // 第一种方式
 [queue addOperation:operation1];
 [queue addOperation:operation2];
 [queue addOperation:operation3];
 // 第二种方式
 [queue addOperationWithBlock:^{
 NSLog(@"NSBlockOperation3--4----%@",[NSThread currentThread]);
 }];
 
 - (void)addOperation:(NSOperation *)op;
 - (void)addOperationWithBlock:(void (^)(void))block;

{
 [super viewDidLoad];
 
 // 创建 NSInvocationOperation 对象，封装操作
 NSInvocationOperation *operation1=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(test1) object:nil];
 NSInvocationOperation *operation2=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(test2) object:nil];
 // 创建对象，封装操作
 NSBlockOperation *operation3=[NSBlockOperation blockOperationWithBlock:^{
 NSLog(@"NSBlockOperation3--1----%@",[NSThread currentThread]);
 }];
 [operation3 addExecutionBlock:^{
 NSLog(@"NSBlockOperation3--2----%@",[NSThread currentThread]);
 }];
 
 // 创建 NSOperationQueue
 NSOperationQueue * queue=[[NSOperationQueue alloc]init];
 // 把操作添加到队列中
 [queue addOperation:operation1];
 [queue addOperation:operation2];
 [queue addOperation:operation3];
 }
 
 -(void)test1
 {
   NSLog(@"NSInvocationOperation--test1--%@",[NSThread currentThread]);
 }
 
 -(void)test2
 {
   NSLog(@"NSInvocationOperation--test2--%@",[NSThread currentThread]);
 }
 
 http://www.cnblogs.com/wendingding/p/3809150.html
 
 二、队列的取消，暂停和恢复
 （1）取消队列的所有操作
 
 - (void)cancelAllOperations;
 
 提⽰:也可以调用NSOperation的- (void)cancel⽅法取消单个操作
 
 （2）暂停和恢复队列
 
 - (void)setSuspended:(BOOL)b; // YES代表暂停队列,NO代表恢复队列
 
 - (BOOL)isSuspended; //当前状态
 
 （3）暂停和恢复的适用场合：在tableview界面，开线程下载远程的网络界面，对UI会有影响，使用户体验变差。那么这种情况，就可以设置在用户操作UI（如滚动屏幕）的时候，暂停队列（不是取消队列），停止滚动的时候，恢复队列。
 
 三、操作优先级
 （1）设置 NSOperation 在 queue 中的优先级,可以改变操作的执⾏优先级
 
 - (NSOperationQueuePriority)queuePriority;
 - (void)setQueuePriority:(NSOperationQueuePriority)p;
 
 （2）优先级的取值
 
 NSOperationQueuePriorityVeryLow = -8L,
 
 NSOperationQueuePriorityLow = -4L,
 
 NSOperationQueuePriorityNormal = 0,
 
 NSOperationQueuePriorityHigh = 4,
 
 NSOperationQueuePriorityVeryHigh = 8
 
 说明：优先级高的任务，调用的几率会更大。

 // 设置操作依赖
 // 先执行 operation2，再执行 operation1，最后执行 operation3
 [operation3 addDependency:operation1];
 [operation1 addDependency:operation2];
 
 // 不能是相互依赖
 //    [operation3 addDependency:operation1];
 //    [operation1 addDependency:operation3];
 
 
 A做完再做B，B做完才做C。
 注意：一定要在添加之前，进行设置。
 提示：任务添加的顺序并不能够决定执行顺序，执行的顺序取决于依赖。使用 Operation 的目的就是为了让开发人员不再关心线程。

 // 创建对象，封装操作
 NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
 for (int i=0; i<10; i++) {
 NSLog(@"-operation-下载图片-%@",[NSThread currentThread]);
 }
 }];
 
 5.操作的监听
 可以监听一个操作的执行完毕
 
 - (void (^)(void))completionBlock;
 - (void)setCompletionBlock:(void (^)(void))block;
 
 //监听操作的执行完毕
 operation.completionBlock = ^{
 //.....下载图片后继续进行的操作
 NSLog(@"--接着下载第二张图片--");
 };
 
 http://www.cnblogs.com/mjios/archive/2013/04/19/3029765.html
 
 三、NSOperation 的其他用法
 1.取消操作
 operation 开始执行之后, 默认会一直执行操作直到完成，我们也可以调用 cancel 方法中途取消操作
 [operation cancel];
 
 四、自定义 NSOperation  (重载-(void)main )
 如果 NSInvocationOperation 和 NSBlockOperation 不能满足需求，我们可以直接新建子类继承NSOperation，并添加任何需要执行的操作。如果只是简单地自定义 NSOperation，只需要重载-(void)main 这个方法，在这个方法里面添加需要执行的操作
 
 http://blog.csdn.net/q199109106q/article/details/8566222
 一、简介
 一个 NSOperation 对象可以通过调用start方法来执行任务，默认是同步执行的。也可以将NSOperation添加到一个NSOperationQueue(操作队列)中去执行，而且是异步执行的。
 创建一个操作队列：
 NSOperationQueue *queue = [[NSOperationQueue alloc] init];
 
 二、添加 NSOperation 到 NSOperationQueue 中
 1.添加一个operation
 [queue addOperation:operation];
 
 2.添加一组 operation
 [queue addOperations:operations waitUntilFinished:NO];
 
 3.添加一个 block 形式的 operation
 [queue addOperationWithBlock:^() {
 NSLog(@"执行一个新的操作，线程：%@", [NSThread currentThread]);
 }];
 
 六、取消 Operations
 一旦添加到 operation queue,queue 就拥有了这个 Operation 对象并且不能被删除,唯一能做的事情是取消。你可以调用 Operation 对象的 cancel 方法取消单个操作,也可以调用 operation queue的cancelAllOperations方法取消当前 queue 中的所有操作。
 // 取消单个操作
 [operation cancel];
 
 // 取消queue中所有的操作
 [queue cancelAllOperations];
 
 八、暂停和继续 queue
 如果你想临时暂停 Operations 的执行,可以使用 queue 的 setSuspended: 方法暂停 queue。不过暂停一个 queue 不会导致正在执行的 operation 在任务中途暂停,只是简单地阻止调度新 Operation 执行。你可以在响应用户请求时,暂停一个 queue 来暂停等待中的任务。稍后根据用户的请求,可以再次调用 setSuspended: 方法继续 queue 中 operation 的执行
 [java] view plain copy
 // 暂停queue
 [queue setSuspended:YES];
 
 // 继续queue
 [queue setSuspended:NO];

 http://www.jianshu.com/p/2de9c776f226
 
 NSOperationQueue *queue = [[NSOperationQueue alloc] init];
 // 子线程下载图片
 [queue addOperationWithBlock:^{
 NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
 NSData *data = [NSData dataWithContentsOfURL:url];
 UIImage *image = [[UIImage alloc] initWithData:data];
 // 回到主线程进行显示
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
 self.imageView.image = image;
 }];
 }];
 
 
 
 */