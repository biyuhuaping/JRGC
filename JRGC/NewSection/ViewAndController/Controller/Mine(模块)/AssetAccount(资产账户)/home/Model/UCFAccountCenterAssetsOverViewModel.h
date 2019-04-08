//
//  UCFAccountCenterAssetsOverViewModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFAccountCenterAssetsOverViewData,UCFAccountCenterAssetsOverViewAssetlist;

@interface UCFAccountCenterAssetsOverViewModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFAccountCenterAssetsOverViewData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFAccountCenterAssetsOverViewData : BaseModel

@property (nonatomic, copy) NSString *totalAsset;

@property (nonatomic, strong) NSArray *assetList;

@end

@interface UCFAccountCenterAssetsOverViewAssetlist : BaseModel

@property (nonatomic, copy) NSString *waitInterest;//待收利息

@property (nonatomic, copy) NSString *availBalance;//账户可用余额

@property (nonatomic, copy) NSString *totalAsset;//账户总资产

@property (nonatomic, copy) NSString *waitPrincipal;//待收本金

@property (nonatomic, copy) NSString *frozenBalance;//账户冻结金额

@property (nonatomic, copy) NSString *type;//“P2P” :微金账户 “ZX”：尊享账户 "GOLD":黄金账户

@end

NS_ASSUME_NONNULL_END
