//
//  UCFMyBatchBidModel.h
//  JRGC
//
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "BasePagination.h"
NS_ASSUME_NONNULL_BEGIN

@class UCFMyBatchBidData,UCFMyBatchPagedata,UCFMyBatchBidResult;
@interface UCFMyBatchBidModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMyBatchBidData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMyBatchBidData : NSObject

@property (nonatomic, strong) UCFMyBatchPagedata *pageData;

@end

@interface UCFMyBatchPagedata : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) BasePagination *pagination;

@end



@interface UCFMyBatchBidResult : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) CGFloat minInvest;

@property (nonatomic, assign) NSInteger collMaxSize;

@property (nonatomic, assign) CGFloat investSuccessTotal;

@property (nonatomic, assign) NSInteger colId;

@property (nonatomic, assign) NSInteger collRepayMode;

@property (nonatomic, copy) NSString *collName;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *investTime;

@property (nonatomic, assign) NSInteger investSuccessNumber;

@property (nonatomic, assign) CGFloat collRate;

@property (nonatomic, copy) NSString *colPeriodTxt;

@property (nonatomic, copy) NSString *collPeriod;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *colRepayModeTxt;

@end

NS_ASSUME_NONNULL_END
