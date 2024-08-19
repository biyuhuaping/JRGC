//
//  UCFNewAITableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewAITableViewCell.h"
#import "UCFProjectLabel.h"
//#import "UIButton+Gradient.h"
#import "UILabel+Misc.h"
#import "UIImage+Compression.h"
@interface UCFNewAITableViewCell()
/**
 标题
 */
@property(nonatomic, strong)UILabel     *titleLab;
@property(strong, nonatomic)UIImageView *imageView1;
@property(strong, nonatomic)UIImageView *imageView2;
@property(strong, nonatomic)UIImageView *imageView3;
@property(strong, nonatomic)UIImageView *imageView4;
@property(strong, nonatomic)UILabel    *tiplabel;

@property(nonatomic, strong) UIButton  *investButton;
@property(nonatomic, strong) UILabel *rateLab;              //利率
@property(nonatomic, strong) UILabel *rateTipLab;           //利率提示标签
@property(nonatomic, strong) UILabel *timeLimitLab;         //期限
@property(nonatomic, strong) UILabel *timeLimitTipLab;      //期限提示标签

@property(nonatomic, strong)UIImageView *iconView;
@end
@implementation UCFNewAITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        
        MyRelativeLayout *whitBaseView = [MyRelativeLayout new];
        whitBaseView.leftPos.equalTo(@15);
        whitBaseView.rightPos.equalTo(@15);
        whitBaseView.topPos.equalTo(@10);
        whitBaseView.bottomPos.equalTo(@0);
        whitBaseView.backgroundColor = [UIColor whiteColor];
        whitBaseView.layer.cornerRadius = 5.0f;
        [self.rootLayout addSubview:whitBaseView];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.myHeight = 18;
        iconView.myWidth = 3;
        iconView.leftPos.equalTo(@15);
        iconView.myTop = 20;
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 1.5;
        self.iconView = iconView;
        [whitBaseView addSubview:iconView];
        
        UILabel *label = [[UILabel alloc] init];
        label.leftPos.equalTo(iconView.rightPos).offset(8);
        label.centerYPos.equalTo(iconView.centerYPos);
        label.text = @"新手专享";
        [whitBaseView addSubview:label];
        [label sizeToFit];
        self.titleLab = label;
        
        self.imageView1.centerYPos.equalTo(iconView.centerYPos);
        self.imageView1.leftPos.equalTo(self.titleLab.rightPos).offset(2);
        self.imageView1.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView1];
        self.imageView1.myVisibility = MyVisibility_Gone;
        
        self.imageView2.centerYPos.equalTo(iconView.centerYPos);
        self.imageView2.leftPos.equalTo(self.imageView1.rightPos).offset(1.5);
        self.imageView2.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView2];
        
        self.imageView2.myVisibility = MyVisibility_Gone;
        
        self.imageView3.centerYPos.equalTo(iconView.centerYPos);
        self.imageView3.leftPos.equalTo(self.imageView2.rightPos).offset(1.5);
        self.imageView3.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView3];
        
        self.imageView3.myVisibility = MyVisibility_Gone;
        
        self.imageView4.centerYPos.equalTo(iconView.centerYPos);
        self.imageView4.leftPos.equalTo(self.imageView3.rightPos).offset(1.5);
        self.imageView4.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView4];
        
        self.imageView4.myVisibility = MyVisibility_Gone;
        
        UILabel *tiplab = [[UILabel alloc] init];
        tiplab.leftPos.equalTo(self.imageView4.rightPos).offset(2);
        tiplab.centerYPos.equalTo(iconView.centerYPos);
        tiplab.heightSize.equalTo(@20);
//        tiplab.text = @"智能分散出借";
        tiplab.textAlignment = NSTextAlignmentCenter;
//        CGSize size = [Common getStrWitdth:@"智能分散出借" Font:11];
        tiplab.font = [Color gc_Font:11];
        tiplab.textColor = [Color color:PGColorOptionTitleOrange];
        [whitBaseView addSubview:tiplab];
        [tiplab sizeToFit];
        
