//
//  HomeHeadCycleView.h
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "MyRelativeLayout.h"
#import "UCFHomeViewModel.h"
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeHeadCycleView : MyRelativeLayout
@property(nonatomic, strong)SDCycleScrollView *adCycleScrollView;
- (void)showView:(UCFHomeViewModel *)viewModel;
- (void)createSubviews;
@end

NS_ASSUME_NONNULL_END
