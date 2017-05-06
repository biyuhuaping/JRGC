//
//  InvestmentDetailTableViewCell.m
//  JRGC
//
//  Created by HeJing on 15/4/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "InvestmentDetailTableViewCell.h"
#import "UILabel+Misc.h"
#import "SharedSingleton.h"
#import "UCFInvestDetailModel.h"
#import "NSDateManager.h"
#import "UCFToolsMehod.h"

#define SECONDSPACING 5

@interface InvestmentDetailTableViewCell ()
{
    UILabel *investmentAmountLabel;//投资金额
    UILabel *annualEarningsLabel;//年化收益
    UILabel *reimbursementMeansLabel;//还款方式
    UILabel *markTimeLabel;//标的期限
    UILabel *payoutDateLabel;//起息日期
    UILabel *collectionDateLabel;//计划回款日期
    UILabel *actualCollectionDateLabel;//实际回款日期
}

@end

@implementation InvestmentDetailTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self) {
        investmentAmountLabel = [UILabel labelWithFrame:CGRectMake(15, 15, ScreenWidth / 2, 12) text:@"¥0" textColor:nil font:[UIFont systemFontOfSize:12]];
        investmentAmountLabel.textAlignment = NSTextAlignmentLeft;
        investmentAmountLabel.numberOfLines = 1;
        [self.contentView addSubview:investmentAmountLabel];
        
        annualEarningsLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + SECONDSPACING, 15, ScreenWidth / 2 - 15, 12) text:@"0%%" textColor:nil font:[UIFont systemFontOfSize:12]];
        annualEarningsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:annualEarningsLabel];
        
        reimbursementMeansLabel = [UILabel labelWithFrame:CGRectMake(15,CGRectGetMaxY(investmentAmountLabel.frame) + 8, ScreenWidth / 2, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
        reimbursementMeansLabel.numberOfLines = 1;
        reimbursementMeansLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:reimbursementMeansLabel];
        
        markTimeLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + SECONDSPACING, CGRectGetMaxY(annualEarningsLabel.frame) + 8, ScreenWidth / 2 - 15, 12) text:@"0天" textColor:nil font:[UIFont systemFontOfSize:12]];
        markTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:markTimeLabel];
        
        payoutDateLabel = [UILabel labelWithFrame:CGRectMake(15, CGRectGetMaxY(reimbursementMeansLabel.frame) + 8, ScreenWidth / 2, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
        payoutDateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:payoutDateLabel];
        
        collectionDateLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + SECONDSPACING, CGRectGetMaxY(markTimeLabel.frame) + 8, ScreenWidth / 2 - 15, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
        collectionDateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:collectionDateLabel];
        
        actualCollectionDateLabel = [UILabel labelWithFrame:CGRectMake(15, CGRectGetMaxY(collectionDateLabel.frame) + 8, ScreenWidth / 2 - 15, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
        actualCollectionDateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:actualCollectionDateLabel];
        [actualCollectionDateLabel setHidden:YES];
    }
    return self;
}

- (void)setValueOfTableViewCellLabel:(UCFInvestDetailModel *)model type:(NSString *)tp
{
    if ([tp isEqualToString:@"1"]) {
        NSString *strAmt = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@",model.investAmt]];
        strAmt = [UCFToolsMehod dealmoneyFormart:strAmt];
        NSString *textStr  = self.accoutType == SelectAccoutTypeP2P ? @"出借金额：" :@"投资金额：";
        NSMutableAttributedString *str1 = [SharedSingleton getAcolorfulStringWithText1:textStr Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"¥%@", [UCFToolsMehod isNullOrNilWithString:strAmt]] Color2:UIColorWithRGB(0xfd4d4c) AllText:[NSString stringWithFormat:@"%@¥%@",textStr,[UCFToolsMehod isNullOrNilWithString:strAmt]]];
        investmentAmountLabel.attributedText = str1;
        NSString *strRate = [NSString stringWithFormat:@"%@",model.annualRate];
        
        NSMutableAttributedString *str2 = [SharedSingleton getAcolorfulStringWithText1:@"预期年化利率：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@%%", [UCFToolsMehod isNullOrNilWithString:strRate]] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"预期年化利率：%@%%",[UCFToolsMehod isNullOrNilWithString:strRate]]];
        annualEarningsLabel.attributedText = str2;
