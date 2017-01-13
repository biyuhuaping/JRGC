//
//  UCFTransferModel.h
//  JRGC
//
//  Created by NJW on 2016/11/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFTransferModel : NSObject
@property (nonatomic, copy) NSString *annualRate;
@property (nonatomic, copy) NSString *assigneeDay;
@property (nonatomic, copy) NSString *busType;
@property (nonatomic, copy) NSString *cantranMoney;
@property (nonatomic, copy) NSString *completeRate;
@property (nonatomic, copy) NSString *guaranteeCompany;
@property (nonatomic, copy) NSString *guaranteeCompanyName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *interestlDiscount;
@property (nonatomic, copy) NSString *investAmt;
@property (nonatomic, copy) NSString *lastDays;
@property (nonatomic, copy) NSString *lastTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nextRepaymentTime;
@property (nonatomic, copy) NSString *offsetInterestAmt;
@property (nonatomic, copy) NSString *oldPrdOrderId;
@property (nonatomic, copy) NSString *planPrincipalAmt;
@property (nonatomic, copy) NSString *prdClaimsId;
@property (nonatomic, copy) NSString *principalDiscount;
@property (nonatomic, copy) NSString *realInterestlAmt;
@property (nonatomic, copy) NSString *realPrincipalAmt;
@property (nonatomic, copy) NSString *realtranMoney;
@property (nonatomic, copy) NSString *repayMode;
@property (nonatomic, copy) NSString *repayModeText;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stopStatus;
@property (nonatomic, copy) NSString *totalDays;
@property (nonatomic, copy) NSString *tradeMark;
@property (nonatomic, copy) NSString *transfereeYearRate;
@property (nonatomic, copy) NSString *validDays;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isAnim;

+ (instancetype)transferWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
