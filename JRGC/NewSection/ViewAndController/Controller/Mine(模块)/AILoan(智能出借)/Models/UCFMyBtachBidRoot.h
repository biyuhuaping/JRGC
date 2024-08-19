//
//  UCFMyBtachBidRoot.h
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "BasePagination.h"
NS_ASSUME_NONNULL_BEGIN

@class UCFMyBatchBidDetaiData,UCFMyBatchBidDetaiPagedata,BasePagination,UCFMyBatchBidDetaiResult,UCFMyBatchBidDetaiColprdclaimdetail;
@interface UCFMyBtachBidRoot : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMyBatchBidDetaiData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMyBatchBidDetaiData : NSObject

@property (nonatomic, strong) UCFMyBatchBidDetaiPagedata *pageData;

@property (nonatomic, strong) UCFMyBatchBidDetaiColprdclaimdetail *colPrdClaimDetail;

@end

@interface UCFMyBatchBidDetaiPagedata : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) BasePagination *pagination;

@end



@interface UCFMyBatchBidDetaiResult : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger completeLoan;

@property (nonatomic, copy) NSString *loanDate;

@property (nonatomic, assign) NSInteger borrowAmount;

@property (nonatomic, assign) CGFloat loanAnnualRate;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *repayTime;

@property (nonatomic, assign) NSInteger investAmt;

@property (nonatomic, copy) NSString *prdName;

@property (nonatomic, copy) NSString *subSize;

@property (nonatomic, assign) NSInteger addRate;

@property (nonatomic, copy) NSString *status;

@end

@interface UCFMyBatchBidDetaiColprdclaimdetail : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) CGFloat totalAmt;

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

NS_ASSUME_NONNULL_END
