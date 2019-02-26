//
//  UCFNewHomeListModel.h
//  JRGC
//
//  Created by zrc on 2019/2/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFNewHomeDataModel,UCFNewHomeGroupModel,UCFNewHomeListPrdlist;
@interface UCFNewHomeListModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFNewHomeDataModel *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFNewHomeDataModel : BaseModel

@property (nonatomic, assign) BOOL showNewHand;

@property (nonatomic, strong) NSArray *group;

@end

@interface UCFNewHomeGroupModel : BaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *prdList;

@end

@interface UCFNewHomeListPrdlist : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger completeLoan;

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

@property (nonatomic, assign) NSInteger borrowAmount;

@property (nonatomic, strong) NSArray *prdLabelsList;

@property (nonatomic, copy) NSString *repayPeriodtext;

@property (nonatomic, copy) NSString *fixedDate;

@property (nonatomic, copy) NSString *prdName;

@property (nonatomic, assign) NSInteger minInvest;

@property (nonatomic, copy) NSString *repayPeriodDay;

/**
 1新手 2 智能出借 3 优质债权
 */
@property (nonatomic, copy) NSString *groupType;

@end

NS_ASSUME_NONNULL_END
