//
//  UCFAssetAccountViewTotalTitleListView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
@class UCFAccountCenterAssetsOverViewAssetlist;
NS_ASSUME_NONNULL_BEGIN

@interface UCFAssetAccountViewTotalTitleListView : BaseView

@property (nonatomic, strong) UIButton    *enterButton;

- (void)reloadAccountContent:(UCFAccountCenterAssetsOverViewAssetlist *)model;

@end

NS_ASSUME_NONNULL_END
