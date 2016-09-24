//
//  MyCollectionReusableView.m
//  CollectionDemo
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 banwang. All rights reserved.
//

#import "MyCollectionReusableView.h"

@implementation MyCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Decoration View";
        label.font = [UIFont systemFontOfSize:18];
        [label sizeToFit];
        label.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:label];
    }
    
    return self;
}

@end
