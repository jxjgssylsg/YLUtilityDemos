//
//  RootViewController.m
//  NavigationControllerDemo
//
//  Created by liumingbo on 12-12-27.
//  Copyright (c) 2012年 com.chinahayrek. All rights reserved.
//

#import "NavRootViewControllerOne.h"
#import "NavSecondViewControllerOne.h"


@interface NavRootViewControllerOne () <UINavigationControllerDelegate>

@end

@implementation NavRootViewControllerOne

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 导航栏上添加左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
   
    // 导航栏上添加右侧按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;

    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"根视图"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    NSArray *segArray = [[NSArray alloc] initWithObjects:@"aa",@"bb", nil];
    UISegmentedControl *segControl = [[UISegmentedControl alloc]initWithItems:segArray];
    segControl.momentary = YES;
    [segControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    // 导航栏添加 segmentcontrol
    self.navigationItem.titleView = segControl;

    self.navigationItem.title = @"firstView";

    // toolbar 上加载4个按钮
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
    UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
    UIBarButtonItem *four = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // 注意这里是 self !!
    [self setToolbarItems:[NSArray arrayWithObjects:flexItem, one, flexItem, two, flexItem, three, flexItem, four, flexItem, nil]];
    
    // 当 pushViewController:navVCOne animated:YES, animation 为 YES 时,界面没出之前 nav 都为 nil
    // 显示出 toolbar, 但是无效! 因为 viewDid 加载完之前 self.navigationController 都等于 nil !! 注意.对比点击 segementControl
    [self.navigationController setToolbarHidden:NO animated:NO];

    self.navigationController.delegate = self; // 设置代理
}

- (void)segmentAction:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                            message:@"you choose aa!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
        }
            break;

            
        case 1:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                            message:@"you choose bb!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
          
            // 当 pushViewController:navVCOne animated:YES, animation 为 YES 时, 这里 self.navigationController 可以使用了,对比 viewDidLoad
             [self.navigationController setToolbarHidden:NO animated:NO];
        }
            break;

        default:
            break;
    }
    

}

- (void)selectLeftAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                    message:@"left button!!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)selectRightAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                    message:@"right button!!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

-(IBAction)goSecondView:(id)sender {
    NavSecondViewControllerOne *secondView = [[NavSecondViewControllerOne alloc] init];
    [self.navigationController pushViewController:secondView animated:YES];
    secondView.title = @"Second View";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationBarDelegate Method 代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"hahah will show");
}
@end
