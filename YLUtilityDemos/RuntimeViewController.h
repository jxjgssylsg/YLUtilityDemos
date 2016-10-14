//
//  ViewController.h
//  RuntimeDemo
//
//  Created by Sam Lau on 7/5/15.
//  Copyright © 2015 Sam Lau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuntimeViewController : UIViewController

@end

/*
http://www.jianshu.com/p/25a319aee33d
 
 Runtime数据结构
 在Objective-C中，使用[receiver message]语法并不会马上执行receiver对象的message方法的代码，而是向receiver发送一条message消息，这条消息可能由receiver来处理，也可能由转发给其他对象来处理，也有可能假装没有接收到这条消息而没有处理。其实[receiver message]被编译器转化为:
 
 id objc_msgSend ( id self, SEL op, ... );
 
 SEL数据结构 : typedef struct objc_selector *SEL;
 
 查看到id数据结构如下：
 
 /// Represents an instance of a class.
 struct objc_object {
 Class isa  OBJC_ISA_AVAILABILITY;
 };
 
 /// A pointer to an instance of a class.
 typedef struct objc_object *id;
 
 注. id其实就是一个指向 objc_object 结构体指针，它包含一个 Class isa 成员，根据 isa 指针就可以顺藤摸瓜找到对象所属的类。
 
 查看到objc_class ( 注意和 objc_object 区别 )结构体定义如下：
 struct objc_class {
 Class isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
 Class super_class                                        OBJC2_UNAVAILABLE;
 const char *name                                         OBJC2_UNAVAILABLE;
 long version                                             OBJC2_UNAVAILABLE;
 long info                                                OBJC2_UNAVAILABLE;
 long instance_size                                       OBJC2_UNAVAILABLE;
 struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
 struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
 struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
 struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 #endif
 
 } OBJC2_UNAVAILABLE;
  Use `Class` instead of `struct objc_class *`

注. isa 表示一个Class对象的 Class，也就是Meta Class. 即类对象的类对象，即元类。

struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
    
    ......
}

注. 由此可见，结构体 objc_class 也是继承 objc_object，说明 Class 在设计中本身也是一个对象。

 ivars 表示多个成员变量，它指向 objc_ivar_list 结构体。在 runtime.h 可以看到它的定义：
 
 struct objc_ivar_list {
 int ivar_count                                           OBJC2_UNAVAILABLE;
 #ifdef __LP64__
 int space                                                OBJC2_UNAVAILABLE;
 #endif
 // variable length structure
struct objc_ivar ivar_list[1]                            OBJC2_UNAVAILABLE;
}

注. objc_ivar_list 其实就是一个链表，存储多个 objc_ivar，而 objc_ivar 结构体存储类的单个成员变量信息

IMP
在上面讲Method时就说过，IMP 本质上就是一个函数指针，指向方法的实现，在 objc.h 找到它的定义：

/// A pointer to the function of a method implementation.
#if !OBJC_OLD_DISPATCH_PROTOTYPES
typedef void (*IMP)(void // id, SEL, ... // );
#else
typedef id (*IMP)(id, SEL, ...);
#endi

Cache
顾名思义，Cache主要用来缓存，那它缓存什么呢？我们先在runtime.h文件看看它的定义：

typedef struct objc_cache *Cache                             OBJC2_UNAVAILABLE;

struct objc_cache {
    unsigned int mask // total = mask + 1 //                  OBJC2_UNAVAILABLE;
    unsigned int occupied                                    OBJC2_UNAVAILABLE;
    Method buckets[1]                                        OBJC2_UNAVAILABLE;
};
Cache其实就是一个存储 Method 的链表，主要是为了优化方法调用的性能。当对象 receiver 调用方法 message 时，首先根据对象 receiver 的 isa 指针查找到它对应的类，然后在类的 methodLists 中搜索方法，如果没有找到，就使用 super_class 指针到父类中的 methodLists 查找，一旦找到就调用方法。如果没有找到，有可能消息转发，也可能忽略它。但这样查找方式效率太低，因为往往一个类大概只有 20% 的方法经常被调用，占总调用次数的 80%。所以使用 Cache 来缓存经常调用的方法，当调用方法时，优先在 Cache 查找，如果没有找到，再到 methodLists 查找。
 
 注.计算机组成原理,操作系统里面的内存命中,cache 等相似.
 
 
 id objc_msgSend ( id self, SEL op, ... );
 现在让我们看一下objc_msgSend它具体是如何发送消息:
 
 首先根据 receiver 对象的 isa 指针获取它对应的 class
 优先在 class 的 cache 查找 message 方法，如果找不到，再到 methodLists 查找
 如果没有在class找到，再到 super_class 查找
 一旦找到 message 这个方法，就执行它实现的 IMP 。
 
 为了让大家更好地理解self和super，借用sunnyxx博客的ios程序员6级考试一道题目
 @implementation Son : Father
 - (id)init
 {
 self = [super init];
 if (self)
 {
 NSLog(@"%@", NSStringFromClass([self class]));
 NSLog(@"%@", NSStringFromClass([super class]));
 }
 return self;
 }
 @end
 
 这时会从当前Son类的方法列表中查找，如果没有，就到Father类查找，还是没有，最后在NSObject类查找到。我们可以从NSObject.mm文件中看到- (Class)class的实现：
 
 id objc_msgSend(id self, SEL op, ...)
 id objc_msgSendSuper(struct objc_super *super, SEL op, ...)
 
 - (Class)class {
 return object_getClass(self);
 }
 
 隐藏参数 self 和 _cmd
 当[receiver message]调用方法时，系统会在运行时偷偷地动态传入两个隐藏参数self和_cmd，之所以称它们为隐藏参数，是因为在源代码中没有声明和定义这两个参数。至于对于self的描述，上面已经解释非常清楚了，下面我们重点讲解 _cmd。
 
 _cmd 表示当前调用方法，其实它就是一个方法选择器 SEL。
 
 
 方法解析与消息转发:
 [receiver message]调用方法时，如果在message方法在receiver对象的类继承体系中没有找到方法，那怎么办？一般情况下，程序在运行时就会Crash掉，抛出 unrecognized selector sent to …类似这样的异常信息。但在抛出异常之前，还有三次机会按以下顺序让你拯救程序。
 
 1. Method Resolution
 2. Fast Forwarding      // 把这消息转发给其他对象来处理
 3. Normal Forwarding
 
 #pragma mark - Method Resolution
 
 /// override resolveInstanceMethod or resolveClassMethod for changing sendMessage method implementation
 + (BOOL)resolveInstanceMethod:(SEL)sel
 {
 if (sel == @selector(sendMessage:)) {
 class_addMethod([self class], sel, imp_implementationWithBlock(^(id self, NSString *word) {
 NSLog(@"method resolution way : send message = %@", word);
 }), "v@*");
 }
 
 return YES;
 }
 
 #pragma mark - Fast Forwarding
 - (id)forwardingTargetForSelector:(SEL)aSelector
 {
 if (aSelector == @selector(sendMessage:)) {
 return [MessageForwarding new];
 }
 
 return nil;
 }
 
 #pragma mark - Normal Forwarding
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
 {
 NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
 
 if (!methodSignature) {
 methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
 }
 
 return methodSignature;
 }
 
 - (void)forwardInvocation:(NSInvocation *)anInvocation
 {
 MessageForwarding *messageForwarding = [MessageForwarding new];
 
 if ([messageForwarding respondsToSelector:anInvocation.selector]) {
 [anInvocation invokeWithTarget:messageForwarding];
 }
 }
 
 三种方法的选择
 Runtime提供三种方式来将原来的方法实现代替掉，那该怎样选择它们呢？
 
 Method Resolution：由于Method Resolution不能像消息转发那样可以交给其他对象来处理，所以只适用于在原来的类中代替掉。
 Fast Forwarding：它可以将消息处理转发给其他对象，使用范围更广，不只是限于原来的对象。
 Normal Forwarding：它跟Fast Forwarding一样可以消息转发，但它能通过NSInvocation对象获取更多消息发送的信息，例如：target、selector、arguments和返回值等信息。
 
 注. 具体见代码例子
 
 Associated Objects:
 当想使用Category对已存在的类进行扩展时，一般只能添加实例方法或类方法，而不适合添加额外的属性。虽然可以在Category头文件中声明property属性，但在实现文件中编译器是无法synthesize任何实例变量和属性访问方法。这时需要自定义属性访问方法并且使用Associated Objects来给已存在的类Category添加自定义的属性。Associated Objects提供三个API来向对象添加、获取和删除关联值：
 
 void objc_setAssociatedObject (id object, const void *key, id value, objc_AssociationPolicy policy )
 id objc_getAssociatedObject (id object, const void *key )
 void objc_removeAssociatedObjects (id object )
 
 其中objc_AssociationPolicy是个枚举类型：
 typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
 OBJC_ASSOCIATION_ASSIGN = 0,           /- < Specifies a weak reference to the associated object. -/
OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /- < Specifies a strong reference to the associated object.
                                        *   The association is not made atomically. -/
OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /-< Specifies that the associated object is copied.
                                        *   The association is not made atomically. -/
OBJC_ASSOCIATION_RETAIN = 01401,       /-*< Specifies a strong reference to the associated object.
                                           The association is made atomically. -/
OBJC_ASSOCIATION_COPY = 01403          /-*< Specifies that the associated object is copied.
                                        *   The association is made atomically. -/
};

Method Swizzling
Method Swizzling就是在运行时将一个方法的实现代替为另一个方法的实现。如果能够利用好这个技巧，可以写出简洁、有效且维护性更好的代码。可以参考两篇关于Method Swizzling技巧的文章：

nshipster Method Swizzling
Method Swizzling 和 AOP 实践
Aspect-Oriented Programming(AOP)
类似记录日志、身份验证、缓存等事务非常琐碎，与业务逻辑无关，很多地方都有，又很难抽象出一个模块，这种程序设计问题，业界给它们起了一个名字叫横向关注点(Cross-cutting concern)，AOP作用就是分离横向关注点(Cross-cutting concern)来提高模块复用性，它可以在既有的代码添加一些额外的行为(记录日志、身份验证、缓存)而无需修改代码。
 
 扩展阅读:
 玉令天下博客的Objective-C Runtime
 顾鹏博客的Objective-C Runtime
 Associated Objects
 Method Swizzling
 Method Swizzling 和 AOP 实践
 Objective-C Runtime Reference
 What are the Dangers of Method Swizzling in Objective C?
 ios程序员6级考试（答案和解释）
 Objective C类方法load和initialize的区别
 。
 
 http://icetime17.github.io/2016/04/12/2016-04/iOS-%E7%90%86%E8%A7%A3Runtime%E6%9C%BA%E5%88%B6%E5%8F%8A%E5%85%B6%E4%BD%BF%E7%94%A8%E5%9C%BA%E6%99%AF/

 # 实例变量 #：
 通过 runtime 方法 class_copyIvarList 可获取一个指向类和对象的所有实例变量的 Ivar 指针.
 
 u_int count = 0;
 Ivar *ivars = class_copyIvarList([UIView class], &count);
 for (int i = 0; i < count; i++) {
 const char *ivarName = ivar_getName(ivars[i]);
 NSString *str = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
 NSLog(@"ivarName : %@", str);
 }
 
 # 属性 #：
 通过runtime方法class_copyPropertyList可获取一个指向类和对象的所有属性的objc_property_t指针.
 
 u_int count = 0;
 objc_property_t *properties = class_copyPropertyList([UIView class], &count);
 for (int i = 0; i < count; i++) {
 const char *propertyName = property_getName(properties[i]);
 NSString *str = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
 NSLog(@"propertyName : %@", str);
 }
 free(properties);
 
 # 方法 #
 通过 runtime 方法 class_copyMethodList 可获取一个指向类和对象的所有方法的 Method 指针：
 u_int count = 0;
 // 获取所有方法
 Method *methods = class_copyMethodList([UIView class], &count);
 for (int i = 0; i < count; i++) {
 Method method = methods[i];
 // 方法类型是SEL选择器类型
 SEL methodName = method_getName(method);
 NSString *str = [NSString stringWithCString:sel_getName(methodName) encoding:NSUTF8StringEncoding];
 int arguments = method_getNumberOfArguments(method);
 NSLog(@"methodName : %@, arguments Count: %d", str, arguments);
 }
 free(methods);
 
 Method Swizzling
 通过修改一个已存在类的方法, 来实现方法替换是比较常用的runtime技巧.
 如在UIView的load方法中:
 + (void)load {
 Method origin = class_getInstanceMethod([UIView class], @selector(touchesBegan:withEvent:));
 Method custom = class_getInstanceMethod([UIView class], @selector(custom_touchesBegan:withEvent:));
 method_exchangeImplementations(origin, custom);
 }
 - (void)custom_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 // TODO
 }
 
 注. 见 Demo 2
 
 https://justinyan.me/post/1624
 
 [self doSomethingWithVar:var1] = objc_msgSend(self,@selector(doSomethingWithVar:),var1);
 
 Blocks 的定义：
 struct Block_literal_1 {
 void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
 int flags;
 int reserved;
 void (*invoke)(void *, ...);
 struct Block_descriptor_1 {
 unsigned long int reserved; // NULL
 unsigned long int size;  // sizeof(struct Block_literal_1)
 // optional helper functions
 void (*copy_helper)(void *dst, void *src);
 void (*dispose_helper)(void *src);
 } *descriptor;
 // imported variables
 };
 
 可以看到一个 block 是被设计成一个对象的，拥有一个 isa 指针，所以你可以对一个 block 使用 retain, release, copy 这些方法
 
 id obj1 = [NSMutableArray alloc];
 id obj2 = [[NSMutableArray alloc] init];
 NSLog(@"obj1 class is %@",NSStringFromClass([obj1 class]));
 NSLog(@"obj2 class is %@",NSStringFromClass([obj2 class]));
 
 // 输出：
 obj1 class is __NSPlaceholderArray
 obj2 class is NSCFArray
 
 id obj3 = [NSArray alloc];
 id obj4 = [[NSArray alloc] initWithObjects:@"Hello",nil];
 NSLog(@"obj3 class is %@",NSStringFromClass([obj3 class]));
 NSLog(@"obj4 class is %@",NSStringFromClass([obj4 class]));
 // 输出：
 obj3 class is __NSPlaceholderArray
 obj4 class is NSCFArray
 
 
 id obj5 = [MyObject alloc];
 id obj6 = [[MyObject alloc] init];
 NSLog(@"obj5 class is %@",NSStringFromClass([obj5 class]));
 NSLog(@"obj6 class is %@",NSStringFromClass([obj6 class]));
 // 输出：
 obj5 class is MyObject
 obj6 class is MyObject
 
 // 首先定义一个 C 语言的函数指针
 int (computeNum *)(id,SEL,int);
 
 // 使用 methodForSelector 方法获取对应与该 selector 的杉树指针，跟 objc_msgSend 方法拿到的是一样的
 // **methodForSelector 这个方法是 Cocoa 提供的，不是 ObjC runtime 库提供的**
 computeNum = (int (*)(id,SEL,int))[target methodForSelector:@selector(doComputeWithNum:)];
 
 // 现在可以直接调用该函数了，跟调用 C 函数是一样的
 computeNum(obj,@selector(doComputeWithNum:),aNum);
 
 - (id)forwardingTargetForSelector:(SEL)aSelector
 {
 if(aSelector == @selector(mysteriousMethod:)){
 return alternateObject;
 }
 return [super forwardingTargetForSelector:aSelector];
 }
 
 注 . 这样你就可以把消息转给别人了。当然这里你不能 return self,不然就死循环了=.=
 
 http://yimouleng.com/2015/05/28/ios-runtime/
 NSObject的方法
 Cocoa 中大多数类都继承于NSObject类，也就自然继承了它的方法。最特殊的例外是NSProxy，它是个抽象超类，它实现了一些消息转发有关的方法，可以通过继承它来实现一个其他类的替身类或是虚拟出一个不存在的类，说白了就是领导把自己展现给大家风光无限，但是把活儿都交给幕后小弟去干。
 有的NSObject中的方法起到了抽象接口的作用，比如description方法需要你重载它并为你定义的类提供描述内容。NSObject还有些方法能在运行时获得类的信息，并检查一些特性，比如class返回对象的类；isKindOfClass:和isMemberOfClass:则检查对象是否在指定的类继承体系中；respondsToSelector:检查对象能否响应指定的消息；conformsToProtocol:检查对象是否实现了指定协议类的方法；methodForSelector:则返回指定方法实现的地址。
 
 objc_property_t class_copyPropertyList(Class cls, unsigned int outCount)
 objc_property_t protocol_copyPropertyList(Protocol proto, unsigned int outCount
 
 - #　Method Swizzling　＃
 这里摘抄一个 NSHipster 的例子：
 #import <objc/runtime.h>
 
 @implementation UIViewController (Tracking)
 
 + (void)load {
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 Class aClass = [self class];
 
 SEL originalSelector = @selector(viewWillAppear:);
 SEL swizzledSelector = @selector(xxx_viewWillAppear:);
 
 Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
 Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
 
 // When swizzling a class method, use the following:
 // Class aClass = object_getClass((id)self);
 // …
 // Method originalMethod = class_getClassMethod(aClass, originalSelector);
 // Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
 
 BOOL didAddMethod =
 class_addMethod(aClass,
 originalSelector,
 method_getImplementation(swizzledMethod),
 method_getTypeEncoding(swizzledMethod));
 
 if (didAddMethod) {
 class_replaceMethod(aClass,
 swizzledSelector,
 method_getImplementation(originalMethod),
 method_getTypeEncoding(originalMethod));
 } else {
 method_exchangeImplementations(originalMethod, swizzledMethod);
 }
 });
 }
 
 #pragma mark - Method Swizzling
 
 - (void)xxx_viewWillAppear:(BOOL)animated {
 [self xxx_viewWillAppear:animated];
 NSLog(@”viewWillAppear: %@”, self);
 }
 
 @end
 
 如果类中不存在要替换的方法，那就先用 class_addMethod 和 class_replaceMethod 函数添加和替换两个方法的实现；如果类中已经有了想要替换的方法，那么就调用method_exchangeImplementations函数交换了两个方法的 IMP，这是苹果提供给我们用于实现 Method Swizzling 的便捷方法。
 
 注.  BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)
 
 参数说明：
 
 cls：被添加方法的类
 
 name：可以理解为方法名，这个貌似随便起名，比如我们这里叫sayHello2
 
 imp：实现这个方法的函数
 
 types：一个定义该函数返回值类型和参数类型的字符串，这个具体会在后面讲
 
 
 class_replaceMethod 方法 看官网说明 // https://developer.apple.com/reference/objectivec/1418677-class_replacemethod?language=objc
 
 IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types);
 
 Discussion
 This function behaves in two different ways:
 
 If the method identified by name does not yet exist, it is added as if class_addMethod were called. The type encoding specified by types is used as given.
 
 If the method identified by name does exist, its IMP is replaced as if method_setImplementation were called. The type encoding specified by types is ignored.
 
 http://www.cnblogs.com/stevenfukua/p/5578196.html
 
 runtime常用方法：
 获取列表：
 我们可以通过runtime的一系列方法获取类的一些信息（包括属性列表，方法列表，成员变量列表，和遵循的协议列表）
 
 class_copyPropertyList        //获取属性列表
 class_copyMethodList         //获取方法列表
 class_copyIvarList               //获取成员变量列表
 class_copyProtocolList       //获取协议列表
 
 1. 常见用于字典转模型的需求中:
 
 @interface LYUser : NSObject
 @property (nonatomic,strong)NSString *userId;
 @property (nonatomic,strong)NSString *userName;
 @property (nonatomic,strong)NSString *age;
 @end
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 //利用runtime遍历一个类的全部成员变量
 NSDictionary *userDict = @{@"userId":@"1",@"userName":@"levi",@"age":@"20"};
 unsigned int count;
 LYUser *newUser = [LYUser new];
 objc_property_t *propertyList = class_copyPropertyList([LYUser class], &count);
 for (int i = 0; i < count; i++) {
 const char *propertyName = property_getName(propertyList[i]);
 NSString *key = [NSString stringWithUTF8String:propertyName];
 [newUser setValue:userDict[key] forKey:key];
 }
 NSLog(@"%@--%@--%@",newUser.userId,newUser.userName,newUser.age);
 }
 
 注. 见 Sample two person 类
 
 2.  交换方法, 动态增加属性
 class_getInstanceMethod（） //类方法和实例方法存在不同的地方,所以两个不同的方法获得
 class_getClassMethod（）    //以上两个函数传入返回Method类型
 method_exchangeImplementations    //（）交换两个方法的实现
 
 注. 文章只是做了简单的交换，并未考虑如果方法不存在的情况
 
 3. 关联对象
 objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
 objc_getAssociatedObject(id object, const void *key)
 
 前面已经讲过,Category不能添加属性,通过关联对象就可以在运行时动态地添加属性.
 # 例如: 增加 UITextField  最大长度属性
 .h
 @interface UITextField (TextRange)
 @property (nonatomic, assign) NSInteger maxLength;   //每次限制的长度设置下就行了
 @end
 
 .m
 - (void)dealloc {
 [[NSNotificationCenter defaultCenter] removeObserver:self];
 }
 
 - (void)setMaxLength:(NSInteger)maxLength {
 objc_setAssociatedObject(self, KTextFieldMaxLength, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 [self textField_addTextDidChangeObserver];
 }
 
 - (NSInteger)maxLength {
 return [objc_getAssociatedObject(self, KTextFieldMaxLength) integerValue];
 }
 
 https://my.oschina.net/panyong/blog/298631
 
 2> 相关应用
 
 NSCoding(归档和解档, 利用runtime遍历模型对象的所有属性)
 字典 --> 模型 (利用runtime遍历模型对象的所有属性, 根据属性名从字典中取出对应的值, 设置到模型的属性上)
 KVO(利用runtime动态产生一个类)
 用于封装框架(想怎么改就怎么改) 这就是我们runtime机制的只要运用方向
 3> 相关函数
 
 objc_msgSend : 给对象发送消息
 class_copyMethodList : 遍历某个类所有的方法
 class_copyIvarList : 遍历某个类所有的成员变量
 class_..... 这是我们学习runtime必须知道的函数！
 
 
 http://www.jianshu.com/p/54c190542aa8
 
 Class object_getClass(id obj)
 {
 if (obj) return obj->getIsa();
 else return Nil;
 }
 
 + (Class)class {   // 类方法 在 meta class 元类内
 return self;
 }
 
 - (Class)class {   // 实例方法,在 class 类对象里
 return object_getClass(self);
 }
 这是NSObject类里实例方法class与类方法class的实现，这里再强调一下：类方法是在meta class里的，类方法就是把自己返回，而实例方法中是返回实例isa的类，我们要验证这个isa的指向链的时候不能用这种方法，千万记住，为什么，一会说明。
 
 #import <objc/runtime.h>
 #import "Person.h"
 
 ...
 
 Person *obj = [Person new];
 NSLog(@"instance         :%p", obj);
 NSLog(@"class            :%p", object_getClass(obj));
 NSLog(@"meta class       :%p", object_getClass(object_getClass(obj)));
 NSLog(@"root meta        :%p", object_getClass(object_getClass(object_getClass(obj))));
 NSLog(@"root meta's meta :%p", object_getClass(object_getClass(object_getClass(object_getClass(obj)))));
 NSLog(@"---------------------------------------------");
 NSLog(@"class            :%p", [obj class]);
 NSLog(@"meta class       :%p", [[obj class] class]);
 NSLog(@"root meta        :%p", [[[obj class] class] class]);
 NSLog(@"root meta's meta :%p", [[[[obj class] class] class] class]);
 
 // Log输出：
 2016-02-02 18:06:11.443 TimerDemo[1718:248402] instance         :0x7fc792530f20
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] class            :0x10ae0e178
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] meta class       :0x10ae0e150
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] root meta        :0x10b66a198
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] root meta's meta :0x10b66a198
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] ---------------------------------------------
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] class            :0x10ae0e178
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] meta class       :0x10ae0e178
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] root meta        :0x10ae0e178
 2016-02-02 18:06:11.444 TimerDemo[1718:248402] root meta's meta :0x10ae0e178
 
 #import <objc/runtime.h>
 
 ...
 
 NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(test) userInfo:nil repeats:YES];
 NSLog(@"instance       :%p", timer1);
 NSLog(@"class          :%p", object_getClass(timer1));
 NSLog(@"meta class     :%p", object_getClass(object_getClass(timer1)));
 NSLog(@"root meta class:%p", object_getClass(object_getClass(object_getClass(timer1))));
 NSLog(@"------------------------------");
 NSLog(@"[NSTimer class]:%p", [NSTimer class]);
 
 // Log输出：
 
 2016-02-02 18:19:11.643 TimerDemo[1745:255746] instance       :0x7fee8bc7a810
 2016-02-02 18:19:11.644 TimerDemo[1745:255746] class          :0x10ece02c0
 2016-02-02 18:19:11.644 TimerDemo[1745:255746] meta class     :0x10ece02e8
 2016-02-02 18:19:11.644 TimerDemo[1745:255746] root meta class:0x10e895198
 2016-02-02 18:19:11.644 TimerDemo[1745:255746] ------------------------------
 2016-02-02 18:19:11.644 TimerDemo[1745:255746] [NSTimer class]:0x10ecdfe38
 
 问题来了：
 为什么[NSTimer class]:0x10ecdfe38与class:0x10ece02c0得到的指针不一样？
 
 就是说为什么object_getClass(obj)与[OBJ class]返回的指针不同？
 答案来了
 答案非常简单，两个字：类簇  (抽象工厂设计模式！)
 
 NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(test) userInfo:nil repeats:YES];
 NSLog(@"instance       :%@", timer1);
 NSLog(@"class          :%@", object_getClass(timer1));
 NSLog(@"meta class     :%@", object_getClass(object_getClass(timer1)));
 NSLog(@"root meta class:%@", object_getClass(object_getClass(object_getClass(timer1))));
 NSLog(@"------------------------------");
 NSLog(@"[NSTimer class]:%@", [NSTimer class]);
 
 // Log输出：
 
 2016-02-02 18:31:54.405 TimerDemo[1772:263501] instance       :<__NSCFTimer: 0x7ff83841e530>
 2016-02-02 18:31:54.405 TimerDemo[1772:263501] class          :__NSCFTimer
 2016-02-02 18:31:54.405 TimerDemo[1772:263501] meta class     :__NSCFTimer
 2016-02-02 18:31:54.406 TimerDemo[1772:263501] root meta class:NSObject
 2016-02-02 18:31:54.406 TimerDemo[1772:263501] ------------------------------
 2016-02-02 18:31:54.406 TimerDemo[1772:263501] [NSTimer class]:NSTimer
 
 NSNumber *intNum = [NSNumber numberWithInt:1];
 NSNumber *boolNum = [NSNumber numberWithBool:YES];
 NSLog(@"intNum :%@", [intNum class]);
 NSLog(@"boolNum:%@", [boolNum class]);
 
 // Log输出：
 
 2016-02-02 23:15:23.868 TimerDemo[1018:35735] intNum :__NSCFNumber
 2016-02-02 23:15:25.027 TimerDemo[1018:35735] boolNum:__NSCFBoolean
 
 
 如何证明__NSCFTimer就是NSTimer的子类，如何证明类簇是真的？其实很简单：
 
 NSLog(@"[NSTimer class]    :%p", [NSTimer class]);
 NSLog(@"class_getSuperClass:%p", class_getSuperclass([timer1 class]));
 
 
 // Log输出：
 
 2016-02-02 23:22:54.367 TimerDemo[1038:39690] [NSTimer class]    :0x109ee4e38
 2016-02-02 23:22:54.367 TimerDemo[1038:39690] class_getSuperClass:0x109ee4e38
 
 http://www.cocoachina.com/ios/20150104/10826.html
 
 1. load 和 initialize 的共同特点以及区别
 
 load和initialize有很多共同特点，下面简单列一下：
 
 在不考虑开发者主动使用的情况下，系统最多会调用一次
 如果父类和子类都被调用，父类的调用一定在子类之前
 都是为了应用运行提前创建合适的运行环境
 在使用时都不要过重地依赖于这两个方法，除非真正必要
 2. load方法相关要点
 
 废话不多说，直接上要点列表：
 
 调用时机比较早，运行环境有不确定因素。具体说来，在iOS上通常就是App启动时进行加载，但当load调用的时候，并不能保证所有类都加载完成且可用，必要时还要自己负责做auto release处理。
 补充上面一点，对于有依赖关系的两个库中，被依赖的类的load会优先调用。但在一个库之内，调用顺序是不确定的。
 对于一个类而言，没有load方法实现就不会调用，不会考虑对NSObject的继承。
 一个类的load方法不用写明[super load]，父类就会收到调用，并且在子类之前。
 Category的load也会收到调用，但顺序上在主类的load调用之后。
 不会直接触发initialize的调用。
 3. initialize方法相关要点
 
 同样，直接整理要点：
 
 initialize的自然调用是在第一次主动使用当前类的时候（lazy，这一点和Java类的“clinit”的很像）。
 在initialize方法收到调用时，运行环境基本健全。
 initialize的运行过程中是能保证线程安全的。
 和load不同，即使子类不实现initialize方法，会把父类的实现继承过来调用一遍。注意的是在此之前，父类的方法已经被执行过一次了，同样不需要super调用。
 由于initialize的这些特点，使得其应用比load要略微广泛一些。可用来做一些初始化工作，或者单例模式的一种实现方案。
 
 */