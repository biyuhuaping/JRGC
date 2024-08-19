//
//  UCFCollectionListCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionListCell.h"
#import "UIDic+Safe.h"
#import "UCFToolsMehod.h"

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
      self.prdNameLab.text = [dataDict objectSafeForKey:@"prdName"];
      self.loanAnnualRateLab.text = [NSString stringWithFormat:@"%@%%",[dataDict objectSafeForKey:@"loanAnnualRate"]];
 
    
     float addRate =   [[dataDict objectSafeForKey:@"addRate"] floatValue];
     if (addRate > 0) {
        self.addRateViewHeight.constant = 27;
        self.addRateLab.text = [NSString stringWithFormat:@"%@%%",[dataDict objectSafeForKey:@"addRate"]];
        self.addRateLabText.hidden = NO;
    }else{
        self.addRateViewHeight.constant = 0;
        self.addRateLab.text = @"";
        self.addRateLabText.hidden = YES;
    }
    
    NSString *loanDateStr  = [dataDict objectSafeForKey:@"loanDate"];
    if ([loanDateStr isEqualToString:@""]) {
        loanDateStr = @"--";
    }
    self.loanDateLab.text = loanDateStr;
    
    NSString *repayTimeStr  = [dataDict objectSafeForKey:@"repayTime"];
    if ([repayTimeStr isEqualToString:@""]) {
        repayTimeStr = @"--";
    }
    self.repayTimeLab.text = [NSString stringWithFormat:@"%@",repayTimeStr];
    
    NSString *investAmtStr =[NSString stringWithFormat:@"%.2f",[[dataDict objectSafeForKey:@"investAmt" ] floatValue]];
    
    investAmtStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:investAmtStr]]]];
    
    self.investAmtLab.text = investAmtStr;

    self.createDateLab.text = [dataDict objectSafeForKey:@"createDate"];
    [self.loanAnnualRateLab setFont:[UIFont boldSystemFontOfSize:12.5]];
    [self.addRateLab setFont:[UIFont boldSystemFontOfSize:12.5]];
    
    NSInteger status = [[dataDict objectSafeForKey:@"status"] integerValue];
     self.statusLab.text = [self getPrdStatus:status];
    if (status == 2 || status == 4) {//招标中或者满标
        self.statusLab.textColor = UIColorWithRGB(0xfd4d4c);
    }
    else if (status == 5) {//回款中
        self.statusLab.textColor = UIColorWithRGB(0x4aa1f9);
    }else{
        self.statusLab.textColor = UIColorWithRGB(0x999999);
    }

}
// _statusArr = @[@"未审核", @"待确认", @"招标中", @"流标", @"满标", @"回款中", @"已回款"];
-(NSString *)getPrdStatus:(NSInteger )status{
    
    NSString *statusStr = @"满标";
    switch (status) {
        case 0:
            statusStr = @"未审核";
            break;
        case 1:
            statusStr = @"待确认";
            break;
        case 2:
            statusStr = @"招标中";
            break;
        case 3:
            statusStr = @"流标";
            break;
        case 4:
            statusStr = @"满标";
            break;
        case 5:
            statusStr = @"回款中";
            break;
        case 6:
            statusStr = @"已回款";
            break;
        case 7:
            statusStr = @"未审核";
            break;
            
        default:
            statusStr = @"满标";
            break;
    }
    return statusStr;
}

@end
