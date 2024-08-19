//
//  NewInvestmentDetailTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/3/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "NewInvestmentDetailTableViewCell.h"
#import "UCFToolsMehod.h"
@interface NewInvestmentDetailTableViewCell()
@property(nonatomic, strong)UILabel *loanMarkLab;
@property(nonatomic, strong)UILabel *loanValueLab;

@property(nonatomic, strong)UILabel *interetMarkLab;
@property(nonatomic, strong)UILabel *interetValueLab;

@property(nonatomic, strong)UILabel *liquidatedMrakLab; //违约金
@property(nonatomic, strong)UILabel *liquidatedValueLab;

@end
@implementation NewInvestmentDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        104
        self.rootLayout.backgroundColor = [UIColor whiteColor];
        
        self.interetMarkLab = [[UILabel alloc] init];
        self.interetMarkLab.text = @"应收利息";
        self.interetMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.interetMarkLab.font = [Color gc_Font:14];
        self.interetMarkLab.leftPos.equalTo(@15);
        self.interetMarkLab.centerYPos.equalTo(self.rootLayout.centerYPos);
        [self.rootLayout addSubview:self.interetMarkLab];
        [self.interetMarkLab sizeToFit];
        
        self.interetValueLab = [[UILabel alloc] init];
        self.interetValueLab.text = @"¥10,000.00";
        self.interetValueLab.textColor = [Color color:PGColorOpttonTextRedColor];
        self.interetValueLab.font = [Color gc_Font:14];
        self.interetValueLab.rightPos.equalTo(@15);
        self.interetValueLab.centerYPos.equalTo(self.rootLayout.centerYPos);
        [self.rootLayout addSubview:self.interetValueLab];
        [self.interetValueLab sizeToFit];
        
        self.loanMarkLab =  [[UILabel alloc] init];
        self.loanMarkLab.text = @"出借金额";
        self.loanMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.loanMarkLab.font = [Color gc_Font:14];
        self.loanMarkLab.leftPos.equalTo(@15);
        self.loanMarkLab.bottomPos.equalTo(self.interetMarkLab.topPos).offset(10);
        [self.rootLayout addSubview:self.loanMarkLab];
        [self.loanMarkLab sizeToFit];
        
        
        self.loanValueLab =  [[UILabel alloc] init];
        self.loanValueLab.text = @"¥40000";
        self.loanValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.loanValueLab.font = [Color gc_Font:14];
        self.loanValueLab.rightPos.equalTo(@15);
        self.loanValueLab.centerYPos.equalTo(self.loanMarkLab.centerYPos);
        [self.rootLayout addSubview:self.loanValueLab];
        [self.loanValueLab sizeToFit];
        
        
        self.liquidatedMrakLab =  [[UILabel alloc] init];
        self.liquidatedMrakLab.text = @"应收违约金";
        self.liquidatedMrakLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.liquidatedMrakLab.font = [Color gc_Font:14];
        self.liquidatedMrakLab.leftPos.equalTo(@15);
        self.liquidatedMrakLab.topPos.equalTo(self.interetMarkLab.bottomPos).offset(10);
        [self.rootLayout addSubview:self.liquidatedMrakLab];
        [self.liquidatedMrakLab sizeToFit];
        
        self.liquidatedValueLab =  [[UILabel alloc] init];
        self.liquidatedValueLab.text = @"¥40000";
        self.liquidatedValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.liquidatedValueLab.font = [Color gc_Font:14];
        self.liquidatedValueLab.rightPos.equalTo(@15);
        self.liquidatedValueLab.centerYPos.equalTo(self.liquidatedMrakLab.centerYPos);
        [self.rootLayout addSubview:self.liquidatedValueLab];
        [self.liquidatedValueLab sizeToFit];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        lineView.leftPos.equalTo(@15);
        lineView.heightSize.equalTo(@0.5);
        lineView.rightPos.equalTo(@15);
        lineView.bottomPos.equalTo(@0);
        [self.rootLayout addSubview:lineView];
        
    }
    return self;
}

- (void)setValueOfTableViewCellLabel:(UCFInvestDetailModel *)model type:(NSString*)tp
{
        if ([tp isEqualToString:@"1"]) {
            NSString *strAmt = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@",model.investAmt]];
            strAmt = [UCFToolsMehod dealmoneyFormart:strAmt];
            NSString *textStr  = self.accoutType == SelectAccoutTypeP2P ? @"出借金额" :@"认购金额";
            self.loanMarkLab.text = textStr;
            self.loanValueLab.text = [NSString stringWithFormat:@"¥%@",strAmt];
            [self.loanValueLab sizeToFit];
            [self.loanMarkLab sizeToFit];
            //应收利息
            NSString *anmout = [NSString stringWithFormat:@"%.2f",(model.awaitInterest.floatValue + model.refundInterest.floatValue)];
            anmout = [UCFToolsMehod dealmoneyFormart:anmout];
            self.interetValueLab.text = [NSString stringWithFormat:@"¥%@",anmout];
            [self.interetValueLab sizeToFit];
            
            //应收违约金
            NSString *liquidatedStr = [NSString stringWithFormat:@"%.2f", model.refundPrepaymentPenalty.floatValue];
            liquidatedStr = [UCFToolsMehod dealmoneyFormart:liquidatedStr];
            self.liquidatedValueLab.text = [NSString stringWithFormat:@"¥%@",liquidatedStr];
            [self.liquidatedValueLab sizeToFit];
        } else {
            self.loanMarkLab.text = @"应收本金";
            [self.loanMarkLab sizeToFit];
            NSString *loanValue = [NSString stringWithFormat:@"%.2f",model.awaitPrincipal.floatValue + model.refundPrincipal.floatValue];
            loanValue = [UCFToolsMehod dealmoneyFormart:loanValue];
            self.loanValueLab.text = [NSString stringWithFormat:@"¥%@",loanValue];
            [self.loanValueLab sizeToFit];
            
            //应收利息
            NSString *anmout = [NSString stringWithFormat:@"%.2f",(model.awaitInterest.floatValue + model.refundInterest.floatValue)];
            anmout = [UCFToolsMehod dealmoneyFormart:anmout];
            self.interetValueLab.text = [NSString stringWithFormat:@"¥%@",anmout];
            [self.interetValueLab sizeToFit];
            
            //应收违约金
            NSString *liquidatedStr = [NSString stringWithFormat:@"%.2f", model.refundPrepaymentPenalty.floatValue];
            liquidatedStr = [UCFToolsMehod dealmoneyFormart:liquidatedStr];
            self.liquidatedValueLab.text = [NSString stringWithFormat:@"¥%@",liquidatedStr];
            [self.liquidatedValueLab sizeToFit];
        }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
