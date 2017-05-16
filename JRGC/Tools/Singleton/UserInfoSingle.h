//
//  UserInfoSingle.h
//  JRGC
//
//  Created by 金融工场 on 16/8/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoSingle : NSObject
//用户id
@property(nonatomic, copy) NSString *userId;
//用户性别
@property(nonatomic, copy) NSString *gender;
//用户头像
@property(nonatomic, copy) NSString *headerUrl;
//用户名
@property(nonatomic, copy) NSString *loginName;
//用户手机
@property(nonatomic, copy) NSString *mobile;
//用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码 5：特殊用户
@property(nonatomic, assign) NSInteger openStatus;
//尊享账号开户状态啊
@property(nonatomic, assign) NSInteger enjoyOpenStatus;
//用户真是姓名
@property(nonatomic, copy) NSString *realName;
//用户登录时间
@property(nonatomic, assign) NSInteger time;
//html 页面免登陆cookie
@property(nonatomic, copy) NSString *jg_ckie;

@property(nonatomic, assign) BOOL companyAgent;

@property(nonatomic, assign) BOOL p2pAuthorization;
@property(nonatomic, assign) BOOL zxAuthorization;

//@property(nonatomic, copy) NSString *userLevel;
//获取用户信息单利对象
+ (UserInfoSingle *)sharedManager;
//赋值
- (void)setUserData:(NSDictionary *)dict;
//获取用户对象数据
- (void)getUserData;
//更新开户状态
- (void)updateOpenStatus:(NSInteger)openStatus;
//清除用户信息
- (void)removeUserInfo;
@end
