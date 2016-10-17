//
//  NSCAnimal.h
//  NSCoding
//
//  Created by Hannibal Yang on 12/6/14.
//  Copyright (c) 2014 Hannibal Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCAnimal : NSObject <NSCoding>

@property (nonatomic, copy) NSString *furColor;
@property (nonatomic, assign) double weight;
@property (nonatomic, assign) BOOL isFly;

@end
