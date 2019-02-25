//
//  HomeHeadCycleView.h
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

@class HomeHeadCycleView;
@protocol HomeHeadCycleViewDelegate <NSObject>

- (void)homeHeadCycleView:(HomeHeadCycleView *)cycleView didSelectIndex:(NSInteger)index;

@end

#import "MyRelativeLayout.h"
#import "UCFBannerViewModel.h"
#import "RCFFlowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeHeadCycleView : MyRelativeLayout
@property(nonatomic, strong)RCFFlowView *adCycleScrollView;
@property(nonatomic, weak)id<HomeHeadCycleViewDelegate> delegate;
- (void)showView:(UCFBannerViewModel *)viewModel;
- (void)createSubviews;
@end

NS_ASSUME_NONNULL_END
