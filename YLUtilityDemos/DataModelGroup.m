//
//  DataModelGroup.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/6/17.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "DataModelGroup.h"
#import "DataModel.h"

@implementation DataModelGroup

+ (NSMutableArray *)DataModelGroupWithNameOfContent:(NSString *)name {
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    
    for (NSDictionary *dic in arr) {
        DataModel *mo = [DataModel DataModelWithDict:dic];
        [dataArr addObject:mo];
    }
    return dataArr;
}

@end
