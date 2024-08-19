//
//  UCFMicroBankOpenAccountOpenAccountIntoBankInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFMicroBankOpenAccountOpenAccountIntoBankInfoData,UCFMicroBankOpenAccountOpenAccountIntoBankInfoTradereq;

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountOpenAccountIntoBankInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankOpenAccountOpenAccountIntoBankInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end

@interface UCFMicroBankOpenAccountOpenAccountIntoBankInfoData : BaseModel

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) UCFMicroBankOpenAccountOpenAccountIntoBankInfoTradereq *tradeReq;

@end

@interface UCFMicroBankOpenAccountOpenAccountIntoBankInfoTradereq : BaseModel

@property (nonatomic, copy) NSString *SIGN;

@property (nonatomic, copy) NSString *PARAMS;

@end

NS_ASSUME_NONNULL_END
