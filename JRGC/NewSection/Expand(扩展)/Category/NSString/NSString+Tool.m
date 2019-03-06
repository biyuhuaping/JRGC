//
//  NSString+Tool.m
//  JRGC
//
//  Created by zrc on 2019/1/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

//给字符串添加逗号
+ (NSString *)AddComma:(NSString *)string{
    
    if(string.length == 0) {
        return nil;
    }
    NSRange range = [string rangeOfString:@"."];
    
    NSMutableString *temp = [NSMutableString stringWithString:string];
    int i;
    if (range.length > 0) {
        //有.
        i = (int)range.location;
    }
    else {
        i = (int)string.length;
    }
    
    while ((i-=3) > 0) {
        
        [temp insertString:@"," atIndex:i];
    }
    
    return temp;
}
//银行卡每隔4位加空格
+ (NSString *)dealWithString:(NSString *)number
{
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < number.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    NSLog(@"%@", doneTitle);
    return doneTitle;
}
//把字符串替换成星号
+ (NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght
{
    NSString *newStr = originalStr;
    for (int i = 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}

+ (NSString *)bankIdSeparate:(NSString *)originalString
{
    NSString *newString = @"";
    while (originalString.length > 0) {
        NSString *subString = [originalString substringToIndex:MIN(originalString.length,4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        originalString = [originalString substringFromIndex:MIN(originalString.length,4)];
    }
    return newString;
}
@end
