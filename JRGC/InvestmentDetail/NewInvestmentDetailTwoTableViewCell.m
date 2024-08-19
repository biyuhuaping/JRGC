//
//  NewInvestmentDetailTwoTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/3/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "NewInvestmentDetailTwoTableViewCell.h"
#import "UCFToolsMehod.h"
@interface NewInvestmentDetailTwoTableViewCell()

@property(nonatomic, strong)UILabel *rateMarkLab;
@property(nonatomic, strong)UILabel *rateValueLab;

@property(nonatomic, strong)UILabel *bidPeriodMarkLab;
@property(nonatomic, strong)UILabel *bidPeriodValueLab;

@property(nonatomic, strong)UILabel *repayModelMarkLab;
@property(nonatomic, strong)UILabel *repayModelValueLab;

@property(nonatomic, strong)UILabel *stepOneLab; //加入
@property(nonatomic, strong)UILabel *stepTwoLab; //起息
@property(nonatomic, strong)UILabel *stepThreeLab; //计划回款

@property(nonatomic, strong)UILabel *firstMarkLab;
@property(nonatomic, strong)UILabel *secondMarkLab;
@property(nonatomic, strong)UILabel *thirdMarkLab;


@end


@implementation NewInvestmentDetailTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.rootLayout.backgroundColor = [UIColor whiteColor];
        
        self.rateMarkLab = [[UILabel alloc] init];
        self.rateMarkLab.text = @"预期年化利率";
        self.rateMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.rateMarkLab.font = [Color gc_Font:14];
        self.rateMarkLab.leftPos.equalTo(@15);
        self.rateMarkLab.topPos.equalTo(@15);
        self.rateMarkLab.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:self.rateMarkLab];
        [self.rateMarkLab sizeToFit];
        
        self.rateValueLab = [[UILabel alloc] init];
        self.rateValueLab.text = @"7.5%";
        self.rateValueLab.textColor = [Color color:PGColorOpttonTextRedColor];
        self.rateValueLab.font = [Color gc_Font:14];
        self.rateValueLab.rightPos.equalTo(@15);
        self.rateValueLab.centerYPos.equalTo(self.rateMarkLab.centerYPos);
        [self.rootLayout addSubview:self.rateValueLab];
        [self.rateValueLab sizeToFit];
        
        self.bidPeriodMarkLab = [[UILabel alloc] init];
        self.bidPeriodMarkLab.text = @"标的期限";
        self.bidPeriodMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.bidPeriodMarkLab.font = [Color gc_Font:14];
        self.bidPeriodMarkLab.leftPos.equalTo(@15);
        self.bidPeriodMarkLab.topPos.equalTo(self.rateMarkLab.bottomPos).offset(8);
        [self.rootLayout addSubview:self.bidPeriodMarkLab];
        [self.bidPeriodMarkLab sizeToFit];
        
        self.bidPeriodValueLab = [[UILabel alloc] init];
        self.bidPeriodValueLab.text = @"30天";
        self.bidPeriodValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.bidPeriodValueLab.font = [Color gc_Font:14];
        self.bidPeriodValueLab.rightPos.equalTo(@15);
        self.bidPeriodValueLab.centerYPos.equalTo(self.bidPeriodMarkLab.centerYPos);
        [self.rootLayout addSubview:self.bidPeriodValueLab];
        [self.bidPeriodValueLab sizeToFit];
        
        self.repayModelMarkLab = [[UILabel alloc] init];
        self.repayModelMarkLab.text = @"还款方式";
        self.repayModelMarkLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.repayModelMarkLab.font = [Color gc_Font:14];
        self.repayModelMarkLab.leftPos.equalTo(@15);
        self.repayModelMarkLab.topPos.equalTo(self.bidPeriodMarkLab.bottomPos).offset(8);
        [self.rootLayout addSubview:self.repayModelMarkLab];
        [self.repayModelMarkLab sizeToFit];
        
        self.repayModelValueLab = [[UILabel alloc] init];
        self.repayModelValueLab.text = @"一次结清";
        self.repayModelValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.repayModelValueLab.font = [Color gc_Font:14];
        self.repayModelValueLab.rightPos.equalTo(@15);
        self.repayModelValueLab.centerYPos.equalTo(self.repayModelMarkLab.centerYPos);
        [self.rootLayout addSubview:self.repayModelValueLab];
        [self.repayModelValueLab sizeToFit];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        lineView.leftPos.equalTo(@15);
        lineView.heightSize.equalTo(@0.5);
        lineView.rightPos.equalTo(@15);
        lineView.bottomPos.equalTo(@90);
        [self.rootLayout addSubview:lineView];
        
        
        UIImageView *centerXImageView = [UIImageView new];
        centerXImageView.image = [UIImage imageNamed:@"bg_redppint"];
        centerXImageView.mySize = CGSizeMake(12, 12);
        centerXImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        centerXImageView.topPos.equalTo(lineView.bottomPos).offset(20);
        [self.rootLayout addSubview:centerXImageView];
        
        
        UIImageView *leftImageView = [UIImageView new];
        leftImageView.image = [UIImage imageNamed:@"bg_redppint"];
        leftImageView.mySize = CGSizeMake(12, 12);
        leftImageView.centerYPos.equalTo(centerXImageView.centerYPos);
        leftImageView.myLeft = 45;
        [self.rootLayout addSubview:leftImageView];
        
        
        UIImageView *rightImageView = [UIImageView new];
        rightImageView.image = [UIImage imageNamed:@"bg_redppint"];
        rightImageView.mySize = CGSizeMake(12, 12);
        rightImageView.centerYPos.equalTo(centerXImageView.centerYPos);
        rightImageView.myRight = 45;
        [self.rootLayout addSubview:rightImageView];
        
        UIView *leftLineView = [UIView new];
        leftLineView.backgroundColor = [Color color:PGColorOpttonRedLineBackColor];
        leftLineView.leftPos.equalTo(leftImageView.rightPos).offset(5);
        leftLineView.rightPos.equalTo(centerXImageView.leftPos).offset(5);
        leftLineView.heightSize.equalTo(@2);
        leftLineView.layer.cornerRadius = 1.0f;
        leftLineView.centerYPos.equalTo(centerXImageView.centerYPos);
        [self.rootLayout addSubview:leftLineView];

        UIView *rightLineView = [UIView new];
        rightLineView.backgroundColor = [Color color:PGColorOpttonRedLineBackColor];
        rightLineView.leftPos.equalTo(centerXImageView.rightPos).offset(5);
        rightLineView.rightPos.equalTo(rightImageView.leftPos).offset(5);
        rightLineView.heightSize.equalTo(@2);
        rightLineView.layer.cornerRadius = 1.0f;
        rightLineView.centerYPos.equalTo(centerXImageView.centerYPos);
        [self.rootLayout addSubview:rightLineView];
        
        UILabel *firstMarkLab = [UILabel new];
        firstMarkLab.text = @"加入";
        firstMarkLab.textColor = [Color color:PGColorOptionTitlerRead];
        firstMarkLab.font = [Color gc_Font:14];
        firstMarkLab.centerXPos.equalTo(leftImageView.centerXPos);
        firstMarkLab.topPos.equalTo(leftImageView.bottomPos).offset(5);
        [self.rootLayout addSubview:firstMarkLab];
        [firstMarkLab sizeToFit];
        [self.firstMarkLab sizeToFit];
        
        self.stepOneLab = [UILabel new];
        self.stepOneLab.text = @"2018-02-02";
        self.stepOneLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.stepOneLab.font = [Color gc_Font:11];
        self.stepOneLab.centerXPos.equalTo(firstMarkLab.centerXPos);
        self.stepOneLab.topPos.equalTo(firstMarkLab.bottomPos).offset(5);
        [self.rootLayout addSubview:self.stepOneLab];
        [self.stepOneLab sizeToFit];
        
        
        UILabel *secondMarkLab = [UILabel new];
        secondMarkLab.text = @"起息";
        secondMarkLab.textColor = [Color color:PGColorOptionTitlerRead];
        secondMarkLab.font = [Color gc_Font:14];
        secondMarkLab.centerXPos.equalTo(centerXImageView.centerXPos);
        secondMarkLab.topPos.equalTo(centerXImageView.bottomPos).offset(5);
        [self.rootLayout addSubview:secondMarkLab];
        [secondMarkLab sizeToFit];
        self.secondMarkLab = secondMarkLab;

        self.stepTwoLab = [UILabel new];
        self.stepTwoLab.text = @"2018-02-02";
        self.stepTwoLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.stepTwoLab.font = [Color gc_Font:11];
        self.stepTwoLab.centerXPos.equalTo(secondMarkLab.centerXPos);
        self.stepTwoLab.topPos.equalTo(secondMarkLab.bottomPos).offset(5);
        [self.rootLayout addSubview:self.stepTwoLab];
        [self.stepTwoLab sizeToFit];
        
        
        UILabel *thirdMarkLab = [UILabel new];
        thirdMarkLab.text = @"计划回款";
        thirdMarkLab.textColor = [Color color:PGColorOptionTitlerRead];
        thirdMarkLab.font = [Color gc_Font:14];
        thirdMarkLab.centerXPos.equalTo(rightImageView.centerXPos);
        thirdMarkLab.topPos.equalTo(rightImageView.bottomPos).offset(5);
        [self.rootLayout addSubview:thirdMarkLab];
        [thirdMarkLab sizeToFit];
        self.thirdMarkLab = thirdMarkLab;
        
        self.stepThreeLab = [UILabel new];
        self.stepThreeLab.text = @"2018-02-02";
        self.stepThreeLab.textColor = [Color color:PGColorOptionTitleBlack];
        self.stepThreeLab.font = [Color gc_Font:11];
        self.stepThreeLab.centerXPos.equalTo(thirdMarkLab.centerXPos);
        self.stepThreeLab.topPos.equalTo(thirdMarkLab.bottomPos).offset(5);
        [self.rootLayout addSubview:self.stepThreeLab];
        [self.stepThreeLab sizeToFit];
    }
    return self;
}

