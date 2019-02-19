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

@interface UCFNewInvestBtnView : BaseView
- (void)blindVM:(UVFBidDetailViewModel *)vm;
- (void)blindTransVM:(UCFTransBidDetailViewModel *)vm;
@end

NS_ASSUME_NONNULL_END
