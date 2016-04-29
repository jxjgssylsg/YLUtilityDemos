//
//  HomeViewController.m
//  NavigationAndTabbar
//
//  Created by Muhamad Rifki on 8/27/13.
//  Copyright (c) 2013 Rifkilabs. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    /*UITableView *HometableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 470.0f) style:UITableViewStylePlain];
    HometableView.dataSource = self;
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Action Title"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"One",@"Two",@"Three",@"Four",@"Five",@"One",@"Two",@"Three",@"Four",@"Five",@"One",@"Two",@"Three",@"Four",@"Five",
                                  nil];
    [actionsheet showInView:self.view];

    /*UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 100.0f, 50.0f)];
    [label setText:@"My Home"];
    //UIColor *color = [UIColor co]
    [label setBackgroundColor:[UIColor blueColor]];

    [self.view addSubview:HometableView];
    [HometableView addSubview: label];*/
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
   // NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = @"object";
    return cell;
}*/

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
