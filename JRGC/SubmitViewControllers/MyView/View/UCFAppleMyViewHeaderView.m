//
//  UCFMineHeaderView.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFAppleMyViewHeaderView.h"
#import "UCFUserBenefitModel.h"
#import "UCFUserAssetModel.h"

@interface UCFAppleMyViewHeaderView ()
@property (strong, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIView *memberLevelView;
@property (strong, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAssetLabel;
@property (strong, nonatomic) IBOutlet UILabel *addedProfitLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *visibleButton;
@property (weak, nonatomic) IBOutlet UIView *messageDotView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userLevelW;
@property (strong, nonatomic) IBOutlet UIView *downView;

@end

@implementation UCFAppleMyViewHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
//
//    self.messageDotView.backgroundColor = UIColorWithRGB(0xfd4d4c);
//    self.downView.backgroundColor = UIColorWithRGB(0x1D0D34);
//    [self.rechargeButton setBackgroundColor:UIColorWithRGB(0x342649)];
//    [self.cashButton setBackgroundColor:UIColorWithRGB(0x342649)];
//    self.rechargeButton.layer.borderColor = UIColorWithRGB(0xA8A2C1).CGColor;
//    self.cashButton.layer.borderColor = UIColorWithRGB(0xA8A2C1).CGColor;
//    self.memberLevelView.hidden = YES;
    
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
        self.addedProfitLabel.text = self.userAssetModel.historyInterests.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.historyInterests] : @"¥0.00";
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
    if (self.visibleButton.selected) {
        self.totalAssetLabel.text = @"***";
        self.addedProfitLabel.text = @"***";
        self.totalBalanceLabel.text = @"***";
    }
    else {
        self.totalAssetLabel.text = self.userAssetModel.total.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.total] : @"¥0.00";
        self.addedProfitLabel.text = self.userAssetModel.historyInterests.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.historyInterests] : @"¥0.00";
        self.totalBalanceLabel.text = self.userAssetModel.cashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.userAssetModel.cashBalance] : @"¥0.00";
    }
     self.userNameLabel.text = [UserInfoSingle sharedManager].realName.length > 0 ? [UserInfoSingle sharedManager].realName : @"未认证";
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setUserAssetModel:self.userAssetModel];
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
        self.memberLevelView.hidden = NO;
    }
    else {
        self.userLevelLabel.text = @"普通会员";
        self.userLevelW.constant = 49.0;
        self.memberLevelView.hidden = [UserInfoSingle sharedManager].superviseSwitch ?  YES : NO;
    }
    
    if (userBenefitModel.unReadMsgCount.integerValue > 0) {
        self.messageDotView.hidden = NO;
    }
    else {
        self.messageDotView.hidden = YES;
    }
}

@end
