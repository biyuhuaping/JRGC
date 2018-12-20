//
//  UCFBidViewModel.m
//  JRGC
//
//  Created by zrc on 2018/12/14.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBidViewModel.h"
#import "UCFToolsMehod.h"
#import "NetworkModule.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
@interface UCFBidViewModel()<NetworkModuleDelegate>
{
    BOOL beansSwitch;
    double  needToRechare;
}
@property (nonatomic, strong)UCFBidModel *model;
@property (nonatomic, strong)UCFContractTypleModel *contractTmpModel;
@property (nonatomic, strong)NSString       *investMoeny;
@property (nonatomic, strong)NSString       *recommendCode;
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
    
    [self dealMyRecommend];
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

/**
 给资金面板数据赋值，将反射到view上
 */
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

/**
 工豆开关回调方法

 @param switchView 工豆开关
 */
- (void)dealMyfundsNumWithBeansSwitch:(UISwitch *)switchView
{
    beansSwitch = switchView.on;
    if (beansSwitch) {
        NSString *totalMoney =[UCFToolsMehod AddComma: [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount + self.model.data.beanAmount/100.0f]];
        self.totalFunds = [NSString stringWithFormat:@"¥%@",totalMoney];
    } else {
        NSString *availableFundsStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",self.model.data.accountAmount]];
        self.totalFunds = [NSString stringWithFormat:@"¥%@",availableFundsStr];
    }
}

/**
 计算预期收益

 @param investMoney 输入框金额
 */
- (void)calculate:(NSString *)investMoney
{
    self.investMoeny = investMoney;
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

- (void)dealMyRecommend
{
    BOOL isLimit = self.model.data.isLimit;
    self.isLimit = isLimit;
}
- (void)outputRecommendCode:(NSString *)string
{
    self.recommendCode = string;
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

/**
 合同点击

 @param viewModel self
 @param contractName 合同名称
 */
- (void)bidViewModel:(UCFBidViewModel *)viewModel WithContractName:(NSString *)contractName
{
    UCFContractTypleModel *model = [UCFContractTypleModel new];
    if ([contractName isEqualToString:@"网络借贷出借风险及禁止性行为提示"]) {
        model.type = @"1";
        model.url = PROTOCOLRISKPROMPT;
        model.title = @"网络借贷出借风险及禁止性行为提示";
        self.contractTypeModel = model;
    }else if ([contractName isEqualToString:@"《CFCA数字证书服务协议》"]) {
        model.type = @"1";
        model.url = self.model.data.cfcaContractUrl;
        model.title = self.model.data.cfcaContractName;
        self.contractTypeModel = model;
    } else {
        for (ContractModel *tmpModel in self.model.data.contractMsg) {
            if ([tmpModel.contractName isEqualToString:contractName]) {
                if (tmpModel.contractUrl && tmpModel.contractUrl.length > 0) {
                    model.type = @"1";
                    model.title = tmpModel.contractName;
                    model.url =tmpModel.contractUrl;
                    self.contractTypeModel = model;
                } else {
                    NSString *projectId = self.model.data.prdClaim.ID;
                    NSString *contractTypeStr = tmpModel.contractType;
                    model.type = @"3";
                    model.title = tmpModel.contractName;
                    self.contractTmpModel = model;
                    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdClaimId=%@&contractType=%@&prdType=0",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],projectId,contractTypeStr];
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetContractMsg owner:self Type:SelectAccoutTypeP2P];
                }
                break;
            }
        }
    }
}

- (void)beginPost:(kSXTag)tag {
    if (_superView) {
        [MBProgressHUD showHUDAddedTo:_superView animated:YES];
    }
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
    } else if (tag.intValue == kSXTagCheckPomoCode) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if ([dic[@"status"] isEqualToString:@"1"]) {
            [self sendBuyDataToService];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"  message:@"工场码不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
            alert.tag = 6000;
            [alert show];
        }
    } else if (tag.intValue == kSXTagInvestSubmit){
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        if([rstcode intValue] == 1)
        {
            //赋值 反射到Controller 做操作
            self.hsbidInfoDict = dic;
        }
        else
        {
//            [self reloadMainView];
            [MBProgressHUD displayHudError:[dic objectSafeForKey:@"message"]];
        }
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    if (_superView) {
        [MBProgressHUD hideAllHUDsForView:_superView animated:YES];
    }
}


