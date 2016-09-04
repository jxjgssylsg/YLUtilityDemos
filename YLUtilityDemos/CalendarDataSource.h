//
//  CalendarDataSource.h
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"
#import "CalendarEventCell.h"
#import "HeaderViewTwo.h"

typedef void (^ConfigureCellBlock)(CalendarEventCell *cell, NSIndexPath *indexPath, id<CalendarEvent> event);  // cell block
typedef void (^ConfigureHeaderViewBlock)(HeaderViewTwo *headerView, NSString *kind, NSIndexPath *indexPath); // headerView block

@interface CalendarDataSource : NSObject <UICollectionViewDataSource> // DataSource 单独隔离出来

@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;
@property (copy, nonatomic) ConfigureHeaderViewBlock configureHeaderViewBlock;

- (id<CalendarEvent>)eventAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex maxDayIndex:(NSInteger)maxDayIndex minStartHour:(NSInteger)minStartHour maxStartHour:(NSInteger)maxStartHour;

@end
