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
@end
