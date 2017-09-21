//
//  UCFMineHeaderView.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineHeaderView.h"

@interface UCFMineHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;

@end

@implementation UCFMineHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedUserIcon:)];
    [self.userIconImageView addGestureRecognizer:tap];
}

#pragma mark - 点击方法
- (void)tappedUserIcon:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(mineHeaderViewDidClikedUserInfoWithCurrentVC:)]) {
        [self.delegate mineHeaderViewDidClikedUserInfoWithCurrentVC:self];
    }
}

//充值
- (IBAction)topUp:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineHeaderView:didClikedTopUpButton:)]) {
        [self.delegate mineHeaderView:self didClikedTopUpButton:sender];
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

@end
