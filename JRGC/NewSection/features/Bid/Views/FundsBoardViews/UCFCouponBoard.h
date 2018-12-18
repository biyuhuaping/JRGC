//
//  UCFCouponBoard.h
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "MyLinearLayout.h"
#import "UCFBidViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@class UCFCouponBoard;
@protocol UCFCouponBoardDelegate <NSObject>

- (void)couponBoard:(UCFCouponBoard *)board SelectPayBackButtonClick:(UIButton *)button;


@end


@interface UCFCouponBoard : MyLinearLayout

@property(weak,nonatomic)id<UCFCouponBoardDelegate>delegate;

- (void)addSubSectionViews;
- (void)showView:(UCFBidViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
