//
//  UCFAssetAccountViewTotalHeaderAccountView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
@class UCFAccountCenterAssetsOverViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UCFAssetAccountViewTotalHeaderAccountView : BaseView

- (void)reloadAccountLayout:(UCFAccountCenterAssetsOverViewModel *)model;

@end

NS_ASSUME_NONNULL_END
