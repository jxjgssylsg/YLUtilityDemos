//
//  ViewController4.m
//  MasonryDemo
//
//  Created by TangJR on 15/4/29.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "MasonryFiveViewController.h"
#import "Masonry.h"

@interface MasonryFiveViewController ()

@property (strong, nonatomic) UITextField *textField;

@end

@implementation MasonryFiveViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _textField = [UITextField new];
    _textField.backgroundColor = [UIColor lightGrayColor];
    _textField.placeholder = @" 这是一个 textField,点击试一试 ";
    [self.view addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerX.equalTo(self.view); // 原来还有个 centerX
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification { // UIKeyboardWillChangeFrameNotification, UIKeyboardWillHideNotification 两个监听都会调用
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight);
        NSLog(@"UIKeyboardWillChangeFrameNotification 1");
    }];
    
    // 更新约束 - 动画, keyboardDuration 是让 _textField 随着键盘一起同步到顶部 make.bottom.mas_equalTo(-keyboardHeight)
    [UIView animateWithDuration:keyboardDuration animations:^{
        NSLog(@"UIKeyboardWillChangeFrameNotification 2");
       [self.view layoutIfNeeded];
        
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification { // UIKeyboardWillHideNotification 监听调用
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改为以前的约束（距下边距0）
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        NSLog(@"UIKeyboardWillHideNotification 3");
        make.bottom.mas_equalTo(0);
    }];
    
    // 更新约束 - 动画, keyboardDuration 是让 _textField 随着键盘一起同步到底部 make.bottom.mas_equalTo(0)
    [UIView animateWithDuration:keyboardDuration animations:^{
        NSLog(@"UIKeyboardWillHideNotification 4");
        [self.view layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];  // use to make the view or any subview that is the first responder resign (optionally force)
}

@end