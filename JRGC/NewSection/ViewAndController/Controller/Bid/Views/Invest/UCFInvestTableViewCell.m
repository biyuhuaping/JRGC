//
//  UCFInvestTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/1/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFInvestTableViewCell.h"
#import "ZZCircleProgress.h"
#import "UCFProjectLabel.h"
#import "UILabel+Misc.h"
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
@property(strong, nonatomic)UIImageView *iconView;

@property(nonatomic, strong) ZZCircleProgress  *progressView;
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
        [whitBaseView addSubview:iconView];
        self.iconView = iconView;
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
        self.imageView3.leftPos.equalTo(self.imageView2.rightPos).offset(1.5);;
        self.imageView3.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView3];

        self.imageView3.myVisibility = MyVisibility_Gone;
        
        self.imageView4.centerYPos.equalTo(iconView.centerYPos);
        self.imageView4.leftPos.equalTo(self.imageView3.rightPos).offset(1.5);;
        self.imageView4.mySize = CGSizeMake(18, 18);
        [whitBaseView addSubview:self.imageView4];

        self.imageView4.myVisibility = MyVisibility_Gone;
        
        UILabel *tiplab = [[UILabel alloc] init];
        tiplab.leftPos.equalTo(self.imageView4.rightPos).offset(3);;
        tiplab.centerYPos.equalTo(iconView.centerYPos);
        tiplab.heightSize.equalTo(@20);
        tiplab.text = @"智能分散出借";
        tiplab.textAlignment = NSTextAlignmentCenter;
        CGSize size = [Common getStrWitdth:@"智能分散出借" Font:11];
        tiplab.font = [Color gc_Font:11];
        tiplab.textColor = [Color color:PGColorOptionTitleOrange];
        [whitBaseView addSubview:tiplab];
        [tiplab sizeToFit];

        tiplab.layer.borderColor = [Color color:PGColorOptionTitleOrange].CGColor;
        tiplab.layer.cornerRadius = 10;
        tiplab.layer.borderWidth = 1.0f;
        tiplab.myWidth = size.width + 10;
