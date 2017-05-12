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
@property (weak, nonatomic) UIImageView *backView;
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
    titleLabel.text = @"我的";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:titleLabel];
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
    
    self.backView.frame = self.bounds;
}

- (void)buttonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(homeListNavView:didClicked:)]) {
        [self.delegate homeListNavView:self didClicked:button];
    }
}

- (void)setOffset:(CGFloat)offset
{
    DBLOG(@"%f", offset);
    _offset = offset;
    if (offset < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.backView.alpha = 0;
        }];
    }
    else {
        CGFloat alf = offset / self.height;
        if (alf < 0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.backView.alpha = 0;
            }];
        }
        else if (alf >= 0 && alf <= 0.9) {
            [UIView animateWithDuration:0.25 animations:^{
                self.backView.alpha = alf;
            }];
        }
        else {
            [UIView animateWithDuration:0.25 animations:^{
                self.backView.alpha = 0.9;
            }];
        }
    }
    
    
}

@end
