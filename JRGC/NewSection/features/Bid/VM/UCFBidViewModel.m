//
//  UCFBidViewModel.m
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBidViewModel.h"
#import "UCFToolsMehod.h"
@interface UCFBidViewModel()
@property (nonatomic, strong)UCFBidModel *model;
@end

@implementation UCFBidViewModel



- (void)setDataModel:(UCFBidModel *)model
{
    self.model = model;
    //标头
    [self dealBidHeader];
    //标信息
    [self dealBidInfo];
    //二级标签
    [self dealMarkView];
    //我的资金
    [self dealMyFunds];
    //我的优惠券
    [self dealMycoupon];
    //我的合同
    [self dealMyContract];
}
- (void)dealBidHeader
{
    
    self.prdName = self.model.data.prdClaim.prdName;
    self.prdLabelsList = self.model.data.prdClaim.prdLabelsList;
    self.platformSubsidyExpense = self.model.data.prdClaim.platformSubsidyExpense;
    self.guaranteeCompanyName = self.model.data.prdClaim.guaranteeCompanyName;
    self.fixedDate = self.model.data.prdClaim.fixedDate;
    self.holdTime = self.model.data.prdClaim.holdTime;
}
- (void)dealBidInfo
{
    self.annualRate = [NSString stringWithFormat:@"%@%%",self.model.data.prdClaim.annualRate];
    
    if (self.model.data.prdClaim.holdTime.length > 0) {
       self.timeLimitText = [NSString stringWithFormat:@"%@~%@",self.model.data.prdClaim.holdTime,self.model.data.prdClaim.repayPeriodtext];//投资期限
    }else{
        self.timeLimitText = self.model.data.prdClaim.repayPeriodtext;//投资期限
    }
    
    NSString *remainStr = [NSString stringWithFormat:@"%.2f",self.model.data.prdClaim.borrowAmount - self.model.data.prdClaim.completeLoan];
    remainStr = [UCFToolsMehod AddComma:remainStr];
    self.remainingMoney = [NSString stringWithFormat:@"¥%@",remainStr];//剩余钱数
}
- (void)dealMarkView
{
    if (self.prdLabelsList.count > 0) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (NSDictionary *dic in _prdLabelsList) {
            NSInteger labelPriority = [dic[@"labelPriority"] integerValue];
            if (labelPriority > 1) {
                if ([dic[@"labelName"] rangeOfString:@"起投"].location == NSNotFound) {
                    [tmpArr addObject:dic[@"labelName"]];
                }
            }
        }
        self.markList = tmpArr;
    }
}
- (void)dealMyFunds
{
    
    NSString *availableFundsStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",self.model.data.accountAmount]];
    self.myFundsNum  = [NSString stringWithFormat:@"¥%@",availableFundsStr];
    
    NSString *gondDouBalancStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",self.model.data.beanAmount/100.0f]];
    self.myBeansNum = [NSString stringWithFormat:@"¥%@",gondDouBalancStr];
    
    NSString *totalMoney =[UCFToolsMehod AddComma: [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount + self.model.data.beanAmount/100.0f]];
    self.totalFunds = [NSString stringWithFormat:@"¥%@",totalMoney];
    
    NSString *palceText = [NSString stringWithFormat:@"%ld元起投",self.model.data.prdClaim.minInvest];
    if ([self.model.data.prdClaim.maxInvest length] != 0) {
        palceText = [palceText stringByAppendingString:[NSString stringWithFormat:@",限投%@元",self.model.data.prdClaim.maxInvest]];
    }
    self.inputViewPlaceStr = palceText;

}
- (void)dealMyfundsNumWithBeansSwitch:(UISwitch *)switchView
{
    if (switchView.on) {
        NSString *totalMoney =[UCFToolsMehod AddComma: [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount + self.model.data.beanAmount/100.0f]];
        self.totalFunds = [NSString stringWithFormat:@"¥%@",totalMoney];
    } else {
        NSString *availableFundsStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",self.model.data.accountAmount]];
        self.totalFunds = [NSString stringWithFormat:@"¥%@",availableFundsStr];
    }
}
- (void)calculate:(NSString *)investMoney
{
    NSString *type = self.model.data.calcType;
    double currentMoney = [investMoney doubleValue];
    double calcRate = self.model.data.calcRate;
    double calcTerm = self.model.data.calcTerm;
    double totalIntersate = 0;
    if ([type isEqualToString:@"PMT"]) {
        double a = currentMoney*calcRate*(1+calcRate);
        double value = pow(a, calcTerm);
        double b = (1+calcRate);
        double value1 = pow(b, calcTerm) - 1;
        totalIntersate = value/value1 *calcTerm - currentMoney;
    } else {
        totalIntersate = currentMoney * calcRate * calcTerm;
        
    }
    self.expectedInterestNum = [NSString stringWithFormat:@"¥%.2f",totalIntersate < 0.01 ? 0.00 : totalIntersate];
}
- (void)dealMycoupon
{
    if ([self.model.data.cashNum integerValue] > 0) {
        NSString *cashNum = [NSString stringWithFormat:@"%@张可用",self.model.data.cashNum];
        self.cashNum = cashNum;
    } else {
        self.cashIsHide = YES;
    }
    
    if ([self.model.data.couponNum integerValue] > 0) {
        NSString *couponNum = [NSString stringWithFormat:@"%@张可用",self.model.data.couponNum];
        self.couponNum = couponNum;
    } else {
        self.couponIsHide = YES;
    }
    if (self.cashIsHide && self.couponIsHide) {
        self.headherIsHide = YES;
    }
}
- (void)dealMyContract
{
    NSString *limitAmountMess = self.model.data.limitAmountMess;
    if (limitAmountMess.length > 0) {
        NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString  *limitAmount = [limitAmountMess stringByTrimmingCharactersInSet:nonDigits];
        self.limitAmountMess = limitAmountMess;
        self.limitAmountNum = limitAmount;
    } else {
        self.limitAmountMess = @"";
    }
    NSString *cfcaContractName = self.model.data.cfcaContractName;
    self.cfcaContractName = cfcaContractName;
    
    NSArray *contractMsg = self.model.data.contractMsg;
    self.contractMsg = contractMsg;
    
    
}
@end
