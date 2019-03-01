//
//  UCFMicroBankUserAccountInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFMicroBankUserAccountInfoData;

@interface UCFMicroBankUserAccountInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankUserAccountInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end

@interface UCFMicroBankUserAccountInfoData : BaseModel

@property (nonatomic, copy) NSString *total;

@property (nonatomic, copy) NSString *batchMaximum;

@property (nonatomic, copy) NSString *hasCoupon;

@property (nonatomic, copy) NSString *noticeTxt;

@property (nonatomic, copy) NSString *bankCardNum;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *repayPerDate;

@property (nonatomic, copy) NSString *riskLevel;

@property (nonatomic, copy) NSString *isRisk;

@property (nonatomic, copy) NSString *cashBalance;

@property (nonatomic, copy) NSString *interests;

@property (nonatomic, copy) NSString *openState;

@property (nonatomic, assign) NSInteger otherNum;

@property (nonatomic, copy) NSString *prdOrderCount;

@end

NS_ASSUME_NONNULL_END
