//
//  UCFGoldRechargeHistoryModel.h
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldRechargeHistoryModel : NSObject
@property (copy, nonatomic) NSString *rechargeAmount;
@property (copy, nonatomic) NSString *rechargeDate;
@property (copy, nonatomic) NSString *rechargeMonth;
@property (copy, nonatomic) NSString *rechargeOrderId;
@property (copy, nonatomic) NSString *statusCode;

+ (instancetype)goldRechargeHistoryModelWithDict:(NSDictionary *)dict;
@end
