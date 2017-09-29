//
//  UCFMineHeaderView.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineHeaderView.h"
#import "UCFUserBenefitModel.h"
#import "UCFUserAssetModel.h"

@interface UCFMineHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *memberLevelView;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAssetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *visibleButton;
@property (weak, nonatomic) IBOutlet UIView *messageDotView;

@end

@implementation UCFMineHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedUserIcon:)];
    [self.userIconImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *levelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedMemberLevel:)];
    [self.memberLevelView addGestureRecognizer:levelTap];
}

#pragma mark - 点击方法
- (void)tappedUserIcon:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(mineHeaderViewDidClikedUserInfoWithCurrentVC:)]) {
        [self.delegate mineHeaderViewDidClikedUserInfoWithCurrentVC:self];
    }
}

- (void)tappedMemberLevel:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:tappedMememberLevelView:)]) {
        [self.delegate mineHeaderView:self tappedMememberLevelView:self.memberLevelView];
    }
}

- (IBAction)visible:(UIButton *)sender {
//    [self setNeedsLayout];
    if (self.visibleButton.selected) {
        self.totalAssetLabel.text = self.userAssetModel.total.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.total] : @"¥0.00";
        self.addedProfitLabel.text = self.userAssetModel.interests.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.interests] : @"¥0.00";
        self.totalBalanceLabel.text = self.userAssetModel.cashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.cashBalance] : @"¥0.00";
    }
    else {
        self.totalAssetLabel.text = @"***";
        self.addedProfitLabel.text = @"***";
        self.totalBalanceLabel.text = @"***";
    }
    sender.selected = !sender.selected;
}

- (IBAction)message:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:didClikedMessageButton:)]) {
        [self.delegate mineHeaderView:self didClikedMessageButton:sender];
    }
}
//充值
- (IBAction)topUp:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:didClikedTopUpButton:)]) {
        [self.delegate mineHeaderView:self didClikedTopUpButton:sender];
    }
}

- (IBAction)totalAssetInstruction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:didClikedTotalAssetButton:)]) {
        [self.delegate mineHeaderView:self didClikedTotalAssetButton:sender];
    }
}


- (IBAction)addedProfitInstruction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:didClikedAddedProfitButton:)]) {
        [self.delegate mineHeaderView:self didClikedAddedProfitButton:sender];
    }
}

//提现
- (IBAction)cash:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:didClikedCashButton:)]) {
        [self.delegate mineHeaderView:self didClikedCashButton:sender];
    }
}

#pragma mark - 计算我的头部信息高度
+ (CGFloat)viewHeight
{
    return 195;
}

- (void)setUserAssetModel:(UCFUserAssetModel *)userAssetModel
{
    _userAssetModel = userAssetModel;
//    [self setNeedsLayout];
    if (self.visibleButton.selected) {
        self.totalAssetLabel.text = @"***";
        self.addedProfitLabel.text = @"***";
        self.totalBalanceLabel.text = @"***";
    }
    else {
        self.totalAssetLabel.text = self.userAssetModel.total.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.total] : @"¥0.00";
        self.addedProfitLabel.text = self.userAssetModel.interests.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.interests] : @"¥0.00";
        self.totalBalanceLabel.text = self.userAssetModel.cashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.cashBalance] : @"¥0.00";
    }
}

- (void)setUserBenefitModel:(UCFUserBenefitModel *)userBenefitModel
{
    _userBenefitModel = userBenefitModel;
    if ([self.userBenefitModel.sex integerValue] == 0) {
        self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_female"];
        self.userNameLabel.text = [UserInfoSingle sharedManager].realName;
    }
    else if ([self.userBenefitModel.sex integerValue] == 1) {
        self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
        self.userNameLabel.text = [UserInfoSingle sharedManager].realName;
    }
    else {
        self.userIconImageView.image = [UIImage imageNamed:@"password_icon_head"];
        self.userNameLabel.text = @"未认证";
    }
    
    self.userLevelLabel.text = [NSString stringWithFormat:@"VIP%@", userBenefitModel.memberLever];
    if (userBenefitModel.unReadMsgCount.integerValue > 0) {
        self.messageDotView.hidden = NO;
    }
    else {
        self.messageDotView.hidden = YES;
    }
//    [self setNeedsLayout];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.userNameLabel.text = [UserInfoSingle sharedManager].realName;
    
    
    
}

@end
