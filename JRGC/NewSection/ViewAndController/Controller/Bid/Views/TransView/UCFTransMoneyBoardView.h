//
//  UCFTransMoneyBoardView.h
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "MyLinearLayout.h"
#import "BaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@class UCFTransMoneyBoardView;
@protocol UCFTransMoneyBoardViewDelegate <NSObject>

- (void)investTransFundsBoard:(UCFTransMoneyBoardView *)board withRechargeButtonClick:(UIButton *)button;


@end





@interface UCFTransMoneyBoardView : MyLinearLayout

@property(nonatomic, weak)id<UCFTransMoneyBoardViewDelegate>delegate;

- (void)addSubSectionViews;

- (void)showTransView:(BaseViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
