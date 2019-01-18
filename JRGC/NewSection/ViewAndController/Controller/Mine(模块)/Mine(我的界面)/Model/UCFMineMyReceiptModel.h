//
//  UCFMineMyReceiptModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/17.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class MyReceiptData;
@interface UCFMineMyReceiptModel : BaseModel

@property (nonatomic, assign) CGFloat code;

@property (nonatomic, strong) MyReceiptData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;

@property (nonatomic, assign) CGFloat ver;

@end
@interface MyReceiptData : BaseModel

@property (nonatomic, copy) NSString *cashTotal;

@property (nonatomic, copy) NSString *goldMarketAmount;

@property (nonatomic, copy) NSString *historyInterests;

@property (nonatomic, copy) NSString *zxCashBalance;

@property (nonatomic, copy) NSString *zxOpenStatus;

@property (nonatomic, copy) NSString *nmCashBalance;

@property (nonatomic, copy) NSString *total;

@property (nonatomic, copy) NSString *allGiveGoldAmount;

@property (nonatomic, copy) NSString *holdGoldAmount;

@property (nonatomic, copy) NSString *cashBalance;

@property (nonatomic, copy) NSString *p2pCashBalance;

@property (nonatomic, copy) NSString *interests;

@property (nonatomic, copy) NSString *nmGoldAuthorization;

@property (nonatomic, copy) NSString *openStatus;

@end
NS_ASSUME_NONNULL_END
