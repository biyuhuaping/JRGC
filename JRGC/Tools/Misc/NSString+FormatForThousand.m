//
//  NSString+FormatForThousand.m
//  JRGC
//
//  Created by NJW on 15/5/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "NSString+FormatForThousand.h"

@implementation NSString (FormatForThousand)

//千位分隔符
+ (NSString *)getKilobitDecollator:(double)floatVel withUnit:(NSString *)unit{
    BOOL isNagtive = NO;
    if (floatVel < 0) {
        floatVel = fabs(floatVel);
        isNagtive = YES;
    }
    double charge = round(floatVel * 100)/100;//四舍五入保留两位小数
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:charge]];
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@", numberString];
    if (isNagtive) {
        [string insertString:@"-" atIndex:1];
    }
    NSRange range = [string rangeOfString:@"$"];
    if (range.location != NSNotFound) {
        [string replaceCharactersInRange:range withString:@"¥"];
    }
    NSRange range1 = [string rangeOfString:@"￥"];
    if (range1.location != NSNotFound) {
        [string replaceCharactersInRange:range1 withString:@"¥ "];
    }
    //[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
    //[string stringByReplacingOccurrencesOfString:@" " withString:@""]
    return string;
}

@end
