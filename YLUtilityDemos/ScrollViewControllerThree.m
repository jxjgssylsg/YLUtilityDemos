//
//  ScrollViewControllerThree.m
//  ScrollViewControllerThree
//
//  Created by Mr_db on 16/4/17.
//  Copyright (c) 2016年 Mr_db. All rights reserved.
//

#import "ScrollViewControllerThree.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IMAGEVIEW_COUNT 3

@interface ScrollViewControllerThree () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    UIPageControl *_pageControl; // 页码小点
    UILabel *_label;
    NSMutableDictionary *_imageData; // 图片数据
    int _currentImageIndex; // 当前图片索引
    int _imageCount; // 图片总数

}
@end

@implementation ScrollViewControllerThree

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadImageData]; // 加载数据
    [self addScrollView]; // 添加滚动控件
    [self addImageViews]; // 添加图片控件
    [self addPageControl]; // 添加分页控件
    [self addLabel]; // 添加图片信息描述控件
    [self setDefaultImage];// 加载默认图片
}

#pragma mark 加载图片数据
- (void)loadImageData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"imageInfo" ofType:@"plist"];
    _imageData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    _imageCount = (int)_imageData.count;
}

#pragma mark 添加控件
- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(IMAGEVIEW_COUNT * SCREEN_WIDTH, SCREEN_HEIGHT); // contentSize
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    _scrollView.pagingEnabled = YES; // YES, 滑动时自动滚动到 subview 的边界
    _scrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark 添加图片三个控件
- (void)addImageViews {
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _leftImageView.contentMode = UIViewContentModeCenter; // UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    
    _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _centerImageView.contentMode = UIViewContentModeCenter; // UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _rightImageView.contentMode = UIViewContentModeCenter; // UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
}

#pragma mark 设置默认显示图片
- (void)setDefaultImage {
    // 加载默认图片
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", 6]];
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", 1]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", 2]];
    _currentImageIndex = 1;
    
    // 设置当分页
    _pageControl.currentPage = _currentImageIndex - 1;
    NSString *imageName = [NSString stringWithFormat:@"%i.png", _currentImageIndex];
    _label.text = _imageData[imageName];
   // _label.backgroundColor = [UIColor grayColor];
}


#pragma mark 添加分页控件
- (void)addPageControl {
    _pageControl = [[UIPageControl alloc] init];
    CGSize size = [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 100);
    
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193 / 255.0f green:219 / 255.0 blue:249 / 255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 / 255.0f green:219 / 255.0 blue:1 alpha:1];
    _pageControl.numberOfPages = _imageCount;
    
    [self.view addSubview:_pageControl];
}

#pragma mark 添加信息描述控件
- (void)addLabel {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor colorWithRed:0 green:150 / 255.0 blue:1 alpha:1];
    
    [self.view addSubview:_label];
}

#pragma mark 重新加载图片
- (void)reloadImage {
    int leftImageIndex,rightImageIndex;
    CGPoint offset = [_scrollView contentOffset];
    if (offset.x > SCREEN_WIDTH) { // 向右滑动
        _currentImageIndex = _currentImageIndex % _imageCount + 1;
    } else if(offset.x < SCREEN_WIDTH) { //向左滑动
        _currentImageIndex = (_currentImageIndex + _imageCount) % _imageCount - 1;
        if (_currentImageIndex <= 0) {
            _currentImageIndex += _imageCount;
        }
    }
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", _currentImageIndex]];
    _centerImageView.contentMode = UIViewContentModeCenter;
    _centerImageView.backgroundColor = [UIColor lightGrayColor];

    leftImageIndex = (_currentImageIndex + _imageCount - 1) % _imageCount;
    rightImageIndex = (_currentImageIndex + 1) % _imageCount;
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", leftImageIndex]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", rightImageIndex]];
}

#pragma mark 滚动停止事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    _pageControl.currentPage = _currentImageIndex - 1;
    NSString *imageName = [NSString stringWithFormat:@"%i.png",_currentImageIndex];
    _label.text = _imageData[imageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