//        tiplab.myWidth = size.width + 10;
        [tiplab setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.layer.borderColor = [Color color:PGColorOptionTitleOrange].CGColor;
            v.layer.cornerRadius = 10;
            v.layer.borderWidth = 1.0f;
        }];
        self.tiplabel = tiplab;
        
        self.investButton.mySize = CGSizeMake(90, 35);
        self.investButton.bottomPos.equalTo(@23);
        self.investButton.rightPos.equalTo(whitBaseView.rightPos).offset(20);
        [self.investButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [whitBaseView addSubview:self.investButton];
        [self.investButton setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.clipsToBounds = YES;
            v.layer.cornerRadius = CGRectGetHeight(v.frame)/2;

        }];
        
        
        self.rateLab.leftPos.equalTo(self.titleLab.leftPos);
        self.rateLab.topPos.equalTo(self.investButton.topPos).offset(-15);
        [whitBaseView addSubview:self.rateLab];
        
        self.rateTipLab.leftPos.equalTo(self.rateLab.leftPos);
        self.rateTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(20);
        [whitBaseView addSubview:self.rateTipLab];
        self.rateTipLab.textColor = [Color color:PGColorOptionTitleGray];
        

        self.timeLimitTipLab.centerXPos.equalTo(whitBaseView.centerXPos).offset(-10);;
        self.timeLimitTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(20);
        self.timeLimitTipLab.textColor = [Color color:PGColorOptionTitleGray];
        [whitBaseView addSubview:self.timeLimitTipLab];
        
        self.timeLimitLab.leftPos.equalTo(self.timeLimitTipLab.leftPos);
        self.timeLimitLab.bottomPos.equalTo(self.rateLab.bottomPos).offset(5);
        [whitBaseView addSubview:self.timeLimitLab];
    }
    return self;
}
- (void)click:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(aiTableViewCell:didClickedInvestButtonWithModel:)]) {
        [self.delegate aiTableViewCell:self didClickedInvestButtonWithModel:_microModel];
    }
}
- (void)setMicroModel:(UCFMicroMoneyModel *)microModel
{
    _microModel = microModel;
    self.rateLab.text = microModel.annualRate ? [NSString stringWithFormat:@"%@%%",microModel.annualRate] : @"0.0%";
    [self.rateLab setFont:[UIFont systemFontOfSize:16] string:@"%"];
    [self.rateLab sizeToFit];
    self.timeLimitLab.text = [NSString stringWithFormat:@"%@", microModel.repayPeriodtext];
    if ([self.timeLimitLab.text containsString:@"天"]) {
        [self.timeLimitLab setFont:[UIFont systemFontOfSize:16] string:@"天"];
    } else {
        [self.timeLimitLab setFont:[UIFont systemFontOfSize:16] string:@"个月"];
    }
    [self.timeLimitLab sizeToFit];
    self.titleLab.text = microModel.prdName;
    [self.titleLab sizeToFit];
    NSUInteger type = [microModel.type integerValue];

    switch (type) {
        case 0://预约
        {
            _microModel.modelType = UCFMicroMoneyModelTypeReserve;
            if([microModel.status intValue] == 2)
            {
                [self.investButton setTitle:@"立即预约" forState:UIControlStateNormal];
                self.investButton.userInteractionEnabled = YES;

            }else{
                self.investButton.userInteractionEnabled = NO;
                [self.investButton setTitle:@"预约已满" forState:UIControlStateNormal];
            }
            
        }
            break;
        case 3://智存宝用3
        {
            _microModel.modelType = UCFMicroMoneyModelTypeIntelligent;
            if([microModel.status intValue] == 2)
            {
                self.investButton.userInteractionEnabled = YES;
                NSString *buttonStr = @"立即出借";
                [self.investButton setTitle:buttonStr forState:UIControlStateNormal];
                
            }else{
                self.investButton.userInteractionEnabled = NO;
                [self.investButton setTitle:@"已售罄" forState:UIControlStateNormal];

                
            }
        }
            break;
        case 14://批量出借
        {
            _microModel.modelType = UCFMicroMoneyModelTypeBatchBid;
            if([microModel.status intValue] == 2)
            {
                NSString *buttonStr = @"一键出借";
                [self.investButton setTitle:buttonStr forState:UIControlStateNormal];
                self.investButton.userInteractionEnabled = YES;
            }else{
                self.investButton.userInteractionEnabled = NO;
                [self.investButton setTitle:@"已售罄" forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
    
    if ([microModel.status intValue] == 2) {
        self.rateLab.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
        self.timeLimitLab.textColor = [Color color:PGColorOptionTitleBlack];
        NSArray *colorArray = [NSArray arrayWithObjects:UIColorWithRGB(0xFF4133),UIColorWithRGB(0xFF7F40), nil];
        UIImage *image = [UIImage imageGradientByColorArray:colorArray ImageSize:CGSizeMake(90, 35) gradientType:leftToRight];
        self.iconView.backgroundColor = [Color color:PGColorOptionTitleOrange];;
        [self.investButton setBackgroundImage:image forState:UIControlStateNormal];
        
    } else {
        NSArray *colorArray = [NSArray arrayWithObjects:[Color color:PGColorOpttonBtnBackgroundColor],[Color color:PGColorOpttonBtnBackgroundColor], nil];
        UIImage *image = [UIImage imageGradientByColorArray:colorArray ImageSize:CGSizeMake(90, 35) gradientType:leftToRight];
        [self.investButton setBackgroundImage:image forState:UIControlStateNormal];
        self.rateLab.textColor = [Color color:PGColorOptionTitleGray];
        self.timeLimitLab.textColor = [Color color:PGColorOptionTitleGray];
        self.iconView.backgroundColor = [Color color:PGColorOptionTitleGray];;
        
    }
    if ([microModel.status intValue] == 2) {
        if (microModel.prdLabelsList.count > 0) {
            UCFProjectLabel *projectLabel = [microModel.prdLabelsList firstObject];
            if ([projectLabel.labelPriority integerValue] == 1) {
                self.tiplabel.hidden = NO;
                self.tiplabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
                [self.titleLab sizeToFit];
                CGSize size = [Common getStrWitdth:projectLabel.labelName Font:11];
                self.tiplabel.myWidth = size.width + 10;
            }
            else {
                self.tiplabel.hidden = YES;
            }
        }
        else {
            self.tiplabel.hidden = YES;
        }
    } else {
        self.tiplabel.hidden = YES;
    }

    if (microModel.platformSubsidyExpense.length > 0 && [microModel.platformSubsidyExpense floatValue] > 0.01) {//贴
        self.imageView1.myVisibility = MyVisibility_Visible;
    }
    else {
        self.imageView1.myVisibility = MyVisibility_Gone;
    }
    if (microModel.guaranteeCompany.length > 0) {//贴
        self.imageView2.myVisibility = MyVisibility_Visible;
    }
    else {
        self.imageView2.myVisibility = MyVisibility_Gone;
    }
    if (microModel.fixedDate.length > 0) {//贴
        self.imageView3.myVisibility = MyVisibility_Visible;
    }
    else {
        self.imageView3.myVisibility = MyVisibility_Gone;
    }
    if (microModel.holdTime.length > 0) {//贴
        self.imageView4.myVisibility = MyVisibility_Visible;
    }
    else {
        self.imageView4.myVisibility = MyVisibility_Gone;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.backgroundColor = [UIColor clearColor];
        _imageView1.image = [UIImage imageNamed:@"invest_icon_buletie"];
        
    }
    return _imageView1;
}
- (UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.backgroundColor = [UIColor clearColor];
        _imageView2.image = [UIImage imageNamed:@"particular_icon_guarantee_dark"];
    }
    return _imageView2;
}
- (UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc] init];
        _imageView3.backgroundColor = [UIColor clearColor];
        _imageView3.image = [UIImage imageNamed:@"invest_icon_ling"];
    }
    return _imageView3;
}
- (UIImageView *)imageView4{
    if (!_imageView4) {
        _imageView4 = [[UIImageView alloc] init];
        _imageView4.backgroundColor = [UIColor clearColor];
        _imageView4.image = [UIImage imageNamed:@"invest_icon_redgu-1"];
    }
    return _imageView4;
}
- (UILabel *)rateLab
{
    if (!_rateLab) {
        _rateLab = [[UILabel alloc] init];
        _rateLab.textColor = UIColorWithRGB(0xfd4d4c);
        //        _rateLab.font = [UIFont boldSystemFontOfSize:16.0f];
        _rateLab.text = @"9.5%";
        _rateLab.font = [Color gc_ANC_font:32.0f];
        [_rateLab sizeToFit];
    }
    return _rateLab;
}
- (UIButton *)investButton
{
    if (!_investButton) {
        _investButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _progressView.backgroundColor = [UIColor yellowColor];
        _investButton.titleLabel.font  = [Color gc_Font:14];
        [_investButton setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];

    }
    return _investButton;
}
- (UILabel *)rateTipLab
{
    if (!_rateTipLab) {
        _rateTipLab = [[UILabel alloc] init];
        _rateTipLab.textColor = UIColorWithRGB(0x777777);
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
        _timeLimitLab.textColor = UIColorWithRGB(0x333333);
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
        _timeLimitTipLab.textColor = UIColorWithRGB(0x777777);
        _timeLimitTipLab.font = [UIFont systemFontOfSize:12.0f];
        _timeLimitTipLab.text = @"出借期限";
        [_timeLimitTipLab sizeToFit];
    }
    return _timeLimitTipLab;
}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
