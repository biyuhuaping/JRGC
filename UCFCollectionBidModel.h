//
//  UCFCollectionBidModel.h
//  JRGC
//
//  Created by njw on 2017/2/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFCollectionBidModel : NSObject
@property (nonatomic, strong) NSNumber *canBuyAmt;
@property (nonatomic, strong) NSNumber *canBuyCount;
@property (nonatomic, strong) NSNumber *colMinInvest;
@property (nonatomic, copy) NSString *colName;
@property (nonatomic, copy) NSString *colPeriod;
@property (nonatomic, copy) NSString *colPeriodTxt;
@property (nonatomic, copy) NSString *colRate;
@property (nonatomic, strong) NSNumber *colRepayMode;
@property (nonatomic, copy) NSString *colRepayModeTxt;
@property (nonatomic, assign) BOOL full;
@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSNumber *totalAmt;


+ (instancetype)collectionBidWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
