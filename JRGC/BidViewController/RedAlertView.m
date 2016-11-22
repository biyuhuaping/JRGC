//
//  RedAlertView.m
//  JRGC
//
//  Created by 金融工场 on 15/6/5.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "RedAlertView.h"

@implementation RedAlertView
- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];

        [self makeView];
    }
    return self;
}
- (void)makeView
{
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor clearColor];
    baseView.tag = 10000;
    if (ScreenHeight == 480) {
        baseView.frame = CGRectMake((ScreenWidth - 320)/2, -28, 320, 568);
    } else {
        baseView.frame = CGRectMake((ScreenWidth - 320)/2, (ScreenHeight - 568)/2, 320, 568);
    }
    [self addSubview:baseView];
    
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [baseView.layer addAnimation:popAnimation forKey:nil];

    
    
    UIImageView *redBagImageView = [[UIImageView alloc] init];
    redBagImageView.image = [UIImage imageNamed:@"bigredbag_bg.png"];
    redBagImageView.frame = CGRectMake(0, 0, 320, 375);
    redBagImageView.tag = 11000;
    redBagImageView.userInteractionEnabled = YES;
    [baseView addSubview:redBagImageView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(320-25-35, 95, 35, 35);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"bigredbag_btn_close.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [redBagImageView addSubview:deleteBtn];
    
    UILabel *redBagValueLab = [[UILabel alloc] init];
    redBagValueLab.frame = CGRectMake(20, 258, 320 - 40, 50);
    redBagValueLab.text = @"¥80";
    redBagValueLab.tag = 11001;
    redBagValueLab.textColor = [UIColor whiteColor];
    redBagValueLab.backgroundColor = [UIColor clearColor];
    redBagValueLab.textAlignment = NSTextAlignmentCenter;
    redBagValueLab.font = [UIFont boldSystemFontOfSize:58];
    [redBagImageView addSubview:redBagValueLab];
    
    UILabel *rewardLabel = [[UILabel alloc] init];
    rewardLabel.text = @"红包被抢光再奖励¥5";
    rewardLabel.tag = 11002;
    rewardLabel.textColor = UIColorWithRGB(0xfcdb6a);
    rewardLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    rewardLabel.textAlignment = NSTextAlignmentCenter;
    rewardLabel.backgroundColor = [UIColor clearColor];
    rewardLabel.frame = CGRectMake(0,CGRectGetMaxY(redBagValueLab.frame) + 7, 320, 17);
    [redBagImageView addSubview:rewardLabel];
    
    UIButton *weiXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (ScreenHeight == 480) {
        weiXinBtn.frame = CGRectMake(66, 568 - 175, 60, 60);
    } else {
        weiXinBtn.frame = CGRectMake(66, 568 - 140, 60, 60);

    }
    weiXinBtn.backgroundColor = [UIColor clearColor];
    weiXinBtn.tag = 2000;
    [weiXinBtn setBackgroundImage:[UIImage imageNamed:@"share_btn_wechat.png"] forState:UIControlStateNormal];
    [weiXinBtn addTarget:self action:@selector(shareRegBag:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:weiXinBtn];
    
    UILabel *weiXinLabel = [[UILabel alloc] init];
    weiXinLabel.frame = CGRectMake(CGRectGetMinX(weiXinBtn.frame) - 40, CGRectGetMaxY(weiXinBtn.frame) + 10, CGRectGetWidth(weiXinBtn.frame) + 80, 12);
    weiXinLabel.textAlignment = NSTextAlignmentCenter;
    weiXinLabel.textColor = [UIColor whiteColor];
    weiXinLabel.font = [UIFont systemFontOfSize:12.0f];
    weiXinLabel.text = @"分享给微信好友";
    [baseView addSubview:weiXinLabel];
    
    
    UIButton *pengYouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (ScreenHeight == 480) {
        pengYouBtn.frame = CGRectMake(CGRectGetMaxX(weiXinBtn.frame) + 67, 568 - 175, 60, 60);
    } else {
        pengYouBtn.frame = CGRectMake(CGRectGetMaxX(weiXinBtn.frame) + 67, 568 - 140, 60, 60);
    }
    pengYouBtn.backgroundColor = [UIColor clearColor];
    pengYouBtn.tag = 2001;
    [pengYouBtn setBackgroundImage:[UIImage imageNamed:@"share_btn_friends.png"] forState:UIControlStateNormal];
    [pengYouBtn addTarget:self action:@selector(shareRegBag:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:pengYouBtn];
    
    UILabel *friedsLabel = [[UILabel alloc] init];
    friedsLabel.frame = CGRectMake(CGRectGetMinX(pengYouBtn.frame) - 40, CGRectGetMaxY(pengYouBtn.frame) + 10, CGRectGetWidth(pengYouBtn.frame) + 80, 12);
    friedsLabel.textAlignment = NSTextAlignmentCenter;
    friedsLabel.textColor = [UIColor whiteColor];
    friedsLabel.font = [UIFont systemFontOfSize:12.0f];
    friedsLabel.text = @"分享到朋友圈";
    [baseView addSubview:friedsLabel];
}
- (void)shareRegBag:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareRedBag:)]) {
        [self.delegate shareRedBag:button.tag];
    }
}
- (void)reloadViews:(NSDictionary *)dict
{
    UIView *baseView = [self viewWithTag:10000];
    UIImageView *redBagImageView = (UIImageView *)[baseView viewWithTag:11000];
    UILabel *redBagValueLab = (UILabel *)[redBagImageView viewWithTag:11001];
    UILabel *rewardLabel = (UILabel *)[redBagImageView viewWithTag:11002];
    NSString *activetyvalue = [NSString stringWithFormat:@"%@",[dict objectForKey:@"activetyvalue"]];
    NSString *rewardAmt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rewardAmt"]];
    if (activetyvalue == nil  || [activetyvalue isEqualToString:@"0"]) {
        redBagValueLab.text = @"0";
    } else {
        redBagValueLab.text = [NSString stringWithFormat:@"¥%@",activetyvalue];
    }
    if (rewardAmt == nil || [rewardAmt isEqualToString:@"0"]) {
        rewardLabel.hidden = YES;
    } else {
        rewardLabel.hidden = NO;
        rewardLabel.text = [NSString stringWithFormat:@"红包被抢光再奖励¥%@",rewardAmt];
    }
}
- (void)deleteBtnClick:(UIButton *)button
{
    [self fadeKeyboard];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showGoodCommentAlertView)]) {
//        [self.delegate showGoodCommentAlertView];
//    }
}
- (void)fadeKeyboard
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
