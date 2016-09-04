//
//  WeekCalendarLayout.m
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import "WeekCalendarLayout.h"
#import "CalendarDataSource.h"

static const NSUInteger DaysPerWeek = 7;
static const NSUInteger HoursPerDay = 24;
static const CGFloat HorizontalSpacing = 10;
static const CGFloat HeightPerHour = 50;
static const CGFloat DayHeaderHeight = 40;
static const CGFloat HourHeaderWidth = 100;

@interface WeekCalendarLayout ()

@end

@implementation WeekCalendarLayout

#pragma mark - UICollectionViewLayout Implementation 重写的方法

- (CGSize)collectionViewContentSize {
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;

    // Scroll vertically to display a full day
    CGFloat contentHeight = DayHeaderHeight + (HeightPerHour * HoursPerDay);
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect { // Rect 中所有元素的布局信息
    NSMutableArray *layoutAttributes = [NSMutableArray array];

    // Cells, 获得可见 Rect 区域的所有 cells 的 indexpaths
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect]; // indexPathsOfItemsInRect 自己实现的
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        // 获得 indexPath 相应的 cell 相关属性
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }

    // Supplementary views: DayHeaderView 视图和 HourHeaderView 视图
    NSArray *dayHeaderViewIndexPaths = [self indexPathsOfDayHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in dayHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"DayHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    NSArray *hourHeaderViewIndexPaths = [self indexPathsOfHourHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in hourHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"HourHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath { // cells 相关的所有信息
    CalendarDataSource *dataSource = self.collectionView.dataSource; // 获得 collectionView 的 dataSource
    id<CalendarEvent> event = [dataSource eventAtIndexPath:indexPath]; // 获得相应的 cell 上的 CalendarEvent 事件
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath]; // 相当于初始化了一个在 indexpath 的 Item Cell, 且返回了 cell 的 attributes
    attributes.frame = [self frameForEvent:event]; // 设置对应 cell 的 frame
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath { // SupplementaryView 所有信息
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath]; // 相当于初始化了一个在 indexpath 的 SupplementaryView, 且返回了 attributes
    
    CGFloat totalWidth = [self collectionViewContentSize].width; //
    if ([kind isEqualToString:@"DayHeaderView"]) {
        CGFloat availableWidth = totalWidth - HourHeaderWidth;
        CGFloat widthPerDay = availableWidth / DaysPerWeek;
        attributes.frame = CGRectMake(HourHeaderWidth + (widthPerDay * indexPath.item), 0, widthPerDay, DayHeaderHeight); // Day 0, Day 1 ....
        attributes.zIndex = -10;
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerHour * indexPath.item, totalWidth, HeightPerHour);
        attributes.zIndex = -10;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Helpers 辅助函数

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect {
    NSInteger minVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    NSLog(@"rect: %@, days: %ld-%ld, hours: %ld-%ld", NSStringFromCGRect(rect), (long)minVisibleDay, (long)maxVisibleDay, (long)minVisibleHour, (long)maxVisibleHour);
    
    CalendarDataSource *dataSource = self.collectionView.dataSource; // 获得 collectionView   的 dataSource
    NSArray *indexPaths = [dataSource indexPathsOfEventsBetweenMinDayIndex:minVisibleDay maxDayIndex:maxVisibleDay minStartHour:minVisibleHour maxStartHour:maxVisibleHour];
    return indexPaths;
}

- (NSInteger)dayIndexFromXCoordinate:(CGFloat)xPosition {
    CGFloat contentWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = contentWidth / DaysPerWeek;
    NSInteger dayIndex = MAX((NSInteger)0, (NSInteger)((xPosition - HourHeaderWidth) / widthPerDay));
    return dayIndex;
}

- (NSInteger)hourIndexFromYCoordinate:(CGFloat)yPosition {
    NSInteger hourIndex = MAX((NSInteger)0, (NSInteger)((yPosition - DayHeaderHeight) / HeightPerHour));
    return hourIndex;
}

- (NSArray *)indexPathsOfDayHeaderViewsInRect:(CGRect)rect { // 获得 HeaderViews 数目和 indexPaths
    if (CGRectGetMinY(rect) > DayHeaderHeight) {
        return [NSArray array];
    }
    
    NSInteger minDayIndex = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxDayIndex = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minDayIndex; idx <= maxDayIndex; idx++) { // 可见范围内的 Day 所有的indexPaths
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (NSArray *)indexPathsOfHourHeaderViewsInRect:(CGRect)rect {
    if (CGRectGetMinX(rect) > HourHeaderWidth) {
        return [NSArray array];
    }
    
    NSInteger minHourIndex = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxHourIndex = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minHourIndex; idx <= maxHourIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (CGRect)frameForEvent:(id<CalendarEvent>)event {
    CGFloat totalWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = totalWidth / DaysPerWeek;

    CGRect frame = CGRectZero;
    frame.origin.x = HourHeaderWidth + widthPerDay * event.day;
    frame.origin.y = DayHeaderHeight + HeightPerHour * event.startHour;
    frame.size.width = widthPerDay;
    frame.size.height = event.durationInHours * HeightPerHour; // height = durationInHours * HeightPerHour
    
    frame = CGRectInset(frame, HorizontalSpacing / 2.0, 0);
    return frame;
    // return CGRectMake(0, 0, 100, 100);
}

@end
