//
//  QREncoding.h
//  QRCode
//
//  Created by syl on 16/4/20.
//  Copyright © 2016年 Moqod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QREncoding : NSObject

+ (UIImage *)createQRcodeForString:(NSString *)qrString withSize:(CGFloat)size;
+ (UIImage *)createQRcodeForString:(NSString *)qrString withSize:(CGFloat)size withRed:(int)red green:(int)green blue:(int)blue;

@end
