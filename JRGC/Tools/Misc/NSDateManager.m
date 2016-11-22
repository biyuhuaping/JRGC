//
//  NSDateManager.m
//  

#import "NSDateManager.h"

@implementation NSDateManager

+ (NSString *)getDateDesWithDate:(NSDate *)date dateFormatterStr:(NSString *)dateFormatterStr
{
    if (date && dateFormatterStr.length > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatterStr];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSDate *)getDateWithDateDes:(NSString *)dateDes dateFormatterStr:(NSString *)dateFormatterStr
{
    if (dateDes && dateFormatterStr.length > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatterStr];
        return [dateFormatter dateFromString:dateDes];
    }
    return nil;
}
+ (NSString *)getDateWithDateDes:(NSNumber *)dateDes
{
    if (nil != dateDes) {
        NSTimeInterval interval = [dateDes doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:DEFAULT_DATE_REPAYPERIOD];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}
@end
