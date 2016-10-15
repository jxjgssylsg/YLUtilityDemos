//
//  ViewController.m
//  DemoKVC
//
//  Created by Chris Hu on 16/1/28.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "KVCViewController.h"

#pragma mark - MyObject

@interface MyObject : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *age;
@property (nonatomic) NSString *language;

@end

@implementation MyObject

@end


#pragma mark - Dog

@interface Dog : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *city;

@end

@implementation Dog

@end



#pragma mark - Person

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) Dog *dog;
@property (nonatomic, strong) NSArray *dogs;

@end

@implementation Person

@end



@interface KVCViewController ()

@property (nonatomic) NSString *name;

@property (nonatomic) MyObject *myObject;

@end

@implementation KVCViewController {  // 不是拓展 extension 的写法,什么鬼?

    NSString *anotherName;
    
    MyObject *myObject1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myObject = [MyObject new];
    
    // NonKVC
    [self testNonKVC];
    
    // KVC
    [self testKVC];
 
    [self testKVCInObject];
    
    [self testKeyPath];
    
    [self testBatchOperation];
}

- (void)testNonKVC {
    //  NonKVC, .语法
    NSLog(@">>>>>>>> testingNonKVC \n");
    
    //  属性
    self.name = @".Name";
    NSLog(@".name : %@", self.name);
    // KVC
    NSLog(@"name valueForKey : %@", [self valueForKey:@"name"]);
    NSLog(@"\n");
    
    // 实例变量
    anotherName = @".Another Name";
    NSLog(@".anotherName : %@", anotherName);
    // KVC
    NSLog(@"anotherName valueForKey : %@", [self valueForKey:@"anotherName"]);
    NSLog(@"\n");
    
    
    // MyObject
    MyObject *myObject = [MyObject new];
    myObject.name = @"myObject Name";
    NSLog(@"myObject.name : %@", myObject.name);
    // KVC
    NSLog(@"myObject valueForKey : %@", [myObject valueForKey:@"name"]);         // valueForKey
    NSLog(@"myObject valueForKeyPath : %@", [myObject valueForKeyPath:@"name"]); // valueForKeyPath
    NSLog(@"\n");
    
    self.myObject.name = @"self.myObject Name";
    NSLog(@"self.myObject.name : %@", self.myObject.name );
    // KVC
    NSLog(@"myObject valueForKey : %@", [self.myObject valueForKey:@"name"]);
    NSLog(@"myObject valueForKeyPath : %@", [self.myObject valueForKeyPath:@"name"]);
    NSLog(@"\n");
    
    myObject1 = [MyObject new];
    myObject1.name = @"myObject1 Name";
    NSLog(@"myObject1.name : %@", myObject1.name);
    // KVC  myObject1 是成员变量
    NSLog(@"myObject1 valueForKeyPath : %@", [self valueForKeyPath:@"myObject1.name"]);
    NSLog(@"\n");
}


- (void)testKVC {
    // KVC
    NSLog(@">>>>>>>> testingKVC \n");
    
    // 属性
    [self setValue:@"Name" forKey:@"name"];
    NSLog(@"name valueForKey : %@", [self valueForKey:@"name"]);
    NSLog(@"name valueForKeyPath : %@", [self valueForKeyPath:@"name"]);
    NSLog(@"\n");
    
    // 实例变量
    [self setValue:@"Another Name" forKey:@"anotherName"];
    NSLog(@"anotherName valueForKey : %@", [self valueForKey:@"anotherName"]);
    NSLog(@"anotherName valueForKeyPath : %@", [self valueForKeyPath:@"anotherName"]);
    NSLog(@"\n");

    
    // MyObject
    MyObject *myObject = [MyObject new];
    [myObject setValue:@"myObject Name" forKey:@"name"];
    NSLog(@"myObject valueForKey : %@", [myObject valueForKey:@"name"]);
    NSLog(@"myObject valueForKeyPath : %@", [myObject valueForKeyPath:@"name"]);
    NSLog(@"\n");
    
    // myObject1 是成员变量
    myObject1 = [MyObject new];
    [self setValue:@"myObject1 Name" forKeyPath:@"myObject1.name"];
    NSLog(@"myObject1 valueForKeyPath : %@", [self valueForKeyPath:@"myObject1.name"]);
    //  对self直接使用forKey等会出错，因self本身就没有该key。只能使用keyPath相关方法。
    //  [self setValue:@"myObject1 Name" forKey:@"myObject1.name"];
    //  NSLog(@"myObject1 valueForKey : %@", [self valueForKey:@"myObject1.name"]);
    NSLog(@"\n");
    
    
}

- (void)testKVCInObject {
    MyObject *myObject = [MyObject new];
    NSArray *array = @[@"name", @"age", @"language"];
    for (NSString *key in array) {
        [myObject setValue:@"unknown" forKey:key];
    }
    NSLog(@"myObject.name : %@", myObject.name);
    NSLog(@"myObject.age : %@", myObject.age);
    NSLog(@"myObject.language : %@", myObject.language);
    NSLog(@"\n");
    
    for (NSString *key in array) {
        NSString *value = [myObject valueForKey:key];
        NSLog(@"%@ - %@", key, value);
    }
}

