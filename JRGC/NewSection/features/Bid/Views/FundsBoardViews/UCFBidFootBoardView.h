//
//  UCFBidFootBoardView.h
//  JRGC
//
//  Created by zrc on 2018/12/18.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "MyLinearLayout.h"
#import "UCFBidViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFBidFootBoardView : MyLinearLayout
- (void)showView:(UCFBidViewModel *)viewModel;
- (void)createAllShowView;
@end

NS_ASSUME_NONNULL_END
