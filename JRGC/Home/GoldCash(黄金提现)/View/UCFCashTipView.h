//
//  UCFCashTipView.h
//  JRGC
//
//  Created by njw on 2017/7/26.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCashTipView;
@protocol UCFCashTipViewDelegate <NSObject>
- (void)cashTipView:(UCFCashTipView *)cashTipView didClickedButton:(UIButton *)button;
@end

@interface UCFCashTipView : UIView
@property (weak, nonatomic) IBOutlet UILabel *actualMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *brokerageLabel;
@property (weak, nonatomic) id<UCFCashTipViewDelegate> delegate;
@end
