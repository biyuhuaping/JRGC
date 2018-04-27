//
//  MoreHeadView.h
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreViewModel.h"
@interface MoreHeadView : UIView
+ (MoreHeadView *)getView;
- (void)blindViewModel:(MoreViewModel *)viewModel;
@end
