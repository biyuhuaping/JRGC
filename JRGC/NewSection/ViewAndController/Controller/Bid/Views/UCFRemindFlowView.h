//
//  UCFRemindFlowView.h
//  JRGC
//
//  Created by zrc on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "MyFlowLayout.h"
#import "UCFBidViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFRemindFlowView : MyFlowLayout
- (void)reloadViewContentWithTextArr:(NSArray *)textArr;

- (void)showView:(UCFBidViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
