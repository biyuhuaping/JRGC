//
//  NSString+Tool.h
//  JRGC
//
//  Created by zrc on 2019/1/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Tool)
//给字符串添加逗号
+ (NSString *)AddComma:(NSString *)string;

//银行卡每隔4位加空格
+ (NSString *)dealWithString:(NSString *)number;
@end

NS_ASSUME_NONNULL_END
