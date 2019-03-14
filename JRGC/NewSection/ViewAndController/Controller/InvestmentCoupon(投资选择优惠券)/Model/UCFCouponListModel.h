//
//  UCFCouponListModel.h
//  JRGC
//
//  Created by zrc on 2019/3/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFCouponListDataModel,UCFCouponPagedataModel,UCFcouponListPagination,UCFCouponListResult;
@interface UCFCouponListModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFCouponListDataModel *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFCouponListDataModel : BaseModel

@property (nonatomic, strong) UCFCouponPagedataModel *pageData;

@property (nonatomic, copy) NSString *moneySum;

@property (nonatomic, copy) NSString *unUserFxCount;

@property (nonatomic, copy) NSString *presentFriendExist;

@end

@interface UCFCouponPagedataModel : BaseModel

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) UCFcouponListPagination *pagination;

@end

@interface UCFcouponListPagination : BaseModel

@property (nonatomic, copy) NSString *hasPrePage;

@property (nonatomic, copy) NSString *hasNextPage;

@property (nonatomic, copy) NSString *totalPage;

@property (nonatomic, copy) NSString *pageNo;

@end

@interface UCFCouponListResult : BaseModel

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString *targetUserName;

@property (nonatomic, copy) NSString *backIntrestRate;

@property (nonatomic, copy) NSString *issue_time;

@property (nonatomic, copy) NSString *isUsed;

@property (nonatomic, copy) NSString *useTime;

@property (nonatomic, copy) NSString *overdueTime;

@property (nonatomic, copy) NSString *isDonateEnable;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *useInvest;

@property (nonatomic, copy) NSString *sentDate;

@property (nonatomic, copy) NSString *investMultip;

@property (nonatomic, copy) NSString *inverstPeriod;

@property (nonatomic, assign)NSInteger couponType;

@end

NS_ASSUME_NONNULL_END
