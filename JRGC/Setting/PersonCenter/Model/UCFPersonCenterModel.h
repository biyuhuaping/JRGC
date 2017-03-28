//
//  UCFPersonCenterModel.h
//  JRGC
//
//  Created by njw on 2017/3/28.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFPersonCenterModel : NSObject
@property (copy, nonatomic) NSString *beanAmount;
@property (strong, nonatomic) NSString *couponNumber;
@property (copy, nonatomic) NSString *enjoyAmount;
@property (copy, nonatomic) NSString *enjoyOpenStatus;
@property (copy, nonatomic) NSString *enjoyRepayPerDate;
@property (copy, nonatomic) NSString *gcm;
@property (copy, nonatomic) NSString *headurl;
@property (assign, nonatomic) NSString *isCompanyAgent;
@property (copy, nonatomic) NSString *loginName;
@property (strong, nonatomic) NSString *memberLever;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *p2pAmount;
@property (copy, nonatomic) NSString *p2pOpenStatus;
@property (copy, nonatomic) NSString *p2pRepayPerDate;
@property (strong, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *unReadMsgCount;
@property (copy, nonatomic) NSString *userCenterTicket;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *userName;

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)personCenterWithDict:(NSDictionary *)dict;
@end
