//
//  UCFCollectionViewModel.m
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionViewModel.h"
#import "UCFBatchPageRootModel.h"
@interface UCFCollectionViewModel()
@property(nonatomic, strong)UCFBatchPageRootModel *dataModel;

@end


@implementation UCFCollectionViewModel
- (void)setModel:(BaseModel *)model
{
    self.dataModel = (UCFBatchPageRootModel *)model;
    
    //标头
    [self dealBidHeader];
    //标信息
    [self dealBidInfo];
    //二级标签
    [self dealMarkView];
    
    [self dealMyFunds];
}
- (void)dealBidHeader
{
    NSString *prdName = self.dataModel.data.colPrdClaimDetail.colName;
    self.prdName = prdName;
}
- (void)dealBidInfo
{
    NSString *annualRate = self.dataModel.data.colPrdClaimDetail.colRate;
    if (annualRate.length > 0) {
        self.annualRate = [NSString stringWithFormat:@"%@%%",annualRate];
    }
    NSString *timeLimitText = self.dataModel.data.colPrdClaimDetail.colPeriodTxt;
    if (annualRate.length > 0) {
        self.timeLimitText = [NSString stringWithFormat:@"%@",timeLimitText];
    }
    NSString *remainingMoney = [NSString stringWithFormat:@"%.2f",self.dataModel.data.colPrdClaimDetail.canBuyAmt];
    if (remainingMoney.length > 0) {
        remainingMoney = [NSString AddComma:remainingMoney];
        self.remainingMoney = [NSString stringWithFormat:@"¥%@",remainingMoney];//剩余钱数
    }
}
- (void)dealMarkView
{
    NSString *colMinInvest = [NSString stringWithFormat:@"%.2f元起",self.dataModel.data.colPrdClaimDetail.colMinInvest];
    NSString *colRepayModeTxt = [NSString stringWithFormat:@"%@",self.dataModel.data.colPrdClaimDetail.colRepayModeTxt];
    self.markList = @[colMinInvest,colRepayModeTxt];
}

- (void)dealMyFunds
{
    NSString *myMoney = [NSString stringWithFormat:@"%.2f",self.dataModel.data.availableBalance];
    myMoney = [NSString AddComma:myMoney];
    self.myMoneyNum = [NSString stringWithFormat:@"¥%@",myMoney];
    
    NSString *investAmt =[NSString stringWithFormat:@"%.2f元起",self.dataModel.data.colPrdClaimDetail.colMinInvest];
    self.inputViewPlaceStr = [NSString stringWithFormat:@"%@",investAmt];
}
//计算预期收益
- (void)calculate:(NSString *)investMoney
{
    
}
//全投按钮
- (void)calculateTotalMoney
{
    
}
@end
