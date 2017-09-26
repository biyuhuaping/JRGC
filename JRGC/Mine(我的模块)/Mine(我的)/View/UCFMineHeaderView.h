//
//  UCFMineHeaderView.h
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFMineHeaderView, UCFUserBenefitModel, UCFUserAssetModel;
@protocol UCFMineHeaderViewDelegate <NSObject>

- (void)mineHeaderViewDidClikedUserInfoWithCurrentVC:(UCFMineHeaderView *)mineHeaderView;

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedTopUpButton:(UIButton*)rechargeButton;
- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedCashButton:(UIButton*)cashButton;

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView tappedMememberLevelView:(UIView *)memberLevelView;
- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedTotalAssetButton:(UIButton*)totalAssetButton;
- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedAddedProfitButton:(UIButton*)totalProfitButton;
- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedMessageButton:(UIButton*)totalProfitButton;

@end

@interface UCFMineHeaderView : UIView
@property (strong, nonatomic) UCFUserBenefitModel *userBenefitModel;
@property (strong, nonatomic) UCFUserAssetModel *userAssetModel;
@property (weak, nonatomic) id<UCFMineHeaderViewDelegate> delegate;
+ (CGFloat)viewHeight;
@end
