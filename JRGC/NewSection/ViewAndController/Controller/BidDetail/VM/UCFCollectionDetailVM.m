//
//  UCFCollectionDetailVM.m
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionDetailVM.h"

@interface UCFCollectionDetailVM()
@property(nonatomic,strong)UCFBatchRootModel *dataModel;
@end


@implementation UCFCollectionDetailVM
- (void)setModel:(BaseModel *)model
{
    if ([model isKindOfClass:[UCFBatchRootModel class]]) {
        self.dataModel = (UCFBatchRootModel *)model;
    }
    
    [self dealNavData];
    
    [self dealBidInfoData];
    
    [self dealMarkInfo];
    
    //处理投标按钮状态
    [self invetsButtonState];
}
- (void)dealNavData
{
    NSString *colName = self.dataModel.data.colName;
    if (colName.length > 0) {
        self.prdName = colName;
    }
}
- (void)dealBidInfoData
{
    NSString *annualRate = self.dataModel.data.colRate;
    if (annualRate.length > 0) {
        self.annualRate = [NSString stringWithFormat:@"%@%%",annualRate];
    }
    NSString *markTimeStr = @"";
    if (_dataModel) {
        markTimeStr = self.dataModel.data.colPeriod;
        if (markTimeStr.length > 0) {
            self.markTimeStr = markTimeStr;
        }
    } else {
//        markTimeStr = self.dataModel.data.colPeriodTxt;
//        colPeriodStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"colPeriodTxt"] ];
    }
    
    NSString *remainMoney = [NSString stringWithFormat:@"¥%.2f", [self.dataModel.data.canBuyAmt floatValue]];
    self.remainMoney = remainMoney;
    
    NSString *projectNum = [NSString stringWithFormat:@"%ld个",self.dataModel.data.canBuyCount];
    self.projectNum = projectNum;
    
    NSString *percentage =[NSString stringWithFormat:@"%.0f",self.dataModel.data.percentage] ;
    self.percentage = percentage;
}

- (void)dealMarkInfo
{
    NSString *colMinInvestStr = [NSString stringWithFormat:@"%ld元起投",self.dataModel.data.colMinInvest];
    NSString *colRepayModeStr = @"";
    if (_dataModel) {
        colRepayModeStr = self.dataModel.data.colRepayMode;
    } else {
//        colRepayModeStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"colRepayModeTxt"] ];
    }
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
    if (self.dataModel.data.isfull) {
        self.bidInvestText = @"已售罄";
    } else {
        self.bidInvestText = @"批量出借";
    }
    
}

- (void)dealClickAction:(NSString *)title
{
    @PGWeakObj(self);
    NSString *colPrdClaimId = [NSString stringWithFormat:@"%ld",self.dataModel.data.colPrdClaimId];
    UCFIntoBatchPageRequest *api = [[UCFIntoBatchPageRequest alloc] initWithTenderID:colPrdClaimId];
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        UCFBatchPageRootModel *model = request.responseJSONModel;
        selfWeak.collcetionBidPageModel = model;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    [api start];
}
@end
