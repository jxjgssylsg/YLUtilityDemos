//
//  TestKeyWindow.m
//  DemoKeyWindow
//
//  Created by Chris Hu on 16/4/4.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "TestKeyWindow.h"

@interface TestKeyWindow() <UITextFieldDelegate>

@end

@implementation TestKeyWindow {
    UITextField *_textField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self addLabel];
        [self addPasswordInput];
    }
    return self;
}

+ (TestKeyWindow *)sharedInstance {
    static TestKeyWindow *sharedInstance; // staic, 保证不会被销毁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TestKeyWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

- (void)show {
    [self makeKeyAndVisible];
    self.hidden = NO;
}

- (void)hide {
    [self resignKeyWindow];
    self.hidden = YES;
}

- (void)addLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.frame), 50)];
    label.backgroundColor = [UIColor redColor];
    [self addSubview:label];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"TestKeyWindow";
}

- (void)addPasswordInput {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [self addSubview:_textField];

    _textField.center = self.center;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.placeholder = @"请输入密码";
    _textField.delegate = self;
    [_textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"123456"]) {
        [textField resignFirstResponder];
        _textField.text = @"";
        [self hide];
    }
    NSLog(@"%@",textField.text); // 注意下调用事时机,看打印结果
    return YES;
}

@end
