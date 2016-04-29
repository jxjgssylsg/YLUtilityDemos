//
//  AboutViewController.m
//  NavigationAndTabbar
//
//  Created by Muhamad Rifki on 8/27/13.
//  Copyright (c) 2013 Rifkilabs. All rights reserved.
//

#import "AboutViewController.h"
#import "SettingViewController.h"

typedef NS_ENUM(NSInteger, Test) {
    TestA = 1,      // 1   1   1
    TestB = 1 << 1, // 2   2   10      转换成 10进制  2
    TestC = 1 << 2, // 4   3   100     转换成 10进制  4
    TestD = 1 << 3, // 8   4   1000    转换成 10进制  8
    TestE = 1 << 4  // 16  5   10000   转换成 10进制  16
};

@interface AboutViewController () {
    UIButton *_subtractBtn;
    SettingViewController *_strongOrWeak; // 强应用! 要加上 __weak 才是弱引用
    NSTimer *_timer;
}

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *passWord = [user objectForKey:@"userPassWord"];
    NSLog(@" haha ");
    
    NSString *passWordOne = @"1234567";
    [user setObject:passWordOne forKey:@"userPassWord"];
    
    Test justTry = TestA | TestB;
    justTry = TestA & TestB;
    NSLog(@"%ld",justTry);
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    // add a button
    _subtractBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _subtractBtn.frame = CGRectMake(47, 124, 30, 30);
    _subtractBtn.backgroundColor = [UIColor darkGrayColor];
    _subtractBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    [_subtractBtn setTitle:@"-" forState:UIControlStateNormal];
    [_subtractBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_subtractBtn addTarget:self action:@selector(subtractBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_subtractBtn];
    
    UISegmentedControl *segMent=[[UISegmentedControl alloc] initWithFrame:CGRectMake(70.0f, 5.0f, 180.0f, 34.0f) ];
    [segMent insertSegmentWithTitle:@"tem1" atIndex:0 animated:YES];
    [segMent insertSegmentWithTitle:@"tem2" atIndex:1 animated:YES];
    [segMent insertSegmentWithTitle:@"tem3" atIndex:2 animated:YES];
    segMent.segmentedControlStyle = UISegmentedControlStyleBar;
    segMent.momentary = NO;  // 设置在点击后是否恢复原样
    segMent.multipleTouchEnabled=NO;  // 可触摸
    segMent.selectedSegmentIndex =0;   // 指定索引
    // segmentedControl.tintColor = [UIColor blackColor];
    // segmentedControl.tintColor = [UIColor colorWithRed:224/255 green:225/255 blue:226/255 alpha:1];
    segMent.tintColor =[UIColor grayColor];
  
    [segMent addTarget:self action:@selector(segMentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segMent;
    // self.navigationItem.titleView = nil;
    self.navigationItem.title = @"syl 1"; //
    self.title = @"syl"; // 上两个都能设置, 可以换位置试试
    
    UIButton *testView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    testView.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:testView];
    [testView addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    
//    testView addTarget:<#(nullable id)#> action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
    
//    self.navigationItem.rightBarButtonItem  tag
//    addtarget:self action:@selector(clickSure:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)segMentClick:(UISegmentedControl *)segmentControl {
    NSLog(@"%ld",segmentControl.selectedSegmentIndex);
}
- (void)subtractBtnPressed:(UIButton *)button {
    SettingViewController *tmp = [[SettingViewController alloc] init];
    tmp.view.frame = CGRectMake(50, 50, 200, 200);
    tmp.view.backgroundColor = [UIColor lightTextColor];
    [self.navigationController pushViewController:tmp animated:YES];
    __weak SettingViewController *weakSelf = tmp;
    // _strongOrWeak = weakSelf; // 强应用! 要加上 __weak 才是弱引用
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(Timer:) userInfo:nil repeats:YES]; // 这里 Timer 对weakSelf 依旧是强应用, 具体原因如上一行

   // self.navigationItem.title = @"wakaka";
}


- (void)clickSure:(UIButton *)button {
    UIViewController *tmp = [[UIViewController alloc] init];
    tmp.view.frame = CGRectMake(50, 50, 200, 200);
    tmp.view.backgroundColor = [UIColor darkGrayColor];
    [self.navigationController pushViewController:tmp animated:YES];
    // self.navigationItem.title = @"wakaka";
    
    // invaild the timer
    // [_timer invalidate];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