- (void)setValueOfTableViewCellLabel:(UCFInvestDetailModel *)model type:(NSString*)tp
{
    if ([tp isEqualToString:@"1"]) {
        NSString *strRate = [NSString stringWithFormat:@"%@",model.annualRate];
        self.rateValueLab.text = [NSString stringWithFormat:@"%@%%",strRate];
        [self.rateValueLab sizeToFit];
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.repayPeriod] isEqualToString:@""]) {
            self.bidPeriodValueLab.text = @"-";
        } else {
            self.bidPeriodValueLab.text = model.repayPeriod;
        }
        [self.bidPeriodValueLab sizeToFit];

        self.repayModelValueLab.text = model.repayModeText;
        [self.repayModelValueLab sizeToFit];
        

        self.stepOneLab.text = model.applyDate;
        [self.stepOneLab sizeToFit];
        
        if ([[UCFToolsMehod isNullOrNilWithString:model.effactiveDate] isEqualToString:@""]) {
            self.stepTwoLab.text = @"-";
        } else {
            self.stepTwoLab.text = model.effactiveDate;
        }
        [self.stepTwoLab sizeToFit];

        if ([model.status integerValue] == 6) {
            self.thirdMarkLab.text = @"实际回款日";
            self.stepThreeLab.text = @"";
            if ([[UCFToolsMehod isNullOrNilWithString:model.paidTime] isEqualToString:@""]) {
                 self.stepThreeLab.text =@"-";
            } else {
                self.stepThreeLab.text = model.paidTime;
            }
        } else {
            self.thirdMarkLab.text = @"计划回款日";
            if ([[UCFToolsMehod isNullOrNilWithString:model.currentRepayPerDate] isEqualToString:@""]) {
                self.stepThreeLab.text = @"-";
            } else {
                self.stepThreeLab.text = model.currentRepayPerDate;
            }
        }
        [self.thirdMarkLab sizeToFit];
        [self.stepThreeLab sizeToFit];
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
