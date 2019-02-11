//
//  UCFUserBenefitModel.h
//  JRGC
//
//  Created by njw on 2017/9/22.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFUserBenefitModel : NSObject
@property (nonatomic, copy) NSString *beanAmount;
@property (nonatomic, copy) NSString *couponNumber;
@property (nonatomic, copy) NSString *beanExpiring;
@property (nonatomic, copy) NSString *couponExpringNum;
@property (nonatomic, copy) NSString *hurl;
@property (nonatomic, copy) NSString *memberLever;
@property (nonatomic, copy) NSString *promotionCode;
@property (nonatomic, copy) NSString *repayPerDateNM;
@property (nonatomic, copy) NSString *repayPerDateWJ;
@property (nonatomic, copy) NSString *repayPerDateZX;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *unReadMsgCount;
@property (nonatomic, copy) NSString *userCenterTicket;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *outBoundMess;

+ (instancetype)userBenefitWithDict:(NSDictionary *)dict;
@end
