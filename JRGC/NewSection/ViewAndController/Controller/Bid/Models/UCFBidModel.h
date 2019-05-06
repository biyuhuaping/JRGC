//
//Created by ESJsonFormatForMac on 18/12/14.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@class BidDataModel,PrdclaimModel,ContractModel;
@interface UCFBidModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) BidDataModel *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface BidDataModel : BaseModel

@property (nonatomic, strong) NSArray *contractMsg;

@property (nonatomic, assign) NSInteger limitAmount;

@property (nonatomic, copy) NSString *couponNum;

@property (nonatomic, strong) PrdclaimModel *prdClaim;

@property (nonatomic, assign) double calcRate;

@property (nonatomic, assign) double accountAmount;

@property (nonatomic, copy) NSString *cashNum;

@property (nonatomic, assign) BOOL isExistRecomder;

@property (nonatomic, copy) NSString *openStatus;

@property (nonatomic, assign) NSInteger calcTerm;

@property (nonatomic, copy) NSString *limitAmountMess;

@property (nonatomic, copy) NSString *cfcaContractName;

@property (nonatomic, assign) NSInteger beanWillOverAmount;

@property (nonatomic, assign) BOOL bankNumEq;

@property (nonatomic, copy) NSString *occupyRate;

@property (nonatomic, assign) BOOL isCompanyAgent;

@property (nonatomic, copy) NSString *calcType;

@property (nonatomic, copy) NSString *cfcaContractUrl;

@property (nonatomic, copy) NSString *apptzticket;

@property (nonatomic, assign) BOOL isLimit;

@property (nonatomic, assign) BOOL isSpecial;

@property (nonatomic, assign) NSInteger beanAmount;

@end

@interface PrdclaimModel : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) CGFloat completeLoan;

@property (nonatomic, copy) NSString *annualRate;

@property (nonatomic, assign) NSInteger repayMode;

@property (nonatomic, assign) NSInteger isTransfer;

@property (nonatomic, copy) NSString *holdTime;

@property (nonatomic, copy) NSString *repayPeriod;

@property (nonatomic, copy) NSString *platformSubsidyExpense;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *maxInvest;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *repayModeText;

@property (nonatomic, copy) NSString *minInvestTxt;

@property (nonatomic, copy) NSString *guaranteeCompanyName;

@property (nonatomic, assign) CGFloat borrowAmount;

@property (nonatomic, strong) NSArray *prdLabelsList;

@property (nonatomic, copy) NSString *repayPeriodtext;

@property (nonatomic, copy) NSString *fixedDate;

@property (nonatomic, copy) NSString *prdName;

@property (nonatomic, assign) NSInteger minInvest;

@property (nonatomic, copy) NSString *repayPeriodDay;

@property (nonatomic, copy) NSString *riskLevelDes;

@end

@interface ContractModel : BaseModel

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *contractName;

@property (nonatomic, copy) NSString *contractType;

@property (nonatomic, copy) NSString *contractUrl;
@end

