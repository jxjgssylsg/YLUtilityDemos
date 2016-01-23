//
//  ScrollViewControllerOne.m
//  YLExperimentForOC
//
//  Created by mingdffe on 16/7/9.
//  Copyright © 2016年 yilin. All rights reserved.
//

#import "ScrollViewControllerOne.h"

@interface ScrollViewControllerOne () <UIScrollViewDelegate> {
   UIScrollView *_scrollView;
}

@end

@implementation ScrollViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建 UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, 250, 250); // frame 中的 size 是指 UIScrollView 的可视范围
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
}

#pragma mark ScrollViewDelegate Method
// 拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
   return  _scrollView.subviews[0]; // 返回需要缩放的控件
}

@end
