//
//  Timer.h
//  easyloan
//
//  Created by 狂战之巅 on 2017/5/18.
//  Copyright © 2017年 狂战之巅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

//保存和获取验证码倒计时时间
+ (void)setCountDownSaveTimePhoneNum:(NSString *)phoneNum andComeFrom:(NSString *)comeFrom;
+ (NSInteger)getCountDownPhoneNum:(NSString *)phoneNum andComeFrom:(NSString *)comeFrom;
@end
