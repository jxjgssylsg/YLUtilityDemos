//
//  TestKeyWindow.h
//  DemoKeyWindow
//
//  Created by Chris Hu on 16/4/4.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestKeyWindow : UIWindow

+ (TestKeyWindow *)sharedInstance;

- (void)show;

- (void)hide;

@end
