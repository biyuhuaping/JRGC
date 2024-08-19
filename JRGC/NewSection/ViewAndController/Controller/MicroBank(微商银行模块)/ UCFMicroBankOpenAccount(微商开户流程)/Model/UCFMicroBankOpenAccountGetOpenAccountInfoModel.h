//
//  UCFMicroBankOpenAccountGetOpenAccountInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class 
UCFMicroBankOpenAccountGetOpenAccountInfoData,UCFMicroBankOpenAccountGetOpenAccountInfoUserinfo;
@interface UCFMicroBankOpenAccountGetOpenAccountInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankOpenAccountGetOpenAccountInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMicroBankOpenAccountGetOpenAccountInfoData : BaseModel

@property (nonatomic, copy) NSString *cfcaContractName;

@property (nonatomic, copy) NSString *openStatus;

@property (nonatomic, copy) NSString *openStatusDes;

@property (nonatomic, copy) NSString *cfcaContractUrl;

@property (nonatomic, strong) UCFMicroBankOpenAccountGetOpenAccountInfoUserinfo *userInfo;

@end

@interface UCFMicroBankOpenAccountGetOpenAccountInfoUserinfo : BaseModel

@property (nonatomic, copy) NSString *bankCard;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, assign) BOOL isCompanyAgent;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, assign) BOOL isSpecial;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *bankLogo;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, copy) NSString *bankzone;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *notSupportDes;

@property (nonatomic, copy) NSString *bankId;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *idCardNo;

@end
NS_ASSUME_NONNULL_END
