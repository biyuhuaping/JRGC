//
//  UserInfoSingle.h
//  JRGC
//
//  Created by 金融工场 on 16/8/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFLoginModel.h"
typedef void(^requestUserAllStatueCallBackBlock)(BOOL);
@interface UserInfoSingle : NSObject <NetworkModuleDelegate>





//SingleUserInfo.loginData.userInfo

@property (nonatomic, assign) BOOL webCloseUpdatePrePage;

@property (nonatomic ,strong) UCFLoginData *loginData;

@property(nonatomic, assign) BOOL   isSubmitTime;//是否审核期间

@property(nonatomic, assign) BOOL   isShowCouple;//是否可见优惠券

@property(nonatomic, assign) BOOL superviseSwitch; //监管开关

@property(nonatomic, copy) NSString *signatureStr;//验签串

@property(nonatomic, copy) NSString *wapSingature;

@property(nonatomic, copy) NSString *bankNumTip;

@property(nonatomic, assign) NSInteger wrangGCodeNumber;  //输错手势密码的次数;


@property (nonatomic,strong) requestUserAllStatueCallBackBlock requestUserbackBlock;
////用户id
//@property(nonatomic, copy) NSString *userId;
////用户性别
//@property(nonatomic, copy) NSString *gender;
////用户头像
//@property(nonatomic, copy) NSString *headerUrl;
////用户名
//@property(nonatomic, copy) NSString *loginName;
////用户手机
//@property(nonatomic, copy) NSString *mobile;
////用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码  
//@property(nonatomic, assign) NSInteger openStatus;
////尊享账号开户状态啊
//@property(nonatomic, assign) NSInteger enjoyOpenStatus;
////用户真是姓名
//@property(nonatomic, copy) NSString *realName;
////用户登录时间
//@property(nonatomic, assign) NSInteger time;
////html 页面免登陆cookie
//@property(nonatomic, copy) NSString *jg_ckie;
////工场码
//@property(nonatomic, copy) NSString *gcm_code;
//
//@property(nonatomic, assign) BOOL companyAgent;
//
//@property(nonatomic, assign) BOOL p2pAuthorization;
//@property(nonatomic, assign) BOOL zxAuthorization;
//@property(nonatomic, assign) BOOL goldAuthorization;//黄金授权标识
//@property(nonatomic, assign) BOOL isSpecial;//是否是特殊用户
//
//@property(nonatomic, assign) BOOL isAutoBid;    //是否自动投标
//#warning about supervise
//@property(nonatomic, assign) BOOL superviseSwitch; //监管开关
//@property(nonatomic, assign) BOOL goldIsNew; //是否黄金新手
//@property(nonatomic, assign) BOOL zxIsNew; //是否尊享新手
//@property(nonatomic, assign) int level; //用户的等级
//
//@property(nonatomic, assign) BOOL goldIsShow;
//@property(nonatomic, assign) BOOL zxIsShow;
//@property(nonatomic, assign) BOOL wjIsShow;
//@property(nonatomic, assign) BOOL transferIsShow;
//
//
//@property(nonatomic, assign) BOOL   isSubmitTime;

//@property(nonatomic, copy)NSString *bankNumTip;
////@property(nonatomic, copy) NSString *userLevel;
////获取用户信息单利对象
//+ (UserInfoSingle *)sharedManager;
////赋值
//- (void)setUserData:(NSDictionary *)dict;
////获取用户对象数据
//- (void)getUserData;
////更新开户状态
//- (void)updateOpenStatus:(NSInteger)openStatus;
////清除用户信息
//- (void)removeUserInfo;
#warning check userinfo on supervise
- (void)checkUserLevelOnSupervise;

- (void)requestUserAllStatueWithView:(UIView *)view;
//获取用户信息单利对象
+ (UserInfoSingle *)sharedManager;
#pragma mark - 同盾
+ (NSString *) didReceiveDeviceBlackBox;

- (void)setUserData:(UCFLoginData *)loginData withPassWord:(NSString *)passWord;
- (void)setUserData:(UCFLoginData *) loginData;
- (void)deleteUserData;
- (UCFLoginData *)getUserData;

- (void)loadLoginViewController;

//保存上次登录名字
- (void)saveLoginAccount:(NSDictionary *)account;

- (NSDictionary *)getLoginAccount;
- (NSString *)getlastLoginName;

- (void)removeIsShare;
- (void)saveIsShare:(NSDictionary *)dic;

/**
 重置用户状态
 */
//- (void)updataCurrentUserStatue;
@end
