//
//  DWTabBarController.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "DWTabBarController.h"

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "AboutViewController.h"
#import "FavoriteViewController.h"

#import "DWTabBar.h"

#define DWColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0] // <<< 用10进制表示颜色，例如（255,255,255）黑色
#define DWRandomColor DWColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@implementation DWTabBarController

#pragma mark -
#pragma mark - Life Cycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setUpChildViewController];
    
    // 处理 tabBar，使用自定义 tabBar 添加 发布按钮
    [self setUpTabBar];
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    
    // 去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // 设置导航控制器颜色为黄色
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:DWColor(253, 218, 68)] forBarMetrics:UIBarMetricsDefault];

}

#pragma mark -
#pragma mark - Private Methods

/**
 *  利用 KVC 把 系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar {
    [self setValue:[[DWTabBar alloc] init] forKey:@"tabBar"];
}


/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes {
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateHighlighted];
    
}


/**
 *  添加子控制器，我这里值添加了4个，没有占位自控制器
 */
- (void)setUpChildViewController {
    [self addOneChildViewController:[[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]]
                          WithTitle:@"首页"
                          imageName:@"1"
                  selectedImageName:@"1"];
    
    [self addOneChildViewController:[[UINavigationController alloc]initWithRootViewController:[[FavoriteViewController alloc] init]]
                          WithTitle:@"同城"
                          imageName:@"2"
                  selectedImageName:@"2"];
    
    
    [self addOneChildViewController:[[UINavigationController alloc]initWithRootViewController:[[SearchViewController alloc]init]]
                          WithTitle:@"消息"
                          imageName:@"3"
                  selectedImageName:@"3"];
    
    
    [self addOneChildViewController:[[UINavigationController alloc]initWithRootViewController:[[AboutViewController alloc]init]]
                          WithTitle:@"我的"
                          imageName:@"4"
                  selectedImageName:@"4"];
    
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param imageName         图片
 *  @param selectedImageName 选中图片
 */

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    viewController.view.backgroundColor = DWRandomColor;
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 注意 Rendering Mode, 如果不设置图片可能不出来, 只显示背景色
    UIImage *image = [UIImage imageNamed:selectedImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 可换: UIImageRenderingModeAlwaysTemplate 看看效果, 忽略图片,根据背景绘制
    viewController.tabBarItem.selectedImage = image;
    [self addChildViewController:viewController];
    
}


// 这个方法可以抽取到 UIImage 的分类中
- (UIImage *)imageWithColor:(UIColor *)color {
    NSParameterAssert(color != nil); // 系统断言
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
