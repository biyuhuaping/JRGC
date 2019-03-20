//
//  UCFMineGetWithdrawInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFMineGetWithdrawInfoData,UCFMineGetWithdrawInfoBankinfo;
@interface UCFMineGetWithdrawInfoModel : BaseModel
@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;
@end

@interface UCFMineGetWithdrawInfoData : BaseModel

@property (nonatomic, assign) BOOL isAuthPayment;

@property (nonatomic, copy) NSString *realWithdrawMess;

@property (nonatomic, copy) NSString *paymentDeadline;

@property (nonatomic, copy) NSString *userStatus;

@property (nonatomic, assign) NSInteger criticalValue;

@property (nonatomic, copy) NSString *bankBranchName;

@property (nonatomic, copy) NSString *minAmt;

@property (nonatomic, assign) BOOL userIsNew;

@property (nonatomic, copy) NSString *workingDay;

@property (nonatomic, strong) UCFMineGetWithdrawInfoBankinfo *bankInfo;

@property (nonatomic, assign) NSInteger accountAmount;

@property (nonatomic, assign) BOOL afterPaymentDeadline;

@property (nonatomic, copy) NSString *customerServiceNo;

@property (nonatomic, assign) BOOL isHoliday;

@property (nonatomic, assign) NSInteger perDayRealTimeAmountLimit;

@property (nonatomic, copy) NSString *doTime;

@property (nonatomic, copy) NSString *withdrawToken;

@property (nonatomic, copy) NSString *lianhangNo;

@property (nonatomic, copy) NSString *fee;

@property (nonatomic, copy) NSString *perDayCountLimit;

@property (nonatomic, assign) BOOL isFeeEnable;

@property (nonatomic, copy) NSString *perDayAmountLimit;

@end

@interface UCFMineGetWithdrawInfoBankinfo : BaseModel

@property (nonatomic, copy) NSString *bankNo;

@property (nonatomic, copy) NSString *bankCardNo;

@property (nonatomic, copy) NSString *bankLogo;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, assign) BOOL supportQPass;

@property (nonatomic, copy) NSString *phoneNo;

@property (nonatomic, assign) BOOL isBindBankBranch;

@end

NS_ASSUME_NONNULL_END
