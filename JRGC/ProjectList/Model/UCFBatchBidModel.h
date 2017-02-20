//
//  UCFBatchBidModel.h
//  JRGC
//
//  Created by njw on 2017/2/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFBatchBidModel : NSObject
@property (nonatomic, strong) NSNumber *canBuyAmt;
@property (nonatomic, strong) NSNumber *colMinInvest;
@property (nonatomic, copy) NSString *colName;
@property (nonatomic, copy) NSString *colPeriod;
@property (nonatomic, copy) NSString *colPeriodTxt;
@property (nonatomic, strong) NSNumber *colRate;
@property (nonatomic, strong) NSNumber *colRepayMode;
@property (nonatomic, copy) NSString *colRepayModeTxt;
@property (nonatomic, assign) BOOL full;
@property (nonatomic, strong) NSNumber *batchBidId;


+ (instancetype)batchWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
