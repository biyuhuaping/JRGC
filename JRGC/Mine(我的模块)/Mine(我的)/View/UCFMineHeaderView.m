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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLevelW;
@property (weak, nonatomic) IBOutlet UIView *downView;

@end

@implementation UCFMineHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.messageDotView.backgroundColor = UIColorWithRGB(0xfd4d4c);
    self.downView.backgroundColor = UIColorWithRGB(0x1D0D34);
    [self.rechargeButton setBackgroundColor:UIColorWithRGB(0x342649)];
    [self.cashButton setBackgroundColor:UIColorWithRGB(0x342649)];
    self.rechargeButton.layer.borderColor = UIColorWithRGB(0xA8A2C1).CGColor;
    self.cashButton.layer.borderColor = UIColorWithRGB(0xA8A2C1).CGColor;
    
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
        sender.enabled = NO;
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
        sender.enabled = NO;
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
    self.userNameLabel.text = userBenefitModel.realName.length > 0 ? userBenefitModel.realName : @"未认证";
    if ([self.userBenefitModel.sex integerValue] == 0) {
        self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_female"];
    }
    else if ([self.userBenefitModel.sex integerValue] == 1) {
        self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
    }
    else {
        self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
    }
    NSInteger  memLevel = userBenefitModel.memberLever.integerValue - 1;
    if (memLevel > 0) {
        self.userLevelLabel.text = [NSString stringWithFormat:@"VIP%ld", (long)memLevel];
        self.userLevelW.constant = 32.0;
    }
    else {
        self.userLevelLabel.text = @"普通会员";
        self.userLevelW.constant = 49.0;
    }
    
    if (userBenefitModel.unReadMsgCount.integerValue > 0) {
        self.messageDotView.hidden = NO;
    }
    else {
        self.messageDotView.hidden = YES;
    }
}

- (void)setDefaultState {
    self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
    self.userNameLabel.text = @"未认证";
    self.userLevelLabel.text = @"普通会员";
    self.userLevelW.constant = 49.0;
    if (self.visibleButton.selected) {
        self.totalAssetLabel.text = @"***";
        self.addedProfitLabel.text = @"***";
        self.totalBalanceLabel.text = @"***";
    }
    else {
        self.totalAssetLabel.text = @"¥0.00";
        self.addedProfitLabel.text = @"¥0.00";
        self.totalBalanceLabel.text = @"¥0.00";
    }
}

@end