- (void)dealInvestLogic
{
    NSString *investMoney = self.investMoeny;
    if ([Common isPureNumandCharacters:investMoney]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return;
    }
    investMoney = [NSString stringWithFormat:@"%.2f",[investMoney doubleValue]];
    if ([Common stringA:@"0.01" ComparedStringB:investMoney] == 1) {
        [MBProgressHUD displayHudError:@"请输入出借金额"];
        return;
    }

    NSString *keTouJinE = [NSString stringWithFormat:@"%.2f",self.model.data.prdClaim.borrowAmount - self.model.data.prdClaim.completeLoan];
    NSString *minInVestNum = [NSString stringWithFormat:@"%ld",self.model.data.prdClaim.minInvest];
    if([Common stringA:minInVestNum ComparedStringB:investMoney] == 1){
        NSString *messageStr = @"出借金额不可低于起投金额";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    NSString *maxIn = [NSString stringWithFormat:@"%@",self.model.data.prdClaim.maxInvest];
    if (maxIn.length != 0) {
        NSString *maxInvest = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",maxIn] doubleValue]];
        if ([Common stringA:investMoney ComparedStringB:maxInvest] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该项目限投¥%@",maxIn] delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
            alert.tag = 1000;
            [alert show];
            return;
        }
    }
    if([Common stringA:investMoney ComparedStringB:keTouJinE] == 1)
    {
        NSString *messageStr = @"不可以这么任性哟，出借金额已超过剩余可投金额了";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    if ([keTouJinE doubleValue] - [investMoney doubleValue] < [minInVestNum doubleValue] && [Common stringA:keTouJinE ComparedStringB:investMoney] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标剩余的金额已不足起投额，不差这一点了亲，全投了吧！" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    
    
    NSString *availableFundsStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",self.model.data.accountAmount]];
    
    NSString *gondDouBalancStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",self.model.data.beanAmount/100.0f]];
    
    NSString *availableBalance = nil;
    
    double availableBala = [availableFundsStr doubleValue];
    
    double gondDouBalance = [gondDouBalancStr doubleValue];
    
    if (beansSwitch) {
        availableBalance = [NSString stringWithFormat:@"%.2f",availableBala + gondDouBalance];
    } else {
        availableBalance = [NSString stringWithFormat:@"%.2f",availableBala];
    }
    
    if([Common stringA:investMoney ComparedStringB:availableBalance] == 1)
    {
        NSString *keyongMoney = availableBalance;
        needToRechare = [investMoney doubleValue] - [keyongMoney doubleValue];
        NSString *showStr = [NSString stringWithFormat:@"总计出借金额¥%@\n可用金额%@\n另需充值金额¥%.2f", investMoney,availableBalance,needToRechare];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可用金额不足" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
        alert.tag = 2000;
        [alert show];
        return;
    }
    /*
    int compare = [Common stringA:investMoney ComparedStringB:@"1000.00"];
    if (compare == 1 || compare == 0 ) {
        [self showLastAlert:investMoney];
    } else {
        [self getNormalBidNetData];
    }
     */
    [self getNormalBidNetData];
}
/*
//投资超过1000最后的提醒框
- (void)showLastAlert:(NSString *)investMoney
{
    NSString *showStr = @"";
    if (self.coupDict && self.cashDict) {
        NSString *cashNum = [self.cashDict valueForKey:@"youhuiNum"];
        NSString *coupNum = [self.coupDict valueForKey:@"youhuiNum"];
        showStr = [NSString stringWithFormat:@"%@金额¥%@,确认%@吗?\n使用返现券%@张(共¥%@)、返息券%@张",_wJOrZxStr,[UCFToolsMehod AddComma:investMoney],_wJOrZxStr, cashNum,[UCFToolsMehod AddComma:[self.cashDict valueForKey:@"youhuiMoney"]], coupNum];
    } else if(self.coupDict) {
        NSString *coupNum = [self.coupDict valueForKey:@"youhuiNum"];
        showStr = [NSString stringWithFormat:@"%@金额¥%@,确认%@吗?\n使用返息券%@张",_wJOrZxStr,[UCFToolsMehod AddComma:investMoney],_wJOrZxStr, coupNum];
        
    } else if(self.cashDict){
        NSString *cashNum = [self.cashDict valueForKey:@"youhuiNum"];
        showStr = [NSString stringWithFormat:@"%@金额¥%@,确认%@吗?\n使用返现券%@张(共¥%@)",_wJOrZxStr,[UCFToolsMehod AddComma:investMoney],_wJOrZxStr, cashNum,[UCFToolsMehod AddComma:[self.cashDict valueForKey:@"youhuiMoney"]]];
    } else {
        showStr = [NSString stringWithFormat:@"%@金额¥%@,确认%@吗?",_wJOrZxStr,[UCFToolsMehod AddComma:investMoney],_wJOrZxStr];
    }
    NSString *buttonTitle = _isP2P ? @"立即出借":@"立即认购";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:buttonTitle, nil];
    alert.tag = 3000;
    [alert show];
}
 */

- (void)getNormalBidNetData
{
    if (self.isLimit) {
        [self sendBuyDataToService];
    } else {
        if ([[Common deleteStrHeadAndTailSpace:self.recommendCode] length] > 0) {
            [self checkGongchangCode:[Common deleteStrHeadAndTailSpace:self.recommendCode]];
        } else {
            [self sendBuyDataToService];
        }
    }
}
- (void)checkGongchangCode:(NSString *)string
{
    NSString *parStr = [NSString stringWithFormat:@"pomoCode=%@",string];
    [[NetworkModule sharedNetworkModule] postReq:parStr tag:kSXTagCheckPomoCode owner:self Type:SelectAccoutDefault];
}

- (void)sendBuyDataToService
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *prdClaimsId = self.model.data.prdClaim.ID;
    NSString *investAmt = self.investMoeny;
    
    [paramDict setValue:userID forKey:@"userId"];
    [paramDict setValue:prdClaimsId forKey:@"tenderId"];
    [paramDict setValue:investAmt forKey:@"investAmount"];
    
    if (beansSwitch) {
        [paramDict setValue:[NSString stringWithFormat:@"%ld",self.model.data.beanAmount] forKey:@"investBeans"];
    }
    
    if (!self.isLimit) {
        NSString *recommendCode = self.recommendCode;
        [paramDict setValue:recommendCode forKey:@"recomendFactoryCode"];
    }
    
//    if (self.coupDict && self.cashDict) {
//        //返现券反息券共用
//        NSString *beanIds0 = [self.coupDict valueForKey:@"idStr"];//返息
//        NSString *beanIds1 = [self.cashDict valueForKey:@"idStr"]; //返现
//        [paramDict setValue:beanIds1 forKey:@"cashBackIds"];
//        [paramDict setValue:beanIds0 forKey:@"couponId"];
//    } else if (self.coupDict) {
//        //使用返息券
//        NSString *beanIds = [self.coupDict valueForKey:@"idStr"];
//        [paramDict setValue:beanIds forKey:@"couponId"];
//    } else if (self.cashDict) {
//        //使用返现券
//        NSString *beanIds = [self.cashDict valueForKey:@"idStr"];
//        [paramDict setValue:beanIds forKey:@"cashBackIds"];
//
//    }
    NSString *apptzticket =  self.model.data.apptzticket;
    [paramDict setValue:apptzticket forKey:@"investClaimsTicket"];
    [paramDict setValue:@"" forKey:@"recomendFactoryCode"];
    [[NetworkModule sharedNetworkModule] newPostReq:paramDict tag:kSXTagInvestSubmit owner:self signature:YES Type:SelectAccoutTypeP2P];
}
@end
