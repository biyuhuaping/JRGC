//
//  UCFBatchRootModel.h
//  JRGC
//
//  Created by zrc on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UCFBatchDataModel,UCFBatchPrdclaimsorderlistModel;
@interface UCFBatchRootModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFBatchDataModel *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFBatchDataModel : BaseModel

@property (nonatomic, assign) NSString *totalAmt;

@property (nonatomic, assign) NSString *canBuyAmt;

@property (nonatomic, assign) CGFloat percentage;

@property (nonatomic, copy) NSString *colPeriod;

@property (nonatomic, assign) BOOL isfull;

@property (nonatomic, assign) NSInteger canBuyCount;

@property (nonatomic, copy) NSString *colRate;

@property (nonatomic, copy) NSString *colName;

@property (nonatomic, strong) NSArray *prdClaimsOrderList;

@property (nonatomic, copy) NSString *colRepayMode;

@property (nonatomic, assign) NSInteger colMinInvest;

@property (nonatomic, copy) NSString *openStatus;

@property (nonatomic, assign) NSInteger colPrdClaimId;

@end

@interface UCFBatchPrdclaimsorderlistModel : BaseModel

@property (nonatomic, copy) NSString *orderTopic;

@property (nonatomic, copy) NSString *orderDescription;

@end


NS_ASSUME_NONNULL_END
