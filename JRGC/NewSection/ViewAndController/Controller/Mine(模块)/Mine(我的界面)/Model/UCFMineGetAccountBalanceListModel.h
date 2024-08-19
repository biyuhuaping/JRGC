//
//  UCFMineGetAccountBalanceListModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFMineGetAccountBalanceListData;
@interface UCFMineGetAccountBalanceListModel : BaseModel
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) UCFMineGetAccountBalanceListData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;
@end

@interface UCFMineGetAccountBalanceListData : BaseModel

@property (nonatomic, copy) NSString *zxCardLogoUrl;

@property (nonatomic, copy) NSString *zxCardName;

@property (nonatomic, copy) NSString *p2pBalance;

@property (nonatomic, copy) NSString *p2pCardBgColor;

@property (nonatomic, copy) NSString *p2pCardNum;

@property (nonatomic, copy) NSString *goldCardLogoUrl;

@property (nonatomic, copy) NSString *p2pCardName;

@property (nonatomic, copy) NSString *zxCardNum;

@property (nonatomic, copy) NSString *goldCardNum;

@property (nonatomic, copy) NSString *goldCardBgColor;

@property (nonatomic, copy) NSString *goldBalance;

@property (nonatomic, copy) NSString *goldCardName;

@property (nonatomic, copy) NSString *zxCardBgColor;

@property (nonatomic, copy) NSString *p2pCardLogoUrl;

@property (nonatomic, copy) NSString *totalBalance;

@property (nonatomic, copy) NSString *zxBalance;

@end


NS_ASSUME_NONNULL_END