//        [tiplab setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
//
//        }];
        self.tiplabel = tiplab;
        
        self.progressView.mySize = CGSizeMake(65, 65);
        self.progressView.bottomPos.equalTo(@15);
        self.progressView.rightPos.equalTo(whitBaseView.rightPos).offset(25);
        [whitBaseView addSubview:self.progressView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.mySize = CGSizeMake(65, 65);
        button.bottomPos.equalTo(@15);
        button.rightPos.equalTo(whitBaseView.rightPos).offset(25);
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [whitBaseView addSubview:button];

        
        self.rateLab.leftPos.equalTo(self.titleLab.leftPos);
        self.rateLab.centerYPos.equalTo(self.progressView.centerYPos).offset(-6);
        [whitBaseView addSubview:self.rateLab];
        
        self.rateTipLab.leftPos.equalTo(self.rateLab.leftPos);
        self.rateTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(20);
        [whitBaseView addSubview:self.rateTipLab];
        
        
        self.timeLimitLab.centerXPos.equalTo(whitBaseView.centerXPos);
        self.timeLimitLab.bottomPos.equalTo(self.rateLab.bottomPos).offset(5);
        [whitBaseView addSubview:self.timeLimitLab];

        self.timeLimitTipLab.leftPos.equalTo(self.timeLimitLab.leftPos);
        self.timeLimitTipLab.bottomPos.equalTo(whitBaseView.bottomPos).offset(20);
        [whitBaseView addSubview:self.timeLimitTipLab];
        
        
    }
    return self;
}
- (void)click:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(investCell:didClickedProgressViewAtIndexPath:)]) {
        [self.delegate investCell:self didClickedProgressViewAtIndexPath:self.indexPath];
    }
}
- (void)setMicroMoneyModel:(UCFMicroMoneyModel *)microMoneyModel
{
    _microMoneyModel = microMoneyModel;
    self.titleLab.text = microMoneyModel.prdName;
    [self.titleLab sizeToFit];
    [self.tiplabel sizeToFit];
    self.rateLab.text = [NSString stringWithFormat:@"%@%%", microMoneyModel.annualRate];
    [self.rateLab setFont:[Color gc_Font:16] string:@"%"];
    [self.rateLab sizeToFit];
    if (microMoneyModel.holdTime.length > 0) {
        self.timeLimitLab.text = [NSString stringWithFormat:@"%@~%@", microMoneyModel.holdTime, microMoneyModel.repayPeriodtext];
    }
    else {
        self.timeLimitLab.text = [NSString stringWithFormat:@"%@", microMoneyModel.repayPeriodtext];
    }
    [self.timeLimitLab setFont:[Color gc_Font:16] string:@"天"];
    [self.timeLimitLab setFont:[Color gc_Font:16] string:@"个月"];

    [self.timeLimitLab sizeToFit];
    
    NSInteger status = [microMoneyModel.status integerValue];
    NSString *showStr = @"出借";
    NSArray *statusArr = @[@"未审核",@"等待确认",showStr,@"流标",@"满标",@"回款中",@"已回款"];
    if (status>2) {
        self.progressView.progressText = @"已售罄";
        self.progressView.textColor = [Color color:PGColorOptionTitleGray];
        self.timeLimitLab.textColor = [Color color:PGColorOptionTitleGray];
        self.rateLab.textColor = [Color color:PGColorOptionTitleGray];
        self.iconView.backgroundColor = [Color color:PGColorOptionTitleGray];;

    }
    else {
        self.progressView.textColor = [Color color:PGColorOptionTitleGray];
        if (microMoneyModel.modelType == UCFMicroMoneyModelTypeBatchBid && status == 2) {
            self.progressView.progressText = @"批量出借";
        }
        else {
            self.progressView.textColor = [Color color:PGColorOptionTitleOrange];
            self.timeLimitLab.textColor = [Color color:PGColorOptionTitleBlack];
            self.rateLab.textColor = [Color color:PGColorOptionTitleOrange];
            self.progressView.progressText = [statusArr objectAtIndex:status];
            self.iconView.backgroundColor = [Color color:PGColorOptionTitleOrange];;

        }
    }
    if (microMoneyModel.prdLabelsList.count > 0) {
        UCFProjectLabel *projectLabel = [microMoneyModel.prdLabelsList firstObject];
        if ([projectLabel.labelPriority integerValue] == 1) {
            self.tiplabel.myVisibility = MyVisibility_Visible;
            self.tiplabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
            
            [self.tiplabel sizeToFit];
            CGSize size = [Common getStrWitdth:projectLabel.labelName Font:11];
            self.tiplabel.layer.borderColor = [Color color:PGColorOptionTitleOrange].CGColor;
            self.tiplabel.layer.cornerRadius = 10;
            self.tiplabel.layer.borderWidth = 1.0f;
            self.tiplabel.myWidth = size.width + 10;
        }
        else {
            self.tiplabel.myVisibility = MyVisibility_Gone;;
        }
    }
    else {
        self.tiplabel.myVisibility = MyVisibility_Gone;;
    }


    if (microMoneyModel.platformSubsidyExpense.length > 0) {//贴
        self.imageView1.myVisibility = MyVisibility_Visible;
    }
    else {
        self.imageView1.myVisibility = MyVisibility_Gone;
    }
    if (microMoneyModel.guaranteeCompany.length > 0) {//贴
        self.imageView2.myVisibility = MyVisibility_Visible;
    }
    else {
        self.imageView2.myVisibility = MyVisibility_Gone;
    }
    if (microMoneyModel.fixedDate.length > 0) {//贴
        self.imageView3.myVisibility = MyVisibility_Visible;

    }
    else {
        self.imageView3.myVisibility = MyVisibility_Gone;
    }
    if (microMoneyModel.holdTime.length > 0) {//贴
        self.imageView4.myVisibility = MyVisibility_Visible;
    }
    else {
        self.imageView4.myVisibility = MyVisibility_Gone;
    }
    
    float progress = [microMoneyModel.completeLoan floatValue]/[microMoneyModel.borrowAmount floatValue];
    if (progress < 0 || progress > 1) {
        progress = 1;
    }
    else {
        self.progressView.progress = progress;
    }
    //控制进度视图显示
    if (status < 3) {
        self.progressView.pathFillColor = UIColorWithRGB(0xff4133);
    }else{
        self.progressView.pathFillColor =  UIColorWithRGB(0xe2e2e2);//未绘制的进度条颜色
        self.tiplabel.hidden = YES;
    }
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
- (ZZCircleProgress *)progressView
{
    if (!_progressView) {
        _progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
        _progressView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _progressView.strokeWidth = 3.5f;
        _progressView.showPoint = NO;
        _progressView.pathBackColor =  UIColorWithRGB(0xe2e2e2);
    }
    return _progressView;
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
        _timeLimitTipLab.textColor = [Color color:PGColorOptionTitleGray];
        _timeLimitTipLab.font = [UIFont systemFontOfSize:12.0f];
        _timeLimitTipLab.text = @"出借期限";
        [_timeLimitTipLab sizeToFit];
    }
    return _timeLimitTipLab;
}
@end
