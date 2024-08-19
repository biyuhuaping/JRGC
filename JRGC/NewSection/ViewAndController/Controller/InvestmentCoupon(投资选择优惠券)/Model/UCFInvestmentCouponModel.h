//
//  UCFInvestmentCouponModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@class InvestmentCouponData,InvestmentCouponCouponlist;
@interface UCFInvestmentCouponModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) InvestmentCouponData *data;

@property (nonatomic, assign) BOOL ret;

@property (nonatomic, assign) NSInteger ver;

@end
@interface InvestmentCouponData : BaseModel

@property (nonatomic, strong) NSArray *couponList;

@end

@interface InvestmentCouponCouponlist : BaseModel

@property (nonatomic, assign) NSInteger couponId;

@property (nonatomic, copy) NSString *sendTime;

@property (nonatomic, assign) BOOL isCanUse;

@property (nonatomic, copy) NSString *overdueTime;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *couponStatus;

@property (nonatomic, copy) NSString *couponType;

@property (nonatomic, assign) NSInteger investMultip;

@property (nonatomic, copy) NSString *overdueFlag;

@property (nonatomic, copy) NSString *couponAmount;

@property (nonatomic, assign) NSInteger inverstPeriod;

@property (nonatomic, assign) BOOL isCheck;//是否勾选

@end

NS_ASSUME_NONNULL_END
