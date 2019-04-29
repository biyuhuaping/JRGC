//
//  QuickRechargeHeadView.h
//  JRGC
//
//  Created by zrc on 2018/11/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuickRechargeHeadView;
@protocol QuickRechargeHeadViewDelegate <NSObject>

- (void)quickRechargeHeadView:(QuickRechargeHeadView *)view fixButtonClick:(UIButton *)button;
- (void)quickRechargeHeadView:(QuickRechargeHeadView *)view rechargeButtonClick:(UIButton *)button;
@end

NS_ASSUME_NONNULL_BEGIN

@interface QuickRechargeHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankRechargeLimitLab;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *fixButton;
@property (weak)id<QuickRechargeHeadViewDelegate>delegate;

- (void)setButtonStyle;
@end

NS_ASSUME_NONNULL_END
