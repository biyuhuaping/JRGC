//
//  UCFTableCellOne.m
//  JRGC
//
//  Created by NJW on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFTableCellOne.h"

@interface UCFTableCellOne ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineThirdHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineFourthWidth;

@end

@implementation UCFTableCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineOneHeight.constant = 0.5;
    self.lineTwoHeight.constant = 0.5;
    self.lineThirdHeight.constant = 0.5;
    self.lineFourthWidth.constant = 0.5;
}

- (void)setAccountInfo:(NSDictionary *)accountInfo
{
    _accountInfo = accountInfo;
    // 昨日收益
    NSString *addedProfit = [accountInfo objectForKey:@"totalIncome"];
    if (addedProfit == nil || addedProfit.length == 0) {
        _addedProfit.text = @"0.00";
    }
    else {
        _addedProfit.text = addedProfit;
    }
    
    // 可用余额
    NSString *availBalance = [accountInfo objectForKey:@"availableBalance"];
    if (availBalance == nil || availBalance.length == 0) {
        _availableBalance.text = @"0.00";
    }
    else {
        _availableBalance.text = availBalance;
    }
    
    
    // 累计收益
    NSString *frozenMoney = [accountInfo objectForKey:@"frozenBalance"];
    if (frozenMoney == nil || frozenMoney.length == 0) {
        _frozenMoney.text = @"0.00";
    }
    else {
        _frozenMoney.text = frozenMoney;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
