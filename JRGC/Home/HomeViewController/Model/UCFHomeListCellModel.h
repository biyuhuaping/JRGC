//
//  UCFHomeListCellModel.h
//  JRGC
//
//  Created by njw on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UCFHomeListCellModelTypeDefault,
    UCFHomeListCellModelTypeReserved,
    UCFHomeListCellModelTypeGoldFixed,
    UCFHomeListCellModelTypeNewUser,
    UCFHomeListCellModelTypeOneImageBatchLending,
    UCFHomeListCellModelTypeOneImageTransfer,
    UCFHomeListCellModelTypeOneImageBatchCycle,
} UCFHomeListCellModelType;

@interface UCFHomeListCellModel : NSObject
@property (nonatomic, copy) NSString *annualRate;
@property (nonatomic, strong) NSNumber *borrowAmount;
@property (nonatomic, copy) NSString *busType;
@property (nonatomic, strong) NSNumber *completeLoan;
@property (nonatomic, copy) NSString *fixedDate;
@property (nonatomic, copy) NSString *guaranteeCompany;
@property (nonatomic, copy) NSString *holdTime;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *appointPeriod;
//invitationSite = "<null>";
@property (nonatomic, strong) NSNumber *isOrder;
@property (nonatomic, strong) NSNumber *maxInvest;
@property (nonatomic, strong) NSNumber *minInvest;
@property (nonatomic, copy) NSString *platformSubsidyExpense;
@property (nonatomic, strong) NSArray *prdLabelsList;
@property (nonatomic, copy) NSString *prdName;
@property (nonatomic, strong) NSNumber *repayMode;
@property (nonatomic, copy) NSString *repayModeText;
@property (nonatomic, copy) NSString *repayPeriod;
@property (nonatomic, copy) NSString *repayPeriodtext;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *p2pTransferNum;
@property (nonatomic, copy) NSString *totalCount;
@property (nonatomic, copy) NSString *zxTransferNum;
@property (nonatomic, copy) NSString *transferNum;
@property (nonatomic, copy) NSString *totleBookAmt;
@property (nonatomic, copy) NSString *remainAmount; //剩余黄金克数
@property (nonatomic, assign) UCFHomeListCellModelType moedelType;
@property (nonatomic, copy) NSString *backImage;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *minInvestTxt;

@property (nonatomic, assign) BOOL p2pAuthorization;
@property (nonatomic, assign) BOOL zxAuthorization;
@property (nonatomic, copy) NSString *openStatus;
@property (nonatomic, copy) NSString *zxOpenStatus;


+ (instancetype)homeListCellWithDict:(NSDictionary *)dict;
@end
