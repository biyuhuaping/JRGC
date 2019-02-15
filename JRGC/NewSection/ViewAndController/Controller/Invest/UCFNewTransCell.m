//
//  UCFNewTransCell.m
//  JRGC
//
//  Created by zrc on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewTransCell.h"
#import "NSObject+Compression.h"
#import "UIView+RoundingCorners.h"
#import "UILabel+Misc.h"
@interface UCFNewTransCell()
@property(nonatomic, strong) UILabel *rateLab;              //利率
@property(nonatomic, strong) UILabel *rateTipLab;           //利率提示标签
@property(nonatomic, strong) UILabel *timeLimitLab;         //期限
@property(nonatomic, strong) UILabel *timeLimitTipLab;      //期限提示标签
@property(nonatomic, strong) UILabel *remainMoneyLab;       //剩余金额
@property(nonatomic, strong) UILabel *remainMoneyTipLab;    //剩余金额提示标签

@property(nonatomic, strong) UIButton *addRateTipView;   //奖励工豆标签

@end



@implementation UCFNewTransCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        
        MyRelativeLayout *whitBaseView = [MyRelativeLayout new];
        whitBaseView.leftPos.equalTo(@15);
        whitBaseView.rightPos.equalTo(@15);
        whitBaseView.topPos.equalTo(@10);
        whitBaseView.bottomPos.equalTo(@0);
        whitBaseView.backgroundColor = [UIColor whiteColor];
        whitBaseView.layer.cornerRadius = 5.0f;
        [self.rootLayout addSubview:whitBaseView];
        
        self.addRateTipView.rightPos.equalTo(whitBaseView.rightPos);
        self.addRateTipView.mySize = CGSizeMake(90, 20);
        self.addRateTipView.myTop = 12;
        [whitBaseView addSubview:self.addRateTipView];
        [self.addRateTipView setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            [v rc_bezierPathWithRoundedRect:v.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
        }];
        
        
        NSArray *colorArray = [NSArray arrayWithObjects:UIColorWithRGB(0xFF4133),UIColorWithRGB(0xFF7F40), nil];
        UIImage *image = [self.addRateTipView imageGradientByColorArray:colorArray ImageSize:CGSizeMake(90, 20) gradientType:leftToRight];
        [self.addRateTipView setBackgroundImage:image forState:UIControlStateNormal];
        
        self.rateLab.leftPos.equalTo(@25);
        self.rateLab.topPos.equalTo(@25);
        [whitBaseView addSubview:self.rateLab];

        self.rateTipLab.leftPos.equalTo(@25);
        self.rateTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(20);
        [whitBaseView addSubview:self.rateTipLab];

        self.timeLimitLab.centerXPos.equalTo(whitBaseView.centerXPos);
        self.timeLimitLab.bottomPos.equalTo(self.rateLab.bottomPos).offset(5);
        [whitBaseView addSubview:self.timeLimitLab];
        
        self.timeLimitTipLab.leftPos.equalTo(self.timeLimitLab.leftPos);
        self.timeLimitTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(20);
        [whitBaseView addSubview:self.timeLimitTipLab];
        
        self.remainMoneyTipLab.rightPos.equalTo(whitBaseView.rightPos).offset(60);
        self.remainMoneyTipLab.bottomPos.equalTo(self.rateTipLab.bottomPos);
        [whitBaseView addSubview:self.remainMoneyTipLab];
        
        self.remainMoneyLab.leftPos.equalTo(self.remainMoneyTipLab.leftPos);
        self.remainMoneyLab.bottomPos.equalTo(self.timeLimitLab.bottomPos);
        [whitBaseView addSubview:self.remainMoneyLab];

    }
    return self;
}
- (void)setModel:(UCFTransferModel *)model
{
    _model = model;
    if ([_model.discountRate floatValue] >= 0.01) {
        _addRateTipView.myVisibility = MyVisibility_Visible;
        NSString *showStr = [NSString stringWithFormat:@"奖本金%@%%工豆",_model.discountRate];
        [_addRateTipView setTitle:showStr forState:UIControlStateNormal];
        
    } else {
        _addRateTipView.myVisibility = MyVisibility_Gone;
    }
    
    self.rateLab.text = [NSString stringWithFormat:@"%@%%",_model.transfereeYearRate];
    [self.rateLab setFont:[UIFont systemFontOfSize:16] string:@"%"];
    [self.rateLab sizeToFit];
    
    self.timeLimitLab.text = [NSString stringWithFormat:@"%@天",_model.lastDays];
    [self.timeLimitLab setFont:[UIFont systemFontOfSize:16] string:@"天"];
    
    self.remainMoneyLab.text = [NSString stringWithFormat:@"¥%@",_model.cantranMoney];
    [self.timeLimitLab sizeToFit];
    [self.remainMoneyLab sizeToFit];
    
//    self.
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma ViewInIt
- (UILabel *)rateLab
{
    if (!_rateLab) {
        _rateLab = [[UILabel alloc] init];
        _rateLab.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
        _rateLab.textColor = UIColorWithRGB(0xFF4133);
        _rateLab.text = @"9.5%";
        _rateLab.font = [Color gc_ANC_font:32.0f];
        [_rateLab sizeToFit];
    }
    return _rateLab;
}

- (UILabel *)rateTipLab
{
    if (!_rateTipLab) {
        _rateTipLab = [[UILabel alloc] init];
        _rateTipLab.textColor = [Color color:PGColorOptionTitleGray];
        _rateTipLab.font = [UIFont systemFontOfSize:12.0f];
        _rateTipLab.text = @"预期年化利率";
        [_rateTipLab sizeToFit];
    }
    return _rateTipLab;
}
- (UILabel *)timeLimitLab
{
    if (!_timeLimitLab) {
        _timeLimitLab = [[UILabel alloc] init];
        _timeLimitLab.textColor = [Color color:PGColorOptionTitleBlackGray];
        _timeLimitLab.font = [Color gc_ANC_font:20.0f];
        _timeLimitLab.text = @"30天";
        [_timeLimitLab sizeToFit];
    }
    return _timeLimitLab;
}
- (UILabel *)timeLimitTipLab
{
    if (!_timeLimitTipLab) {
        _timeLimitTipLab = [[UILabel alloc] init];
        _timeLimitTipLab.textColor = [Color color:PGColorOptionTitleGray];
        _timeLimitTipLab.font = [UIFont systemFontOfSize:12.0f];
        _timeLimitTipLab.text = @"剩余期限";
        [_timeLimitTipLab sizeToFit];
    }
    return _timeLimitTipLab;
}
- (UILabel *)remainMoneyLab
{
    if (!_remainMoneyLab) {
        _remainMoneyLab = [[UILabel alloc] init];
        _remainMoneyLab.textColor = [Color color:PGColorOptionTitleBlackGray];
        _remainMoneyLab.font = [Color gc_ANC_font:20.0f];
        _remainMoneyLab.text = @"¥234567";
        [_remainMoneyLab sizeToFit];
    }
    return _remainMoneyLab;
}
- (UILabel *)remainMoneyTipLab
{
    if (!_remainMoneyTipLab) {
        _remainMoneyTipLab = [[UILabel alloc] init];
        _remainMoneyTipLab.textColor = [Color color:PGColorOptionTitleGray];
        _remainMoneyTipLab.font = [UIFont systemFontOfSize:12.0f];
        _remainMoneyTipLab.text = @"可投金额";
        [_remainMoneyTipLab sizeToFit];
    }
    return _remainMoneyTipLab;
}
- (UIButton *)addRateTipView
{
    if (!_addRateTipView) {
        _addRateTipView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addRateTipView setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        _addRateTipView.titleLabel.font = [Color gc_Font:10];
    }
    return _addRateTipView;
}
@end
