//
//  UCFGoldLimitedBankModel.h
//  JRGC
//
//  Created by njw on 2017/8/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldLimitedBankModel : NSObject
@property (nonatomic, copy) NSString *bankDayLimit;
@property (nonatomic, copy) NSString *bankLogoUrl;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankOneLimt;

+ (UCFGoldLimitedBankModel *)getGoldLimitedBankModelByDataDict:(NSDictionary *)dataDict;
@end
