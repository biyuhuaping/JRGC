//
//  UCFHomeListNavView.m
//  JRGC
//
//  Created by njw on 2017/5/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListNavView.h"

@interface UCFHomeListNavView ()
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *backView;
@property (weak, nonatomic) UIView *bottmLine;

@end

@implementation UCFHomeListNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - 设置界面
- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0;
    [self addSubview:backView];
    self.backView = backView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = UIColorWithRGB(0x333333);
    titleLabel.text = @"首页";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"登录/注册" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateSelected];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5, 8, 5, 8)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.loginAndRegisterButton = button;
    [self setLoginAndRegisterButtonWithState:NO];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"mine_icon_ad"] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 addTarget:self action:@selector(giftClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button1];
    self.giftButton = button1;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    bottomLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self addSubview:bottomLine];
    self.bottmLine = bottomLine;
    self.bottmLine.alpha = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, 80, 30);
    CGFloat yCenter = self.center.y + 10;
    self.titleLabel.center = CGPointMake(ScreenWidth * 0.5, yCenter);
    
    self.loginAndRegisterButton.frame = CGRectMake(ScreenWidth - 95, 20+19*0.5, 80, 25);
    self.loginAndRegisterButton.layer.cornerRadius = 25*0.5;
    self.loginAndRegisterButton.clipsToBounds = YES;
    
    self.giftButton.frame = CGRectMake(ScreenWidth - 45, 27, 30, 30);
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        self.giftButton.alpha = 0.7;
    }
    else {
        self.giftButton.alpha = 0.0;
    }
    
    self.backView.frame = self.bounds;
    
    self.bottmLine.frame = CGRectMake(0, self.height-0.5, ScreenWidth, 0.5);
}

- (void)setLoginAndRegisterButtonWithState:(BOOL)selected
{
    if (selected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.backView.alpha = 0;
            self.bottmLine.alpha = 0;
        }];
        self.loginAndRegisterButton.layer.borderWidth = 0;
        [self.loginAndRegisterButton setBackgroundColor:[UIColor clearColor]];
        self.loginAndRegisterButton.alpha = 1.0;
    }
    else {
        self.loginAndRegisterButton.layer.borderWidth = 0.5;
        [self.loginAndRegisterButton setBackgroundColor:[UIColor blackColor]];
        self.loginAndRegisterButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.loginAndRegisterButton.alpha = 0.7;
    }
}

- (void)buttonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(homeListNavView:didClicked:)]) {
        [self.delegate homeListNavView:self didClicked:button];
    }
}

- (void)giftClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(homeListNavView:didClickedGiftButton:)]) {
        [self.delegate homeListNavView:self didClickedGiftButton:button];
    }
}

- (void)setOffset:(CGFloat)offset
{
    DBLOG(@"%f", offset);
    _offset = offset;
    
    if (offset < 40) {
        self.loginAndRegisterButton.selected = NO;
        [self setLoginAndRegisterButtonWithState:NO];
    }
    else {
        self.loginAndRegisterButton.selected = YES;
        [self setLoginAndRegisterButtonWithState:YES];
    }
    
    if (offset <= 0) {
        if ([UserInfoSingle sharedManager].userId) {
            self.hidden = NO;
        }
        else {
            self.hidden = NO;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.backView.alpha = 0;
            self.bottmLine.alpha = 0;
        }];
    }
    else {
        self.hidden = NO;
        CGFloat alf = offset / self.height;
        if (alf >= 0 && alf <= 0.9) {
            [UIView animateWithDuration:0.25 animations:^{
                self.backView.alpha = alf;
                self.bottmLine.alpha = alf;
            }];
        }
        else {
            self.backView.alpha = 0.9;
            self.bottmLine.alpha = 0.9;
        }
        if (self.backView.alpha > 0.3) {
            [UIView animateWithDuration:0.25 animations:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
            
        }
        else {
            [UIView animateWithDuration:0.25 animations:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
        }
    }
    
}

@end
