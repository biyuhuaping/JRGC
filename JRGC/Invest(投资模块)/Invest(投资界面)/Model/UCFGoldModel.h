//
//  UCFGoldModel.h
//  JRGC
//
//  Created by njw on 2017/7/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldModel : NSObject
@property (copy, nonatomic) NSString *annualRate;
@property (copy, nonatomic) NSString *minPurchaseAmount;
@property (copy, nonatomic) NSString *nmPrdClaimId;
@property (copy, nonatomic) NSString *nmPrdClaimName;
@property (copy, nonatomic) NSString *nmTypeName;
@property (copy, nonatomic) NSString *paymentType;
@property (copy, nonatomic) NSString *periodTerm;
@property (copy, nonatomic) NSString *isFirstbid;
@property (copy, nonatomic) NSArray *prdLabelsList;
@property (copy, nonatomic) NSString *holdTime;
@property (copy, nonatomic) NSString *remainAmount;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *totalAmount;
@property (copy, nonatomic) NSString *nmTypeId;
@property (copy, nonatomic) NSString *buyServiceRate;//买入手续费率
@property (copy, nonatomic) NSString *pauseInfo;//暂停信息
@property (copy, nonatomic) NSString *nmPurchaseToken;
@property (copy, nonatomic) NSString *cashServiceRate;//变现手续费率
@property (copy, nonatomic) NSString *goldServiceRate;//提金手续费率
+ (instancetype)goldModelWithDict:(NSDictionary *)dict;
@end
