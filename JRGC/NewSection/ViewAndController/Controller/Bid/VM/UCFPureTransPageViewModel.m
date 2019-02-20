//
//  UCFPureTransPageViewModel.m
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPureTransPageViewModel.h"
#import "NSString+Tool.h"
#import "NetworkModule.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
@interface UCFPureTransPageViewModel ()<NetworkModuleDelegate>
@property(nonatomic, strong)UCFPureTransBidRootModel *model;
@property (nonatomic, strong)UCFContractTypleModel *contractTmpModel;
@end

@implementation UCFPureTransPageViewModel
- (void)setDataModel:(UCFPureTransBidRootModel *)model
{
    self.model = model;
    [self dealBidMessage];
}
- (void)dealBidMessage
{
    //标头
    [self dealBidHeader];
    //标信息
    [self dealBidInfo];
    //二级标签
    [self dealMarkView];
    //我的资金
    [self dealMyFunds];
    //我的合同
    [self dealMyContract];
//
//    [self requestCoupnData];
}
- (void)dealBidHeader
{
    NSString *prdName = self.model.data.name;
    self.prdName = prdName;
}
- (void)dealBidInfo
{
    NSString *annualRate = self.model.data.transfereeYearRate;
    if (annualRate.length > 0) {
        self.annualRate = [NSString stringWithFormat:@"%@%%",annualRate];
    }
    NSString *timeLimitText = self.model.data.lastDays;
    if (annualRate.length > 0) {
        self.timeLimitText = [NSString stringWithFormat:@"%@天",timeLimitText];
    }
    NSString *remainingMoney = self.model.data.cantranMoney;
    if (remainingMoney.length > 0) {
        remainingMoney = [NSString AddComma:remainingMoney];
        self.remainingMoney = [NSString stringWithFormat:@"¥%@",remainingMoney];//剩余钱数
    }
}
- (void)dealMarkView
{
    if (self.model.prdLabelsList.count > 0) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (UCFTransPurePrdlabelslist *tmpModel in self.model.prdLabelsList) {
            NSInteger labelPriority = [tmpModel.labelPriority integerValue];
            if (labelPriority > 1) {
                if ([tmpModel.labelName rangeOfString:@"起投"].location == NSNotFound) {
                    [tmpArr addObject:tmpModel.labelName];
                }
            }
        }
        self.markList = tmpArr;
    }
}
- (void)dealMyFunds
{
    NSString *myMoney = self.model.data.actBalance;
    myMoney = [NSString AddComma:myMoney];
    self.myMoneyNum = [NSString stringWithFormat:@"¥%@",myMoney];
    
    NSString *investAmt = self.model.data.investAmt;
    self.inputViewPlaceStr = [NSString stringWithFormat:@"%@起投",investAmt];
    
}
- (void)calculateTotalMoney
{
    NSString *allMoneyInputNum = @"100";
    if ([self.model.data.type isEqualToString:@"2"]) {
        allMoneyInputNum = [self getHonerDefaultText];
    } else {
        allMoneyInputNum = [self getP2PDefaultText];
    }
    self.allMoneyInputNum = allMoneyInputNum;
    
}
-(NSString*)getHonerDefaultText{
    NSString *cantranMoney = self.model.data.cantranMoney;
    NSString *keTouJinEStr = [NSString stringWithFormat:@"%.2lf",[cantranMoney doubleValue]];
    return keTouJinEStr;
}
- (NSString *)getP2PDefaultText
{
    NSString *cantranMoney = self.model.data.cantranMoney;
    long long int keTouJinE = round(([cantranMoney doubleValue]) * 100) ;
    long long int keYongZiJin = round([self.model.data.actBalance doubleValue] * 100);
    NSString*  investAmt = self.model.data.investAmt;
    long long int minInVestNum = round([investAmt intValue]* 100);
    
    if (keTouJinE - minInVestNum < minInVestNum) {
        return [NSString stringWithFormat:@"%.2lf",(double)(keTouJinE)/100.0f];
    } else {
        if (keYongZiJin < minInVestNum) {
            return [NSString stringWithFormat:@"%.2lf",(double)(minInVestNum)/100.0f];
        }
        if (keYongZiJin >= minInVestNum && keYongZiJin < keTouJinE) {
            if (keYongZiJin + minInVestNum < keTouJinE) {
                return [NSString stringWithFormat:@"%.2lf",(double)(keYongZiJin)/100.0f];
            } else {
                return [NSString stringWithFormat:@"%.2lf",(double)(keTouJinE - minInVestNum)/100.0f];
            }
        }
        if (keYongZiJin >= minInVestNum && keYongZiJin >= keTouJinE) {
            return [NSString stringWithFormat:@"%.2lf",(double)(keTouJinE)/100.0f];
        }
    }
    return @"100";
}
- (void)calculate:(NSString *)currentText
{
    NSString *annualRate = self.model.data.transfereeYearRate;
    NSString *timeLimitText = self.model.data.lastDays;
    double value  = ([annualRate doubleValue]/100.0f) * ([timeLimitText integerValue]/360.0) * [currentText doubleValue];
    
    CGFloat discountRate = self.model.data.discountRate;
    double value1  = (discountRate/100.0f) * ([timeLimitText integerValue]/360.0) * [currentText doubleValue];
    self.expectedInterestStr = [NSString stringWithFormat:@"¥%.2f+¥%.2f工豆",value,value1];

}

