//
//  ScrollViewControllerTwo.m
//
//  Created by Mr_db on 16/4/16.
//  Copyright (c) 2016年 Mr_db. All rights reserved.
//

#import "ScrollViewControllerTwo.h"

// 定义rgb颜色
#define NORMAL_COLOR [UIColor colorWithRed:75/255.0 green:160/255.0 blue:253/255.0 alpha:1]
#define HIGHLIGHTED_COLOR [UIColor colorWithRed:197/255.0 green:221/225.0 blue:249/225.0 alpha:1]

// 按钮操作
typedef void (^ButtonHandle)();
@interface ScrollViewControllerTwo () {
    UIImageView *_imageView; // 图片控件
    UIButton *_btnRotation; // 旋转按钮
    UIButton *_btnScale; // 缩放按钮
    UIButton *_btnTranslate; // 移动按钮
}

@end

@implementation ScrollViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self addImageView];
    [self addRotationButton];
    [self addScaleButton];
    [self addTranslateButton];
    
}

#pragma mark 添加图片控件
- (void)addImageView {
    UIImage *image = [UIImage imageNamed:@"bigPicture.jpeg"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.frame = CGRectMake(20, 20, 280, 154);
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_imageView];
}
- (void)addRotationButton {
    _btnRotation = [self getButton];
    _btnRotation.frame = CGRectMake(20, 400, 280, 30);
    [_btnRotation setTitle:@"旋转" forState:UIControlStateNormal];
    // 添加按钮点击事件
    [_btnRotation addTarget:self action:@selector(rotation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRotation];
}

#pragma mark 添加缩放按钮
- (void)addScaleButton {
    // 在上面一个按钮位置的基础上确认当前位置
    CGRect scaleButtonFrame = _btnRotation.frame;
    scaleButtonFrame.origin.y += 40;
    _btnScale = [self getButton];
    _btnScale.frame = scaleButtonFrame;
    [_btnScale setTitle:@"缩放" forState:UIControlStateNormal];
    // 添加按钮点击事件
    [_btnScale addTarget:self action:@selector(scale:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnScale];
}

#pragma mark 添加移动按钮
- (void)addTranslateButton {
    CGRect translateButtonFrame = _btnScale.frame;
    translateButtonFrame.origin.y += 40;
    _btnTranslate = [self getButton];
    _btnTranslate.frame = translateButtonFrame;
    [_btnTranslate setTitle:@"移动" forState:UIControlStateNormal];
    [_btnTranslate addTarget:self action:@selector(translate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnTranslate];
    
}

#pragma mark 图片旋转方法,注意参数中的btn表示当前点击按钮
- (void)rotation:(UIButton *)btn {
    [self animation:^{ // 自己定义的动画,一般用系统的
        // 注意旋转角度必须是弧度，不是角度
        CGFloat angle = M_PI_4; // M开头的宏都是和数学（Math）相关的宏定义，M_PI_4表示四分之派，M_2_PI表示2派
        // 使用 CGAffineTransformMakeRotation 获得一个旋转角度形变, 但是需要注意 tranform 的 \
           旋转不会自动在原来的角度上进行叠加，所以下面的方法旋转一次以后再点击按钮不会旋转了
        // _imageView.transform = CGAffineTransformMakeRotation(angle);
        
        // 利用CGAffineTransformRotate在原来的基础上产生一个新的角度(当然也可以定义一个全局变量自己累加)
        _imageView.transform = CGAffineTransformRotate(_imageView.transform, angle);
        
    }];
}
#pragma mark 图片缩放方法
- (void)scale:(UIButton *)btn {
    // 通常使用 UIView 的静态方法实现动画而不是自己写一个方法
    [UIView animateWithDuration:0.5 animations:^{ // 系统动画 $$
        CGFloat scalleOffset = 0.9;
        // _imageView.transform=CGAffineTransformMakeScale(scalleOffset, scalleOffset);
        _imageView.transform = CGAffineTransformScale(_imageView.transform, scalleOffset, scalleOffset);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 图片移动方法
- (void)translate:(UIButton *)btn {
    [self animation:^{
        CGFloat translateY = 50;
        // _imageView.transform = CGAffineTransformMakeTranslation(0, translateY);
        _imageView.transform = CGAffineTransformTranslate(_imageView.transform, 0, translateY);
    }];
}
#pragma mark 动画执行方法，注意这里可以使用 UIView 的 animateWithDuration 方法代替这里只是为了演示
- (void)animation:(ButtonHandle)handle { // block 方法体作为参数,理解为基本数据类型,例如 int
    [UIView beginAnimations:@"animation" context:nil]; // 开始动画
    [UIView setAnimationDuration:0.5]; // 设置动画执行时间
    handle(); // 函数体作为参数,调用的时机是方法内部决定的
    [UIView commitAnimations]; // 执行动画操作
    
}

#pragma mark 取得一个按钮,统一按钮样式
- (UIButton *)getButton {
    UIButton *button = [[UIButton alloc] init];
    // 设置正常状态下字体颜色
    [button setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    // 设置高亮状态下的字体颜色
    [button setTitleColor:HIGHLIGHTED_COLOR forState:UIControlStateHighlighted];
    return button;
}

@end
