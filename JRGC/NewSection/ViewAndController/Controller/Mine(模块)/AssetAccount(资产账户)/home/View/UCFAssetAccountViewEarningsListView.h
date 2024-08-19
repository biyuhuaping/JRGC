//
//  UCFAssetAccountViewEarningsListView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/8.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
@class UCFAccountCenterAlreadyProfitModel;
NS_ASSUME_NONNULL_BEGIN

@interface UCFAssetAccountViewEarningsListView : BaseView

@property (nonatomic, strong) MyRelativeLayout *zxProfitLayout;// 尊享收益

@property (nonatomic, strong) MyRelativeLayout *goldProfitLayout;// 黄金收益

- (void)reloadAccountContent:(UCFAccountCenterAlreadyProfitModel *)model;
@end

NS_ASSUME_NONNULL_END
