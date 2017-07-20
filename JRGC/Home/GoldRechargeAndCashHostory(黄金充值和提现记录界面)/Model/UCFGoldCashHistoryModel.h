//
//  UCFGoldCashHistoryModel.h
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldCashHistoryModel : NSObject
@property (copy, nonatomic) NSString *statusCode;
@property (copy, nonatomic) NSString *statusName;
@property (copy, nonatomic) NSString *withdrawAmount;
@property (copy, nonatomic) NSString *withdrawDate;
@property (copy, nonatomic) NSString *withdrawMode;
@property (copy, nonatomic) NSString *withdrawOrderId;
@property (copy, nonatomic) NSString *rechargeMonth;

+ (instancetype)goldCashHistoryModelWithDict:(NSDictionary *)dict;
@end
