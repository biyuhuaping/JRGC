//
//  UCFGoldIncreTransListModel.h
//  JRGC
//
//  Created by njw on 2017/8/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldIncreTransListModel : NSObject
@property (nonatomic, copy) NSString *dealGoldPrice;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderStatusCode;
@property (nonatomic, copy) NSString *orderStatusName;
@property (nonatomic, copy) NSString *orderTypeCode;
@property (nonatomic, copy) NSString *orderTypeName;
@property (nonatomic, copy) NSString *tradeAmount;
@property (nonatomic, copy) NSString *tradeMoney;
@property (nonatomic, copy) NSString *tradeTime;
@property (nonatomic, strong) NSArray *nmContractModelList;

+ (instancetype)goldIncreseListContractModelWithDict:(NSDictionary *)dict;
@end
