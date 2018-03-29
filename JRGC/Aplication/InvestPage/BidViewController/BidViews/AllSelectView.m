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
    _keYongBaseView = [[UIView alloc] init];
    _keYongBaseView.frame = CGRectMake(0, 0, ScreenWidth, 37.5);
    _keYongBaseView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self addSubview:_keYongBaseView];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_normal.png"] forState:UIControlStateNormal];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_highlight.png"] forState:UIControlStateSelected];
    _selectedBtn.frame = CGRectMake(12, (37.5 - 25)/2.0, 25, 25);
    _selectedBtn.tag = 1000;
    [_selectedBtn addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_keYongBaseView addSubview:_selectedBtn];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectedBtn.frame) + 8,(37.5 - 13)/2, 30, 13)];
    _tipLabel.textColor = UIColorWithRGB(0x999999);
    _tipLabel.text = @"全选";
    _tipLabel.font = [UIFont systemFontOfSize:13.0f];
    _tipLabel.backgroundColor = [UIColor clearColor];
    [_keYongBaseView addSubview:_tipLabel];
    
    _showNumSelectLabe = [[UILabel alloc] init];
    _showNumSelectLabe.frame = CGRectMake(15, 10, ScreenWidth - 30, 15);
    _showNumSelectLabe.font = [UIFont systemFontOfSize:13.0f];
    _showNumSelectLabe.textColor = UIColorWithRGB(0x999999);
    _showNumSelectLabe.text = @"已选2张,可返现¥2000";
    _showNumSelectLabe.textAlignment = NSTextAlignmentRight;
    [_keYongBaseView addSubview:_showNumSelectLabe];
    
    NSString *showStr = @"投资按月/季等额还款项目，最终返息获得工豆需要乘以0.56。0.56为借款方占用投资方自己的使用率";
    CGSize size = [Common getStrHeightWithStr:showStr AndStrFont:13 AndWidth:ScreenWidth - 30];
    _showNumTipLab = [[UILabel alloc] init];
    _showNumTipLab.frame = CGRectMake(15, CGRectGetMaxY(_showNumSelectLabe.frame) + 5 , ScreenWidth - 30, size.height);
    _showNumTipLab.font = [UIFont systemFontOfSize:13.0f];
    _showNumTipLab.textColor = UIColorWithRGB(0x999999);
    _showNumTipLab.text = showStr;
    _showNumTipLab.numberOfLines = 0;
    _showNumTipLab.textAlignment = NSTextAlignmentLeft;
    [_keYongBaseView addSubview:_showNumTipLab];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(15, CGRectGetMaxY(_keYongBaseView.frame) + 10, ScreenWidth - 30, 37);
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
