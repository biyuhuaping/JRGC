//
//  UCFTransferHeaderView.h
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFTransferHeaderView;
@protocol UCFTransferHeaderViewDelegate <NSObject>

- (void)transferHeaderView:(UCFTransferHeaderView *)transferHeader didClickOrderButton:(UIButton *)orderBtn andIsIncrease:(BOOL)isUp;

@end

@interface UCFTransferHeaderView : UIView

@property (weak, nonatomic) id<UCFTransferHeaderViewDelegate> delegate;
- (void)initData;
- (void)getNormalBannerData;
@end
