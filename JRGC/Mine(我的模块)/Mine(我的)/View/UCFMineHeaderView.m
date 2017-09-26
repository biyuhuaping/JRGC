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
    [self setNeedsLayout];
    sender.selected = !sender.selected;
}

//充值
- (IBAction)topUp:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:didClikedTopUpButton:)]) {
        [self.delegate mineHeaderView:self didClikedTopUpButton:sender];
    }
}

- (IBAction)totalAssetInstruction:(UIButton *)sender {
    
}


- (IBAction)totalBalanceInstruction:(UIButton *)sender {
    
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
    [self setNeedsLayout];
    
}

- (void)setUserBenefitModel:(UCFUserBenefitModel *)userBenefitModel
{
    _userBenefitModel = userBenefitModel;
    [self setNeedsLayout];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.userBenefitModel.sex integerValue] == 1) {
        self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_male"];
    }
    else if ([self.userBenefitModel.sex integerValue] == 2) {
        self.userIconImageView.image = [UIImage imageNamed:@"user_icon_head_female"];
    }
    else {
        self.userIconImageView.image = [UIImage imageNamed:@"password_icon_head"];
    }
    self.userNameLabel.text = [UserInfoSingle sharedManager].realName;
    self.userLevelLabel.text = [NSString stringWithFormat:@"VIP%@", self.userBenefitModel.memberLever];
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
    if (self.userBenefitModel.unReadMsgCount.integerValue > 0) {
        self.messageDotView.hidden = NO;
    }
    else {
        self.messageDotView.hidden = YES;
    }
}

@end
