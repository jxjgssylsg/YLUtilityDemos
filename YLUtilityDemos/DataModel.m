//
//  DataModel.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/17.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

+ (instancetype)DataModelWithDict:(NSDictionary *)dict
{
    DataModel *vi = [[DataModel alloc] init];
    //kvc (key value coding)
    [vi setValuesForKeysWithDictionary:dict];
    return vi;
}
// 注:对象中包含的 >= dic中包含的键值,是可以正常初始化的,否则需调用以下方法,要不然会崩溃的
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"hehe~");
}

@end
