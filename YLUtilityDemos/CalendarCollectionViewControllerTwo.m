//
//  CalendarViewController.m
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import "CalendarCollectionViewControllerTwo.h"
#import "CalendarDataSource.h"
#import "HeaderViewTwo.h"

@interface CalendarCollectionViewControllerTwo ()

// @property (strong, nonatomic) IBOutlet CalendarDataSource *calendarDataSource;

@end

@implementation CalendarCollectionViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register NIB for supplementary views, cell 不需要注册是因为在 SB 加载了
    UINib *headerViewNib = [UINib nibWithNibName:@"HeaderViewTwo" bundle:nil]; // 加载 HeaderView xib
    [self.collectionView registerNib:headerViewNib forSupplementaryViewOfKind:@"DayHeaderView" withReuseIdentifier:@"HeaderViewTwo"];
    [self.collectionView registerNib:headerViewNib forSupplementaryViewOfKind:@"HourHeaderView" withReuseIdentifier:@"HeaderViewTwo"];
    
    // Define cell and header view configuration
    CalendarDataSource *dataSource = (CalendarDataSource *)self.collectionView.dataSource;
    dataSource.configureCellBlock = ^(CalendarEventCell *cell, NSIndexPath *indexPath, id<CalendarEvent> event) {
        cell.titleLabel.text = event.title;
    };
    dataSource.configureHeaderViewBlock = ^(HeaderViewTwo *headerView, NSString *kind, NSIndexPath *indexPath) {
        if ([kind isEqualToString:@"DayHeaderView"]) {
            headerView.titleLabel.text = [NSString stringWithFormat:@"Day %ld", indexPath.item + 1]; // Day 1, Day 2, Day 3 ...
        } else if ([kind isEqualToString:@"HourHeaderView"]) {
            headerView.titleLabel.text = [NSString stringWithFormat:@"%2ld:00", indexPath.item + 1]; // 1:00, 2:00
        }
    };
 }

@end
