//
//  UCFNewInvestBtnView.h
//  JRGC
//
//  Created by zrc on 2019/1/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "UVFBidDetailViewModel.h"
#import "UCFTransBidDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@class UCFNewInvestBtnView;
@protocol UCFNewInvestBtnViewDelegate <NSObject>

- (void)newInvestBtnView:(UCFNewInvestBtnView *)view clickButton:(UIButton *)button;

@end


@interface UCFNewInvestBtnView : BaseView

@property(nonatomic, weak)id<UCFNewInvestBtnViewDelegate>delegate;

- (void)blindVM:(UVFBidDetailViewModel *)vm;
- (void)blindTransVM:(UCFTransBidDetailViewModel *)vm;

- (void)blindBaseVM:(BaseViewModel *)vm;

@end

NS_ASSUME_NONNULL_END
