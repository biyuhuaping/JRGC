//
//  UCF404ErrorView.m
//  JRGC
//
//  Created by HeJing on 15/5/26.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCF404ErrorView.h"
#import "UILabel+Misc.h"
#import "UIImage+Compression.h"
@interface UCF404ErrorView ()
{
    NSString *_errorTitle;
    UIView *bkView;
}

@end

@implementation UCF404ErrorView

- (id)initWithFrame:(CGRect)frame errorTitle:(NSString*)titleStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _errorTitle = titleStr;
        [self initViewControls];
    }
    return self;
}

- (void)initViewControls
{
    self.backgroundColor =  [Color color:PGColorOpttonTabeleViewBackgroundColor];
    
    bkView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 323) / 2, self.frame.size.width, 323)];
    bkView.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoImageVW = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 70)/2, 0, 70, 93)];
    logoImageVW.image = [UIImage imageNamed:@"404bg.png"];
    [bkView addSubview:logoImageVW];
    
    UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageVW.frame) + 20, ScreenWidth, 18) text:@"网络连接异常，请检查后重试" textColor:[Color color:PGColorOptionTitleGray] font:[UIFont systemFontOfSize:15]];
    [bkView addSubview:infoLabel];
    
    UIButton *reLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reLoadBtn setBackgroundImage:[UIImage gc_styleImageSize:CGSizeMake(205, 40)] forState:UIControlStateNormal];
    reLoadBtn.frame = CGRectMake((ScreenWidth - 205)/2, CGRectGetMaxY(infoLabel.frame) + 25, 205, 40);
    [reLoadBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reLoadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    reLoadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    reLoadBtn.layer.cornerRadius = 20.0f;
    reLoadBtn.layer.masksToBounds = YES;
    [bkView addSubview:reLoadBtn];
    
    [self addSubview:bkView];
}
- (void)addBackBtnView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = 100;
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.backgroundColor = [DBColor colorWithHexString:@"fd4d4c" andAlpha:1.0];
    [backBtn.layer setCornerRadius:4.0];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIView *views in self.subviews)
    {
        for (UILabel * subView in views.subviews)
        {
            if ([subView isKindOfClass:[UILabel class]] )
            {
                if ([subView.text isEqualToString:@"点击屏幕重新加载"]) {
                    backBtn.frame = CGRectMake((ScreenWidth - 120)/2,CGRectGetMaxY(subView.frame) + 20, 120, 37);
                }
                
            }
        }
    }
    [bkView addSubview:backBtn];
    bkView.frame = CGRectMake(0, (self.frame.size.height - 380) / 2, self.frame.size.width, 380);
    
}

- (void)btnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(refreshBtnClicked:fatherView:)]) {
        [self.delegate refreshBtnClicked:sender fatherView:self];
    }
}

- (void)backBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(refreshBackBtnClicked:fatherView:)]) {
        [self.delegate refreshBackBtnClicked:sender fatherView:self];
    }
}
- (void)showInView:(UIView*)fatherView
{
    if (self.hidden) {
        self.hidden = NO;
    }
    [fatherView addSubview:self];
    [fatherView bringSubviewToFront:self];
}

- (void)hide
{
    [self setHidden:YES];
    [self removeFromSuperview];
}

@end
