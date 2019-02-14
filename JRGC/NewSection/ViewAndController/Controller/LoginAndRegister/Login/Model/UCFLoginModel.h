//
//  UCFLoginModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/31.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFLoginData,UCFLoginUserinfo;

@interface UCFLoginModel : BaseModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) UCFLoginData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFLoginData : BaseModel

@property (nonatomic, strong) UCFLoginUserinfo *userInfo;

@property (nonatomic, copy) NSString *userLevel;

@end

@interface UCFLoginUserinfo : BaseModel

@property (nonatomic, assign) BOOL openStatus;

@property (nonatomic, assign) BOOL isCompanyAgent;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *headerUrl;

@property (nonatomic, assign) BOOL isSpecial;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) BOOL p2pAuthorization;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, assign) long long time;

@property (nonatomic, copy) NSString *zxOpenStatus;

@property (nonatomic, copy) NSString *jg_ckie;

@property (nonatomic, assign) NSInteger promotionCode;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *zxAuthorization;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, assign) BOOL nmAuthorization;

@end

NS_ASSUME_NONNULL_END
