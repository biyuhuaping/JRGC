//
//  Timer.m
//  easyloan
//
//  Created by 狂战之巅 on 2017/5/18.
//  Copyright © 2017年 狂战之巅. All rights reserved.
//

#import "Timer.h"

@implementation Timer
//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    //获取系统当前时间
//    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设置格式：zzz表示时区
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
//    //NSDate转NSString
//    NSString *currentDateString = [dateFormatter stringFromDate:date];
//    //输出currentDateString
//    NSLog(@"%@",currentDateString);
//    return currentDateString;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1427472281];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    NSLog(@"time = %@",time);
    return time;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //需要转换的字符串
//    NSString *dateString = @"2015-06-26 08:08:08";
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    return date;
}

+ (void)setCountDownSaveTimePhoneNum:(NSString *)phoneNum andComeFrom:(NSString *)comeFrom
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *array = [ user objectForKey:comeFrom];
    NSMutableArray *newArray;
    if (array != nil && array.count >0) {
        //有数据则追加
        newArray= [NSMutableArray arrayWithArray:array];
    }
    else
    {
        //没有数据则新建
        newArray = [NSMutableArray array];
    }
    [newArray addObject:@{@"phone":phoneNum,@"lastTime":[Timer stringFromDate:[NSDate date]]}];
    [user setObject:[newArray copy] forKey:comeFrom];
}

+ (NSInteger)getCountDownPhoneNum:(NSString *)phoneNum andComeFrom:(NSString *)comeFrom
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *array = [ user objectForKey:comeFrom];
     NSString *dbStr;
    if (array ==nil || array.count == 0) {
        //没有数据,即倒计时从60开始算
        return 60;
    }
    else
    {
        for (NSDictionary *dic in array) {
            if ([dic[@"phone"] isEqualToString:phoneNum]) {
                dbStr = dic[@"lastTime"];
                break;
            }
        }
        if (dbStr == nil || [dbStr isEqualToString:@""]) {
            return 60;
        }
        else
        {
            NSDate *timer = [Timer dateFromString:dbStr];
            NSTimeInterval time = [timer timeIntervalSinceDate:[NSDate date]];
            NSInteger newTime = (NSInteger)time +60;
            
            if (newTime < 60 && newTime > 0) {
                
                return newTime;
            }
            else
            {
                [user setObject:nil forKey:comeFrom];
                return 60;
            }
        }
    }
}
@end
