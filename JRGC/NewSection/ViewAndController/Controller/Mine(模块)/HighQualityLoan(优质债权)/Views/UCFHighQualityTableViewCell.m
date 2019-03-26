//
//  UCFHighQualityTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/3/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHighQualityTableViewCell.h"
@interface UCFHighQualityTableViewCell()
@property(nonatomic, strong)UILabel   *titleLab;
@property(nonatomic, strong)UILabel   *bidStatusLab;
@property(nonatomic, strong)UILabel   *loanTimeValueLab;
@property(nonatomic, strong)UILabel   *loanMoneyValueLab;
@property(nonatomic, strong)UILabel   *loanPeriodValueLab;
@property(nonatomic, strong)UILabel   *loanRateValueLab;
@property(nonatomic, strong)UILabel   *playRepayValueLab;
@property(nonatomic, strong)NSArray   *statusArr;
@end
@implementation UCFHighQualityTableViewCell
- (NSArray *)statusArr
{
    if (!_statusArr) {
        _statusArr = @[@"未审核", @"待确认", @"招标中", @"流标", @"满标", @"回款中", @"已回款"];
    }
    return _statusArr;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.rootLayout.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIView *whiteView = [MyRelativeLayout new];
        whiteView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        whiteView.leftPos.equalTo(@15);
        whiteView.rightPos.equalTo(@15);
        whiteView.topPos.equalTo(@0);
        whiteView.bottomPos.equalTo(@15);
        whiteView.clipsToBounds = YES;
        whiteView.layer.cornerRadius = 8;
        [self.rootLayout addSubview:whiteView];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.heightSize.equalTo(@18);
        iconView.widthSize.equalTo(@3);
        iconView.leftPos.equalTo(@15);
        iconView.topPos.equalTo(@16);
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
        
        self.bidStatusLab = [UILabel new];
        self.bidStatusLab.text = @"已回款";
        self.bidStatusLab.textColor = [Color color:PGColorOptionTitleGray];
        self.bidStatusLab.rightPos.equalTo(@32);
        self.bidStatusLab.centerYPos.equalTo(self.titleLab.centerYPos);
        self.bidStatusLab.font = [Color gc_Font:15];
        [whiteView addSubview:self.bidStatusLab];
        [self.bidStatusLab sizeToFit];
        
        UIImageView *arrowView = [UIImageView new];
        arrowView.image = [UIImage imageNamed:@"list_icon_arrow"];
        arrowView.mySize = CGSizeMake(7, 11);
        arrowView.rightPos.equalTo(@15);
        arrowView.centerYPos.equalTo(self.titleLab.centerYPos);
        [whiteView addSubview:arrowView];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.heightSize.equalTo(@1);
        lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        lineView.myHorzMargin = 15;
        lineView.topPos.equalTo(@50);
        [whiteView addSubview:lineView];
        
        CGFloat VSpace = 6;
        
        UILabel *loanRateMarkLab = [UILabel new];
        loanRateMarkLab.text = @"预期年化利率";
        loanRateMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanRateMarkLab.font = [Color gc_Font:14];
        loanRateMarkLab.leftPos.equalTo(@15);
        loanRateMarkLab.topPos.equalTo(lineView.bottomPos).offset(15);
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
        self.loanRateValueLab.textAlignment = NSTextAlignmentRight;
        
        UILabel *loanTimeMarkLab = [UILabel new];
        loanTimeMarkLab.text = @"交易日期";
        loanTimeMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanTimeMarkLab.font = [Color gc_Font:14];
        loanTimeMarkLab.leftPos.equalTo(@15);
        loanTimeMarkLab.topPos.equalTo(loanRateMarkLab.bottomPos).offset(VSpace);
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
        self.loanTimeValueLab.textAlignment = NSTextAlignmentRight;
        
        
        UILabel *loanMoneyMarkLab = [UILabel new];
        loanMoneyMarkLab.text = @"出借金额";
        loanMoneyMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanMoneyMarkLab.font = [Color gc_Font:14];
        loanMoneyMarkLab.leftPos.equalTo(@15);
        loanMoneyMarkLab.topPos.equalTo(loanTimeMarkLab.bottomPos).offset(VSpace);
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
        self.loanMoneyValueLab.textAlignment = NSTextAlignmentRight;
        
        
        UILabel *loanPeriodMarkLab = [UILabel new];
        loanPeriodMarkLab.text = @"起息日期";
        loanPeriodMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanPeriodMarkLab.font = [Color gc_Font:14];
        loanPeriodMarkLab.leftPos.equalTo(@15);
        loanPeriodMarkLab.topPos.equalTo(loanMoneyMarkLab.bottomPos).offset(VSpace);
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
        self.loanPeriodValueLab.textAlignment = NSTextAlignmentRight;
        
        UILabel *playRepayMarkLab = [UILabel new];
        playRepayMarkLab.text = @"计划回款日";
        playRepayMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        playRepayMarkLab.font = [Color gc_Font:14];
        playRepayMarkLab.leftPos.equalTo(@15);
        playRepayMarkLab.topPos.equalTo(loanPeriodMarkLab.bottomPos).offset(VSpace);
        [playRepayMarkLab sizeToFit];
        [whiteView addSubview:playRepayMarkLab];
        
        UILabel *playRepayValueLab = [UILabel new];
        playRepayValueLab.text = @"12个月";
        playRepayValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        playRepayValueLab.font = [Color gc_Font:14];
        playRepayValueLab.rightPos.equalTo(@15);
        playRepayValueLab.centerYPos.equalTo(playRepayMarkLab.centerYPos);
        [playRepayValueLab sizeToFit];
        [whiteView addSubview:playRepayValueLab];
        self.playRepayValueLab = playRepayValueLab;
        self.loanPeriodValueLab.textAlignment = NSTextAlignmentRight;
    }
    return self;
}
- (void)setDataDict:(NSDictionary *)dataDict isTrans:(BOOL)isTrans
{
    if (isTrans) {
        self.titleLab.text = dataDict[@"name"];
        [self.titleLab sizeToFit];
        int status =  [dataDict[@"status"] intValue];
        self.bidStatusLab.text = self.statusArr[status];
        [self.bidStatusLab sizeToFit];
        
        NSString *annualRate = [dataDict objectSafeForKey:@"annualRate"];
        NSString *transfereeYearRate = [dataDict objectSafeForKey:@"transfereeYearRate"];
        
        NSString *ratestr = [transfereeYearRate.length == 0?annualRate:transfereeYearRate stringByAppendingString:@"%"];
        
        self.loanRateValueLab.text = ratestr;
        [self.loanRateValueLab sizeToFit];
        
        NSString *effactiveDate = dataDict[@"startInervestTime"];//起息日
        NSString *repayPerDate = dataDict[@"repayPerDate"];//回款时间
        self.loanPeriodValueLab.text = effactiveDate.length > 0?effactiveDate:@"--";
        [self.loanPeriodValueLab sizeToFit];
        self.playRepayValueLab.text = repayPerDate.length > 0?repayPerDate:@"--";
        [self.playRepayValueLab sizeToFit];
        
        double investAmt = [dataDict[@"contributionAmt"] doubleValue];
        self.loanMoneyValueLab.text = [NSString stringWithFormat:@"¥%0.2f",investAmt];//投资金额
        [self.loanMoneyValueLab sizeToFit];
        self.loanTimeValueLab.text = dataDict[@"createdTime"];//交易时间
        
        [self.loanTimeValueLab sizeToFit];
        
    } else {
        self.titleLab.text = dataDict[@"prdName"];
        [self.titleLab sizeToFit];
        int status =  [dataDict[@"status"] intValue];
        self.bidStatusLab.text = self.statusArr[status];
        [self.bidStatusLab sizeToFit];
        self.loanRateValueLab.text = [dataDict[@"annualRate"] stringByAppendingString:@"%"];
        [self.loanRateValueLab sizeToFit];
        
        NSString *effactiveDate = dataDict[@"effactiveDate"];//起息日
        NSString *repayPerDate = dataDict[@"repayPerDate"];//回款时间
        self.loanPeriodValueLab.text = effactiveDate.length > 0?effactiveDate:@"--";
        [self.loanPeriodValueLab sizeToFit];
        self.playRepayValueLab.text = repayPerDate.length > 0?repayPerDate:@"--";
        [self.playRepayValueLab sizeToFit];
        
        double investAmt = [dataDict[@"investAmt"] doubleValue];
        self.loanMoneyValueLab.text = [NSString stringWithFormat:@"¥%0.2f",investAmt];//投资金额
        [self.loanMoneyValueLab sizeToFit];
        self.loanTimeValueLab.text = dataDict[@"applyDate"];//交易时间
        
        [self.loanTimeValueLab sizeToFit];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
