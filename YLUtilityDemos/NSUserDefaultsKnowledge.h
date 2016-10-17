//
//  NSUserDefaultsKnowledge.h
//  YLExperimentForOC
//
//  Created by Mr_db on 16/10/10.
//  Copyright (c) 2016年 yilin. All rights reserved.
//

#ifndef YLExperimentForOC_NSUserDefaultsKnowledge_h
#define YLExperimentForOC_NSUserDefaultsKnowledge_h

/*
   这部分内容较少
    
 http://www.jianshu.com/p/4b118ebb656f
 # 简介 #
 1. NSUserDefaults 是一个单例，在整个程序中只有一个实例对象，他可以用于数据的永久保存，而且简单实用，这是它可以让数据自由传递的一个前提。
 2. NSUserDefaults 适合存储轻量级的本地数据，比如要保存一个登陆界面的数据，用户名、密码之类的，个人觉得使用 NSUserDefaults 是首选。下次再登陆的时候就可以直接从 NSUserDefaults 里面读取上次登陆的信息。就像读字符串一样，直接读取就可以了。
 3. 用 NSUserDefaults 存储的数据下次程序运行的时候依然存在 .它的数据存储在应用程序内置的一个 plist 文件里, 在/Library/Prefereces 沙盒路径下.
 
 # 支持数据格式: #
 NSNumber ( Integer、Float、Double )
 NSString
 NSArray
 NSDictionary
 BOOL 类型
 nsDate
 
 # 简单类型数据读写 NSUserDefaults 中: #
 
 // 1. 创建NSUserDefaults单例:
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
 // 2. 数据写入:
 // 通过 key 值 来存入 和 读取数据
 [defaults setInteger:23 forKey:@"myInteger"];
 // 注意：对相同的Key赋值约等于一次覆盖，要保证每一个Key的唯一性
 
 // 3. 将数据 立即存入到 磁盘:
 [defaults synchronize];
 
 // 4. 通过key值 按照写入对应类型 读取数据 有返回值
 NSInteger *myInteger = [defaults integerForKey:@"myInteger"];
 
 注.
 NSUserDefaults 存储的对象全是不可变的（这一点非常关键，弄错的话程序会出bug），例如，如果我想要存储一个 NSMutableArray 对象，我必须先创建一个不可变数组（ NSArray ）再将它存入 NSUserDefaults 中去，代码如下：
 
 NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:@"123",@"234", nil];
 NSArray * array = [NSArray arrayWithArray:mutableArray];
 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
 [user setObject:array forKey:@"记住存放的一定是不可变的"];
 
 # 将自定义类型数据读写 NSUserDefaults 中 #
 使用 NSKeyedArchiver 对数据进行归档 反归档.
 将自定义类型转换为 NSData 类型:
 当数据重复而且多的时候（例如想存储全班同学的学号，姓名，性别（这个数据量可能太大了 ）），如果不用SQLite 存储 （多数据最好还是用这个），可以选择使用归档，再将文件写入本地。但是这种方式和 NSUserDefaults 比起来麻烦多了（因为 NSFileManager 本来就挺复杂） ，但是问题是， NSUserDefaults  本身不支持自定义对象的存储，不过它支持 NSData 的类型，可以转化为 NSData  类型 。
 
 我们先建立一个叫Student 的类，这个类里有三个属性(姓名, 年龄, 性别）,代码如下：
 
 //  Created by LiCheng on 16/5/5.
 //  Copyright © 2016年 LiCheng. All rights reserved.
 //
 #import <Foundation/Foundation.h>
 
 @interface Student : NSObject
 
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, strong) NSString *sex;
 @property (nonatomic, assign) NSInteger age;
 
 @end
 
 我们要做的就是将 Student 类型变成 NSData 类型 ，那么就必须实现归档：
 这里要实现在 .h 文件中申明 NSCoding 协议，再在 .m 中实现 encodeWithCoder 方法 和
 initWithCoder 方法就可以了 ：
 .h 中修改,代码如下 ：
 
 
 
 #import <Foundation/Foundation.h>
 
 @interface Student : NSObject  <NSCoding>  // 实现 NSCoding 协议
 
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, strong) NSString *sex;
 @property (nonatomic, assign) NSInteger age;
 
 @end
 
 .m中加入代码 ：
 
 //  Created by LiCheng on 16/5/5.
 //  Copyright © 2016年 LiCheng. All rights reserved.
 //
 #import "Student.h"
 
 @implementation Student
 // 归档
 -(void)encodeWithCoder:(NSCoder *)aCoder {
 
 [aCoder encodeObject:self.name forKey:@"name"];
 [aCoder encodeObject:self.age forKey:@"age"];
 [aCoder encodeObject:self.sex forKey:@"sex"];
 }
 // 反归档
 -  (instancetype)initWithCoder:(NSCoder *)aDecoder {
 
 self = [super init];
 if (self) {
 self.name = [aDecoder decodeObjectForKey:@"name"];
 self.age = [aDecoder decodeObjectForKey:@"age"];
 self.sex = [aDecoder decodeObjectForKey:@"sex"];
 }
 return self;
 }
 @end
 
 这样做就可以将自定义类型转变为 NSData 类型了, 下来进行 写入 和 读取.
 
 写入数据：
 // 首先，要建立一个可变数组来存储 NSDate对象
 Student *student = [[Student alloc] init];
 
 // 下面进行的是对student对象的 name, age, sex 赋值
 student.name = @"张三";
 student.age = @"20";
 student.sex = @"男";
 
 // 将student 对象转换成为 NSData 类型
 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:student];
 
 // 保存学生信息
 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
 [user setObject:data forKey:@"oneStudent"];
 
 读取数据:
 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
 
 // 读取 data 数据
 NSData *data = [user objectForKey:@"oneStudent"];
 
 // 将 data 类型转换成 Student 类型
 Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:data];
 NSLog(@"%@", student.name);
 NSLog(@"%@", student.age);
 NSLog(@"%@", student.sex);
 
 http://www.jianshu.com/p/459c15cf6ce2
 
 # NSUserDefaults 是什么，有什么用处 #
 对于应用来说，每个用户都有自己的独特偏好设置，而好的应用会让用户根据喜好选择合适的使用方式，把这些偏好记录在应用包的 plist 文件中，通过 NSUserDefaults 类来访问，这是 NSUserDefaults 的常用姿势。如果有一些设置你希望用户即使升级后还可以继续使用，比如玩游戏时得过的最高分、喜好和通知设置、主题颜色甚至一个用户头像，那么你可以使用 NSUserDefaults 来存储这些信息，如果有更多需求，可以了解数据持久化相关的知识。
 
 具体来说 NSUserDefaults 是 iOS 系统提供的一个单例类( iOS 提供了若干个单例类)，通过类方法 standardUserDefaults 可以获取 NSUserDefaults 单例。如：
 
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
 NSUserDefaults 单例以 key-value 的形式存储了一系列偏好设置，key 是名称，value 是相应的数据。存/取数据时可以使用方法 objectForKey: 和 setObject:forKey: 来把对象存储到相应的 plist 文件中，或者读取，既然是 plist 文件，那么对象的类型则必须是 plist 文件可以存储的类型，正如官方文档中提到的——
 {
     NSData
     NSString
     NSNumber
     NSDate
     NSArray
     NSDictionary
 }
 
 而如果需要存储 plist 文件不支持的类型，比如图片，可以先将其归档为 NSData 类型，再存入 plist 文件，需要注意的是，即使对象是 NSArray 或 NSDictionary ，他们存储的类型也应该是以上范围包括的。
 
 # 存/读不同类型数据 #
 比如存/读一个整数、字符串和一张图片：
 
 ###存
 
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 [defaults setObject:@”jack“ forKey:@"firstName"];
 [defaults setInteger:10 forKey:@"Age"];
 
 UIImage *image =[UIImage imageNamed:@"somename"];
 NSData *imageData = UIImageJPEGRepresentation(image, 100); // 把 image 归档为 NSData
 [defaults setObject:imageData forKey:@"image"];
 
 [defaults synchronize];
 
 其中，方法 synchronise 是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的。
 
 ###读
 
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 NSString *firstName = [defaults objectForKey:@"firstName"]
 NSInteger age = [defaults integerForKey:@"Age"];
 
 NSData *imageData = [defaults dataForKey:@"image"];
 UIImage *image = [UIImage imageWithData:imageData];
 我们通过为三个数据设置 key 的方式把 NSInteger 、 NSString 和 UIImage 三种数据存储下来，其中图片是通过归档为NSData 的方式进行存储的，除此之外，还可以被转为 NSNumber 或 NSString 类型。顺便提一句，这里 NSInteger 没有星号，因为 NSInteger 根据系统是 64 位还是 32 位来判断自身是 long 还是 int 类型，并且它也不是一个标准 Objective-C 对象。
 
 # 简便方法存取不同类型数据 #
 
 由上边的例子可以看到一个方法 -setInteger: ,这跟常用的 - setObject：相比设置类型更明确。其实， NSUserDefaults 提供了若干简便方法可以存储某些常用类型的值，例如：
 
 - setBool:forKey:
 - setFloat:forKey:
 - setInteger:forKey:
 - setDouble:forKey:
 - setURL:forKey:
 这将使某些值的设置更简单。
 
 # NSUserDefaults 域 #
 
 NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
 NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
 [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
 
 UserDefaults 数据库中其实是由多个层级的域组成的，当你读取一个键值的数据时，NSUserDefaults 从上到下透过域的层级寻找正确的值，不同的域有不同的功能，有些域是可持久的，有些域则不行。
 
 1. 应用域（application domain）是最重要的域，它存储着你 app 通过 NSUserDefaults set...forKey 添加的设置。
 2. 注册域（registration domain）仅有较低的优先权，只有在应用域没有找到值时才从注册域去寻找。
 3. 全局域（global domain）则存储着系统的设置
 4. 语言域（language-specific domains）则包括地区、日期等
 5. 参数域（ argument domain）有最高优先权
 
 http://www.jianshu.com/p/9cb6ea37f46c
 # iOS 清空 NSUserDefaults 下的内容 #
 // 方法一
 
 NSString *appDomain = [[NSBundlemainBundle] bundleIdentifier];
 [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
 
 // 方法二
 - (void)resetDefaults {
 
 NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
 NSDictionary *dict = [defs dictionaryRepresentation];
 
 for(idkeyindict) {
   [defsremoveObjectForKey:key];
 
 }
 
   [defs synchronize];
 
 }
 */


#endif
