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
////用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码 5：特殊用户
@property(nonatomic, assign) NSInteger  openStatus;

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

@property (nonatomic, copy) NSString *promotionCode;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *zxAuthorization;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, assign) BOOL nmAuthorization;

@property(nonatomic, assign) BOOL isRisk;       //是否风险评估

@property(nonatomic, assign) BOOL isAutoBid;    //是否自动投标

@property(nonatomic, assign) BOOL goldAuthorization;//黄金授权标识

@property(nonatomic, assign) BOOL goldIsNew; //是否黄金新手

@property(nonatomic, assign) BOOL zxIsNew; //是否尊享新手

@property(nonatomic, assign)BOOL goldIsShow;

@property(nonatomic, assign)BOOL transferIsShow;

@property(nonatomic, assign)BOOL wjIsShow;

@property(nonatomic, assign)BOOL zxIsShow;
@end

NS_ASSUME_NONNULL_END
