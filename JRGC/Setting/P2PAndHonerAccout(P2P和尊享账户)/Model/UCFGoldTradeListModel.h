//
//  UCFGoldTradeListModel.h
//  JRGC
//
//  Created by 张瑞超 on 2017/7/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldTradeListModel : NSObject
@property(nonatomic, copy)NSString *frozenMoney;
@property(nonatomic, copy)NSString *purchaseAmount;
@property(nonatomic, copy)NSString *purchasePrice;
@property(nonatomic, copy)NSString *tradeMoney;
@property(nonatomic, copy)NSString *tradeRemark;
@property(nonatomic, copy)NSString *tradeTime;
@property(nonatomic, copy)NSString *tradeTypeCode;
@property(nonatomic, copy)NSString *tradeTypeName;
@property(nonatomic, copy)NSString *poundage;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
