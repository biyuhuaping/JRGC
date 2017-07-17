//
//  UCFUserInfoModel.h
//  JRGC
//
//  Created by njw on 2017/5/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFUserInfoModel : NSObject
@property (nonatomic, copy) NSString *cashBalance;
@property (nonatomic, copy) NSString *interests;
@property (nonatomic, copy) NSString *p2pCashBalance;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *zxCashBalance;
@property (nonatomic, assign) BOOL isCompanyAgent;
@property (nonatomic, copy) NSString *openStatus;
@property (nonatomic, copy) NSString *tipsDes;
@property (nonatomic, copy) NSString *zxOpenStatus;

@property (nonatomic, copy) NSString *beanAmount;
@property (nonatomic, strong) NSNumber *couponNumber;
@property (nonatomic, copy) NSString *hurl;
@property (nonatomic, copy) NSString *memberLever;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, strong) NSNumber *unReadMsgCount;
@property (nonatomic, copy) NSString *userCenterTicket;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *holdGoldAmount;

+ (instancetype)userInfomationWithDict:(NSDictionary *)dict;
@end
