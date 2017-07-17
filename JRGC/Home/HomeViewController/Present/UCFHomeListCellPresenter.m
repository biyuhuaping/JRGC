//
//  UCFHomeListCellPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListCellPresenter.h"

#define CELLRATE (600/180)

@interface UCFHomeListCellPresenter ()
@property (strong, nonatomic) UCFHomeListCellModel *item;
@end

@implementation UCFHomeListCellPresenter
+ (instancetype)presenterWithItem:(UCFHomeListCellModel *)item {//懒
    UCFHomeListCellPresenter *presenter = [UCFHomeListCellPresenter new];
    presenter.item = item;
    return presenter;
}

- (NSString *)proTitle
{
    return self.item.prdName;
}

- (UCFHomeListCellModelType)modelType
{
    return self.item.moedelType ? self.item.moedelType : UCFHomeListCellModelTypeDefault;
}

- (NSString *)type
{
    return self.item.type ? self.item.type : @"";
}

- (NSString *)annualRate
{
    if ([self.item.type isEqualToString:@"3"]) {
        return self.item.annualRate ? [NSString stringWithFormat:@"%@克/100克", self.item.annualRate] : @"0.000克/100克" ;
    }
    return self.item.annualRate ? [NSString stringWithFormat:@"%@%%",self.item.annualRate] : @"0.0%";
}

- (NSString *)repayModeText
{
    return self.item.repayModeText;
}

- (NSString *)repayPeriodtext
{
    return self.item.repayPeriodtext;
}

- (NSString *)minInvest
{
    return self.item.minInvest ? [NSString stringWithFormat:@"%@元起", self.item.minInvest] : @"";
}

- (NSString *)availBorrowAmount
{
    NSString *temp = [NSString stringWithFormat:@"%lf",[self.item.borrowAmount doubleValue]-[self.item.completeLoan doubleValue]];
    return [self moneywithRemaining:temp total:self.item.borrowAmount];
}

- (NSString *)platformSubsidyExpense
{
    return self.item.platformSubsidyExpense;
}

- (NSString *)guaranteeCompany
{
    return self.item.guaranteeCompany;
}

- (NSString *)fixedDate
{
    return self.item.fixedDate;
}

- (NSString *)holdTime
{
    return self.item.holdTime;
}

- (NSString *)totalCount
{
    return self.item.totalCount;
}

- (NSString *)p2pTransferNum
{
    return self.item.p2pTransferNum;
}

- (NSString *)zxTransferNum
{
    return self.item.zxTransferNum;
}

- (NSString *)transferNum
{
    return self.item.transferNum;
}

- (CGFloat)cellHeight
{
    if (self.item.moedelType == UCFHomeListCellModelTypeDefault) {
        return 95.0;
    }
    else {
        return (ScreenWidth - 20) / CELLRATE + 15;
    }
    return 0;
}

- (NSString *)moneywithRemaining:(id)rem total:(id)total{
    NSInteger rem1 = [rem integerValue]*0.0001;
    double rem2 = [rem doubleValue]*0.0001;
    
    NSInteger total1 = [total integerValue]*0.0001;
    double total2 = [total doubleValue]*0.0001;
    
    NSString *str1 = @"";
    NSString *str2 = @"";
    
    if (rem1 == rem2) {
        str1 = [NSString stringWithFormat:@"%.f万",rem2];
    }else
        str1 = [NSString stringWithFormat:@"%.2f万",rem2];
    
    if (total1 == total2) {
        str2 = [NSString stringWithFormat:@"%.f万",total2];
    }else
        str2 = [NSString stringWithFormat:@"%.2f万",total2];
    
    //    return [NSString stringWithFormat:@"剩%@/%@",str1,str2];
    //标未满的时候显示剩余 //满标的时候，显示总额
    if (rem2 == 0) {
        return [NSString stringWithFormat:@"%@",str2];
    }
    return [NSString stringWithFormat:@"剩%@",str1];
}

@end
