//
//  UCFBidInfoView.h
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBidViewModel.h"
#import "UCFPureTransPageViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFBidInfoView : MyRelativeLayout
- (void)bidLayoutSubViewsFrame;


- (void)showView:(UCFBidViewModel *)viewModel;

- (void)showTransView:(UCFPureTransPageViewModel *)viewModel;

- (void)blindBaseViewModel:(BaseViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
