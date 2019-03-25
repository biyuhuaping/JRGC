//
//  UCFMyBatchBidViewModel.m
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMyBatchBidViewModel.h"

@implementation UCFMyBatchBidViewModel

- (void)setMyBatchModel:(UCFMyBtachBidRoot *)myBatchModel
{
    _myBatchModel = myBatchModel;
    
    //处理头信息
    [self dealNavData];
    //处理标头
    [self dealBidInfo];
    
    [self dealMarkInfo];
    
    //处理投标按钮状态
    [self invetsButtonState];
}
- (void)dealNavData
{
    NSString *prdName = _myBatchModel.data.colPrdClaimDetail.colName;
    if (prdName.length > 0) {
        self.prdName = prdName;
    }
}
- (void)dealBidInfo
{
    NSString *annualRate = _myBatchModel.data.colPrdClaimDetail.colRate;
    if (annualRate.length > 0) {
        self.annualRate = [NSString stringWithFormat:@"%@%%",annualRate];
    }
    NSString *markTimeStr = @"";
    markTimeStr =  _myBatchModel.data.colPrdClaimDetail.colPeriodTxt;
    if (markTimeStr.length > 0) {
        self.markTimeStr = markTimeStr;
    }

    
    NSString *remainMoney = [NSString stringWithFormat:@"¥%.2f", _myBatchModel.data.colPrdClaimDetail.canBuyAmt];
    self.remainMoney = remainMoney;
    
    NSString *projectNum = [NSString stringWithFormat:@"%ld个", _myBatchModel.data.colPrdClaimDetail.canBuyCount];
    self.projectNum = projectNum;
    
    CGFloat currentPro = (_myBatchModel.data.colPrdClaimDetail.totalAmt - _myBatchModel.data.colPrdClaimDetail.canBuyAmt) / _myBatchModel.data.colPrdClaimDetail.totalAmt;
    
    NSString *percentage =[NSString stringWithFormat:@"%.0f", currentPro * 100];
    self.percentage = percentage;
}
- (void)dealMarkInfo
{
    NSString *colMinInvestStr = [NSString stringWithFormat:@"%.0f元起投",_myBatchModel.data.colPrdClaimDetail.colMinInvest];
    NSString *colRepayModeStr = _myBatchModel.data.colPrdClaimDetail.colRepayModeTxt;

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    if (colMinInvestStr.length > 0) {
        [arr addObject:colMinInvestStr];
    }
    if (colRepayModeStr.length > 0) {
        [arr addObject:colRepayModeStr];
    }
    self.markList = [NSArray arrayWithArray:arr];
}
- (void)invetsButtonState
{
    self.bidInvestText = @"查看奖励";
}
@end
