//
//  UCFCashRecordCell.m
//  JRGC
//
//  Created by hanqiyuan on 2016/12/29.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFCashRecordCell.h"
#import "UCFToolsMehod.h"
#import "UIDic+Safe.h"
@implementation UCFCashRecordCell

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
    self.orderNumLabel.text = [dataDict objectSafeForKey:@"indentNo"];
    NSString *reflectAmount = [dataDict objectSafeForKey:@"reflectAmount"];
    NSString *reflectAmountStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",[reflectAmount doubleValue]]];
    self.moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",reflectAmountStr];
    self.timeValueLabel.text = [dataDict objectSafeForKey:@"happenTime"];
    NSInteger statue = [[dataDict objectForKey:@"handleState"] integerValue];
    
    NSString *withdrawModeStr = [dataDict objectSafeForKey:@"withdrawMode"];
    if ([withdrawModeStr isEqualToString:@""]) {//如果提现方式为空 就隐藏该字段
        self.cashWayViewHight.constant = 0;
        self.cashWayLabel.hidden  = YES;
        self.withdrawalWayLabel.hidden = YES;
        
    }else{
        self.cashWayViewHight.constant = 27;
        self.cashWayLabel.hidden  = NO;
        self.withdrawalWayLabel.hidden = NO;
        if ([withdrawModeStr intValue] == 1) { // 1:实时到账 2:大额提现
          self.cashWayLabel.text = @"实时到账";
        }else{
          self.cashWayLabel.text = @"大额提现";
        }
    }
    //  0：未处理；7：已退款；9：提现成功；10：提现失败；11：处理中
    if (statue == 9) { // 9:提现成功
        self.statueLabel.textColor = UIColorWithRGB(0x4aa1f9);
    }else if(statue == 11 || statue == 10) // 10：提现失败；11：处理中
    {
        self.statueLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }else{ //0：未处理；7：已退款；
        self.statueLabel.textColor = UIColorWithRGB(0x999999);
    }
    switch (statue) {
        case 0:
        {
            self.statueLabel.text = @"未处理";
        }
            break;
        case 7:
        {
            self.statueLabel.text = @"已退款";
        }
            break;
        case 9:
        {
            self.statueLabel.text = @"提现成功";
        }
            break;
        case 10:
        {
            self.statueLabel.text = @"提现失败";
        }
            break;
        case 11:
        {
            self.statueLabel.text = @"处理中";
        }
        default:
            break;
    }

}
@end