//        annualEarningsLabel.text = [NSString stringWithFormat:@"年化收益率：%@%%",[UCFToolsMehod isNullOrNilWithString:strRate]];
        
        NSMutableAttributedString *str3 = [SharedSingleton getAcolorfulStringWithText1:@"还款方式：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", model.repayModeText] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"还款方式：%@", model.repayModeText]];
        reimbursementMeansLabel.attributedText = str3;
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.repayPeriod] isEqualToString:@""]) {
            markTimeLabel.text = @"标的期限：-";
            markTimeLabel.textColor = UIColorWithRGB(0x999999);
        } else {
            NSMutableAttributedString *str4 = [SharedSingleton getAcolorfulStringWithText1:@"标的期限：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", model.repayPeriod] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"标的期限：%@",[UCFToolsMehod isNullOrNilWithString:model.repayPeriod]]];
            markTimeLabel.attributedText = str4;
        }
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.effactiveDate] isEqualToString:@""]) {
            payoutDateLabel.textColor = UIColorWithRGB(0x999999);
            payoutDateLabel.text = @"起息日期：-";
        } else {
            NSMutableAttributedString *str5 = [SharedSingleton getAcolorfulStringWithText1:@"起息日期：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", model.effactiveDate] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"起息日期：%@",[UCFToolsMehod isNullOrNilWithString:model.effactiveDate]]];
            payoutDateLabel.attributedText = str5;
        }
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.currentRepayPerDate] isEqualToString:@""]) {
            collectionDateLabel.text = @"计划回款日：-";
            collectionDateLabel.textColor = UIColorWithRGB(0x999999);
        } else {
            NSMutableAttributedString *str6 = [SharedSingleton getAcolorfulStringWithText1:@"计划回款日：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", model.currentRepayPerDate] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"计划回款日：%@",[UCFToolsMehod isNullOrNilWithString:model.currentRepayPerDate]]];
            collectionDateLabel.attributedText = str6;
        }
        
        if ([model.status integerValue] == 6) {
            [actualCollectionDateLabel setHidden:NO];
        }
        //实际回款日期
        if ([[UCFToolsMehod isNullOrNilWithString:model.paidTime] isEqualToString:@""]) {
            actualCollectionDateLabel.text = @"实际回款日：-";
            actualCollectionDateLabel.textColor = UIColorWithRGB(0x999999);
        } else {
            NSMutableAttributedString *str6 = [SharedSingleton getAcolorfulStringWithText1:@"实际回款日：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", model.paidTime] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"实际回款日：%@",[UCFToolsMehod isNullOrNilWithString:model.paidTime]]];
            actualCollectionDateLabel.attributedText = str6;
        }
    } else {
        NSString *strAmt = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@",model.actualInvestAmt]];
        strAmt = [UCFToolsMehod dealmoneyFormart:strAmt];
        NSMutableAttributedString *str = [SharedSingleton getAcolorfulStringWithText1:@"实付金额：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"¥%@", [UCFToolsMehod isNullOrNilWithString:strAmt]] Color2:UIColorWithRGB(0xfd4d4c) AllText:[NSString stringWithFormat:@"实付金额：¥%@", [UCFToolsMehod isNullOrNilWithString:strAmt]]];
        investmentAmountLabel.attributedText = str;
        NSString *strRate = [NSString stringWithFormat:@"%@",model.annualRate];
        
        NSMutableAttributedString *str2 = [SharedSingleton getAcolorfulStringWithText1:@"预期收益：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"¥%@", model.taotalIntrest] Color2:UIColorWithRGB(0xfd4d4c) AllText:[NSString stringWithFormat:@"预期收益：¥%@",model.taotalIntrest]];
        annualEarningsLabel.attributedText = str2;
        
        NSMutableAttributedString *str3 = [SharedSingleton getAcolorfulStringWithText1:@"预期年化：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@%%", [UCFToolsMehod isNullOrNilWithString:strRate]] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"预期年化：%@%%",[UCFToolsMehod isNullOrNilWithString:strRate]]];
        reimbursementMeansLabel.attributedText = str3;
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.repayModeText] isEqualToString:@""]) {
            markTimeLabel.text = @"还款方式：-";
            markTimeLabel.textColor = UIColorWithRGB(0x999999);
        } else {
            NSMutableAttributedString *str4 = [SharedSingleton getAcolorfulStringWithText1:@"还款方式：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", model.repayModeText] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"还款方式：%@", model.repayModeText]];
            markTimeLabel.attributedText = str4;
        }
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.repayPeriod] isEqualToString:@""]) {
            payoutDateLabel.text = @"原标期限：-";
            payoutDateLabel.textColor = UIColorWithRGB(0x999999);
        } else {
            NSMutableAttributedString *str5 = [SharedSingleton getAcolorfulStringWithText1:@"原标期限：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@天", model.repayPeriod] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"原标期限：%@天",[UCFToolsMehod isNullOrNilWithString:model.repayPeriod]]];
            [[NSUserDefaults standardUserDefaults] setValue:model.repayPeriod forKey:@"bidDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            payoutDateLabel.attributedText = str5;
        }
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.effactiveDate] isEqualToString:@""]) {
            collectionDateLabel.text = @"起息日期：-";
            collectionDateLabel.textColor = UIColorWithRGB(0x999999);
        } else {
            NSMutableAttributedString *str6 = [SharedSingleton getAcolorfulStringWithText1:@"起息日期：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", model.effactiveDate] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"起息日期：%@",[UCFToolsMehod isNullOrNilWithString:model.effactiveDate]]];
            collectionDateLabel.attributedText = str6;
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
