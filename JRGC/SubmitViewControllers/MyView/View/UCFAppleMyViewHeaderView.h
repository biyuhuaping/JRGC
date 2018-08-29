//
//  UCFMineHeaderView.h
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFAppleMyViewHeaderView, UCFUserBenefitModel, UCFUserAssetModel;
@protocol UCFMineHeaderViewDelegate <NSObject>

- (void)mineHeaderViewDidClikedUserInfoWithCurrentVC:(UCFAppleMyViewHeaderView *)mineHeaderView;

- (void)mineHeaderView:(UCFAppleMyViewHeaderView *)mineHeaderView didClikedTopUpButton:(UIButton*)rechargeButton;
- (void)mineHeaderView:(UCFAppleMyViewHeaderView *)mineHeaderView didClikedCashButton:(UIButton*)cashButton;

- (void)mineHeaderView:(UCFAppleMyViewHeaderView *)mineHeaderView tappedMememberLevelView:(UIView *)memberLevelView;
- (void)mineHeaderView:(UCFAppleMyViewHeaderView *)mineHeaderView didClikedTotalAssetButton:(UIButton*)totalAssetButton;
- (void)mineHeaderView:(UCFAppleMyViewHeaderView *)mineHeaderView didClikedAddedProfitButton:(UIButton*)totalProfitButton;
- (void)mineHeaderView:(UCFAppleMyViewHeaderView *)mineHeaderView didClikedMessageButton:(UIButton*)totalProfitButton;

@end

@interface UCFAppleMyViewHeaderView : UIView
@property (strong, nonatomic) UCFUserBenefitModel *userBenefitModel;
@property (strong, nonatomic) UCFUserAssetModel *userAssetModel;
@property (weak, nonatomic) id<UCFMineHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
+ (CGFloat)viewHeight;
@end
