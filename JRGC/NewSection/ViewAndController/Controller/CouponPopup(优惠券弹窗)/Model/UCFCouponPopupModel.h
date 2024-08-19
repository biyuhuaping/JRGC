//
//  UCFCouponPopupModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/13.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFCouponPopupData,UCFCouponPopupCouponlist;
NS_ASSUME_NONNULL_BEGIN

@interface UCFCouponPopupModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UCFCouponPopupData *data;

@property (nonatomic, assign) BOOL ret;

@property (nonatomic, assign) NSInteger ver;

@end
@interface UCFCouponPopupData : BaseModel

@property (nonatomic, strong) NSArray *couponList;

@property (nonatomic, copy) NSString *type;

@end

@interface UCFCouponPopupCouponlist : BaseModel

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

@end



NS_ASSUME_NONNULL_END
