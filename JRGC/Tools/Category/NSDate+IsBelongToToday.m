//
//  NSDate+IsBelongToToday.m
//  JRGC
//
//  Created by NJW on 15/7/24.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "NSDate+IsBelongToToday.h"

@implementation NSDate (IsBelongToToday)

+ (BOOL)isBelongToTodayWithDate:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSDateComponents *compt = [calendar components:NSDayCalendarUnit fromDate:date];
    NSDateComponents *lastCompt = [greCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDateComponents *currentCompt = [greCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    if (lastCompt.year == currentCompt.year && lastCompt.month == currentCompt.month && lastCompt.day == currentCompt.day) {
        return YES;
    }
    else return NO;
    
//    DLog(@"%f %f", lastLoginS, currentLoginS);
    return YES;
}

@end
