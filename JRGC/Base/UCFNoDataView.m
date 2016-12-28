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

- (void)initViewControls
{
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 112) / 2, (self.frame.size.height - 112) / 2, 112, 112)];
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    
//    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 83, 83)];
//    iconImage.image = [UIImage imageNamed:@"default_icon.png"];
//    [centerView addSubview:iconImage];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 83, 83)];
    iconView.image = [UIImage imageNamed:@"default_icon.png"];
    [centerView addSubview:iconView];
    
    UILabel *errorLbl = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 15, 112, 14) text:_errorTitle textColor:UIColorWithRGB(0x8591b3) font:[UIFont systemFontOfSize:14]];
    [centerView addSubview:errorLbl];
    
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
