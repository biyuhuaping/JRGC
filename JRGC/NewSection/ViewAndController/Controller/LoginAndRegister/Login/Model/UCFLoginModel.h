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

@property (nonatomic, assign) NSInteger ver;

@end

@interface UCFLoginData : BaseModel

@property (nonatomic, strong) UCFLoginUserinfo *userInfo;

@property (nonatomic, copy) NSString *userLevel;

@property (nonatomic, copy) NSString *imei;

@end

@interface UCFLoginUserinfo : BaseModel

//@property(nonatomic, assign) NSInteger  openStatus;//用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码  
@property (nonatomic, copy) NSString *openStatus;//用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码  

@property (nonatomic, assign) BOOL isCompanyAgent;//是否是机构

@property (nonatomic, copy) NSString *loginName; //登录名

@property (nonatomic, copy) NSString *headerUrl;//头像地址

@property (nonatomic, assign) BOOL isSpecial;//是否特殊用户

@property (nonatomic, copy) NSString *mobile;//手机号

@property (nonatomic, assign) BOOL p2pAuthorization;//P2P是否授权 true 已经授权    boolean

@property (nonatomic, copy) NSString *realName;//真实姓名

@property (nonatomic, assign) long long time; //客户端登录时间戳

@property (nonatomic, copy) NSString *zxOpenStatus;//zxOpenStatus    尊享开户状态    string    1：未开户 2：已开户 3：已绑卡 4：已设交易密

@property (nonatomic, copy) NSString *jg_ckie;//免登陆cookie

@property (nonatomic, copy) NSString *promotionCode;//工场码

@property (nonatomic, copy) NSString *userId; //用户ID

//@property (nonatomic, copy) NSString *zxAuthorization;//尊享是否授权 true 已经授权    object
@property (nonatomic, assign) BOOL zxAuthorization;//尊享是否授权 true 已经授权

@property (nonatomic, copy) NSString *gender;//性别

@property (nonatomic, copy) NSString *checkId;

@property (nonatomic, assign) BOOL nmAuthorization; //黄金账户是否已经授权（新）    boolean    true：是；false:否

@property(nonatomic, assign) BOOL isRisk;       //是否风险评估

@property(nonatomic, assign) BOOL isAutoBid;    //是否自动投标

@property(nonatomic, assign) BOOL goldAuthorization;//黄金授权标识

@property(nonatomic, assign) BOOL goldIsNew; //是否黄金新手

@property(nonatomic, assign) BOOL zxIsNew; //是否尊享新手

@property(nonatomic, assign)BOOL goldIsShow; //是否展示黄金

@property(nonatomic, assign)BOOL transferIsShow;

@property(nonatomic, assign)BOOL wjIsShow;

@property(nonatomic, assign)BOOL zxIsShow;

/**
 是否新手
 */
@property(nonatomic, assign)BOOL isNewUser;
@end

NS_ASSUME_NONNULL_END
