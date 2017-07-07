//
//  UCFCalendarCollectionViewCell.m
//  TestCalenar
//
//  Created by njw on 2017/7/2.
//  Copyright © 2017年 njw. All rights reserved.
//

#import "UCFCalendarCollectionViewCell.h"
#import "FSCalendar.h"
#import "DIYCalendarCell.h"
#import "UCFCalendarDayInfo.h"

@interface UCFCalendarCollectionViewCell () <FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (weak, nonatomic) UILabel *eventLabel;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;
@end

@implementation UCFCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0,  0, self.bounds.size.width, self.bounds.size.height)];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.scrollEnabled = NO;
        calendar.swipeToChooseGesture.enabled = NO;
        calendar.allowsMultipleSelection = YES;
//        calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
        [self addSubview:calendar];
        self.calendar = calendar;
        
        calendar.calendarHeaderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        calendar.calendarWeekdayView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        calendar.headerHeight = 44;
        calendar.weekdayHeight = 30;
        calendar.appearance.eventSelectionColor = [UIColor whiteColor];
        calendar.appearance.eventOffset = CGPointMake(0, -7);
        calendar.appearance.weekdayTextColor = UIColorWithRGB(0x333333);
        calendar.appearance.weekdayFont = [UIFont systemFontOfSize:12];
        calendar.today = nil; // Hide the today circle
        [calendar registerClass:[DIYCalendarCell class] forCellReuseIdentifier:@"cell"];
        
        self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        [self.calendar selectDate:[NSDate date] scrollToDate:NO];
    }
    return self;
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2012-01-01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2020-12-31"];
//    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:5 toDate:[NSDate date] options:0];
}

//- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
//{
//    if ([self.gregorian isDateInToday:date]) {
//        return @"今";
//    }
//    return nil;
//}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar withSections:(NSInteger)sections
{
    NSLog(@"calendar : %@, sections : %ld", calendar, (long)sections);
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    if (self.days > 0) {
        NSString *dateStr = [self.dateFormatter stringFromDate:date];
        for (UCFCalendarDayInfo *day in self.days) {
            if ([dateStr isEqualToString:day.paidTime]) {
                switch ([day.isAdvanceRepay intValue]) {
                    case 0:
                    case 1:
                        return 1;
                        break;
                        
                    case 2:
                        return 2;
                        break;
                }
            }
        }
    }
    return 0;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    
    self.eventLabel.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.frame.size.width, 50);
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    if ([self.delegate respondsToSelector:@selector(calendar:didClickedDay:)]) {
        [self.delegate calendar:self didClickedDay:[self.dateFormatter stringFromDate:date]];
    }
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    //
    if (self.days > 0) {
        NSString *dateStr = [self.dateFormatter stringFromDate:date];
        for (UCFCalendarDayInfo *day in self.days) {
            if ([dateStr isEqualToString:day.paidTime]) {
                switch ([day.isAdvanceRepay intValue]) {
                    case 0:
                        return @[UIColorWithRGB(0xfd4d4c)];
                        break;
                    case 1:
                        return @[UIColorWithRGB(0x7c9dc7)];
                        break;
                        
                    case 2:
                        return @[UIColorWithRGB(0x7c9dc7), UIColorWithRGB(0xfd4d4c)];
                        break;
                }
            }
        }
    }
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    DIYCalendarCell *diyCell = (DIYCalendarCell *)cell;
    
    // Custom today circle
    diyCell.circleImageView.hidden = ![self.gregorian isDateInToday:date];
    
    // Configure selection layer
    if (monthPosition == FSCalendarMonthPositionCurrent) {
        
        SelectionType selectionType = SelectionTypeNone;
        if ([self.calendar.selectedDates containsObject:date]) {
            NSDate *previousDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
            NSDate *nextDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
            if ([self.calendar.selectedDates containsObject:date]) {
                if ([self.calendar.selectedDates containsObject:previousDate] && [self.calendar.selectedDates containsObject:nextDate]) {
                    selectionType = SelectionTypeMiddle;
                } else if ([self.calendar.selectedDates containsObject:previousDate] && [self.calendar.selectedDates containsObject:date]) {
                    selectionType = SelectionTypeRightBorder;
                } else if ([self.calendar.selectedDates containsObject:nextDate]) {
                    selectionType = SelectionTypeLeftBorder;
                } else {
                    selectionType = SelectionTypeSingle;
                }
            }
        } else {
            selectionType = SelectionTypeNone;
        }
        
        if (selectionType == SelectionTypeNone) {
            diyCell.selectionLayer.hidden = YES;
            return;
        }
        
        diyCell.selectionLayer.hidden = NO;
        diyCell.selectionType = selectionType;
        
    } else {
        
        diyCell.circleImageView.hidden = YES;
        diyCell.selectionLayer.hidden = YES;
    }
}

- (void)setMonth:(NSString *)month
{
    _month = month;
    [self.calendar setCurrentPage:[self.dateFormatter dateFromString:[month stringByAppendingString:@"-01"]] animated:NO];
}

- (void)setDays:(NSMutableArray *)days
{
    _days = days;
    [_calendar reloadData];
}

@end
