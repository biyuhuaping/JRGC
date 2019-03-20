//
//  UCFNewBatchTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/3/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBatchTableViewCell.h"

@interface UCFNewBatchTableViewCell ()
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel   *loanTimeValueLab;
@property(nonatomic, strong)UILabel   *loanMoneyValueLab;
@property(nonatomic, strong)UILabel   *loanPeriodValueLab;
@property(nonatomic, strong)UILabel   *loanRateValueLab;
@end

@implementation UCFNewBatchTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.rootLayout.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        
        UIView *whiteView = [MyRelativeLayout new];
        whiteView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        whiteView.leftPos.equalTo(@15);
        whiteView.rightPos.equalTo(@15);
        whiteView.topPos.equalTo(@15);
        whiteView.bottomPos.equalTo(@0);
        whiteView.clipsToBounds = YES;
        whiteView.layer.cornerRadius = 10;
        [self.rootLayout addSubview:whiteView];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.heightSize.equalTo(@18);
        iconView.widthSize.equalTo(@3);
        iconView.leftPos.equalTo(@15);
        iconView.topPos.equalTo(@10);
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 2;
        [whiteView addSubview:iconView];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.leftPos.equalTo(iconView.rightPos).offset(8);
        label.centerYPos.equalTo(iconView.centerYPos);
        label.text = @"新手专享";
        [whiteView addSubview:label];
        [label sizeToFit];
        self.titleLab = label;
       
        UILabel *loanTimeMarkLab = [UILabel new];
        loanTimeMarkLab.text = @"出借日期";
        loanTimeMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanTimeMarkLab.font = [Color gc_Font:14];
        loanTimeMarkLab.leftPos.equalTo(@15);
        loanTimeMarkLab.bottomPos.equalTo(@20);
        [loanTimeMarkLab sizeToFit];
        [whiteView addSubview:loanTimeMarkLab];
        
        UILabel *loanTimeValueLab = [UILabel new];
        loanTimeValueLab.text = @"2019-02-04";
        loanTimeValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanTimeValueLab.font = [Color gc_Font:14];
        loanTimeValueLab.rightPos.equalTo(@15);
        loanTimeValueLab.centerYPos.equalTo(loanTimeMarkLab.centerYPos);
        [loanTimeValueLab sizeToFit];
        [whiteView addSubview:loanTimeValueLab];
        self.loanTimeValueLab = loanTimeValueLab;
       
       
        CGFloat VSpace = 6;
        
        UILabel *loanMoneyMarkLab = [UILabel new];
        loanMoneyMarkLab.text = @"出借金额";
        loanMoneyMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanMoneyMarkLab.font = [Color gc_Font:14];
        loanMoneyMarkLab.leftPos.equalTo(@15);
        loanMoneyMarkLab.bottomPos.equalTo(loanTimeMarkLab.topPos).offset(VSpace);
        [loanMoneyMarkLab sizeToFit];
        [whiteView addSubview:loanMoneyMarkLab];
        
        UILabel *loanMoneyValueLab = [UILabel new];
        loanMoneyValueLab.text = @"1000";
        loanMoneyValueLab.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
        loanMoneyValueLab.font = [Color gc_Font:14];
        loanMoneyValueLab.rightPos.equalTo(@15);
        loanMoneyValueLab.centerYPos.equalTo(loanMoneyMarkLab.centerYPos);
        [loanMoneyValueLab sizeToFit];
        [whiteView addSubview:loanMoneyValueLab];
        self.loanMoneyValueLab = loanMoneyValueLab;

        
        UILabel *loanPeriodMarkLab = [UILabel new];
        loanPeriodMarkLab.text = @"项目周期";
        loanPeriodMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanPeriodMarkLab.font = [Color gc_Font:14];
        loanPeriodMarkLab.leftPos.equalTo(@15);
        loanPeriodMarkLab.bottomPos.equalTo(loanMoneyMarkLab.topPos).offset(VSpace);
        [loanPeriodMarkLab sizeToFit];
        [whiteView addSubview:loanPeriodMarkLab];
        
        UILabel *loanPeriodValueLab = [UILabel new];
        loanPeriodValueLab.text = @"12个月";
        loanPeriodValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanPeriodValueLab.font = [Color gc_Font:14];
        loanPeriodValueLab.rightPos.equalTo(@15);
        loanPeriodValueLab.centerYPos.equalTo(loanPeriodMarkLab.centerYPos);
        [loanPeriodValueLab sizeToFit];
        [whiteView addSubview:loanPeriodValueLab];
        self.loanPeriodValueLab = loanPeriodValueLab;

        
        UILabel *loanRateMarkLab = [UILabel new];
        loanRateMarkLab.text = @"预期年化利率";
        loanRateMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanRateMarkLab.font = [Color gc_Font:14];
        loanRateMarkLab.leftPos.equalTo(@15);
        loanRateMarkLab.bottomPos.equalTo(loanPeriodMarkLab.topPos).offset(VSpace);
        [loanRateMarkLab sizeToFit];
        [whiteView addSubview:loanRateMarkLab];
        
        UILabel *loanRateValueLab = [UILabel new];
        loanRateValueLab.text = @"12%";
        loanRateValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanRateValueLab.font = [Color gc_Font:14];
        loanRateValueLab.rightPos.equalTo(@15);
        loanRateValueLab.centerYPos.equalTo(loanRateMarkLab.centerYPos);
        [loanRateValueLab sizeToFit];
        [whiteView addSubview:loanRateValueLab];
        self.loanRateValueLab = loanRateValueLab;
    }
    return self;
}
- (void)setModel:(UCFMyBatchBidResult *)model
{
    _model = model;
    self.titleLab.text = model.collName;
    self.loanRateValueLab.text = [NSString stringWithFormat:@"%.2f",model.collRate];
    self.loanPeriodValueLab.text = [NSString stringWithFormat:@"%@",model.colPeriodTxt];
    self.loanMoneyValueLab.text = [NSString stringWithFormat:@"%.2f",model.investSuccessTotal];
    self.loanTimeValueLab.text = model.investTime;
    
    
    [self.titleLab sizeToFit];
    [self.loanRateValueLab sizeToFit];
    [self.loanMoneyValueLab sizeToFit];
    [self.loanTimeValueLab sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
