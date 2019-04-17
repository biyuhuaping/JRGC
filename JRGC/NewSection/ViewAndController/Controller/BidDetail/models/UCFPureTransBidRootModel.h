//
//  UCFPureTransBidRootModel.h
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFTransPureDataModel,UCFTransPureContractmsg,UCFTransPurePrdlabelslist;
@interface UCFPureTransBidRootModel : BaseModel

@property (nonatomic, copy) NSString *stopStatus;

@property (nonatomic, copy) NSString *openStatus;

@property (nonatomic, copy) NSString *beancount;

@property (nonatomic, assign) BOOL isCompanyAgent;

@property (nonatomic, copy) NSString *cfcaContractUrl;

@property (nonatomic, assign) BOOL isSpecial;

@property (nonatomic, assign) BOOL bankNumEq;

@property (nonatomic, copy) NSString *apptzticket;

@property (nonatomic, strong) UCFTransPureDataModel *data;

@property (nonatomic, assign) NSInteger intervalMilli;

@property (nonatomic, strong) NSArray *contractMsg;

@property (nonatomic, strong) NSArray *prdLabelsList;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *cfcaContractName;

@property (nonatomic, copy) NSString *statusdes;

@end
@interface UCFTransPureDataModel : BaseModel

@property (nonatomic, copy) NSString *beanBalance;

@property (nonatomic, copy) NSString *repayPeriodtext;

@property (nonatomic, copy) NSString *realPrincipalAmt;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *lastDays;

@property (nonatomic, copy) NSString *completeRate;

@property (nonatomic, copy) NSString *loanDate;

@property (nonatomic, copy) NSString *principalDiscount;

@property (nonatomic, copy) NSString *totalDays;

@property (nonatomic, copy) NSString *guaranteeCoverageNane;

@property (nonatomic, copy) NSString *applyUname;

@property (nonatomic, copy) NSString *borrowRemark;

@property (nonatomic, copy) NSString *guaranteeCompany;

@property (nonatomic, copy) NSString *busType;

@property (nonatomic, copy) NSString *tradeMark;

@property (nonatomic, copy) NSString *lastInterestlAmt;

@property (nonatomic, copy) NSString *validDays;

@property (nonatomic, copy) NSString *prdClaimsId;

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, copy) NSString *assigneeDay;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *transfereeYearRate;

@property (nonatomic, copy) NSString *repayPeriod;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *transferFeeRate;

@property (nonatomic, copy) NSString *createdBy;

@property (nonatomic, copy) NSString *realInterestlAmt;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *cantranMoney;

@property (nonatomic, copy) NSString *putawaytime;

@property (nonatomic, copy) NSString *planPrincipalAmt;

@property (nonatomic, copy) NSString *investAmt;

@property (nonatomic, copy) NSString *repayMode;

@property (nonatomic, copy) NSString *annualRate;

@property (nonatomic, copy) NSString *prdName;

@property (nonatomic, copy) NSString *guaranteeCompanyName;

@property (nonatomic, copy) NSString *originalPrdOrderId;

@property (nonatomic, copy) NSString *lastTime;

@property (nonatomic, assign) long long soldOutTime;

@property (nonatomic, copy) NSString *stopStatus;

@property (nonatomic, copy) NSString *nextRepaymentTime;

@property (nonatomic, copy) NSString *repayPeriodDay;

@property (nonatomic, copy) NSString *repayModeText;

@property (nonatomic, copy) NSString *offsetInterestAmt;

@property (nonatomic, copy) NSString *realtranMoney;

@property (nonatomic, assign) CGFloat discountRate;

@property (nonatomic, copy) NSString *oldPrdOrderId;

@property (nonatomic, copy) NSString *borrowName;

@property (nonatomic, copy) NSString *interestlDiscount;

@property (nonatomic, copy) NSString *lastPrincipalAmt;

@property (nonatomic, copy) NSString *actBalance;

@end

@interface UCFTransPureContractmsg : BaseModel

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *contractName;

@property (nonatomic, copy) NSString *contractType;

@end

@interface UCFTransPurePrdlabelslist : BaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *labelPriority;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *labelPrompt;

@end



NS_ASSUME_NONNULL_END
