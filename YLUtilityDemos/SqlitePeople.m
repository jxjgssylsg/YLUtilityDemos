//
//  People.m
//  SqliteManager
//
//  Created by pg on 16/5/10.
//  Copyright © 2016年 person. All rights reserved.
//

#import "SqlitePeople.h"

@implementation SqliteSchool

@end

@implementation SqlitePeople

- (void)setSex:(int)sex {

}

- (int)sex {
    return 0;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"出错%@---%@", key, value);
}

-(id)valueForUndefinedKey:(NSString *)key {
    return @"";
}
@end


@implementation SqlitePeople (test)

- (void)setDesc:(NSString *)desc {
    
}

- (NSString *)desc {
    return @"";
}
@end
