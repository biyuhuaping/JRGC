//
//  UCFMyInvestBatchBidModel.h
//  JRGC
//
//  Created by njw on 2017/2/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFMyInvestBatchBidModel : NSObject
@property (nonatomic, strong) NSNumber *colId;
@property (nonatomic, strong) NSNumber *collMaxSize;
@property (nonatomic, copy) NSString *collName;
@property (nonatomic, copy) NSString *collPeriod;
@property (nonatomic, strong) NSNumber *collRate;
@property (nonatomic, strong) NSNumber *collRepayMode;
@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSNumber *investSuccessNumber;
@property (nonatomic, strong) NSNumber *investSuccessTotal;
@property (nonatomic, strong) NSNumber *investTime;
@property (nonatomic, strong) NSNumber *minInvest;
@property (nonatomic, copy) NSString *orderIdList;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSNumber *userId;

+ (instancetype)investBatchListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
