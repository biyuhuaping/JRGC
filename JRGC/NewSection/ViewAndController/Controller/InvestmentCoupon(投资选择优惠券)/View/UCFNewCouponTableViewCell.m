//
//  UCFNewCouponTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/3/13.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCouponTableViewCell.h"

@implementation UCFNewCouponTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
        

        [self.couponTypeLayout addSubview:self.willExpireLayout];
        [self.couponTypeLayout addSubview:self.investMultipLabel];
        [self.couponTypeLayout addSubview:self.inverstPeriodLabel];
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
        _couponAmounLabel.textColor = [UIColor whiteColor];
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
        _willExpireLayout.topPos.equalTo(self.couponTypeLayout.topPos).offset(-3);
        _willExpireLayout.rightPos.equalTo(self.couponTypeLayout.rightPos).offset(10);
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
        _investMultipLabel.textColor = UIColorWithRGB(0x999999);
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
@end
