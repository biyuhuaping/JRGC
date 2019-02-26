//
//  UCFNewHomeViewController.h
//  JRGC
//
//  Created by zrc on 2019/1/10.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"
#import "UCFNewHomeListModel.h"
typedef enum : NSUInteger {
    
    UCFNewHomeListTypeDetail,
    UCFNewHomeListTypeInvest,

} UCFNewHomeListType;

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewHomeViewController : UCFNewBaseViewController
- (void)userGuideCellClickButton:(UIButton *)button;

- (void)homeViewDataBidClickModel:(UCFNewHomeListModel *)model type:(UCFNewHomeListType)type;

@end

NS_ASSUME_NONNULL_END
