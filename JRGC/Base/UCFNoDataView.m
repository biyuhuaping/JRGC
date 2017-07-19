//
//  UCFNoDataView.m
//  JRGC
//
//  Created by HeJing on 15/5/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFNoDataView.h"
#import "UILabel+Misc.h"

@interface UCFNoDataView ()
{
    NSString *_errorTitle;
    BOOL    isGold;
    NSString *_btnStr;
}

@end

@implementation UCFNoDataView

- (id)initWithFrame:(CGRect)frame errorTitle:(NSString*)titleStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        _errorTitle = titleStr;
        [self initViewControls];
    }
    return self;
}
- (id)initGoldWithFrame:(CGRect)frame errorTitle:(NSString*)titleStr buttonTitle:(NSString *)btnTitleStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        isGold = YES;
        _errorTitle = titleStr;
        _btnStr = btnTitleStr;
        [self initViewControls];
    }
    return self;
}
- (void)initViewControls
{
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 112) / 2, (self.frame.size.height - 112) / 2, 112, 112)];
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 83, 83)];
    NSString *imageStr = isGold ? @"gold_transaction_icon_NoRecords" : @"default_icon.png";
    iconView.image = [UIImage imageNamed:imageStr];
    [centerView addSubview:iconView];
    UIColor *showColor = isGold ? UIColorWithRGB(0xe3a257) : UIColorWithRGB(0x8591b3);
    UILabel *errorLbl = [UILabel labelWithFrame:CGRectMake(-20, CGRectGetMaxY(iconView.frame) + 15, 152, 14) text:_errorTitle textColor:showColor font:[UIFont systemFontOfSize:14]];
    [centerView addSubview:errorLbl];
    
    if (isGold && ![_btnStr isEqualToString:@""]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_btnStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor: UIColorWithRGB(0xe3a257)];
        button.layer.cornerRadius = 2.0f;
        button.frame = CGRectMake(15, CGRectGetMaxY(centerView.frame) + 25 , self.frame.size.width - 30, 37);
        [self addSubview:button];
    }
}

- (void)btnClicked:(id)sender
{
    [_delegate refreshBtnClicked:sender];
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
