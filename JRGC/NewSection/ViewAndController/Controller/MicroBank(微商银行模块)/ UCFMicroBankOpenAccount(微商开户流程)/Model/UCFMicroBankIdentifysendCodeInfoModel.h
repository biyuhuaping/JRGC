//
//  UCFMicroBankIdentifysendCodeInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class
UCFMicroBankIdentifysendCodeInfoData;
NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankIdentifysendCodeInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankIdentifysendCodeInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end

@interface UCFMicroBankIdentifysendCodeInfoData : BaseModel

@property (nonatomic, assign) BOOL isInFiveNum;

@property (nonatomic, copy) NSString *smsSerialNo;

@property (nonatomic, copy) NSString *rechargeToken;

@end
NS_ASSUME_NONNULL_END
