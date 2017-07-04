//
//  UCFCalendarGroup.h
//  JRGC
//
//  Created by njw on 2017/7/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFCalendarGroup : NSObject
@property (strong, nonatomic) NSNumber *count;
@property (copy, nonatomic) NSString *interest;
@property (copy, nonatomic) NSString *isAdvance;
@property (copy, nonatomic) NSString *prepaymentPenalty;
@property (copy, nonatomic) NSString *principal;
@property (copy, nonatomic) NSString *proName;
@property (copy, nonatomic) NSString *repayPerDate;
@property (strong, nonatomic) NSNumber *repayPerNo;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *totalMoney;

/**
 *  数组中装的都是Funds模型
 */
@property (nonatomic, strong) NSArray *datalist;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
