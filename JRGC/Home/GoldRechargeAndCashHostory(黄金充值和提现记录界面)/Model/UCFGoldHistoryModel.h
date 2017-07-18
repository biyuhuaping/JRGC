//
//  UCFGoldHistoryModel.h
//  JRGC
//
//  Created by njw on 2017/7/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UCFGoldHistoryModelTypeRecharge,
    UCFGoldHistoryModelTypeCash,
} UCFGoldHistoryModelType;

@interface UCFGoldHistoryModel : NSObject
@property (copy, nonatomic) NSString *rechargeAmount;
@property (copy, nonatomic) NSString *rechargeDate;
@property (copy, nonatomic) NSString *rechargeOrderId;
@property (copy, nonatomic) NSString *statusCode;
@property (assign, nonatomic) UCFGoldHistoryModelType type;

+ (instancetype)goldHistoryModelWithDict:(NSDictionary *)dict;
@end
