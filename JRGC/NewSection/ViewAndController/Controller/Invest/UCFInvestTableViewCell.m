//
//  UCFInvestTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/1/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFInvestTableViewCell.h"
@interface UCFInvestTableViewCell()

/**
 标题
 */
@property(nonatomic, strong)UILabel     *titleLab;
@property(strong, nonatomic)UIImageView *imageView1;
@property(strong, nonatomic)UIImageView *imageView2;
@property(strong, nonatomic)UIImageView *imageView3;
@property(strong, nonatomic)UIImageView *imageView4;
@property(strong, nonatomic)UILabel    *tiplabel;

@property(nonatomic, strong) UIView  *progressView;
@property(nonatomic, strong) UILabel *rateLab;              //利率
@property(nonatomic, strong) UILabel *rateTipLab;           //利率提示标签
@property(nonatomic, strong) UILabel *timeLimitLab;         //期限
@property(nonatomic, strong) UILabel *timeLimitTipLab;      //期限提示标签
@end

@implementation UCFInvestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.myHeight = 18;
        iconView.myWidth = 3;
        iconView.leftPos.equalTo(@15);
        iconView.myTop = 20;
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 2;
        [whitBaseView addSubview:iconView];
        
        UILabel *label = [[UILabel alloc] init];
        label.leftPos.equalTo(iconView.rightPos).offset(8);
        label.centerYPos.equalTo(iconView.centerYPos);
        label.text = @"新手专享";
        [whitBaseView addSubview:label];
        [label sizeToFit];
        self.titleLab = label;
        
        self.imageView1.centerYPos.equalTo(iconView.centerYPos);
        self.imageView1.leftPos.equalTo(self.titleLab.rightPos);
        self.imageView1.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView1];
//        self.imageView1.myVisibility = MyVisibility_Gone;
        
        self.imageView2.centerYPos.equalTo(iconView.centerYPos);
        self.imageView2.leftPos.equalTo(self.imageView1.rightPos);
        self.imageView2.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView2];

//        self.imageView2.myVisibility = MyVisibility_Gone;
        
        self.imageView3.centerYPos.equalTo(iconView.centerYPos);
        self.imageView3.leftPos.equalTo(self.imageView2.rightPos);
        self.imageView3.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView3];

//        self.imageView3.myVisibility = MyVisibility_Gone;
        
        self.imageView4.centerYPos.equalTo(iconView.centerYPos);
        self.imageView4.leftPos.equalTo(self.imageView3.rightPos);
        self.imageView4.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView4];

//        self.imageView4.myVisibility = MyVisibility_Gone;
        
        UILabel *tiplab = [[UILabel alloc] init];
        tiplab.leftPos.equalTo(self.imageView4.rightPos);
        tiplab.centerYPos.equalTo(iconView.centerYPos);
        tiplab.heightSize.equalTo(@20);
        tiplab.text = @"智能分散出借";
        tiplab.textAlignment = NSTextAlignmentCenter;
        CGSize size = [Common getStrWitdth:@"智能分散出借" Font:11];
        tiplab.font = [Color gc_Font:11];
        tiplab.textColor = [Color color:PGColorOptionTitleOrange];
        [whitBaseView addSubview:tiplab];
//        [tiplab sizeToFit];
        
        tiplab.myWidth = size.width + 10;
        [tiplab setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.layer.borderColor = [Color color:PGColorOptionTitleOrange].CGColor;
            v.layer.cornerRadius = 10;
            v.layer.borderWidth = 1.0f;
        }];
        self.tiplabel = tiplab;
        
        
        self.progressView.mySize = CGSizeMake(65, 65);
        self.progressView.bottomPos.equalTo(@15);
        self.progressView.rightPos.equalTo(whitBaseView.rightPos).offset(25);
        [whitBaseView addSubview:self.progressView];
        
        self.rateLab.leftPos.equalTo(self.titleLab.leftPos);
        self.rateLab.centerYPos.equalTo(self.progressView.centerYPos);
        [whitBaseView addSubview:self.rateLab];
        
        self.rateTipLab.leftPos.equalTo(self.rateLab.leftPos);
        self.rateTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(15);
        [whitBaseView addSubview:self.rateTipLab];
        
        
        self.timeLimitLab.centerXPos.equalTo(whitBaseView.centerXPos);
        self.timeLimitLab.bottomPos.equalTo(self.rateLab.bottomPos).offset(5);
        [whitBaseView addSubview:self.timeLimitLab];

        self.timeLimitTipLab.leftPos.equalTo(self.timeLimitLab.leftPos);
        self.timeLimitTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(15);
        [whitBaseView addSubview:self.timeLimitTipLab];
        
        
    }
    return self;
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
- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor redColor];
    }
    return _progressView;
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
@end
