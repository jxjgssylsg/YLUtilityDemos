//
//  ScrollViewControllerOne.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/7/9.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "TimerTestViewController.h"
#import "NSTimer+Blocks.h"
#import "NSTimer+BFEExtension.h"

@interface TimerTestViewController () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    NSTimer *_timer;        // 采用系统的方法
    NSTimer *_timerTwo;     // 采用分类的 NSTimer+Blocks 方法
    NSTimer *_timerThree;   // 采用分类的 NSTimer+BFEExtension 方法
}

@end

@implementation TimerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建 UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, 350, 350); // frame 中的 size 是指 UIScrollView 的可视范围
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    // 2.创建 UIImageView（图片）
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"bigPicture.jpeg"];
    CGFloat imgW = imageView.image.size.width; // 图片的宽度
    CGFloat imgH = imageView.image.size.height; // 图片的高度
    imageView.frame = CGRectMake(0, 0, imgW, imgH);
    [scrollView addSubview:imageView];
    
    // 3.设置 scrollView 的属性
    scrollView.contentSize = imageView.image.size;  // 设置 UIScrollView 的滚动范围（内容大小）
    
    // 隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    // 用来记录 scrollview 滚动的位置
    // scrollView.contentOffset = ;
    
    scrollView.bounces = NO; // 去掉弹簧效果
    // 增加额外的滚动区域（逆时针，上、左、下、右） top left bottom right
    scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20); // 注. 原点没有发生改变
    _scrollView = scrollView;
    _scrollView.delegate = self;
    
    // 放大缩小比例
    _scrollView.maximumZoomScale = 3.0f;
    _scrollView.minimumZoomScale = 0.5f;
    
    __weak TimerTestViewController *weakSelf = self;
    // TimerTestViewController *_strongOrWeak = weakSelf; // _strongOrWeak 是强引用! 要加上 __weak 才是弱引用
    
    // NStimer 系统方法, 注意这里有循环引用, 即使这里使用了 weakSelf, 就如 id tmp = weakSelf, 这里 tmp 也是对 self 的强引用
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(Timer:) userInfo:nil repeats:YES];
    
    // 修改 NSTimer 的 runloop, 如果不加的话,在 UI 操作时(例如滑动), 定时操作方法便不会执行
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode]; // UITrackingRunLoopMode, NSDefaultRunLoopMode, NSRunLoopCommonModes
    /* 或者
     *[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // 模式集合,相当于绑定了集合内的每一个模式
     */
    
 // ------------------------------ 分类 Timer NSTimer+Blocks ------------------------------------ //
    
    _timerTwo = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        [weakSelf TimerExtension];  // 这里可以且必须 weakSelf, 否则循环引用. 可以试试改成 self
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerTwo forMode:NSRunLoopCommonModes]; // 加入 runloopMode
    
// ------------------------------ 分类 Timer NSTimer+Blocks ------------------------------------ //
    
    _timerThree = [NSTimer scheduledTimerWithTimeInterval:1 count:10 callback:^{
        [weakSelf TimerExtensionTwo];
    }];
    
}

- (void)Timer: (NSTimer *)timer {
    NSLog(@" hahahha "); //
}

- (void)TimerExtension {
    NSLog(@" hahahha  NSTimer+Blocks  "); //
}

- (void)TimerExtensionTwo {
    NSLog(@" hahahha  NSTimer+BFEExtension "); //
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"disappear");
    [_timer invalidate]; // 移除了对 taget 的强引用,将计时器从 runloop 中移除了
     _timer = nil;
    
    [_timerTwo invalidate];
    _timerTwo = nil;
    
    [_timerThree invalid]; // NSTimer+BFEExtension 内方法
}

- (void)dealloc {
    NSLog(@"delloc"); // 测试 viewController 的释放
}

#pragma mark ScrollViewDelegate Method

// 拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // NSLog(@"scrollViewDidScroll");
}

// 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
}

// 停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
    // _scrollView.contentOffset = CGPointMake(0, 0); // 可以测试原点
}

// 加速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDecelerating");
}

// 停止加速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scrollViewShouldScrollToTop");
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScrollToTop");
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return  _scrollView.subviews[0]; // 返回需要缩放的控件
}

@end
