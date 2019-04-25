//
//  UCFNewCouponTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/3/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCouponTableViewCell.h"
#import "UCFToolsMehod.h"
#import "UIImage+Compression.h"
#import "Image.h"
@implementation UCFNewCouponTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        [self.rootLayout addSubview:self.couponTypeLayout];
        self.couponTypeLayout.layer.cornerRadius = 4.0f;
        self.couponTypeLayout.clipsToBounds = YES;
        self.couponTypeLayout.layer.borderWidth = 0.5;
        self.couponTypeLayout.layer.borderColor = [Color color:PGColorOptionCellSeparatorGray].CGColor;
        [self.couponTypeLayout addSubview:self.separteImageView];
        
        [self.couponTypeLayout addSubview:self.couponAmounLabel];
        [self.couponTypeLayout addSubview:self.remarkLabel];
        [self.couponTypeLayout addSubview:self.overdueTimeLabel];
        

        [self.rootLayout addSubview:self.willExpireLayout];
        [self.couponTypeLayout addSubview:self.investMultipLabel];
        [self.couponTypeLayout addSubview:self.inverstPeriodLabel];
        
        [self.couponTypeLayout addSubview:self.donateButton];
        [self.couponTypeLayout addSubview:self.investButton];
        
        
       
        [self.couponTypeLayout addSubview:self.printView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (MyRelativeLayout *)couponTypeLayout
{
    if (nil == _couponTypeLayout) {
        _couponTypeLayout = [MyRelativeLayout new];
        _couponTypeLayout.topPos.equalTo(@10);
        _couponTypeLayout.clipsToBounds = NO;
        _couponTypeLayout.leftPos.equalTo(@15);
        _couponTypeLayout.rightPos.equalTo(@15);
        _couponTypeLayout.heightSize.equalTo(@115);
        _couponTypeLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        
    }
    return _couponTypeLayout;
}
- (UIImageView *)separteImageView
{
    if (nil == _separteImageView) {
        _separteImageView = [[UIImageView alloc] init];
        _separteImageView.image = [UIImage imageNamed:@"cash_card_separte"];
        _separteImageView.rightPos.equalTo(@0);
        _separteImageView.leftPos.equalTo(@0);
        _separteImageView.heightSize.equalTo(@10);
        _separteImageView.bottomPos.equalTo(@25);
    }
    return _separteImageView;
}
- (NZLabel *)couponAmounLabel
{
    if (nil == _couponAmounLabel) {
        _couponAmounLabel = [NZLabel new];
        _couponAmounLabel.topPos.equalTo(@15);
        _couponAmounLabel.leftPos.equalTo(@15);
        _couponAmounLabel.rightPos.equalTo(@10);
        _couponAmounLabel.textAlignment = NSTextAlignmentLeft;
        _couponAmounLabel.font = [UIFont systemFontOfSize:30.0];
        
    }
    return _couponAmounLabel;
}
- (UILabel *)remarkLabel
{
    if (nil == _remarkLabel) {
        _remarkLabel = [UILabel new];
        _remarkLabel.topPos.equalTo(self.couponAmounLabel.bottomPos).offset(10);
        _remarkLabel.leftPos.equalTo(self.couponAmounLabel.leftPos);
        _remarkLabel.textAlignment = NSTextAlignmentLeft;
        _remarkLabel.font = [UIFont systemFontOfSize:10.0];
        _remarkLabel.textColor = [Color color:PGColorOptionTitleGray];
        //        [_titleLabel sizeToFit];
    }
    return _remarkLabel;
}
- (UILabel *)overdueTimeLabel
{
    if (nil == _overdueTimeLabel) {
        _overdueTimeLabel = [UILabel new];
        _overdueTimeLabel.centerYPos.equalTo(self.remarkLabel.centerYPos);
        _overdueTimeLabel.rightPos.equalTo(@15);
        _overdueTimeLabel.leftPos.equalTo(self.remarkLabel.rightPos);
        _overdueTimeLabel.textAlignment = NSTextAlignmentRight;
        _overdueTimeLabel.font = self.remarkLabel.font;
        _overdueTimeLabel.textColor = self.remarkLabel.textColor;
        //        [_titleLabel sizeToFit];
    }
    return _overdueTimeLabel;
}
- (MyRelativeLayout *)willExpireLayout
{
    if (nil == _willExpireLayout) {
        _willExpireLayout = [MyRelativeLayout new];
        _willExpireLayout.topPos.equalTo(@5);
        _willExpireLayout.rightPos.equalTo(@25);
        _willExpireLayout.widthSize.equalTo(@63);
        _willExpireLayout.heightSize.equalTo(@17);
        _willExpireLayout.clipsToBounds = NO;
        UIImageView *willExpireImageView = [[UIImageView alloc] init];
        // 加载图片
        UIImage *image = [UIImage imageNamed:@"invest_bg_label"];
        // 设置左边端盖宽度
        NSInteger leftCapWidth = image.size.width * 0.5;
        // 设置上边端盖高度
        NSInteger topCapHeight = image.size.height * 0.5;
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        willExpireImageView.image= newImage;
        willExpireImageView.topPos.equalTo(@0);
        willExpireImageView.rightPos.equalTo(@0);
        willExpireImageView.widthSize.equalTo(@63);
        willExpireImageView.heightSize.equalTo(@17);
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.topPos.equalTo(willExpireImageView.topPos).offset(3);
        label.bottomPos.equalTo(willExpireImageView.bottomPos).offset(3);
        label.leftPos.equalTo(willExpireImageView.leftPos).offset(5);
        label.rightPos.equalTo(willExpireImageView.rightPos).offset(5);
        label.font = [UIFont systemFontOfSize:10.0];
        label.textColor = [UIColor whiteColor];
        label.text = @"即将过期";
        label.textAlignment = NSTextAlignmentCenter;
        [_willExpireLayout addSubview:willExpireImageView];
        [_willExpireLayout addSubview:label];
        _willExpireLayout.myVisibility = MyVisibility_Gone;
        
    }
    return _willExpireLayout;
}
- (UILabel *)investMultipLabel
{
    if (nil == _investMultipLabel) {
        _investMultipLabel = [UILabel new];
        _investMultipLabel.bottomPos.equalTo(@10);
        _investMultipLabel.leftPos.equalTo(self.remarkLabel.leftPos);
        _investMultipLabel.font = self.remarkLabel.font;
        _investMultipLabel.textColor = [Color color:PGColorOptionTitleGray];
        //        [_titleLabel sizeToFit];
    }
    return _investMultipLabel;
}
- (UILabel *)inverstPeriodLabel
{
    if (nil == _inverstPeriodLabel) {
        _inverstPeriodLabel = [UILabel new];
        _inverstPeriodLabel.centerYPos.equalTo(self.investMultipLabel.centerYPos);
        _inverstPeriodLabel.rightPos.equalTo(@15);
        _inverstPeriodLabel.textAlignment = NSTextAlignmentRight;
        _inverstPeriodLabel.font = self.remarkLabel.font;
        _inverstPeriodLabel.textColor = self.investMultipLabel.textColor;
        //        [_titleLabel sizeToFit];
    }
    return _inverstPeriodLabel;
}
- (UIButton *)donateButton
{
    if (!_donateButton) {
        _donateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _donateButton.mySize = CGSizeMake(50, 25);
        _donateButton.layer.cornerRadius = 12.5;
        _donateButton.clipsToBounds = YES;
        _donateButton.rightPos.equalTo(@80);
        _donateButton.topPos.equalTo(@18);
        _donateButton.layer.borderColor = [Color color:PGColorOptionTitlerRead].CGColor;
        _donateButton.layer.borderWidth = 1.0f;

    }
    return _donateButton;
}
- (UIButton *)investButton
{
    if (!_investButton) {
        _investButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _investButton.mySize = CGSizeMake(50, 25);
        _investButton.layer.cornerRadius = 12.5;
        _investButton.clipsToBounds = YES;
        _investButton.rightPos.equalTo(@15);
        _investButton.topPos.equalTo(@18);
        UIImage *image = [UIImage gc_styleImageSize:CGSizeMake(50, 25)];
        [_investButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _investButton;
}
- (PrintView *)printView
{
    if (!_printView) {
        _printView = [[PrintView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 30, 115) andTime:@"xxxx-xx-xx"];
        [_printView setBackgroundColor:[UIColor clearColor]];
    }
    return _printView;

}

- (void)setModel:(UCFCouponListResult *)model
{
    _model = model;
    switch ([model.isUsed intValue]) {
        case 0:{//未使用
            self.printView.myVisibility = MyVisibility_Gone;
            [self.investButton setTitle:@"使用" forState:UIControlStateNormal];
            [self.donateButton setTitle:@"转赠" forState:UIControlStateNormal];
         
            self.investButton.titleLabel.font = [Color gc_Font:13];
            self.donateButton.titleLabel.font = [Color gc_Font:13];
            if ([model.inverstPeriod isEqualToString:@"0"] || [model.inverstPeriod isEqualToString:@""]) {//0 通用   "" 旧返现券
                self.inverstPeriodLabel.text = @"任意标可用";
            }else{
                if (model.couponType == 1) {
                    [self.investButton setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
                    [self.donateButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
                    self.donateButton.layer.borderColor = [Color color:PGColorOptionCellContentBlue].CGColor;

                    self.couponAmounLabel.textColor = [Color color:PGColorOptionCellContentBlue];
                    self.couponAmounLabel.text = [NSString stringWithFormat:@"%@",model.backIntrestRate];
                    [self.couponAmounLabel setFont:[UIFont systemFontOfSize:15] string:@"%"];
                    UIImage *image = [Image createImageWithColor:[Color color:PGColorOptionCellContentBlue] withCGRect:CGRectMake(0, 0, 50, 25)];
                    [_investButton setBackgroundImage:image forState:UIControlStateNormal];
                }
                else {
                    [self.investButton setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
                    [self.donateButton setTitleColor:[Color color:PGColorOpttonRateNoramlTextColor] forState:UIControlStateNormal];
                    self.couponAmounLabel.text = [NSString stringWithFormat:@"¥%@",model.useInvest];
                    [self.couponAmounLabel setFont:[UIFont systemFontOfSize:15] string:@"¥"];
                    self.couponAmounLabel.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
                }
            }
        }
            break;
        case 1:{ //已过期
            self.couponAmounLabel.textColor =  [Color color:PGColorOptionTitleGray];
            self.investButton.myVisibility = MyVisibility_Gone;
            self.donateButton.myVisibility = MyVisibility_Gone;
            if ([model.inverstPeriod isEqualToString:@"0"] || [model.inverstPeriod isEqualToString:@""]) {//0 通用   "" 旧返现券
                self.inverstPeriodLabel.text = @"任意标可用";
            } else {
                self.printView.conponType = 2;
                if (model.couponType == 1) {
                    self.couponAmounLabel.textColor = [Color color:PGColorOptionTitleGray];
                    self.couponAmounLabel.text = [NSString stringWithFormat:@"%@",model.backIntrestRate];
                    [self.couponAmounLabel setFont:[UIFont systemFontOfSize:15] string:@"%"];
                } else {
                    self.couponAmounLabel.textColor = [Color color:PGColorOptionTitleGray];
                    self.couponAmounLabel.text = [NSString stringWithFormat:@"¥%@",model.useInvest];
                    [self.couponAmounLabel setFont:[UIFont systemFontOfSize:15] string:@"¥"];
                }
            }
        }
            break;
        case 2:{ //已使用
            self.couponAmounLabel.textColor =  [Color color:PGColorOptionTitleGray];
            self.investButton.myVisibility = MyVisibility_Gone;
            self.donateButton.myVisibility = MyVisibility_Gone;
            if ([model.inverstPeriod isEqualToString:@"0"] || [model.inverstPeriod isEqualToString:@""]) {//0 通用   "" 旧返现券
                self.inverstPeriodLabel.text = @"任意标可用";
            } else {
                self.printView.useTime = model.useTime;
                if (model.couponType == 1) {
                    self.couponAmounLabel.textColor = [Color color:PGColorOptionTitleGray];
                    self.couponAmounLabel.text = [NSString stringWithFormat:@"%@",model.backIntrestRate];
                    [self.couponAmounLabel setFont:[UIFont systemFontOfSize:15] string:@"%"];
                } else {
                    self.couponAmounLabel.textColor = [Color color:PGColorOptionTitleGray];
                    self.couponAmounLabel.text = [NSString stringWithFormat:@"¥%@",model.useInvest];
                    [self.couponAmounLabel setFont:[UIFont systemFontOfSize:15] string:@"¥"];
                }
            }
        }
            break;
            default:
            break;
    }

    
    NSString *temp = [UCFToolsMehod AddComma:model.investMultip];

    self.investMultipLabel.text = [NSString stringWithFormat:@"投资金额 ≥%@元可用", temp];
    self.remarkLabel.text = model.remark;
    self.overdueTimeLabel.text = [NSString stringWithFormat:@"有效期至 %@", model.overdueTime];
    self.inverstPeriodLabel.text = [NSString stringWithFormat:@"投资期限 ≥%@天可用",model.inverstPeriod];
    [self.couponAmounLabel sizeToFit];
    [self.investMultipLabel sizeToFit];
    [self.remarkLabel sizeToFit];
    [self.overdueTimeLabel sizeToFit];
    [self.inverstPeriodLabel sizeToFit];
    self.willExpireLayout.hidden = ([model.flag integerValue] == 0) ? NO : YES;
    self.donateButton.hidden = ([model.isDonateEnable integerValue] == 0) ? YES : NO;//是否可赠送    0：否 1：是
}

@end
