//
//  UCFCollectionListCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionListCell.h"
#import "UIDic+Safe.h"

@implementation UCFCollectionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
//    addRate	年化加息
//    borrowAmount	总金额	number
//    completeLoan	完成额	number
//    createDate	发标时间	number
//    id	标id	number
//    investAmt	投资额	number
//    loanAnnualRate	预期年化	number
//    loanDate	起息日
//    prdName	标名称	string
//    repayTime	计划回款日
//    status	状态	string
     self.loanAnnualRateLab.text = [NSString stringWithFormat:@"%@%%",[dataDict objectSafeForKey:@"loanAnnualRate"]];
    self.addRateLab.text = [NSString stringWithFormat:@"%@%%",[dataDict objectSafeForKey:@"addRate"]];
    NSString *loanDateStr  = [dataDict objectSafeForKey:@"loanDate"];
    if ([loanDateStr isEqualToString:@""]) {
        loanDateStr = @"--";
    }
    self.loanDateLab.text = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"loanDate"]];
    
    NSString *repayTimeStr  = [dataDict objectSafeForKey:@"repayTime"];
    if ([repayTimeStr isEqualToString:@""]) {
        repayTimeStr = @"--";
    }
    self.repayTimeLab.text = [NSString stringWithFormat:@"%@",repayTimeStr];
    
    
    self.investAmtLab.text = [NSString stringWithFormat:@"¥%@",[dataDict objectSafeForKey:@"investAmt"]];
    self.statusLab.text = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"status"]];
    [self.loanAnnualRateLab setFont:[UIFont boldSystemFontOfSize:12.5]];
    [self.addRateLab setFont:[UIFont boldSystemFontOfSize:12.5]];
    
    
}

@end
