//
//  UCFPersonalInfoModel.h
//  JRGC
//
//  Created by NJW on 15/4/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFPersonalInfoModel : NSObject
//我的投资总条数
@property (nonatomic, strong) NSNumber  *prdOrderCount;
//银行卡
@property (nonatomic, copy) NSString    *bankCard;
//工豆是否有红点
@property (nonatomic, copy) NSString    *beanCount;
//返现券是否有红点
@property (nonatomic, copy) NSString    *beanRecordCount;
//账户余额
@property (nonatomic, copy) NSString    *cashBalance;

@property (nonatomic, copy) NSString    *couponCount;
//邀请返利是否有红点
@property (nonatomic, copy) NSString    *financialCount;
//工场码
@property (nonatomic, copy) NSString    *gcm;
//用户电话
@property (nonatomic, copy) NSString    *mobile;
//账户头像
@property (nonatomic, copy) NSString    *headurl;
//返息券是否有红点
@property (nonatomic, copy) NSString    *interestCount;
//累计收益
@property (nonatomic, copy) NSString    *interests;
//用户登录名
@property (nonatomic, copy) NSString    *loginName;
//
@property (nonatomic, copy) NSString    *principal;
//
@property (nonatomic, copy) NSString    *proxyInterest;
//红包是否有红点
@property (nonatomic, copy) NSString    *redPackageCount;
//回款是否有红点
@property (nonatomic, copy) NSString    *refundCount;
//最近一条回款时间
@property (nonatomic, copy) NSString    *repayPerDate;
//用户性别
@property (nonatomic, copy) NSString    *sex;
//用户连续签到的天数
@property (nonatomic,strong) NSNumber   *signDays;
//用户状态
@property (nonatomic, strong) NSNumber  *state;
//总资产
@property (nonatomic, copy) NSString    *total;
//消息中心是否有红点
@property (nonatomic, copy) NSString    *unReadMsgCount;
@property (nonatomic, strong) NSNumber  *userId;            //用户ID
@property (nonatomic, copy) NSString    *userName;          //用户名









//+ (instancetype)defaultPersonalInfo;
+ (instancetype)personalInfoModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
