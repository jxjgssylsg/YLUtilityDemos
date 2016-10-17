//
//  ViewController.h
//  NSCoding
//
//  Created by Hannibal Yang on 12/6/14.
//  Copyright (c) 2014 Hannibal Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSCodingViewController : UIViewController

- (IBAction)save;

- (IBAction)read;

@end

/*
 http://www.cnblogs.com/someonelikeyou/p/5667906.html
 
 // 属性编码方法
 - (void)encodeWithCoder:(NSCoder *)aCoder；
 
 // 属性解码方法
 - (id)initWithCoder:(NSCoder *)aDecoder；
 
 调用　+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path；会启动属性编码
 调用　+ (nullable id)unarchiveObjectWithFile:(NSString *)path;　会启动属性解码
 
 
 http://www.jianshu.com/p/a517499634a3
 NSUserDefaults 简介:
 NSUserDefaults 本身是一个单例，在整个程序中只有一个实例对象，它是数据持久化的一种方式, 使用起来也很方便
 
 NSUserDefaults 存储的数据存在什么地方:
 存储位置为 <UUID for your App>\Library\Preferences\<your App's bundle ID>.plist
 由于该存储位置容易被找到,因此不建议存储很重要或者隐私的数据(加密之后存储除外),可以存储一些配置信息
 
 NSUserDefaults 存储支持哪些数据类型:
 NSUserDefaults 支持的数据类型有  NSNumber（NSInteger、float、double）， NSString ， NSDate ， NSData, NSArray, NSDictionary , BOOL  ,当然 NSUserDefaults 虽然不能直接存储其他类型的数据, 但是我们可以把其他类型的转成 NSUserDefaults 可以直接存储的类型再进行存储, 下文中会提到用 NSUserDefaults 存储自定义对象,会用到 NSCoding
 
 需要注意的地方:
 NSUserDefaults 存储的为不可变类型, 例如你要存储的是一个可变的数组, 存储之前首先用不可变数组接受一下才可以
 
 - (void)action2 {
 // 初始化两个英雄:寒冰和蛮王( 他俩是两口子 )
 Hero *hanBing = [[Hero alloc]  init];
 hanBing.HP = @"400";
 hanBing.MP = @"200";
 hanBing.SP = @"0";
 Hero *manWang = [[Hero alloc] init];
 manWang.HP = @"420";
 manWang.MP = @"0";
 manWang.SP = @"50";
 // 用 NSData 接收
 NSData *hanBingData = [NSKeyedArchiver archivedDataWithRootObject:hanBing];
 NSData *manWangData = [NSKeyedArchiver archivedDataWithRootObject:manWang];
 // 存到不可变数组中
 NSArray *heroArr = [NSArray array];
 heroArr = @[hanBingData, manWangData];
 // 存到沙盒
 NSUserDefaults *heroes = [NSUserDefaults standardUserDefaults];
 [heroes setObject:heroArr forKey:@"heroes"];
 // 读取英雄数据
 NSArray *array = [heroes objectForKey:@"heroes"];
 for (NSData *heroData in array) {
 Hero *hero = [NSKeyedUnarchiver unarchiveObjectWithData:heroData];
 NSLog(@"HP:%@  MP:%@  SP:%@",hero.HP,hero.MP,hero.SP);
 }
 
 打印结果:
 2016-02-17 12:06:15.005 NSUserDefaults[2192:85145] HP:400  MP:200  SP:0
 2016-02-17 12:06:15.005 NSUserDefaults[2192:85145] HP:420  MP:0  SP:50
 
}
 http://blog.sina.com.cn/s/blog_7b9d64af01019kk5.html
 归档需要注意的是：
 1. 同一个对象属性，编码/解码的 key 要相同！
 2. 每一种基本数据类型，都有一个相应的编码/解码方法。
 如：encodeObject 方法与 decodeObjectForKey 方法，是成对出现的。
 3.如果一个自定义的类 A，作为另一个自定义类B的一个属性存在；那么，如果要对 B 进行归档，那么 B 要实现 NSCoding协议。并且，A 也要实现 NSCoding 协议。
 
 http://blog.sina.com.cn/s/blog_769527d10101d0gk.html
 
 思考:避免死循环
 聪明的读者可能会怀疑:""如果对象A使对象B进行encode,对象B使对象C进行encode,而对象C又使得对象A进行encode. 这样不是会产生无穷循环吗?"" 没错,确实会发生这种情况,好在NSKeyedArchiver类设计好了避免这种情况发送.
 
 当 encode 一个对象的时候,会将一个唯一标识同时放到流中.并建立一个表,一旦 Archive 对象,就会把该对象和它的唯一标识联系起来. 如果下次又要 encode 同一个对象, NSKeyedArchiver 会先浏览这个表,看是否已经 encode 过,并只会把唯一标识放置到流中.
 
 当从流中 decode 出对象时,  NSKeyedUnarchiver 同样会生成一个表,把 encode 对象和唯一标识关联起来.如果发现流中只有唯一标识[说明之前有 encode 这个对象], unarchiver 就会在表中来查找这个对象,而不是再生成一个新的对象.
 
 http://www.piggybear.net/?p=484
 
 #import "PGStudent.h"
 
 @interface PGStudent()&lt;NSCoding&gt;
 @end
 
 @implementation PGStudent
 
 #pragma mark - Encoding/Decoding
 
 NSString *const NameKey  = @"NameKey";
 NSString *const AgeKey   = @"AgeKey";
 NSString *const ImageKey = @"ImageKey";
 // 编码
 -  (void)encodeWithCoder:(NSCoder *)aCoder {
 [aCoder encodeObject:_name forKey:NameKey];
 [aCoder encodeInt:_age forKey:AgeKey];
 // 将 _userImage 转换成 NSData 在编码 对象要进行编码时必须先转换成 NSData
 [aCoder encodeObject:UIImagePNGRepresentation(_userImage) forKey:ImageKey];
 }
 
 // 解码
 - (instancetype)initWithCoder:(NSCoder *)aDecoder {
 if (self =[super init]) {
 self.name  = [aDecoder decodeObjectForKey:NameKey];
 self.age     = [aDecoder decodeIntForKey:AgeKey];
 NSData *data   = [aDecoder decodeObjectForKey:ImageKey];
 self.userImage = [UIImage imageWithData:data];
 }
 return self;
 }
 @end
 
 */