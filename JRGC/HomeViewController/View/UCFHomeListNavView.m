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
@property (weak, nonatomic) UIButton *loginAndRegisterButton;
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
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = UIColorWithRGB(0x333333);
    titleLabel.text = @"我的";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"登录/注册" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.loginAndRegisterButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, 80, 30);
    CGFloat yCenter = self.center.y + 10;
    self.titleLabel.center = CGPointMake(ScreenWidth * 0.5, yCenter);
    
    self.loginAndRegisterButton.frame = CGRectMake(ScreenWidth - 95, 20, 80, 44);
}

- (void)buttonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(homeListNavView:didClicked:)]) {
        [self.delegate homeListNavView:self didClicked:button];
    }
}

@end
