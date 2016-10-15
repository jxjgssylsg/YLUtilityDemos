//
//  ViewController.h
//  关于NSNotificationCenter的探讨
//
//  Created by yifan on 15/9/16.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCenterViewController : UIViewController

@end

/*
 http://southpeak.github.io/2015/03/20/cocoa-foundation-nsnotificationcenter/
 一个NSNotificationCenter对象(通知中心)提供了在程序中广播消息的机制，它实质上就是一个通知分发表。这个分发表负责维护为各个通知注册的观察者，并在通知到达时，去查找相应的观察者，将通知转发给他们进行处理。
 
 # 添加观察者 #
 如果想让对象监听某个通知，则需要在通知中心中将这个对象注册为通知的观察者。早先，NSNotificationCenter提供了以下方法来添加观察者：
 - (void)addObserver:(id)notificationObserver
 selector:(SEL)notificationSelector
 name:(NSString *)notificationName
 object:(id)notificationSender
 这个方法带有4个参数，分别指定了通知的观察者、处理通知的回调、通知名及通知的发送对象。这里需要注意几个问题：
 1. notificationObserver 不能为nil。
 2. notificationSelector 回调方法有且只有一个参数( NSNotification 对象) 。
 3. 如果 notificationName 为 nil，则会接收所有的通知(如果 notificationSender 不为空，则接收所有来自于  notificationSender的所有通知)。如代码清单1所示。
 4. 如果 notificationSender 为 nil，则会接收所有 notificationName 定义的通知；否则，接收由 notificationSender 发送的通知。
 5. 监听同一条通知的多个观察者，在通知到达时，它们执行回调的顺序是不确定的，所以我们不能去假设操作的执行会按照添加观察者的顺序来执行。
 
 代码清单1：添加一个 Observer，其中 notificationName 为 nil
 @implementation ViewController
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:nil object:nil];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];
 }
 - (void)handleNotification:(NSNotification *)notification
 {
 NSLog(@"notification = %@", notification.name);
 }
 @end
 
 输出结果如下 Log ：
 notification = TestNotification
 notification = UIWindowDidBecomeVisibleNotification
 notification = UIWindowDidBecomeKeyNotification
 notification = UIApplicationDidFinishLaunchingNotification
 notification = _UIWindowContentWillRotateNotification
 notification = _UIApplicationWillAddDeactivationReasonNotification
 notification = _UIApplicationDidRemoveDeactivationReasonNotification
 notification = UIDeviceOrientationDidChangeNotification
 notification = _UIApplicationDidRemoveDeactivationReasonNotification
 notification = UIApplicationDidBecomeActiveNotification
 
 可以看出，我们的对象基本上监听了测试程序启动后的所示消息。当然，我们很少会去这么做。
 
 而对于第4条，使用得比较多的场景是监听 UITextField 的修改事件，通常我们在一个 viewController 中，只希望去监听当前视图中的 UITextField 修改事件，而不希望监听所有 UITextField 的修改事件，这时我们就可以将当前页面的 UITextField 对象指定为 notificationSender。
 
 在iOS 4.0之后，NSNotificationCenter 为了跟上时代，又提供了一个以 block 方式实现的添加观察者的方法，如下所示：
 
 - (id<NSObject>)addObserverForName:(NSString *)name
 object:(id)obj
 queue:(NSOperationQueue *)queue
 usingBlock:(void (^)(NSNotification *note))block
 
 大家第一次看到这个方法时是否会有这样的疑问：观察者呢？参数中并没有指定具体的观察者，那谁是观察者呢？实际上，与前一个方法不同的是，前者使用一个现存的对象作为观察者，而这个方法会创建一个匿名的对象作为观察者(即方法返回的 id<NSObject> 对象)，这个匿名对象会在指定的队列 (queue) 上去执行我们的 block。
 
 注. 返回的 id<NSObject> 是观察者。
 
 这个方法的优点在于添加观察者的操作与回调处理操作的代码更加紧凑，不需要拼命滚动鼠标就能直接找到处理代码，简单直观。这个方法也有几个地方需要注意：
 1. name 和 obj 为 Nil 时的情形与前面一个方法是相同的。
 2. 如果 queue 为 nil，则消息是默认在 post 线程中同步处理，即通知的 post 与转发是在同一线程中；但如果我们指定了操作队列，情况就变得有点意思了，我们一会再讲。
 3. block 块会被通知中心拷贝一份(执行 copy 操作)，以在堆中维护一个 block 对象，直到观察者被从通知中心中移除。所以，应该特别注意在 block 中使用外部对象，避免出现对象的循环引用，这个我们在下面将举例说明。
 4. 如果一个给定的通知触发了多个观察者的 block 操作，则这些操作会在各自的 Operation queue 中被并发执行。所以我们不能去假设操作的执行会按照添加观察者的顺序来执行。
 5. 该方法会返回一个表示观察者的对象，记得在不用时释放这个对象。
 
 关于第2点，当我们指定一个 Operation queue 时，不管通知是在哪个线程中 post 的，都会在 Operation queue 所属的线程中进行转发，如代码清单2所示：
 代码清单2：在指定队列中接收通知
 @implementation ViewController
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [[NSNotificationCenter defaultCenter] addObserverForName:TEST_NOTIFICATION object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
 
 NSLog(@"receive thread = %@", [NSThread currentThread]);
 }];
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
 NSLog(@"post thread = %@", [NSThread currentThread]);
 [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];
 });
 }
 @end
 
 在这里，我们在 "主线程" 里添加了一个观察者，并指定在主线程队列中去接收处理这个通知。然后我们在一个 "全局队列" 中 post 了一个通知。我们来看下输出结果：
 LOG:
	post thread = <NSThread: 0x7ffe0351f5f0>{number = 2, name = (null)}
	receive thread = <NSThread: 0x7ffe03508b30>{number = 1, name = main}
 
 可以看到，消息的 post 与接收处理并不是在同一个线程中。如上面所提到的，如果 queue 为 nil，则消息是默认在 post 线程中同步处理，大家可以试一下。
 
 对于第 3 点，由于使用的是 block，所以需要注意的就是避免引起循环引用的问题，如代码清单3所示：
 
 代码清单 3：block 引发的循环引用问题
 
 @interface Observer : NSObject
 @property (nonatomic, assign) NSInteger i;
 @property (nonatomic, weak) id<NSObject> observer;
 @end
 
 @implementation Observer
 
 - (instancetype)init
 {
 self = [super init];
 
 if (self)
 {
 NSLog(@"Init Observer");
 
 // 添加观察者
 _observer =  [[NSNotificationCenter defaultCenter] addObserverForName:TEST_NOTIFICATION object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
 
 NSLog(@"handle notification");
 
 // 使用self
 self.i = 10;
 }];
 }
 
 return self;
 }
 @end
 
 #pragma mark - ViewController
 
 @implementation ViewController
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [self createObserver];
 
 // 发送消息
 [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];
 }
 - (void)createObserver {
 
 Observer *observer = [[Observer alloc] init];
 }
 @end
 
 运行后的输出如下：
 Log:
	Init Observer
	handle notification
 我们可以看到 createObserver 中创建的 observer 并没有被释放。所以，使用addObserverForName:object:queue:usingBlock: 一定要注意这个问题。
 
 # 除观察者 #
 与注册观察者相对应的，NSNotificationCenter 为我们提供了两个移除观察者的方法。它们的定义如下：
 - (void)removeObserver:(id)notificationObserver
 - (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName object:(id)notificationSender
 
 前一个方法会将 notificationObserver 从通知中心中移除，这样 notificationObserver 就无法再监听任何消息。而后一个会根据三个参数来移除相应的观察者。
 
 这两个方法也有几点需要注意：
 1. 由于注册观察者时(不管是哪个方法)，通知中心会维护一个观察者的 unsafe_unretained 的引用，所以在释放对象时，要确保移除对象所有监听的通知。否则，可能会导致程序崩溃或一些莫名其妙的问题。
 2. 对于第二个方法，如果 notificationName 为 nil，则会移除所有匹配 notificationObserver 和 notificationSender 的通知，同理 notificationSender 也是一样的。而如果 notificationName 和 notificationSender 都为 nil，则其效果就与第一个方法是一样的了。大家可以试一下。
 3. 最有趣的应该是这两个方法的使用时机。–removeObserver: 适合于在类的 dealloc 方法中调用，这样可以确保将对象从通知中心中清除；而在 viewWillDisappear: 这样的方法中，则适合于使用 -removeObserver:name:object: 方法，以避免不知情的情况下移除了不应该移除的通知观察者。例如，假设我们的 viewController 继承自一个类库的某个ViewController 类(假设为 SKViewController 吧)，可能 SKViewController 自身也监听了某些通知以执行特定的操作，但我们使用时并不知道。如果直接在 viewWillDisappear: 中调用 –removeObserver:，则也会把父类监听的通知也给移除。
 
 注. 关于注册监听者，还有一个需要注意的问题是，每次调用 addObserver 时，都会在通知中心重新注册一次，即使是同一对象监听同一个消息，而不是去覆盖原来的监听。这样，当通知中心转发某一消息时，如果同一对象多次注册了这个通知的观察者，则会收到多个通知，如代码清单4所示
 代码清单4：同一对象多次注册同一消息
 
 @implementation ViewController
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:TEST_NOTIFICATION object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:TEST_NOTIFICATION object:nil];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];
 }
 - (void)handleNotification:(NSNotification *)notification
 {
 NSLog(@"notification = %@", notification.name);
 }
 @end
 
 
 其输出结果如下所示：
 notification = TestNotification
 notification = TestNotification
 
 可以看到对象处理了两次通知。所以，如果我们需要在viewWillAppear监听一个通知时，一定要记得在对应的viewWillDisappear里面将观察者移除，否则就可能会出现上面的情况。
 
 最后，再特别重点强调的非常重要的一点是，在释放对象前，一定要记住如果它监听了通知，一定要将它从通知中心移除。如果是用 addObserverForName:object:queue:usingBlock: ，也记得一定得移除这个匿名观察者 ( 返回的 id 对象)。说白了就一句话，添加和移除要配对出现。
 
 # post 消息 #
 注册了通知观察者，我们便可以随时随地的去 post 一个通知了(当然，如果闲着没事，也可以不注册观察者，post 通知随便玩，只是没人理睬罢了)。NSNotificationCenter 提供了三个方法来 post 一个通知，如下所示：
 - postNotification:
 – postNotificationName:object:
 – postNotificationName:object:userInfo:
 
 我们可以根据需要指定通知的发送者 (object) 并附带一些与通知相关的信息 (userInfo) ，当然这些发送者和 userInfo 可以封装在一个 NSNotification 对象中，由 - postNotification: 来发送。注意，- postNotification: 的参数不能为空，否则会引发一个异常，如下所示：
 ** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[NSNotificationCenter postNotification:]: notification is nil'
 
 每次 post 一个通知时，通知中心都会去遍历一下它的分发表，然后将通知转发给相应的观察者。
 
 注. 另外，通知的发送与处理是同步的，在某个地方 post 一个消息时，会等到所有观察者对象执行完处理操作后，才回到 post 的地方，继续执行后面的代码。如代码清单 5 所示：
 代码清单5：通知的同步处理
 
 @implementation ViewController
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:TEST_NOTIFICATION object:nil];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];
 
 NSLog(@"continue");
 }
 - (void)handleNotification:(NSNotification *)notification
 {
 NSLog(@"handle notification");
 }
 @end
 
 运行后输出结果是：
 Log:
 handle notification
 continue
 
 # 小结 #
 
 在我们的应用程序中，一个大的话题就是两个对象之间如何通信。我们需要根据对象之间的关系来确定采用哪一种通信方式。对象之间的通信方式主要有以下几种：
 1. 直接方法调用
 2. Target-Action
 3. Delegate
 4. 回调(block)
 5. KVO
 6. 通知
 一般情况下，我们可以根据以下两点来确定使用哪种方式：
 1. 通信对象是一对一的还是一对多的
 2. 对象之间的耦合度，是强耦合还是松耦合
 
 Objective-C 中的通知由于其广播性及松耦合性，非常适合于大的范围内对象之间的通信(模块与模块，或一些框架层级)。通知使用起来非常方便，也正因为如此，所以容易导致滥用。所以在使用前还是需要多想想，是否有更好的方法来实现我们所需要的对象间通信。毕竟，通知机制会在一定程度上会影响到程序的性能。
 
 对于使用 NSNotificationCenter，最后总结一些小建议：
 1. 在需要的地方使用通知。
 2. 注册的观察者在不使用时一定要记得移除，即添加和移除要配对出现。
 3. 尽可能迟地去注册一个观察者，并尽可能早将其移除，这样可以改善程序的性能。因为，每post一个通知，都会是4. 遍历通知中心的分发表，确保通知发给每一个观察者。
 5. 记住通知的发送和处理是在同一个线程中。
 6. 使用-addObserverForName:object:queue:usingBlock:务必处理好内存问题，避免出现循环引用。
 7. NSNotificationCenter是线程安全的，但并不意味着在多线程环境中不需要关注线程安全问题。不恰当的使用仍然会引发线程问题。
 
 http://southpeak.github.io/2015/03/14/nsnotification-and-multithreading/
 
 # 代码清单2：在不同线程中 post 和转发一个 Notification #
   见原文或 notificationMultiThreadVC DEMO 2
 
 **代码清单4：NSNotificationCenter引发的线程安全问题**
 #pragma mark - Poster
	
 @interface Poster : NSObject
	
 @end
	
 @implementation Poster
	
 - (instancetype)init
 {
 self = [super init];
 
 if (self)
 {
 [self performSelectorInBackground:@selector(postNotification) withObject:nil];
 }
 
 return self;
 }
	
 - (void)postNotification
 {
 [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];
 }
	
 @end
	
 #pragma mark - Observer
	
 @interface Observer : NSObject
 {
 Poster  *_poster;
 }
	
 @property (nonatomic, assign) NSInteger i;
	
 @end
	
 @implementation Observer
	
 - (instancetype)init
 {
 self = [super init];
 
 if (self)
 {
 _poster = [[Poster alloc] init];  // 这里创建了 poster 对象，同时发送了通知
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:TEST_NOTIFICATION object:nil];
 }
 
 return self;
 }
	
 - (void)handleNotification:(NSNotification *)notification
 {
 NSLog(@"handle notification begin");
 sleep(1);
 NSLog(@"handle notification end");
 
 self.i = 10;
 }
	
 - (void)dealloc
 {
 [[NSNotificationCenter defaultCenter] removeObserver:self];
 
 NSLog(@"Observer dealloc");
 }
	
 @end
	
 #pragma mark - ViewController
	
 @implementation ViewController
	
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 __autoreleasing Observer *observer = [[Observer alloc] init];
 }
	
 @end
 
 这段代码是在主线程添加了一个 TEST_NOTIFICATION 通知的监听者，并在主线程中将其移除，而我们的 NSNotification 是在后台线程中 post 的。在通知处理函数中，我们让回调所在的线程睡眠1秒钟，然后再去设置属性i值。这时会发生什么呢？我们先来看看输出结果：
 
 2015-03-14 00:31:41.286 SKTest[932:88791] handle notification begin
 2015-03-14 00:31:41.291 SKTest[932:88713] Observer dealloc
 2015-03-14 00:31:42.361 SKTest[932:88791] handle notification end
 (lldb)
	
 // 程序在self.i = 10处抛出了"Thread 6: EXC_BAD_ACCESS(code=EXC_I386_GPFLT)"
 
 经典的内存错误，程序崩溃了。其实从输出结果中，我们就可以看到到底是发生了什么事。我们简要描述一下：
 1. 当我们注册一个观察者是，通知中心会持有观察者的一个弱引用，来确保观察者是可用的。
 2. 主线程调用 dealloc 操作会让 observer 对象的引用计数减为0，这时对象会被释放掉。
 3. 后台线程发送一个通知，如果此时 observer 还未被释放，则会向其转发消息，并执行回调方法。而如果在回调执行的过程中对象被释放了，就会出现上面的问题。
 4. 当然，上面这个例子是故意而为之，但不排除在实际编码中会遇到类似的问题。虽然 NSNotificationCenter 是线程安全的，但并不意味着我们在使用时就可以保证线程安全的，如果稍不注意，还是会出现线程问题。
 
 那我们该怎么做呢？这里有一些好的建议：
 1. 尽量在一个线程中处理通知相关的操作，大部分情况下，这样做都能确保通知的正常工作。不过，我们无法确定到底会在哪个线程中调用 dealloc 方法，所以这一点还是比较困难。
 2. 注册监听都时，使用基于 block 的 API。这样我们在 block 还要继续调用 self 的属性或方法，就可以通过 weak-strong 的方式来处理。具体大家可以改造下上面的代码试试是什么效果。
 3. 使用带有安全生命周期的对象，这一点对象单例对象来说再合适不过了，在应用的整个生命周期都不会被释放。
 4. 使用代理。
 
 http://www.2cto.com/kf/201504/394367.html
 # 通知中心(NSNotificationCenter) #
 http://www.2cto.com/uploadfile/Collfiles/20150425/20150425083929139.PNG 图不错
 
 每一个应用程序都有一个通知中心( NSNotificationCenter )实例，专门负责协助不同对象之间的消息通信
 任何一个对象都可以向通知中心发布通知( NSNotification )，描述自己在做什么。其他感兴趣的对象( observer )可以申请在某个特定通知发布时(或在某个特定的对象发布通知时)收到这个通知
 
 # 通知 (NSNotification) #
 一个完整的通知一般包含3个属性：
 - (NSString *)name;				 // 通知的名称
 - (id)object;					 // 通知发布者(是谁要发布通知)
 - (NSDictionary *)userInfo;		 // 一些额外的信息(通知发布者传递给通知接收者的信息内容)
 
 初始化一个通知（NSNotification）对象
 + (instancetype)notificationWithName:(NSString *)aName object:(id)anObject;
 + (instancetype)notificationWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
 - (instancetype)initWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;
 
 # 注册通知监听器 #
 通知中心(NSNotificationCenter)提供了方法来注册一个监听通知的监听器(Observer)
 - (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
 // observer：监听器，即谁要接收这个通知
 // aSelector：收到通知后，回调监听器的这个方法，并且把通知对象当做参数传入
 // aName：通知的名称。如果为nil，那么无论通知的名称是什么，监听器都能收到这个通知
 // anObject：通知发布者。如果为anObject和aName都为nil，监听器都收到所有的通知
 
 - (id)addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
 // name：通知的名称
 // obj：	通知发布者
 // block：	收到对应的通知时，会回调这个 block
 // queue:	决定了 block 在哪个操作队列中执行，如果传 Nil，默认在当前操作队列中同步执行
 
 
 # 发布通知 #
 - (void)postNotification:(NSNotification *)notification;
 发布一个 notification 通知，可在 notification 对象中设置通知的名称、通知发布者、额外信息等
 
 - (void)postNotificationName:(NSString *)aName object:(id)anObject;
 发布一个名称为 aName 的通知，anObject 为这个通知的发布者
 
 - (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
 发布一个名称为 aName 的通知，anObject 为这个通知的发布者，aUserInfo 为额外信息
 
 # 取消注册通知监听器 #
 - (void)removeObserver:(id)observer;
 - (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject;
 
 //一般在监听器销毁之前取消注册（如在监听器中加入下列代码）：
 - (void)dealloc {
 // [super dealloc];  非ARC中需要调用此句
 [[NSNotificationCenter defaultCenter] removeObserver:self];  // 注. 这样做存在隐患
 }
 
 # UIDevice通知 #
 // UIDevice对象会不间断地发布一些通知，下列是UIDevice对象所发布通知的名称常量：
 UIDeviceOrientationDidChangeNotification	 // 设备旋转
 UIDeviceBatteryStateDidChangeNotification	 // 电池状态改变
 UIDeviceBatteryLevelDidChangeNotification	 // 电池电量改变
 UIDeviceProximityStateDidChangeNotification // 近距离传感器(比如设备贴近了使用者的脸部)
 
 # 键盘通知 #
 // 键盘状态改变的时候,系统会发出一些特定的通知
 UIKeyboardWillShowNotification	// 键盘即将显示
 UIKeyboardDidShowNotification	// 键盘显示完毕
 UIKeyboardWillHideNotification	// 键盘即将隐藏
 UIKeyboardDidHideNotification	// 键盘隐藏完毕
 UIKeyboardWillChangeFrameNotification // 键盘的位置尺寸即将发生改变
 UIKeyboardDidChangeFrameNotification  // 键盘的位置尺寸改变完毕
 
 # 通知和代理的选择 #
 共同点
 利用通知和代理都能完成对象之间的通信
 (比如A对象告诉D对象发生了什么事情, A对象传递数据给D对象)
 
 不同点
 代理 : 一对一关系(1个对象只能告诉另1个对象发生了什么事情)
 通知 : 多对多关系(1个对象能告诉 N 个对象发生了什么事情, 1个对象能得知 N 个对象发生了什么事情)
 
 https://my.oschina.net/u/2340880/blog/406163
 摘要: NSNotification 是 iOS 中一个调度消息通知的类，采用"单例模式"设计，在程序中实现传值、回调等地方应用很广。
 
 http://www.jianshu.com/p/a4d519e4e0d5
 
 那我们如何证明呢？由于我们看不到源码，所以也不知道有没有调用。这个时候，我们可以从这个通知中心下手！！！怎么下手呢？我只要证明 UIViewController 在销毁的时候调用了remove方法，就可以证明我们的猜想是对的了！这个时候，就需要用到我们强大的类别这个特性了。我们为NSNotificationCenter添加个类别，重写他的- (void)removeObserver:(id)observer方法：
 
 - (void)removeObserver:(id)observer {
 NSLog(@"====%@ remove===", [observer class]);
 }
 
 这样在我们VC中导入这个类别，然后pop出来，看看发生了什么！
 
 2015-01-19 22:59:00.580 测试[1181:288728] ====TestViewController remove===
 
 证明系统的 UIViewController 在销毁的时候调用了这个方法。
 
 # 正确姿势之注意重复 addObserver #
 在我们开发中，我们经常可以看到这样的代码：
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
 }
 
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:@"test" object:nil];
 }
 
 就是在页面出现的时候注册通知，页面消失时移除通知。你这边可要注意了，一定要成双成对出现，如果你只在viewWillAppear 中 addObserver 没有在 viewWillDisappear 中 removeObserver 那么当消息发生的时候，你的方法会被调用多次，这点必须牢记在心。
 
 # 正确姿势之多线程通知 #
 意思很简单，NSNotificationCenter 消息的接受线程是基于发送消息的线程的。也就是同步的，因此有时候你发送的消息可能不在主线程，而大家都知道操作 UI 必须在主线程，不然会出现不响应的情况。所以，在你收到消息通知的时候，注意选择你要执行的线程。下面看个示例代码
 //接受消息通知的回调
 - (void)test
 {
 if ([[NSThread currentThread] isMainThread]) {
 NSLog(@"main");
 } else {
 NSLog(@"not main");
 }
 dispatch_async(dispatch_get_main_queue(), ^{
 //do your UI
 });
 
 }
 
 //发送消息的线程
 - (void)sendNotification
 {
 dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_async(defaultQueue, ^{
 [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
 });
 }
 */