- (void)dealMyContract
{
    NSString *cfcaContractNameStr =  self.model.cfcaContractName;
    SelectAccoutType type = [self.model.data.type isEqualToString:@"2"] ? SelectAccoutTypeHoner : SelectAccoutTypeP2P;
    if (type == SelectAccoutTypeP2P) {
        if (cfcaContractNameStr.length > 0) {
            self.isShowCFCA = YES;
        } else {
            self.isShowCFCA = NO;
        }
        self.isShowRisk = YES;
    } else {
        if (cfcaContractNameStr.length > 0) {
            self.isShowCFCA = YES;
        } else {
            self.isShowCFCA = NO;
        }
        self.isShowRisk = NO;
    }
    
    NSArray *contractMsg = self.model.contractMsg;
    self.contractMsg = contractMsg;
    
    if (type == SelectAccoutTypeHoner) {
        self.isShowHonerTip = YES;
    } else {
        self.isShowHonerTip = NO;
    }
}

/**
 合同点击
 
 @param viewModel self
 @param contractName 合同名称
 */
- (void)bidViewModel:(UCFPureTransPageViewModel *)viewModel WithContractName:(NSString *)contractName
{
    UCFContractTypleModel *model = [UCFContractTypleModel new];
    if ([contractName isEqualToString:@"网络借贷出借风险及禁止性行为提示"]) {
        model.type = @"1";
        model.url = PROTOCOLRISKPROMPT;
        model.title = @"网络借贷出借风险及禁止性行为提示";
        self.contractTypeModel = model;
    }else if ([contractName isEqualToString:@"CFCA数字证书服务协议"]) {
        model.type = @"1";
        model.url = self.model.cfcaContractUrl;
        model.title = self.model.cfcaContractName;
        self.contractTypeModel = model;
    } else {
        for (UCFTransPureContractmsg *tmpModel in self.model.contractMsg) {
            if ([tmpModel.contractName isEqualToString:contractName]) {
                
                NSString *projectId = self.model.data.ID;
                NSString *contractTypeStr = tmpModel.contractType;
                model.type = @"3";
                model.title = tmpModel.contractName;
                self.contractTmpModel = model;
                NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdClaimId=%@&contractType=%@&prdType=1",SingleUserInfo.loginData.userInfo.userId,projectId,contractTypeStr];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetContractMsg owner:self Type:[self.model.data.type isEqualToString:@"2"] ? SelectAccoutTypeHoner : SelectAccoutTypeP2P];
                
                break;
            }
        }
    }
}
- (void)beginPost:(kSXTag)tag
{
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    if (_superView) {
        [MBProgressHUD hideAllHUDsForView:_superView animated:YES];
    }
    if(tag.intValue == kSXTagGetContractMsg) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSDictionary *dictionary =  [dic objectSafeDictionaryForKey:@"contractMess"];
        NSString *status = [dic objectSafeForKey:@"status"];
        if ([status intValue] == 1) {
            NSString *contractMessStr = [dictionary objectSafeForKey:@"contractMess"];
            self.contractTmpModel.htmlContent = contractMessStr;
            self.contractTypeModel = self.contractTmpModel;
        }else{
            
        }
    }  else if (tag.intValue == kSXTagInvestSubmit){
        /*
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        BOOL rstcode = [dic[@"ret"] boolValue];
        if(rstcode)
        {
            //赋值 反射到Controller 做操作
            self.hsbidInfoDict = dic;
        }
        else
        {
            if ([dic[@"code"] integerValue] == 43016) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"message"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
                alert.tag = 10023;
                [alert show];
            } else {
                [self reloadVMData];
                [MBProgressHUD displayHudError:[dic objectSafeForKey:@"message"]];
            }
        }
    } else if (tag.intValue == kSXTagP2PPrdClaimsDealBid) {
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([dic[@"ret"] boolValue]) {
            UCFBidModel *tmpModel = [UCFBidModel yy_modelWithJSON:result];
            [self setDataModel:tmpModel];
            //            self.model = tmpModel;
            //            //我的资金
            //            [self dealMyFunds];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
            alert.tag = 10023;
            [alert show];
        }
         */
        
    }
}

-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:_superView animated:YES];
}
@end
