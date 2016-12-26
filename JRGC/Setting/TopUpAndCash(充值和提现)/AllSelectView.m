//
//  AllSelectView.m
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "AllSelectView.h"
#import "Common.h"

@implementation AllSelectView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}
- (void)createViews
{
    UIView *keYongBaseView = [[UIView alloc] init];
    keYongBaseView.frame = CGRectMake(0, 0, ScreenWidth, 37.5);
    keYongBaseView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self addSubview:keYongBaseView];
    [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:keYongBaseView isTop:NO];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_normal.png"] forState:UIControlStateNormal];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_highlight.png"] forState:UIControlStateSelected];
    _selectedBtn.frame = CGRectMake(12, (37.5 - 25)/2.0, 25, 25);
    _selectedBtn.tag = 1000;
    [_selectedBtn addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
    [keYongBaseView addSubview:_selectedBtn];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectedBtn.frame) + 8,(37.5 - 13)/2, 30, 13)];
    _tipLabel.textColor = UIColorWithRGB(0x999999);
    _tipLabel.text = @"全选";
    _tipLabel.font = [UIFont systemFontOfSize:13.0f];
    _tipLabel.backgroundColor = [UIColor clearColor];
    [keYongBaseView addSubview:_tipLabel];
    
    _showNumSelectLabe = [[UILabel alloc] init];
    _showNumSelectLabe.frame = CGRectMake(CGRectGetMaxX(_tipLabel.frame) + 10, CGRectGetMinY(_tipLabel.frame) - 2, ScreenWidth - CGRectGetMaxX(_tipLabel.frame) - 10 - 15, 17);
    _showNumSelectLabe.font = [UIFont systemFontOfSize:13.0f];
    _showNumSelectLabe.textColor = UIColorWithRGB(0x999999);
    _showNumSelectLabe.text = @"已选2张,可返现¥2000";
    _showNumSelectLabe.textAlignment = NSTextAlignmentRight;
    [keYongBaseView addSubview:_showNumSelectLabe];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(15, CGRectGetMaxY(keYongBaseView.frame) + 10, ScreenWidth - 30, 37);
    _sureBtn.backgroundColor = UIColorWithRGB(0xfd4d4c);
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_sureBtn setTitle:@"确认使用" forState:UIControlStateNormal];
    _sureBtn.tag = 2000;
    _sureBtn.layer.cornerRadius = 2.0f;
    [_sureBtn addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
}
- (void)allSelected:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(allSelectedViewBtnClicked:)]) {
        [self.delegate allSelectedViewBtnClicked:button];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
