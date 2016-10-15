//
//  ViewController.h
//  DemoKVC
//
//  Created by Chris Hu on 16/1/28.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KVCViewController : UIViewController


@end

/*
 
 http://blog.csdn.net/wzzvictory/article/details/9674431
 
 1、Key 和 Key Path
 
 - (id)valueForKey:(NSString *)key;
 - (void)setValue:(id)value forKey:(NSString *)key;
 - (id)valueForKeyPath:(NSString *)keyPath;
 - (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
 
 前边两个方法用到的Key较容易理解，就是要访问的属性名称对应的字符串。
 后面两个方法用到的KeyPath是一个被点操作符隔开的用于访问对象的指定属性的字符串序列。比如KeyPath address.street 将会访问消息接收对象所包含的address属性中包含的一个street属性。其实 KeyPath 说白了就是我们平时使用点操作访问某个对象的属性时所写的那个字符串。
 
 4、键值验证（Key-Value Validation）
 - (BOOL)validateValue:(inout id *)ioValue forKey:(NSString *)inKey error:(out NSError **)outErro
 
 6、集合运算符（Collection Operators）
 @avg，@count，@max，@min，@sum5
 
 有一个集合类的对象：transactions，它存储了一个个的Transaction类的实例，该类有三个属性：payee，amount，date。下面以此为例说明如何使用这些运算符：
 要获取amount的平均值可以这样：
 NSNumber *transactionAverage = [transactions valueForKeyPath:@"@avg.amount"];
 
 注. 详见 Demo 1
 
 三、实现原理
 
 KVC再某种程度上提供了访问器的替代方案。不过访问器方法是一个很好的东西，以至于只要是有可能，KVC也尽量再访问器方法的帮助下工作。为了设置或者返回对象属性，KVC按顺序使用如下技术：（见原文）
 
 注. 如果仍为找到，就用 valueForUndefinedKey: 和 setValue:forUndefinedKey: 方法。这些方法的默认实现都是抛出异常，我们可以根据需要重写它们。
 
 2、KVC/KVO实现原理
 当某个类的对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的 setter 方法。派生类在被重写的 setter 方法实现真正的通知机制，对象的 isa 指针指向这个新诞生的派生类
 
 ①class
 重写class方法是为了我们调用它的时候返回跟重写继承类之前同样的内容。
 打印如下内容：
 NSLog(@"self->isa:%@",self->isa);
 NSLog(@"self class:%@",[self class]);
 
 在建立KVO监听前，打印结果为：
 self->isa:Person
 self class:Person
 
 在建立KVO监听之后，打印结果为：
 self->isa:NSKVONotifying_Person
 self class:Person
 
 这也是isa指针和class方法的一个区别，大家使用的时候注意
 
 https://www.zybuluo.com/MicroCai/note/66738	   // KVO 和 KVC 的使用和实现
 
 原理：KVO/KVC 是观察者模式在 Objective-C 中的实现，以非正式协议（Category）的形式被定义在 NSObject 中
 
 // "NSKeyValueObserving.h"
 @interface NSObject(NSKeyValueObserving)
 // "NSKeyValueCoding.h"
 @interface NSObject(NSKeyValueCoding)
 
# KVO 即 Key-Value-Observing，顾名思义用于观察键值
 
 //通过此方法即可添加对象的观察者
 - (void)addObserver:(NSObject *)observer
 forKeyPath:(NSString *)keyPath
 options:(NSKeyValueObservingOptions)options
 context:(void *)context;
 KVC 即 Key-Value-Coding，用于键值编码
 
 - (id)valueForKey:(NSString *)key;
 - (void)setValue:(id)value forKey:(NSString *)key;
 - (id)valueForKeyPath:(NSString *)keyPath;
 - (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
 
 # 键值验证（KVV，Key-Value Validate） #
 // KVV 验证
 BOOL isLegalName = [aPerson validateValue:&name forKey:key error:&error];
 if (isLegalName) {
 NSLog(@"it's a legal name.");
 [aPerson setValue:name forKey:key];
 }else{
 NSLog(@"the name is illegal.");
 }
 
 
 - (BOOL)validateName:(NSString **)name error:(NSError * __autoreleasing *)outError
 {
 if ((*name).length == 0)
 {
 (*name) = @"default name";
 return NO;
 }
 return YES;
 }
 
 //移除观察者
 [aPerson removeObserver:aPersonObserver forKeyPath:@"name"];
 
# 集合操作符（Collection Operator） #
 (见原文)
 
# 手动键值观察 #
 通过自动属性，建立键值观察，都属于自动键值观察。因为使用这种方法，只要设置键值，就会自动发出通知。而手动键值观察，不能使用自动化属性，需要自己写 setter/getter 方法，手动发送通知。
 - (void)setName:(NSString *)theName
 {
 //发送通知：键值即将改变
 [self willChangeValueForKey:@"name"];
 name = theName;
 //发送通知：键值已经修改
 [self didChangeValueForKey:@"name"];
 }
 ;
 
 # 设置属性之间的依赖 #
 + (NSSet *)keyPathsForValuesAffecting<Key>;
 
 例;
 //设置属性依赖：fullName属性依赖于firstName、lastName
 //如果观察name，当firstName、lastName发生变化时，观察者也会收到name变化通知
 + (NSSet *)keyPathsForValuesAffectingFullName
 {
 NSSet *set = [NSSet setWithObjects:@"firstName", @"lastName", nil];
 return set;
 }
 
 输出结果，发现虽然观察的是 fullName，但是当修改 firstName 的时候，观察者也会收到 fullName 变化的通知，达到了我们的期望。
 
# 理解 KVO/KVC 的实现 #
 KVO 是通过 isa-swizzling 实现的。
 
 基本的流程就是编译器自动为被观察对象创造一个派生类，并将被观察对象的isa 指向这个派生类。如果用户注册了对某此目标对象的某一个属性的观察，那么此派生类会重写这个方法，并在其中添加进行通知的代码。Objective-C 在发送消息的时候，会通过 isa 指针找到当前对象所属的类对象。而类对象中保存着当前对象的实例方法，因此在向此对象发送消息时候，实际上是发送到了派生类对象的方法。由于编译器对派生类的方法进行了 override，并添加了通知代码，因此会向注册的对象发送通知。注意派生类只重写注册了观察者的属性方法。
 */