- (void)testKeyPath {
    Dog *aDog = [[Dog alloc] init];
    aDog.name = @"My Dog";
    aDog.age = 2;
    NSString *dogName = [aDog valueForKey:@"name"];
    NSInteger dogAge = [[aDog valueForKey:@"age"] integerValue]; // valueForKey 返回的是 id 类型的, 这里应该是 NSNumber
    NSLog(@"dogName : %@, dogAge : %ld", dogName, dogAge);
    
    Person *aPerson = [[Person alloc] init];
    aPerson.name = @"Chris";
    aPerson.age = 18;
    aPerson.dog = aDog;
    
    NSString *name = [aPerson valueForKeyPath:@"name"];
    NSInteger age = [[aPerson valueForKeyPath:@"age"] integerValue];
    dogName = [aPerson valueForKeyPath:@"dog.name"];
    dogAge = [[aPerson valueForKeyPath:@"dog.age"] integerValue];
    NSLog(@"testKeyPath: name : %@, age : %ld", name, age);
    NSLog(@"testKeyPath: dogName : %@, dogAge : %ld", dogName, dogAge);
}

- (void)testBatchOperation {
    Dog *dog1 = [[Dog alloc] init];
    dog1.name = @"Dog 1";
    dog1.age = 1;
    dog1.city = @"Shanghai";
    
    Dog *dog2 = [[Dog alloc] init];
    dog2.name = @"Dog 2";
    dog2.age = 2;
    dog2.city = @"Shanghai";
    
    Dog *dog3 = [[Dog alloc] init];
    dog3.name = @"Dog 3";
    dog3.age = 3;
    dog3.city = @"Beijing";
    
    Person *aPerson = [[Person alloc] init];
    aPerson.name = @"Chris";
    aPerson.age = 18;
    aPerson.dogs = @[dog1, dog2, dog3];
    
    // NSArray 实现 valueForKeyPath:的方法是循环遍历它的内容并向每个对象发送消息.
    // 返回 dogs 中所有 dog 的 name 的集合
    NSArray *dogNames = [aPerson valueForKeyPath:@"dogs.name"];
    NSArray *dogAges = [aPerson valueForKeyPath:@"dogs.age"];
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"dogNames :"];
    for (NSInteger i = 0; i < dogNames.count; i++) {
        [str appendFormat:@" %@, %ld years old. ", dogNames[i], [dogAges[i] integerValue]];
    }
    
    NSLog(@"%@", str);
    
    // dogs表示取出内容, @count即进行计算, 通知KVC机制进行键路径左侧值的对象总数
    NSNumber *countOfDogs = [aPerson valueForKeyPath:@"dogs.@count"];
    NSLog(@"count of dogs : %@", countOfDogs);
    
    // 获取@sum左侧的集合, 对集合中的每个对象执行右侧操作 age, 将结果组成一个集合并返回.
    NSNumber *ageCountOfDogs = [aPerson valueForKeyPath:@"dogs.@sum.age"];
    NSLog(@"ageCountOfDogs of dogs : %@", ageCountOfDogs);
    
    NSNumber *ageAvgOfDogs = [aPerson valueForKeyPath:@"dogs.@avg.age"];
    NSLog(@"age avg of dogs : %@", ageAvgOfDogs);
    NSLog(@"age min : %@, max : %@", [aPerson valueForKeyPath:@"dogs.@min.age"], [aPerson valueForKeyPath:@"dogs.@max.age"]);
    
    // 获取唯一值
    NSArray *cities = [aPerson valueForKeyPath:@"dogs.@distinctUnionOfObjects.city"];
    NSLog(@"cities : %@", cities);
    
    // 批量修改
    [aPerson setValue:@"Xiamen" forKeyPath:@"dogs.city"];
    
    cities = [aPerson valueForKeyPath:@"dogs.@distinctUnionOfObjects.city"];
    NSLog(@"cities : %@", cities);
    
    // 根据设置的 key, 来进行组合结果.
    Dog *lastDog = [[aPerson valueForKeyPath:@"dogs"] lastObject];
    NSArray *keys = @[@"name"];
    NSDictionary *values = [lastDog dictionaryWithValuesForKeys:keys];
    NSLog(@"values : %@", values);
    
    // 使用 setValuesForKeysWithDictionary 根据字典对 Dog 进行修改
    NSDictionary *newValues = @{@"name": @"My Dog", @"age": @"14"};
    [lastDog setValuesForKeysWithDictionary:newValues];
    values = [lastDog dictionaryWithValuesForKeys:keys];
    NSLog(@"values : %@", values);
    
    // 不要滥用KVC, KVC需要解析字符串来计算需要的结果, 因此速度较慢. 且无法进行错误检查.
}

@end
