//
//  UCFInvestFundsBoard.h
//  JRGC
//
//  Created by zrc on 2018/12/13.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "MyRelativeLayout.h"
#import "UCFBidViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@class UCFInvestFundsBoard;
@protocol UCFInvestFundsBoardDelegate <NSObject>

- (void)investFundsBoard:(UCFInvestFundsBoard *)board withRechargeButtonClick:(UIButton *)button;

@end

@interface UCFInvestFundsBoard : MyLinearLayout

@property(nonatomic, weak)id<UCFInvestFundsBoardDelegate>delegate;

- (void)showView:(UCFBidViewModel *)viewModel;

- (void)addSubSectionViews;
@end

NS_ASSUME_NONNULL_END
