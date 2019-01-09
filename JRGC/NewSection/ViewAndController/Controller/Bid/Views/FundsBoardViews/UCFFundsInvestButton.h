//
//  UCFFundsInvestButton.h
//  JRGC
//
//  Created by zrc on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "MyRelativeLayout.h"
#import "UCFBidViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFFundsInvestButton : MyRelativeLayout

- (void)showView:(UCFBidViewModel *)viewModel;
- (void)createSubviews;

@end

NS_ASSUME_NONNULL_END
