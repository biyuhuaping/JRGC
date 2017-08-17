//
//  UCFCouponModel.h
//  JRGC
//
//  Created by NJW on 15/5/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFCouponModel : NSObject
@property (copy, nonatomic) NSString *flag;
@property (copy, nonatomic) NSString *investMultip;
@property (copy, nonatomic) NSString *overdueTime;
@property (copy, nonatomic) NSString *remark;           //返现券来源
@property (copy, nonatomic) NSString *useInvest;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *useTime;
@property (copy, nonatomic) NSString *inverstPeriod;
@property (copy, nonatomic) NSString *backIntrestRate;  //反息利率
@property (copy, nonatomic) NSString *couponType;       //0返现券 1返息券 2工豆 3返金券
@property (assign, nonatomic) NSInteger state;          //0未使用 1已使用 2已过期  //1：未使用 2：已使用 3：已过期 4：已赠送
@property (copy, nonatomic) id isDonateEnable;          //是否可赠送	0否 1是
@property (copy, nonatomic) id isUsed;                  //是否已使用  0可用 1过期 2使用
@property (copy, nonatomic) NSString *couponId;
@property (copy, nonatomic) NSString *sentDate;         //赠送时间
@property (copy, nonatomic) NSString *targetUserName;   //赠送人

- (id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)couponWithDict:(NSDictionary *)dict;

@end
