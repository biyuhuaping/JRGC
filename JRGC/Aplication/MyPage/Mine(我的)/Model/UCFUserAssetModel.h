//
//  UCFUserAssetModel.h
//  JRGC
//
//  Created by njw on 2017/9/22.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFUserAssetModel : NSObject
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *p2pInterests;
@property (nonatomic, copy) NSString *cashTotal;
@property (nonatomic, copy) NSString *interests;
@property (nonatomic, copy) NSString *nmInterests;
@property (nonatomic, copy) NSString *tipsDes;
@property (nonatomic, copy) NSString *nmCashBalance;
@property (nonatomic, copy) NSString *goldMarketAmount;
@property (nonatomic, copy) NSString *p2pCashBalance;
@property (nonatomic, copy) NSString *holdGoldAmount;
@property (nonatomic, copy) NSString *zxCashBalance;
@property (nonatomic, copy) NSString *allGiveGoldAmount;
@property (nonatomic, copy) NSString *cashBalance;
@property (nonatomic, copy) NSString *zxInterests;
@property (nonatomic, copy) NSString *historyInterests;
+ (instancetype)userAssetWithDict:(NSDictionary *)dict;
@end
