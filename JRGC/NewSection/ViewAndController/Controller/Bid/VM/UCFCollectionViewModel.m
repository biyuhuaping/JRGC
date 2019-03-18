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
    
    //我的合同
    [self dealMyContract];
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
    NSString *str =   [self GetDefaultText];
     self.allMoneyInputNum = str;
}

-(NSString *)GetDefaultText
{
    //    InvestmentItemInfo * info1 = [[InvestmentItemInfo alloc] initWithDictionary:[_dataDict objectForKey:@"data"]];
    
//    NSDictionary *colPrdClaimDetailDict = [_dataDict objectSafeDictionaryForKey:@"colPrdClaimDetail"];
    
    NSString *canBuyAmtStr = [NSString stringWithFormat:@"%.2f",self.dataModel.data.colPrdClaimDetail.canBuyAmt];
    
    
    long long int keTouJinE = round(([canBuyAmtStr doubleValue])* 100);
    
    
    long long int keYongZiJin = round(self.dataModel.data.availableBalance * 100);
    
//    NSInteger gongDouCount = [[_dataDict objectForKey:@"beanAmount"] integerValue];
//    if (!isGongDouSwitch) {
//        gongDouCount = 0;
//    }
//    keYongZiJin += gongDouCount;
    
    NSString *colMinInvestStr = [NSString stringWithFormat:@"%.2f",self.dataModel.data.colPrdClaimDetail.colMinInvest];
    long long int minInVestNum = round([colMinInvestStr intValue]* 100);
    
    //判断是不是最后一笔
    if (keTouJinE - minInVestNum < minInVestNum) {
        return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keTouJinE)/100.0f]];
    } else {
        if (keYongZiJin < minInVestNum) {
            return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(minInVestNum)/100.0f]];
        }
        if (keYongZiJin >= minInVestNum && keYongZiJin < keTouJinE) {
            if (keYongZiJin + minInVestNum < keTouJinE) {
                return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keYongZiJin)/100.0f]];
            } else {
                return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keTouJinE - minInVestNum)/100.0f]];
            }
        }
        if (keYongZiJin >= minInVestNum && keYongZiJin >= keTouJinE) {
            return [self checkBeyondLimit:[NSString stringWithFormat:@"%.2lf",(double)(keTouJinE)/100.0f]];
        }
    }
    return @"100.0";
}
- (NSString *)checkBeyondLimit:(NSString *)investMoney
{
    
    //    NSString *maxIn = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"batchAmount"]];
    //    if (maxIn.length != 0) {
    //        if ([Common stringA:investMoney ComparedStringB:maxIn] == 1) {
    //            return maxIn;
    //        } else {
    //            return investMoney;
    //        }
    //    }
    return investMoney;
}
- (void)dealMyContract
{
    NSString *cfcaContractName = self.dataModel.data.cfcaContractName;
    if (cfcaContractName.length > 0) {
        self.cfcaContractName = cfcaContractName;
    }
    //显示风险出借
    self.isShowRisk = YES;
    //
    self.contractMsg = @[@"出借人承诺书",@"履行反洗钱义务的承诺书"];
}

- (void)bidViewModel:(UCFCollectionViewModel *)viewModel WithContractName:(NSString *)contractName
{
    UCFContractTypleModel *model = [UCFContractTypleModel new];
    if ([contractName isEqualToString:@"网络借贷出借风险及禁止性行为提示"]) {
        model.type = @"1";
        model.url = PROTOCOLRISKPROMPT;
        model.title = @"网络借贷出借风险及禁止性行为提示";
        self.contractTypeModel = model;
    }else if ([contractName isEqualToString:@"CFCA数字证书服务协议"]) {
        model.type = @"1";
        model.url = self.dataModel.data.cfcaContractUrl;
        model.title = @"CFCA数字证书服务协议";
        self.contractTypeModel = model;
    } else if ([contractName isEqualToString:@"出借人承诺书"]) {
        model.type = @"1";
        model.url = PROTOCOLENDERPROMISE;
        model.title = @"出借人承诺书";
        self.contractTypeModel = model;
    } else if ([contractName isEqualToString:@"履行反洗钱义务的承诺书"]) {
        model.type = @"1";
        model.url = PROTOCOLENTUSTTRANSFER;
        model.title = @"履行反洗钱义务的承诺书";
        self.contractTypeModel = model;
    }
}
@end
