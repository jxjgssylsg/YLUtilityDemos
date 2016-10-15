//
//  CCViewController.h
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    测试如何使用Run Loop阻塞线程，等待其他线程执行后再执行操作。
 */
@interface CCTestRunLoopViewController : UIViewController


@end

/*
 ttp://chun.tips/blog/2014/10/20/zou-jin-run-loopde-shi-jie-%5B%3F%5D-:shi-yao-shi-run-loop%3F/
 
 UIApplicationMain()方法在这里不仅完成了初始化我们的程序并设置程序Delegate的任务，而且随之开启了主线程的Run Loop, 开始接受处理事件。
 
 从图中可以看出，Run Loop是线程中的一个循环，并对接收到的事件进行处理。我们的代码可以通过提供while或者for循环来驱动Run Loop。在循环中，Run Loop对象来负责事件处理代码（接收事件并且调用事件处理方法）。
 
 Run Loop从两个不同的事件源中接收消息:
 1. Input source用来投递异步消息，通常消息来自另外的"线程"或者程序。在接收到消息并调用程序指定方法时，线程中对应的NSRunLoop对象会通过执行runUntilDate:方法来退出。
 2. Timer source 用来投递 timer 事件（Schedule 或者 Repeat）中的同步消息。在处理消息时，并"不会"退出Run Loop。
 3. Run Loop还有一个观察者Observer的概念，可以往Run Loop中加入自己的观察者以便监控Run Loop的运行过程。
 
 # Run Loop modes #
 
 Run Loop mode 可以理解为一个集合中包括所有要监视的事件源和要通知的 Run Loop 中注册的观察者。每一次运行自己的 Run Loop 时，都需要显示或者隐示的指定其运行于哪一种 Mode。在设置 Run Loop mode 后，你的 Run Loop会自动过滤和其他 mode 相关的事件源，而只监视和当前设置 mode 相关的源(通知相关的观察者)。大多数时候，Run Loop都是运行在系统定义的默认模式上。
 
 注. Run Loop Mode 区分基于事件的源，而不是事件的种类。比如你不能通过 Run Loop mode 去只选择鼠标点击事件或者键盘输入事件。你可以使用Run Loop Mode去监听端口，暂停计时器或者改变其他源。
 
 注. 我们可以给Mode指定任意名称，但是它对应的集合内容不能是任意的。我们需要添加Input source, Timer source 或者 Observer到自己自定义的Mode。
 
 下面列出 iOS 下一些已经定义的Run Loop Modes:
 1) NSDefaultRunLoopMode: 大多数工作中默认的运行方式。
 2) NSConnectionReplyMode: 使用这个 mode 去监听 NSConnection 对象的状态，我们"很少"需要自己使用这个 Mode。
 3) NSModalPanelRunLoopMode: 使用这个 mode 在 Model Panel 情况下去区分事件(OS x 开发中会遇到)。
 4) UITrackingRunLoopMode: 使用这个 mode 去跟踪来自用户交互的事件（比如 UITableView 上下滑动）。
 5) GSEventReceiveRunLoopMode: 用来接受系统事件，内部的 Run Loop Mode。
 6) NSRunLoopCommonModes: 这是一个伪模式，其为一组 run loop mode 的集合。如果将 Input source 加入此模式，意味着关联 Input source 到 Common modes 中包含的所有模式下。在 iOS 系统中 NSRunLoopCommonMode 包含NSDefaultRunLoopMode、NSTaskDeathCheckMode、UITrackingRunLoopMode.可使用 CFRunLoopAddCommonMode 方法向 Common modes 中添加自定义 mode。
 
 注. Run Loop 运行时只能以一种固定的 mode 运行，只会监控这个 mode 下添加的 Timer source 和 Input source 。如果这个 mode 下没有添加事件源，Run Loop 会立刻返回。
 
 # 事件源 #
 
 Input source 有两个不同的种类: Port-Based Sources 和 Custom Input Sources. Run Loop 本身并不关心 Input source 是哪一种类型。系统会实现两种不同的 Input source 供我们使用。这两种不同类型的 Input source 的区别在于：Port-Based Sources 由"内核"自动发送，Custom Input Sources 需要从 "其他线程" 手动发送。
 
 1. Custom Input Sources:
 我们可以使用 Core Foundation 里面的 CFRunLoopSourceRef 类型相关的函数来创建 Custom input source。
 
 2. Port-Based Sources:
 通过内置的端口相关的对象和函数，配置基于端口的 Input source。 (比如在主线程创建子线程时传入一个 NSPort 对象,主线程和子线程就可以进行通讯。NSPort对象会负责自己创建和配置Input source。)
 
 3. Cocoa Perform Selector Sources
 Cocoa 框架为我们定义了一些 Custom Input Sources，允许我们在线程中执行一系列 selector 方法。
 //在主线程的Run Loop下执行指定的 @selector 方法
 performSelectorOnMainThread:withObject:waitUntilDone:
 performSelectorOnMainThread:withObject:waitUntilDone:modes:
 
 //在当前线程的Run Loop下执行指定的 @selector 方法
 performSelector:onThread:withObject:waitUntilDone:
 performSelector:onThread:withObject:waitUntilDone:modes:
 
 //在当前线程的Run Loop下延迟加载指定的 @selector 方法
 performSelector:withObject:afterDelay:
 performSelector:withObject:afterDelay:inModes:
 
 //取消当前线程的调用
 cancelPreviousPerformRequestsWithTarget:
 cancelPreviousPerformRequestsWithTarget:selector:object:
 
 注：
 和Port-Based Sources一样的是：这些 selector 的请求会在目标线程中序列化，以减缓线程中多个方法执行带来的同步问题。
 和Port-Based Sources不一样的是： 一个selector方法执行完之后会自动从当前Run Loop中移除。
 
 注. 走进Run Loop世界系列的第二章会专门讨论如何自定义事件源。
 
 4. Timer Sources
 Timer source 在预设的时间点同步的传递消息。Timer是线程通知自己做某件事的一种方式。
 Foundation 中 NSTimer Class 提供了相关方法来设置 Timer source. 需要注意的是除了 scheduledTimerWithTimeInterval 开头的方法创建的 timer 都需要手动添加到当前 Run Loop 中。（scheduledTimerWithTimeInterval 创建的 timer 会自动以 Default mode 加载到当前 Run Loop 中。）
 
 注. Timer在选择使用一次后，在执行完成时，会从 Run Loop 中移除。选择循环时，会一直保存在当前 Run Loop 中，直到调用 invalidate 方法。
 
 5. Run Loop Observers
 事件源是同步或者异步的事件驱动时触发，而 Run Loop observer 则在 Run Loop 本身进入某个状态时得到通知:
 {
	Run Loop 进入的时候
	Run Loop 处理一个 timer 的时候
	Run Loop 处理一个 Input source 的时候
	Run Loop 进入睡眠的时候
	Run Loop 被唤醒的时候，在唤醒它的事件被处理之前
	Run Loop 停止的时候
 }
 
 注. observer 需要使用 Core Foundataion 框架。和 timer 一样，Run Loop Observers 也可以使用一次或者选择 repeat。如果只使用一次，Observer会在它被执行后自己从Run Loop中移除。而循环的Observer会一直保存在Run Loop中。
 
 # Run Loop 事件队列 #
 Run Loop 本质是一个处理事件源的循环。我们对 Run Loop 的运行时具有控制权，如果当前没有时间发生，Run Loop会让当前线程进入"睡眠模式"，来减轻 CPU 压力。如果有事件发生，Run Loop 就处理事件并通知相关的 Observer。具体的顺序如下:
	1) Run Loop 进入的时候，会通知 Observer
	2) timer 即将被触发时，会通知 Observer
	3) 有其它非 Port-Based Input source 即将被触发时，会通知 Observer
	4) 启动非 Port-Based Input source 的事件源
	5) 如果基于 Port 的 Input source 事件源即将触发时，立即处理该事件，并跳转到 9
	6) 通知 observer 当前线程进入睡眠状态
	7) 将线程置入睡眠状态直到有以下事件发生：1. Port-Based Input source 被触发。2. Timer被触发。 3. Run Loop  设置的时间已经超时。 4. Run Loop 被显示唤醒。
	8) 通知 observer 线程将要被唤醒
	9) 处理被触发的事件：1. 如果是用户自定义的 Timer，处理 Timer 事件后重启 Run Loop 并直接进入步骤 2。 2.如果线程被显示唤醒又没有超时，那么进入步骤2。 3.如果是其他Input source 事件源有事件发生，直接传递这个消息。
	10) 通知 Observer Run Loop 结束，Run Loop 退出。
 
 # 何时使用 Run Loop #
 下面是官方 document 提供的使用 Run Loop 的几个场景:
	1. 需要使用 Port-Based Input source 或者 Custom Input source 和 "其他线程"通讯时
	2. 需要在线程中使用 Timer
	3. 需要在线程中使用上文中提到的 selector 相关方法
	4. 需要让线程执行周期性的工作
 
 注. 使用Foundation中的NSRunLoop类来修改自己的Run Loop，我们必须在Run Loop的所在线程中完成这些操作。在其他线程中给Run Loop添加事件源或者Timer会导致程序崩溃。
 
 # Show time #
 1.使用 NSRunLoop 的 currentRunLoop 可以获得当前线程的 Run Loop 对象。
 NSRunLoop *currentThreadRunLoop = [NSRunLoop currentRunLoop];
 // 或者
 CFRunLoopRef currentThreadRunLoop = CFRunLoopGetCurrent();
 
 2. 在配置Run Loop之前，我们必须添加一个事件源或者 Timer source 给它。如果 Run Loop 没有任何源需要监视的话，会立刻退出。同样的我们可以给 Run Loop 注册 Observer。
 
 我们一般可以通过这几张方式"启动"Run Loop：
 1. 无条件的 : 不推荐使用，这种方式启动Run Loop会让一个线程处于永久的循环中。退出Run Loop的唯一方式就是显
 示的去杀死它。 - (void)run;
 2. 设置超时时间 - (void)runUntilDate:(NSDate *)limitDate;
 3. 特定的Mode - (BOOL)runMode:(NSString *)mode beforeDate:(NSDate *)limitDate;
 
 
 退出Run Loop一般如下：
 1. 设置超时时间："推荐使用"
 2. 通知 Run Loop 停止：使用 CFRunLoopStop 来显式的停止 Run loop。无条件启动的 Run Loop 中调用这个方法退出 Run Loop。
 
 注. 尽管移除 Run Loop 的 Input source 和 timer 也可能导致 Run loop 退出，但这并不是可靠的退出 Run loop 的方法。一些状态下系统会添加 Input source 到 Run loop 里面来处理所需事件。由于我们的代码未必会考虑到这些 Input source，这样可能导致无法移除这些事件源，从而导致 Run loop 不能正常退出。
 
 注. 为当前长时间运行的线程配置 Run Loop 的时候，最好添加至少一个 Input source 到 Run Loop 以接收消息。虽然我们可以使用 timer 来进入 Run Loop，但是一旦 timer 触发后，它通常就变为无效了，这会导致 Run Loop 退出。虽然附加一个循环的 timer 可以让 Run Loop 运行一个相对较长的周期，但是这也会导致周期性的唤醒线程，这实际上是轮询（polling）的另一种形式而已。与之相反，Input source 会一直等待某事件发生，"在事件发生前它会让线程处于休眠状态"。
 
 # 如何正确使用Run Loop阻塞线程 #
 见原文
 
 # Run Loop开发中遇到的问题 #
 1) NSTimer, NSURLConnection 和 NSStream 默认运行在 Default mode 下，UIScrollView 在接收到用户交互事件时，主线程 Run Loop 会设置为 UITrackingRunLoopMode 下，这个时候 NSTimer 不能 fire，NSURLConnection 的数据也无法处理。
 
 上述代码，在正常情况下 label 可以刷新 text，但是在用户拖动 tableView 时，label 将不在更新，直到手指离开屏幕。 解决方法，一种是修改 timer 运行的 Run Loop 模式，将其加入 NSRunLoopCommonModes 中。
 // self.testTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self         selector:@selector(updateTestLabel) userInfo:nil repeats:YES];
 
 self.testTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateTestLabel) userInfo:nil repeats:YES];
 [[NSRunLoop currentRunLoop] addTimer:self.testTimer forMode:NSRunLoopCommonModes];
 
 另外一种解决方法是在另外一个线程中处理Timer事件，在perform到主线程去更新Label。
 
 NSURLConnection和NSTimer也大致如此，其中注意NSURLConnection要使用- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately生成NSURLConnection对象，并且第三个参数要设置为NO。之后再用- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode设置Run Loop与其模式。
 关于NSURLConnection的最佳实践可以参考AFNetworking。
 
 2) NSTimer 的构造方法会对传入的 target 对象强引用，直到这个 timer 对象 invalidated。在使用时需要注意内存问题，根据需要，要在适当的地方调用 invalidated 方法。
 
 3) 运行一次的 timer 源也可能导致 Run Loop 退出：一次的 timer 在执行完之后会自己从 Run Loop 中删除，如果使用while 来驱动 Run Loop 的话，下一次再运行 Run Loop 就可能导致退出，因为此时已经没有其他的源需要监控。
 
 http://www.cnblogs.com/chenxianming/p/5527498.html
 总结：
 
 1、[runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]其实是为线程创建
 
 一个循环，如果线程已经有，创建的是一个子循环。
 
 2、通过[runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]创建的循环过一段时间或
 
 马上返回，这取决于输入源及系统的调度。所以用while进行不断驱动，不停创建循环。
 
 3、我们看到日志打印出kCFRunLoopExit是子循环的exit.
 
 https://hit-alibaba.github.io/interview/iOS/ObjC-Basic/Runloop.html
 
 # Runloop 与线程 #
 
 Runloop 和线程是绑定在一起的。每个线程（包括主线程）都有一个对应的 Runloop 对象。我们并不能自己创建 Runloop 对象，但是可以获取到系统提供的 Runloop 对象。
 
 主线程的 Runloop 会在应用启动的时候完成启动，其他线程的 Runloop 默认并不会启动，需要我们手动启动。
 
 # Input Source 和 Timer source #
 
 这两个都是 Runloop 事件的来源，其中 Input Source 又可以分为三类
 
 Port-Based Sources，系统底层的 Port 事件，例如 CFSocketRef ，在应用层基本用不到
 Custom Input Sources，用户手动创建的 Source
 Cocoa Perform Selector Sources， Cocoa 提供的 performSelector 系列方法，也是一种事件源
 Timer Source 顾名思义就是指定时器事件了。
 
 # Runloop observer #
 Runloop 通过监控 Source 来决定有没有任务要做，除此之外，我们还可以用 Runloop Observer 来监控 Runloop 本身的状态。 Runloop Observer 可以监控下面的 runloop 事件：
	The entrance to the run loop.
	When the run loop is about to process a timer.
	When the run loop is about to process an input source.
	When the run loop is about to go to sleep.
	When the run loop has woken up, but before it has processed the event that woke it up.
	The exit from the run loop.
 
 
 http://www.jianshu.com/p/b29b3ebc4343
 
 # RunLoop观察者 #
 
 RunLoop观察者
 源是在合适的同步或异步事件发生时触发，而run loop观察者则是在run loop本身运行的特定时候触发。你可以使用run loop观察者来为处理某一特定事件或是进入休眠的线程做准备。你可以将run loop观察者和以下事件关联：
 
 1.  Runloop入口
 
 2.  Runloop何时处理一个定时器
 
 3.  Runloop何时处理一个输入源
 
 4.  Runloop何时进入睡眠状态
 
 5.  Runloop何时被唤醒，但在唤醒之前要处理的事件
 
 6.  Runloop终止
 
 http://blog.ximu.site/runloop/
 #  runloop对象 #
 iOS中有2套API来访问和使用RunLoop:
 1. Foundation中的NSRunLoop
 2. Core Foundation中的CFRunLoopRef
 
 NSRunLoop和CFRunLoopRef都代表着RunLoop对象
 NSRunLoop是基于CFRunLoopRef的一层OC包装
 
 # 获取runloop对象 #
 Foundation:
 [NSRunLoop currentRunLoop]; // 获得当前线程的RunLoop对象
 [NSRunLoop mainRunLoop]; // 获得主线程的RunLoop对象
 Core Foundation:
 CFRunLoopGetCurrent(); // 获得当前线程的RunLoop对象
 CFRunLoopGetMain(); // 获得主线程的RunLoop对象
 
 # RunLoop与线程 #
 每条线程都有唯一的一个与之对应的RunLoop对象
 
 主线程的RunLoop已经自动创建好了，子线程的RunLoop需要主动创建
 
 线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。你只能在一个线程的内部获取其 RunLoop（主线程除外）
 
 # RunLoop的五个类 #
 CFRunLoopRef
 CFRunLoopModeRef
 CFRunLoopSourceRef
 CFRunLoopTimerRef
 CFRunLoopObserverRef
 
 # CFRunLoopSourceRef 类 #
 CFRunLoopSourceRef是事件源（输入源），比如外部的触摸，点击事件和系统内部进程间的通信等。
 
 按照官方文档，Source的分类：
 1. Port-Based Sources
 2. Custom Input Sources
 3. Cocoa Perform Selector Sources
 
 按照函数调用栈，Source的分类：
 Source0：非基于Port的。只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
 Source1：基于Port的，通过内核和其他线程通信，接收、分发系统事件。这种 Source 能主动唤醒 RunLoop 的线程。后面讲到的创建常驻线程就是在线程中添加一个NSport来实现的。
 
 # CFRunLoopTimerRef 类 #
 见原文
 # CFRunLoopObserverRef 类 #
 见原文
 # CFRunLoopModeRef #
 见原文
 
 下面具体解释下该流程：
 挺好的一张图，见原文  // http://7xslqw.com1.z0.glb.clouddn.com/2016/06/5---Snip20160605_8.PNG
 
 # RunLoop实践 #
 
 # 1、滚动scrollview导致定时器失效 #
 
 解决办法1：
 [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
 
 解决办法2：
 使用 GCD 创建定时器，GCD 创建的定时器不会受 runLoop 的影响
 
 //  获得队列
 dispatch_queue_t queue = dispatch_get_main_queue();
 
 //  创建一个定时器( dispatch_source_t 本质还是个 OC 对象)
 self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
 
 // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
 // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
 // 比当前时间晚1秒开始执行
 dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
 
 //每隔一秒执行一次
 uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
 dispatch_source_set_timer(self.timer, start, interval, 0);
 
 // 设置回调
 dispatch_source_set_event_handler(self.timer, ^{
 NSLog(@"------------%@", [NSThread currentThread]);
 
 });
 
 // 启动定时器
 dispatch_resume(self.timer);
 
 #  2、图片下载 #
 
 来看一个需求：
 
 由于图片渲染到屏幕需要消耗较多资源，为了提高用户体验，当用户滚动tableview的时候，只在后台下载图片，但是不显示图片，当用户停下来的时候才显示图片。
 
 实现代码
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 self.thread = [[XMGThread alloc] initWithTarget:self selector:@selector(run) object:nil];
 [self.thread start];
 }
 
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [self performSelector:@selector(useImageView) onThread:self.thread withObject:nil waitUntilDone:NO];
 }
 
 - (void)useImageView
 {
 // 只在NSDefaultRunLoopMode模式下显示图片
 [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"placeholder"] afterDelay:3.0 inModes:@[NSDefaultRunLoopMode]];
 }
 
 分析：
 上面的代码可以达到如下效果：
 
 用户点击屏幕，在主线程中，三秒之后显示图片
 
 但是当用户点击屏幕之后，如果此时用户又开始滚动textview，那么就算过了三秒，图片也不会显示出来，当用户停止了滚动，才会显示图片。
 
 这是因为限定了方法setImage只能在NSDefaultRunLoopMode 模式下使用。而滚动textview的时候，程序运行在tracking模式下面，所以方法setImage不会执行。
 
 # 3、常驻线程  #
 
 3、常驻线程
 需求：
 
 需要创建一个在后台一直存在的程序，来做一些需要频繁处理的任务。比如检测网络状态等。
 
 默认情况一个线程创建出来，运行完要做的事情，线程就会消亡。而程序启动的时候，就创建的主线程已经加入到runloop，所以主线程不会消亡。
 
 这个时候我们就需要把自己创建的线程加到runloop中来，就可以实现线程常驻后台。
 
 实现代码1、添加NSPort：
 (void)viewDidLoad {
 [super viewDidLoad];
 
 self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
 [self.thread start];
 }
 
 - (void)run
 {
 NSLog(@"----------run----%@", [NSThread currentThread]);
 @autoreleasepool{
 // 如果不加这句，会发现runloop创建出来就挂了，因为runloop如果没有CFRunLoopSourceRef事件源输入或者定时器，就会立马消亡。
 // 下面的方法给runloop添加一个NSport，就是添加一个事件源，也可以添加一个定时器，或者observer，让runloop不会挂掉
[[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];

// 方法1 ,2，3实现的效果相同，让runloop无限期运行下去
[[NSRunLoop currentRunLoop] run];
}


// 方法2
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

// 方法3
[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];

NSLog(@"---------");
}

- (void)test
{
    NSLog(@"----------test----%@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

实现代码2、添加NSTimer：
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
}
- (void)run
{
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(test) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] run];
}
分析：
如果没有实现添加NSPort或者NSTimer，会发现执行完run方法，线程就会消亡，后续再执行touchbegan方法无效。

我们必须保证线程不消亡，才可以在后台接受时间处理

RunLoop 启动前内部必须要有至少一个 Timer/Observer/Source，所以在 [runLoop run] 之前先创建了一个新的 NSMachPort 添加进去了。通常情况下，调用者需要持有这个 NSMachPort (mach_port) 并在外部线程通过这个 port 发送消息到 loop 内；但此处添加 port 只是为了让 RunLoop 不至于退出，并没有用于实际的发送消息。

可以发现执行完了run方法，这个时候再点击屏幕，可以不断执行test方法，因为线程self.thread一直常驻后台，等待事件加入其中，然后执行。

# 4、在所有UI相应操作之前处理任务  #

比如我们点击了一个按钮，在ui关联的事件开始执行之前，我们需要执行一些其他任务，可以在observer中实现

代码如下：

- (IBAction)btnClick:(id)sender {
    NSLog(@"btnClick----------");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self observer];
}
- (void)observer
{
    // 创建observer，参数kCFRunLoopAllActivities表示监听所有状态
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"----监听到RunLoop状态发生改变---%zd", activity);
    });
    // 添加观察者：监听RunLoop的状态
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    // 释放Observer
    CFRelease(observer);
}
 
 http://blog.ibireme.com/2015/05/18/runloop/
 # CFRunLoopSourceRef  #
 是事件产生的地方。Source 有两个版本：Source0 和 Source1。
 • Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
 • Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程，其原理在下面会讲到。
 
 # RunLoop 的内部逻辑 #
 /// 用DefaultMode启动
 void CFRunLoopRun(void) {
 CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
 }
 
 /// 用指定的Mode启动，允许设置RunLoop超时时间
 int CFRunLoopRunInMode(CFStringRef modeName, CFTimeInterval seconds, Boolean stopAfterHandle) {
 return CFRunLoopRunSpecific(CFRunLoopGetCurrent(), modeName, seconds, returnAfterSourceHandled);
 }
 
 /// RunLoop的实现
 int CFRunLoopRunSpecific(runloop, modeName, seconds, stopAfterHandle) {
 
 /// 首先根据modeName找到对应mode
 CFRunLoopModeRef currentMode = __CFRunLoopFindMode(runloop, modeName, false);
 /// 如果mode里没有source/timer/observer, 直接返回。
 if (__CFRunLoopModeIsEmpty(currentMode)) return;
 
 /// 1. 通知 Observers: RunLoop 即将进入 loop。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopEntry);
 
 /// 内部函数，进入loop
 __CFRunLoopRun(runloop, currentMode, seconds, returnAfterSourceHandled) {
 
 Boolean sourceHandledThisLoop = NO;
 int retVal = 0;
 do {
 
 /// 2. 通知 Observers: RunLoop 即将触发 Timer 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeTimers);
 /// 3. 通知 Observers: RunLoop 即将触发 Source0 (非port) 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeSources);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 4. RunLoop 触发 Source0 (非port) 回调。
 sourceHandledThisLoop = __CFRunLoopDoSources0(runloop, currentMode, stopAfterHandle);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 5. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
 if (__Source0DidDispatchPortLastTime) {
 Boolean hasMsg = __CFRunLoopServiceMachPort(dispatchPort, &msg)
 if (hasMsg) goto handle_msg;
 }
 
 /// 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
 if (!sourceHandledThisLoop) {
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
 }
 
 /// 7. 调用 mach_msg 等待接受 mach_port 的消息。线程将进入休眠, 直到被下面某一个事件唤醒。
 /// • 一个基于 port 的Source 的事件。
 /// • 一个 Timer 到时间了
 /// • RunLoop 自身的超时时间到了
 /// • 被其他什么调用者手动唤醒
 __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort) {
 mach_msg(msg, MACH_RCV_MSG, port); // thread wait for receive msg
 }
 
 /// 8. 通知 Observers: RunLoop 的线程刚刚被唤醒了。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopAfterWaiting);
 
 /// 收到消息，处理消息。
 handle_msg:
 
 /// 9.1 如果一个 Timer 到时间了，触发这个Timer的回调。
 if (msg_is_timer) {
 __CFRunLoopDoTimers(runloop, currentMode, mach_absolute_time())
 }
 
 /// 9.2 如果有dispatch到main_queue的block，执行block。
 else if (msg_is_dispatch) {
 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
 }
 
 /// 9.3 如果一个 Source1 (基于port) 发出事件了，处理这个事件
 else {
 CFRunLoopSourceRef source1 = __CFRunLoopModeFindSourceForMachPort(runloop, currentMode, livePort);
 sourceHandledThisLoop = __CFRunLoopDoSource1(runloop, currentMode, source1, msg);
 if (sourceHandledThisLoop) {
 mach_msg(reply, MACH_SEND_MSG, reply);
 }
 }
 
 /// 执行加入到Loop的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 
 if (sourceHandledThisLoop && stopAfterHandle) {
 /// 进入 loop 时参数说处理完事件就返回。
 retVal = kCFRunLoopRunHandledSource;
 } else if (timeout) {
 /// 超出传入参数标记的超时时间了
 retVal = kCFRunLoopRunTimedOut;
 } else if (__CFRunLoopIsStopped(runloop)) {
 /// 被外部调用者强制停止了
 retVal = kCFRunLoopRunStopped;
 } else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
 /// source/timer/observer一个都没有了
 retVal = kCFRunLoopRunFinished;
 }
 
 /// 如果没超时，mode 里没空，loop 也没被停止，那继续 loop。
 } while (retVal == 0);
 }
 
 /// 10. 通知 Observers: RunLoop 即将退出。
 __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
 }
 
 # 关于网络请求 #
 
 iOS 中，关于网络请求的接口自下至上有如下几层:
 {
 CFSocket
 CFNetwork       ->ASIHttpRequest
 NSURLConnection ->AFNetworking
 NSURLSession    ->AFNetworking2, Alamofire
 }
 • CFSocket 是最底层的接口，只负责 socket 通信。
 • CFNetwork 是基于 CFSocket 等接口的上层封装，ASIHttpRequest 工作于这一层。
 • NSURLConnection 是基于 CFNetwork 的更高层的封装，提供面向对象的接口，AFNetworking 工作于这一层。
 • NSURLSession 是 iOS7 中新增的接口，表面上是和 NSURLConnection 并列的，但底层仍然用到了 NSURLConnection 的部分功能 (比如 com.apple.NSURLConnectionLoader 线程)，AFNetworking2 和 Alamofire 工作于这一层。
 
 下面主要介绍下 NSURLConnection 的工作过程。
 
 通常使用 NSURLConnection 时，你会传入一个 Delegate，当调用了 [connection start] 后，这个 Delegate 就会不停收到事件回调。实际上，start 这个函数的内部会会获取 CurrentRunLoop，然后在其中的 DefaultMode 添加了4个 Source0 (即需要手动触发的Source)。CFMultiplexerSource 是负责各种 Delegate 回调的，CFHTTPCookieStorage 是处理各种 Cookie 的。
 
 当开始网络传输时，我们可以看到 NSURLConnection 创建了两个新线程：com.apple.NSURLConnectionLoader 和 com.apple.CFSocket.private。其中 CFSocket 线程是处理底层 socket 连接的。NSURLConnectionLoader 这个线程内部会使用 RunLoop 来接收底层 socket 的事件，并通过之前添加的 Source0 通知到上层的 Delegate。
 
 RunLoop_network   # 图片见原文 #
 
 NSURLConnectionLoader 中的 RunLoop 通过一些基于 mach port 的 Source 接收来自底层 CFSocket 的通知。当收到通知后，其会在合适的时机向 CFMultiplexerSource 等 Source0 发送通知，同时唤醒 Delegate 线程的 RunLoop 来让其处理这些通知。CFMultiplexerSource 会在 Delegate 线程的 RunLoop 对 Delegate 执行实际的回调。
 
 http://blog.csdn.net/ztp800201/article/details/9240913
 2.3 RunLoop的事件队列
 每次运行run loop，你线程的run loop对会自动处理之前未处理的消息，并通知相关的观察者。具体的顺序如下：
 {
     通知观察者run loop已经启动
     通知观察者任何即将要开始的定时器
     通知观察者任何即将启动的非基于端口的源
     启动任何准备好的非基于端口的源
     如果基于端口的源准备好并处于等待状态，立即启动；并进入步骤9。
     通知观察者线程进入休眠
     将线程置于休眠直到任一下面的事件发生：
     某一事件到达基于端口的源
     定时器启动
     Run loop设置的时间已经超时
     run loop被显式唤醒
     通知观察者线程将被唤醒。
     处理未处理的事件
     如果用户定义的定时器启动，处理定时器事件并重启run loop。进入步骤2
     如果输入源启动，传递相应的消息
     如果run loop被显式唤醒而且时间还没超时，重启run loop。进入步骤2
     通知观察者run loop结束。
 }
 
 http://www.jianshu.com/p/37ab0397fec7
 
 runloop:
 1、（要让马儿跑）通过 do-while 死循环让程序持续运行：接收用户输入，调度处理事件时间。
 2、（要让马儿少吃草）通过 mach_msg() 让 runLoop 没事时进入 trap 状态，节省 CPU 资源。
 
 4、Runloop本质：mach port 和 mach_msg()。
 Mach 是 XNU 的内核，进程、线程和虚拟内存等对象通过端口发消息进行通信，Runloop 通过 mach_msg() 函数发送消息，如果没有 port  消息，内核会将线程置于等待状态 mach_msg_trap() 。如果有消息，判断消息类型处理事件，并通过modeItem 的 callback 回调。
 
 runLoop 有两个关键判断点，一个是通过 msg 决定 runLoop 是否等待，一个是通过判断退出条件来决定 runLoop 是否循环。
 
 */
