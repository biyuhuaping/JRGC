//
//  UCFLoginShaowView.m
//  JRGC
//
//  Created by Qnwi on 15/12/4.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UCFLoginShaowView.h"
#import "UILabel+Misc.h"

@interface UCFLoginShaowView () {
    UIView *_upIconView;
    UIImageView *_iconOne;
    UILabel *_LabelOne;
    
    UIView *_downIconView;
    UIImageView *_iconTwo;
    UILabel *_LabelTwo;
}

@end

@implementation UCFLoginShaowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initShadowViews];
    }
    return self;
}

- (void)initShadowViews
{
    //灰色背景
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 48)];
    bkView.backgroundColor = [UIColor blackColor];
    bkView.alpha = 0.7;
    [self addSubview:bkView];
    
    //登录背景
    CGFloat bkViewHeight = 242+29+37+40;//图片高＋ 间隙＋按钮高＋间隙＋更多按钮高
    UIView *btnBKView = [[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - bkViewHeight - 44) / 2, ScreenWidth, bkViewHeight)];
    btnBKView.backgroundColor = [UIColor clearColor];
    [self addSubview:btnBKView];
    
    UIImageView *loginIconView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 280)/2, 0, 280, 242)];
    loginIconView.image = [UIImage imageNamed:@"usercenter_douge_profile"];
    [btnBKView addSubview:loginIconView];
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame = CGRectMake(15, CGRectGetMaxY(loginIconView.frame) + 20 , (ScreenWidth - 45)/2, 37);
    [regBtn setBackgroundColor:UIColorWithRGB(0x7c9dc7)];
    [regBtn addTarget:self action:@selector(regBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    regBtn.layer.cornerRadius = 2.0f;
    regBtn.layer.masksToBounds = YES;
    [btnBKView addSubview:regBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(CGRectGetMaxX(regBtn.frame) + 15, CGRectGetMaxY(loginIconView.frame) + 20 , (ScreenWidth - 45)/2, 37);
    [loginBtn setBackgroundColor:UIColorWithRGB(0xfd4d4c)];
    [loginBtn addTarget:self action:@selector(loginBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    loginBtn.layer.cornerRadius = 2.0f;
    loginBtn.layer.masksToBounds = YES;
    [btnBKView addSubview:loginBtn];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake((ScreenWidth - 60)/2, CGRectGetMaxY(loginBtn.frame) + 20 , 60, 20);
    [moreBtn addTarget:self action:@selector(moreBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setTitle:@"更多>>" forState:UIControlStateNormal];
//    [moreBtn setImage:[UIImage imageNamed:@"particular_icon_up.png"] forState:UIControlStateNormal];
//    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0,40,0,0);
//    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnBKView addSubview:moreBtn];
    
    //上图标和label
//    _upIconView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 15)];
//    CGPoint center = _upIconView.center;
//    center.x = btnBKView.center.x;
//    _upIconView.center = center;
//    [btnBKView addSubview:_upIconView];
//    
//    _iconOne = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 15, 15)];
//    _iconOne.image = [UIImage imageNamed:@"icon_xindai.png"];
//    [_upIconView addSubview:_iconOne];
//    
//    _LabelOne = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(_iconOne.frame) + 3, 0,200, 15) text:@"中国信贷(08207.HK)" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:15]];
//    _LabelOne.textAlignment = NSTextAlignmentLeft;
//    _LabelOne.numberOfLines = 1;
//    [_upIconView addSubview:_LabelOne];
    
//    _iconOne = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 15, 15)];
//    _iconOne.image = [UIImage imageNamed:@"icon_wdhyxh.png"];
//    [_upIconView addSubview:_iconOne];
    
    
    //下图标和label
//    _downIconView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_upIconView.frame) + 8, ScreenWidth, 15)];
//    CGPoint center1 = _downIconView.center;
//    center1.x = btnBKView.center.x;
//    _downIconView.center = center1;
//    [btnBKView addSubview:_downIconView];
//    
//    _LabelTwo = [UILabel labelWithFrame:CGRectMake(0,0,200, 15) text:@"旗下专业互联网金融平台" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:15]];
//    _LabelTwo.textAlignment = NSTextAlignmentLeft;
//    _LabelTwo.numberOfLines = 1;
//    [_downIconView addSubview:_LabelTwo];
//    
//    [self resetLabelFrame];
    
    UIImageView *tabbarShadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 59, ScreenWidth, 10)];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    tabbarShadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    [self addSubview:tabbarShadowView];
}

//动态计算 确定两个label的中心
- (void)resetLabelFrame
{
    CGFloat stringWidth1 = [@"中国信贷(08207.HK)" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}].width;
    CGRect frame1 = _LabelOne.frame;
    frame1.size.width = stringWidth1;
    _LabelOne.frame = frame1;
    
    CGRect frame2 = _upIconView.frame;
    frame2.size.width = 15 + 3 + stringWidth1;
    frame2.origin.x = (ScreenWidth - (15 + 3 + stringWidth1)) / 2;
    _upIconView.frame = frame2;
    
    stringWidth1 = [@"旗下专业互联网金融平台" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}].width;
    frame1 = _LabelTwo.frame;
    frame1.size.width = stringWidth1;
    _LabelTwo.frame = frame1;
    
    CGRect frame3 = _downIconView.frame;
    frame3.size.width = stringWidth1;
    frame3.origin.x = (ScreenWidth - stringWidth1) / 2;
    _downIconView.frame = frame3;
}

- (void)loginBtnclicked:(id)sender
{
    [_delegate btnShadowClicked:sender];
}

- (void)regBtnclicked:(id)sender
{
    [_delegate regBtnclicked:sender];
}

- (void)moreBtnclicked:(id)sender
{
    [_delegate moreBtnclicked:sender];
}

@end
