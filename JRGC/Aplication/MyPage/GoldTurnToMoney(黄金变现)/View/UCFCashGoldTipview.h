//
//  UCFCashGoldTipview.h
//  JRGC
//
//  Created by njw on 2017/8/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFCashGoldTipviewDelegate <NSObject>
- (void)cashGoldTipViewDidClickedCloseButton:(UIButton *)button;
@end

@interface UCFCashGoldTipview : UIView
@property (weak, nonatomic) IBOutlet UILabel *realGoldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualGoldPriceLabel;
@property (nonatomic, weak) id<UCFCashGoldTipviewDelegate> delegate;
@end
