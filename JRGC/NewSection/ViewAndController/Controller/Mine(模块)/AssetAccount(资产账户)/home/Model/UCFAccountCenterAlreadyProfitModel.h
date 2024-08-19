//
//  UCFAccountCenterAlreadyProfitModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFAccountCenterAlreadyProfitData;

@interface UCFAccountCenterAlreadyProfitModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFAccountCenterAlreadyProfitData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFAccountCenterAlreadyProfitData : BaseModel

@property (nonatomic, copy) NSString *beanProfit;//工豆收益

@property (nonatomic, copy) NSString *goldProfit;//黄金收益

@property (nonatomic, copy) NSString *wjProfit;//微金收益

@property (nonatomic, copy) NSString *couponProfit;//返现券收益

@property (nonatomic, copy) NSString *totalProfit;//总收益

@property (nonatomic, copy) NSString *balanceProfit; //余额收益

@property (nonatomic, copy) NSString *zxProfit;//尊享收益

@end

NS_ASSUME_NONNULL_END
