//
//  UCFTransBidInfoModel.h
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFTransPrdtransferfore,UCFTransPrdclaimsreveal,UCFTransSafetysecuritylist,UCFTransUserothermsg,UCFTransPrdguaranteemess,UCFTransOrderuser,UCFTransContractmsg,UCFTransPrdlabelslist;
@interface UCFTransBidInfoModel : BaseModel

@property (nonatomic, copy) NSString *prdDesType;

@property (nonatomic, copy) NSString *openStatus;

@property (nonatomic, strong) NSArray *originalList;

@property (nonatomic, strong) UCFTransPrdtransferfore *prdTransferFore;

@property (nonatomic, strong) UCFTransPrdclaimsreveal *prdClaimsReveal;

@property (nonatomic, strong) UCFTransUserothermsg *userOtherMsg;

@property (nonatomic, copy) NSString *isCompanyAgent;

@property (nonatomic, strong) UCFTransPrdguaranteemess *prdGuaranteeMess;

@property (nonatomic, strong) NSArray *prdOrders;

@property (nonatomic, strong) UCFTransOrderuser *orderUser;

@property (nonatomic, assign) NSInteger intervalMilli;

@property (nonatomic, strong) NSArray *contractMsg;

@property (nonatomic, strong) NSArray *prdLabelsList;

@property (nonatomic, copy) NSString *serverTime;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *stopStatus;

@property (nonatomic, copy) NSString *statusdes;
@end
@interface UCFTransPrdtransferfore : BaseModel

@property (nonatomic, copy) NSString *holdTime;

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

@interface UCFTransPrdclaimsreveal : BaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *originalInfo;

@property (nonatomic, copy) NSString *originalLend;

@property (nonatomic, copy) NSString *lineContractName;

@property (nonatomic, copy) NSString *transferorInfo;

@property (nonatomic, copy) NSString *originalContractNo;

@property (nonatomic, copy) NSString *safetySecurity;

@property (nonatomic, copy) NSString *lineContractNo;

@property (nonatomic, strong) NSArray *safetySecurityList;

@property (nonatomic, copy) NSString *prdClaimsId;

@property (nonatomic, copy) NSString *originalTotal;

@property (nonatomic, copy) NSString *originalContractName;

@property (nonatomic, copy) NSString *originalBorrower;

@end

@interface UCFTransSafetysecuritylist : BaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@end

@interface UCFTransUserothermsg : BaseModel

@property (nonatomic, copy) NSString *age;

@end

@interface UCFTransPrdguaranteemess : BaseModel

@property (nonatomic, copy) NSString *insShortName;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *post;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *contacts;

@property (nonatomic, copy) NSString *insName;

@property (nonatomic, copy) NSString *legalRealName;

@property (nonatomic, copy) NSString *guaranteeType;

@property (nonatomic, copy) NSString *licenseNumber;

@end

@interface UCFTransOrderuser : BaseModel

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *ncityId;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *ncityName;

@property (nonatomic, copy) NSString *haschild;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *jprovinceId;

@property (nonatomic, copy) NSString *nprovinceName;

@property (nonatomic, copy) NSString *workemail;

@property (nonatomic, copy) NSString *idno;

@property (nonatomic, copy) NSString *hashouse;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *byear;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *officedomain;

@property (nonatomic, copy) NSString *office;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *bday;

@property (nonatomic, copy) NSString *graduation;

@property (nonatomic, copy) NSString *graduatedyear;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *university;

@property (nonatomic, copy) NSString *houseloan;

@property (nonatomic, copy) NSString *nprovinceId;

@property (nonatomic, copy) NSString *jcityId;

@property (nonatomic, copy) NSString *bmonth;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *carloan;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *officecale;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *hascar;

@property (nonatomic, copy) NSString *officetype;

@property (nonatomic, copy) NSString *hcityName;

@property (nonatomic, copy) NSString *promotioncode;

@property (nonatomic, copy) NSString *referreruserid;

@property (nonatomic, copy) NSString *joboauth;

@property (nonatomic, copy) NSString *agencyCode;

@property (nonatomic, copy) NSString *jobtype;

@property (nonatomic, copy) NSString *creditAuth;

@property (nonatomic, copy) NSString *officeaddress;

@property (nonatomic, copy) NSString *mechanism;

@property (nonatomic, copy) NSString *hprovinceName;

@property (nonatomic, copy) NSString *workyears;

@property (nonatomic, copy) NSString *marriage;

@end

@interface UCFTransContractmsg : BaseModel

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *contractName;

@property (nonatomic, copy) NSString *contractType;

@end

@interface UCFTransPrdlabelslist : BaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *labelPriority;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *labelPrompt;

@end



NS_ASSUME_NONNULL_END
