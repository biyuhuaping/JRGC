//
//  UCFBidDetailModel.h
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

//@interface UCFBidDetailModel : BaseModel
//
//@end



@class BidDetailData,DetailSafetysecuritylist,DetailPrdlabelslist;
@interface UCFBidDetailModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) BidDetailData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface BidDetailData : NSObject

@property (nonatomic, assign) NSInteger minInvest;

@property (nonatomic, copy) NSString *repayPeriodtext;

@property (nonatomic, copy) NSString *remainAmount;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *minInvestTxt;

@property (nonatomic, assign) double borrowAmount;

@property (nonatomic, assign) double maxInvest;

@property (nonatomic, copy) NSString *platformSubsidyExpense;

@property (nonatomic, assign) NSInteger intervalMilli;

@property (nonatomic, copy) NSString *prdDesType;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *guaranteeCompany;

@property (nonatomic, copy) NSString *busType;

@property (nonatomic, copy) NSString *tradeMark;

@property (nonatomic, copy) NSString *invitationSite;

@property (nonatomic, copy) NSString *fixedDate;

@property (nonatomic, copy) NSString *repayPeriod;

@property (nonatomic, copy) NSString *holdTime;

@property (nonatomic, assign) NSInteger completeLoan;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger repayMode;

@property (nonatomic, assign) NSInteger isOrder;

@property (nonatomic, strong) NSArray *prdLabelsList;

@property (nonatomic, copy) NSString *annualRate;

@property (nonatomic, copy) NSString *prdName;

@property (nonatomic, copy) NSString *guaranteeCompanyName;

@property (nonatomic, copy) NSString *stopStatus;

@property (nonatomic, copy) NSString *isFirstbid;

@property (nonatomic, copy) NSString *repayModeText;

@property (nonatomic, copy) NSString *totleBookAmt;

@property (nonatomic, assign) NSInteger isTransfer;

@property (nonatomic, strong) NSArray *safetySecurityList;

@property (nonatomic, copy) NSString *appointPeriod;

@end

@interface DetailSafetysecuritylist : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@end

@interface DetailPrdlabelslist : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *labelPriority;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *labelPrompt;

@end


NS_ASSUME_NONNULL_END
