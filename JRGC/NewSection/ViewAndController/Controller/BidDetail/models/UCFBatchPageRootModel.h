//
//  UCFBatchPageRootModel.h
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFBatchPageData,UCFBatchPageColprdclaimdetail,UCFBatchPageContractmsg;
@interface UCFBatchPageRootModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFBatchPageData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFBatchPageData : BaseModel

@property (nonatomic, assign) BOOL isNewUser;

@property (nonatomic, copy) NSString *beancount;

@property (nonatomic, copy) NSString *cfcaContractUrl;

@property (nonatomic, strong) UCFBatchPageColprdclaimdetail *colPrdClaimDetail;

@property (nonatomic, assign) BOOL bankNumEq;

@property (nonatomic, assign) NSInteger beanAmount;

@property (nonatomic, copy) NSString *apptzticket;

@property (nonatomic, copy) NSString *batchAmount;

@property (nonatomic, assign) BOOL isOpenBatch;

@property (nonatomic, assign) CGFloat canUserBalance;

@property (nonatomic, copy) NSString *prdClaimId;

@property (nonatomic, strong) NSArray *contractMsg;

@property (nonatomic, assign) BOOL isLimit;

@property (nonatomic, assign) CGFloat availableBalance;

@property (nonatomic, copy) NSString *recomendFactoryCode;

@property (nonatomic, copy) NSString *cfcaContractName;

@end

@interface UCFBatchPageColprdclaimdetail : BaseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger totalAmt;

@property (nonatomic, assign) CGFloat canBuyAmt;

@property (nonatomic, assign) BOOL full;

@property (nonatomic, copy) NSString *colPeriod;

@property (nonatomic, copy) NSString *colRate;

@property (nonatomic, assign) NSInteger canBuyCount;

@property (nonatomic, copy) NSString *colName;

@property (nonatomic, assign) NSInteger colRepayMode;

@property (nonatomic, copy) NSString *colPeriodTxt;

@property (nonatomic, assign) CGFloat colMinInvest;

@property (nonatomic, copy) NSString *colRepayModeTxt;

@end

@interface UCFBatchPageContractmsg : BaseModel

@property (nonatomic, copy) NSString *contractName;

@property (nonatomic, copy) NSString *contractType;

@end

NS_ASSUME_NONNULL_END
