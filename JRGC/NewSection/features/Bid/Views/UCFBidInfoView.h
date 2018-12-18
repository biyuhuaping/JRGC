//
//  UCFBidInfoView.h
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBidViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFBidInfoView : MyRelativeLayout
- (void)bidLayoutSubViewsFrame;


- (void)showView:(UCFBidViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
