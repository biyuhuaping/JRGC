//
//  UCFAssetAccountViewTotalListView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
@class UCFAccountCenterAssetsOverViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface UCFAssetAccountViewTotalListView : BaseView

@property (nonatomic, strong) UIButton    *enterButton;

- (void)reloadAccountContent:(UCFAccountCenterAssetsOverViewModel *)model;
@end

NS_ASSUME_NONNULL_END
