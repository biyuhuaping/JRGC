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
#import "UCFCheckCouponApi.h"
#import "UCFInvestmentCouponModel.h"
@interface UCFBidViewModel()<NetworkModuleDelegate>
{
    BOOL beansSwitch;
    double  needToRechare;
}
@property (nonatomic, strong)UCFBidModel *model;
@property (nonatomic, strong)UCFContractTypleModel *contractTmpModel;
@property (nonatomic, strong)NSString       *investMoeny;
@property (nonatomic, strong)NSString       *recommendCode;

@property (nonatomic, strong)NSArray        *cashCouponArray;
@property (nonatomic, strong)NSArray        *interestCouponArray;

@end

@implementation UCFBidViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadVMData) name:@"UPDATEINVESTDATA" object:nil];
//        [self requestCoupnData];
    }

    return self;
}

- (UCFBidModel *)getDataData
{
    return self.model;
}
- (void)setDataModel:(UCFBidModel *)model
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
    //我的优惠券
    [self dealMycoupon];
    
    [self dealMyRecommend];
    //我的合同
    [self dealMyContract];
    
    [self requestCoupnData];
}
- (NSString *)getDataModelBidID
{
    return self.model.data.prdClaim.ID;
}
- (NSString *)getTextFeildInputMoeny
{
    return self.investMoeny;
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
    NSString *totalMoney = @"";
    if (self.model.data.isCompanyAgent) {
        self.isCompanyAgent =  YES;
        self.myBeansNum = [NSString stringWithFormat:@"¥0.00"];
        totalMoney = [UCFToolsMehod AddComma: [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount]];
    } else {
        self.isCompanyAgent =  NO;
        if ([UserInfoSingle sharedManager].isShowCouple) {
            if (self.model.data.isCompanyAgent) {
                self.myBeansNum = [NSString stringWithFormat:@"¥0.00"];
                totalMoney = [UCFToolsMehod AddComma: [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount]];
            } else {
                self.myBeansNum = [NSString stringWithFormat:@"¥%@",gondDouBalancStr];
                totalMoney = [UCFToolsMehod AddComma: [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount + self.model.data.beanAmount/100.0f]];
            }
        } else {
            self.myBeansNum = [NSString stringWithFormat:@"¥0.00"];
            totalMoney = [UCFToolsMehod AddComma: [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount]];
        }
    }

    self.totalFunds = [NSString stringWithFormat:@"¥%@",totalMoney];
    NSString *palceText = [NSString stringWithFormat:@"%ld元起投",(long)self.model.data.prdClaim.minInvest];
    if ([self.model.data.prdClaim.maxInvest length] != 0) {
        palceText = [palceText stringByAppendingString:[NSString stringWithFormat:@",限投%@元",self.model.data.prdClaim.maxInvest]];
    }
    self.inputViewPlaceStr = palceText;

    
}

/**
 工豆开关回调方法

 @param switchView 工豆开关
 */
- (void)dealMyfundsNumWithBeansSwitch:(UIButton *)switchView
{
    beansSwitch = switchView.selected;
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
        double value =currentMoney * calcRate * pow((1+calcRate), calcTerm);
        double b = (1+calcRate);
        double value1 = (pow(b, calcTerm) - 1);
        double value2 = [[NSString stringWithFormat:@"%.2f",(value/value1)] doubleValue];
        totalIntersate =value2 * calcTerm  - currentMoney;
    } else {
        totalIntersate = currentMoney * calcRate * calcTerm;
        
    }
    self.expectedInterestNum = [NSString stringWithFormat:@"¥%.2f",totalIntersate < 0.01 ? 0.00 : totalIntersate];
    self.investMoneyIsChange = YES;
    [self dealCouponData:investMoney];
    
}

/**
 获取可投资最大金额
 */
- (void)calculateTotalMoney
{
    NSString *mostMoney = [self getDefaultText];
    self.allMoneyInputNum = mostMoney;
}
//获取默认填写金额
- (NSString *)getDefaultText
{
    long long int keTouJinE = round((self.model.data.prdClaim.borrowAmount - self.model.data.prdClaim.completeLoan)* 100);
    long long int keYongZiJin = round(self.model.data.accountAmount * 100);
    NSInteger gongDouCount = self.model.data.beanAmount;
    if (!beansSwitch) {
        gongDouCount = 0;
    }
    keYongZiJin += gongDouCount;
    long long int minInVestNum = round(self.model.data.prdClaim.minInvest* 100);
    
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
    NSString *maxIn = [NSString stringWithFormat:@"%@",self.model.data.prdClaim.maxInvest];
    if (maxIn.length != 0) {
        NSString *maxInvest = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.model.data.prdClaim.maxInvest] doubleValue]];
        if ([Common stringA:investMoney ComparedStringB:maxInvest] == 1) {
            return maxInvest;
        } else {
            return investMoney;
        }
    }
    return investMoney;
}
- (void)dealMycoupon
{
    if ([self.model.data.cashNum integerValue] > 0) {
        NSString *cashNum = [NSString stringWithFormat:@"%@张",self.model.data.cashNum];
        self.cashNum = cashNum;
    } else {
        self.cashIsHide = YES;
    }
    
    if ([self.model.data.couponNum integerValue] > 0) {
        NSString *couponNum = [NSString stringWithFormat:@"%@张",self.model.data.couponNum];
        self.couponNum = couponNum;
    } else {
        self.couponIsHide = YES;
    }
    if (self.cashIsHide && self.couponIsHide) {
        self.headherIsHide = YES;
    }
}

/**
 计算返息券反的工豆

 @param backInterstae 返息券利率
 @return 返息工豆价值
 */
- (NSString  *)getInvestGetBeansByCoupon:(NSString *)backInterstae
{
    double investAmtMoney = [self.investMoeny doubleValue];
    NSString *annleRate = backInterstae;
    NSString *repayPeriodDay = nil;
    //灵活期限标如果有灵活期限holdtime取 holdtime 否则取repayPeriodDay
    
    NSString *holdTime = self.model.data.prdClaim.holdTime;
    if (holdTime.length > 0) {
        repayPeriodDay = holdTime;
    } else {
        repayPeriodDay = self.model.data.prdClaim.repayPeriodDay;
    }
    double liLv = [annleRate doubleValue]/100.0f;
    double qiXian = [repayPeriodDay doubleValue];
    double occupyRate = [self.model.data.occupyRate doubleValue];
    //计算返息的工豆
    double money1 = (investAmtMoney * liLv) * (qiXian/360.0f) * occupyRate;
    
    NSString *couponSum = [NSString stringWithFormat:@"%.2f",round(money1 * 100)/100.0f];
    return couponSum;
}
- (void)requestCoupnData
{
    //获取返现券数据
    UCFCheckCouponApi *api = [[UCFCheckCouponApi alloc] initWithPrdclaimid:self.model.data.prdClaim.ID investAmt:@"1" couponType:@"0" type:SelectAccoutTypeP2P];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        UCFInvestmentCouponModel *cashModel = request.responseJSONModel;
        self.cashCouponArray = cashModel.data.couponList;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.cashCouponArray = nil;
    }];

    //获取返息券数据
    UCFCheckCouponApi *api1 = [[UCFCheckCouponApi alloc] initWithPrdclaimid:self.model.data.prdClaim.ID investAmt:@"1" couponType:@"1" type:SelectAccoutTypeP2P];
    [api1 startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        UCFInvestmentCouponModel *couponModel = request.responseJSONModel;
        self.interestCouponArray = couponModel.data.couponList;

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.interestCouponArray = nil;
    }];
}

- (void)dealCouponData:(NSString *)investMoeny
{
//    if (self.cashSelectCount == 0) {
        int a = 0;
        for (InvestmentCouponCouponlist *model in self.cashCouponArray) {
            if (model.investMultip <= [investMoeny doubleValue]) {
                a++;
            }
        }
//        NSString *tmpCash = self.availableCashNum;
//        if ([tmpCash containsString:@"张可用"]) {
//            NSString *tmpStr = [tmpCash stringByReplacingOccurrencesOfString:@"张可用" withString:@""];
//            if ([tmpStr intValue] != a) {
//                self.availableCashNum = [NSString stringWithFormat:@"%d张可用",a];
//            }
//        } else {
            self.availableCashNum = [NSString stringWithFormat:@"%d张可用",a];
//        }
//    } else {0
//
//    }
    
//    if (self.couponSelectCount == 0) {
        int b = 0;
        for (InvestmentCouponCouponlist *model in self.interestCouponArray) {
            if (model.investMultip <= [investMoeny doubleValue]) {
                b++;
            }
        }
//        NSString *tmpCoupon = self.availableCouponNum;
//        if ([tmpCoupon containsString:@"张可用"]) {
//            NSString *tmpStr = [tmpCoupon stringByReplacingOccurrencesOfString:@"张可用" withString:@""];
//            if ([tmpStr intValue] != b) {
//                self.availableCouponNum = [NSString stringWithFormat:@"%d张可用",b];
//            }
//        } else {
            self.availableCouponNum = [NSString stringWithFormat:@"%d张可用",b];
//        }
//    }



}


#pragma mark ------------------------

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
    }else if ([contractName isEqualToString:@"CFCA数字证书服务协议"]) {
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
                    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdClaimId=%@&contractType=%@&prdType=0",SingleUserInfo.loginData.userInfo.userId,projectId,contractTypeStr];
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
        
    }
}
- (void)reloadVMData
{
    NSDictionary *paraDict = @{
                               @"id":self.model.data.prdClaim.ID,
                               @"userId":SingleUserInfo.loginData.userInfo.userId,
                               };
    [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:kSXTagP2PPrdClaimsDealBid owner:self signature:YES Type:SelectAccoutTypeP2P];
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
    NSString *minInVestNum = [NSString stringWithFormat:@"%ld",(long)self.model.data.prdClaim.minInvest];
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
    
    
    NSString *availableFundsStr = [NSString stringWithFormat:@"%.2f",self.model.data.accountAmount];
    
    NSString *gondDouBalancStr =[NSString stringWithFormat:@"%.2f",self.model.data.beanAmount/100.0f];
    
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
        self.rechargeStr =[NSString stringWithFormat:@"%.2f", needToRechare];
        NSString *showStr = [NSString stringWithFormat:@"总计出借金额¥%@\n可用金额%@\n另需充值金额¥%.2f", investMoney,availableBalance,needToRechare];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可用金额不足" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
        alert.tag = 2000;
        [alert show];
        return;
    }
    
    BOOL isHaveCashNum = [self.cashNum integerValue] > 0 ? YES : NO;
    BOOL isHaveCouponNum = [self.couponNum integerValue] > 0 ? YES : NO;
    if (![UserInfoSingle sharedManager].isShowCouple) {
        isHaveCashNum = NO;
        isHaveCouponNum = NO;
    }
    
    //有返息券 和 返现券 可用
    if (isHaveCashNum && isHaveCouponNum) {
        
        BOOL noSelectCash = self.cashTotalIDStr.length == 0 ? YES : NO;
        BOOL noSelectCoupon = self.couponIDStr.length == 0 ? YES : NO;
        //返现券和返息券都未勾选
        if (noSelectCash && noSelectCoupon) {
            NSString *messageStr = @"有可用优惠券，确认不使用并继续出借吗？";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4000;
            [alert show];
            return;
        } else if (!noSelectCash && noSelectCoupon) {
            //勾选返现券 没有勾选返息全
            NSString *couponPrdaimSum1 = [NSString stringWithFormat:@"%.2f",[self.cashTotalcouponAmount doubleValue]] ;
            NSString *invenestMoney = [NSString stringWithFormat:@"%.2f",[self.investMoeny doubleValue]];
            int compareResult1 = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum1];
            NSString *showStr = @"";
            if (compareResult1 == -1) {
                showStr = [NSString stringWithFormat:@"返现券使用条件不足,需出借满¥%@可用",[UCFToolsMehod AddComma:couponPrdaimSum1]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
                alert.tag = 1000;
                [alert show];
                return;
            }
            NSString *messageStr =@"有可用返息券，确认不使用并继续出借吗？";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4000;
            [alert show];
            return;
        } else if (noSelectCash && !noSelectCoupon) {
            //勾选息现券 没有勾选返现券
            //勾选使用条件不足
            NSString *couponPrdaimSum2 = [NSString stringWithFormat:@"%.2f",[self.couponTotalcouponAmount doubleValue]];
            NSString *invenestMoney = [NSString stringWithFormat:@"%.2f",[self.investMoeny doubleValue]];
            int compareResult1 = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum2];
            NSString *showStr = @"";
            if (compareResult1 == -1) {
                showStr = [NSString stringWithFormat:@"返息券使用条件不足,需出借满¥%@可用",[UCFToolsMehod AddComma:couponPrdaimSum2]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
                alert.tag = 1000;
                [alert show];
                return;
            }
            NSString *messageStr =@"有可用返现券，确认不使用并继续出借吗？";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4000;
            [alert show];
            return;
        } else {
            //全部勾选的情况下
            NSString *couponPrdaimSum1 = [NSString stringWithFormat:@"%.2f",[self.cashTotalcouponAmount doubleValue]];
            NSString *couponPrdaimSum2 = [NSString stringWithFormat:@"%.2f",[self.couponTotalcouponAmount doubleValue]];
    
            
            NSString *couponPrdaimSum = [couponPrdaimSum1 doubleValue] > [couponPrdaimSum2 doubleValue] ? couponPrdaimSum1 : couponPrdaimSum2;
            NSString *invenestMoney = [NSString stringWithFormat:@"%.2f",[self.investMoeny doubleValue]];
            
            //计算出使用该返息券所需投的金额
            int compareResult = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum];
            if (compareResult == -1) {
                NSString *showStr = @"";
                int compareResult1 = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum1];
                int compareResult2 = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum2];
                if (compareResult1 == -1 && compareResult2 == -1) {
                    showStr = [NSString stringWithFormat:@"优惠券使用条件不足,需出借满¥%@可用",[UCFToolsMehod AddComma:couponPrdaimSum]] ;
                } else if (compareResult1 == -1) {
                    showStr = [NSString stringWithFormat:@"返现券使用条件不足,需出借满¥%@可用",[UCFToolsMehod AddComma:couponPrdaimSum1]];
                } else if (compareResult2 == -1) {
                    showStr = [NSString stringWithFormat:@"返息券使用条件不足,需出借满¥%@可用",[UCFToolsMehod AddComma:couponPrdaimSum2]];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
                alert.tag = 1000;
                [alert show];
                return;
            }
        }
    } else if (isHaveCouponNum && !isHaveCashNum) {
        //只有返息券
        if (self.couponIDStr) {
            //勾选使用条件不足
            NSString *couponPrdaimSum2 = [NSString stringWithFormat:@"%.2f",[self.couponTotalcouponAmount doubleValue]];
            NSString *invenestMoney = [NSString stringWithFormat:@"%.2f",[self.investMoeny doubleValue]];
            int compareResult1 = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum2];
            NSString *showStr = @"";
            if (compareResult1 == -1) {
                showStr = [NSString stringWithFormat:@"返息券使用条件不足,需出借满¥%@可用",[UCFToolsMehod AddComma:couponPrdaimSum2]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
                alert.tag = 1000;
                [alert show];
                return;
            }
            
        } else {
            NSString *messageStr = [NSString stringWithFormat:@"有可用返息券,确认不使用继续出借吗"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4000;
            [alert show];
            return;
        }
    } else if (isHaveCashNum && !isHaveCouponNum) {
        //只有返现券
        if (self.cashTotalIDStr.length > 0) {
            //勾选使用条件不足
            NSString *couponPrdaimSum1 = [NSString stringWithFormat:@"%.2f", [self.cashTotalcouponAmount doubleValue]];
            NSString *invenestMoney =    [NSString stringWithFormat:@"%.2f", [self.investMoeny doubleValue]];
            
            int compareResult1 = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum1];
            NSString *showStr = @"";
            if (compareResult1 == -1) {
                showStr = [NSString stringWithFormat:@"返现券使用条件不足,需出借满¥%@可用",[UCFToolsMehod AddComma:couponPrdaimSum1]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
                alert.tag = 1000;
                [alert show];
                return;
            }
            
        } else {
            NSString *messageStr = [NSString stringWithFormat:@"有可用返现券,确认不使用并继续出借吗"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4000;
            [alert show];
            return;
        }
    }
    
    int compare = [Common stringA:self.investMoeny ComparedStringB:@"1000.00"];
    if (compare == 1 || compare == 0 ) {
        [self showLastAlert:investMoney];
    } else {
        [self getNormalBidNetData];
    }
}

//投资超过1000最后的提醒框
- (void)showLastAlert:(NSString *)investMoney
{
    NSString *showStr = @"";
    if (self.couponIDStr.length > 0 && self.cashTotalIDStr.length > 0) {
        NSString *cashNum = [NSString stringWithFormat:@"%ld",(long)self.cashSelectCount];
        NSString *coupNum = [NSString stringWithFormat:@"%ld",(long)self.couponSelectCount];
        showStr = [NSString stringWithFormat:@"出借金额¥%@,确认出借吗?\n使用返现券%@张(共¥%@)、返息券%@张",[UCFToolsMehod AddComma:investMoney], cashNum,[UCFToolsMehod AddComma:self.repayCash], coupNum];
    } else if(self.couponIDStr.length > 0) {
        NSString *coupNum = [NSString stringWithFormat:@"%ld",(long)self.couponSelectCount];
        showStr = [NSString stringWithFormat:@"出借金额¥%@,确认出借吗?\n使用返息券%@张",[UCFToolsMehod AddComma:investMoney], coupNum];
        
    } else if(self.cashTotalIDStr.length > 0){
        NSString *cashNum = [NSString stringWithFormat:@"%ld",(long)self.cashSelectCount];
        showStr = [NSString stringWithFormat:@"出借金额¥%@,确认出借吗?\n使用返现券%@张(共¥%@)",[UCFToolsMehod AddComma:investMoney], cashNum,[UCFToolsMehod AddComma:self.repayCash]];
    } else {
        showStr = [NSString stringWithFormat:@"出借金额¥%@,确认出借吗?",[UCFToolsMehod AddComma:investMoney]];
    }
    NSString *buttonTitle = @"立即出借";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:buttonTitle, nil];
    alert.tag = 3000;
    [alert show];
}


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
    NSString *userID = SingleUserInfo.loginData.userInfo.userId;
    NSString *prdClaimsId = self.model.data.prdClaim.ID;
    NSString *investAmt = self.investMoeny;
    
    [paramDict setValue:userID forKey:@"userId"];
    [paramDict setValue:prdClaimsId forKey:@"tenderId"];
    [paramDict setValue:investAmt forKey:@"investAmount"];
    
    if (beansSwitch) {
        [paramDict setValue:[NSString stringWithFormat:@"%ld",(long)self.model.data.beanAmount] forKey:@"investBeans"];
    }
    
    if (!self.isLimit) {
        NSString *recommendCode = self.recommendCode;
        [paramDict setValue:recommendCode forKey:@"recomendFactoryCode"];
    }
    
    if (self.couponIDStr.length > 0 && self.cashTotalIDStr.length > 0) {
        //返现券反息券共用
        [paramDict setValue:self.cashTotalIDStr forKey:@"cashBackIds"];
        [paramDict setValue:self.couponIDStr forKey:@"couponId"];
    } else if (self.couponIDStr.length > 0) {
        //使用返息券
        [paramDict setValue:self.couponIDStr forKey:@"couponId"];
    } else if (self.cashTotalIDStr.length > 0) {
        //使用返现券
        [paramDict setValue:self.cashTotalIDStr forKey:@"cashBackIds"];
    }
    NSString *apptzticket =  self.model.data.apptzticket;
    [paramDict setValue:apptzticket forKey:@"investClaimsTicket"];
    [[NetworkModule sharedNetworkModule] newPostReq:paramDict tag:kSXTagInvestSubmit owner:self signature:YES Type:SelectAccoutTypeP2P];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_rootController reflectAlertView:alertView clickedButtonAtIndex:buttonIndex];
    } else if (buttonIndex == 1) {
        if (alertView.tag == 2000) {
            [_rootController reflectAlertView:alertView clickedButtonAtIndex:buttonIndex];
        }
        
        if (alertView.tag == 3000) {
            [self getNormalBidNetData];
        }
        if (alertView.tag == 4000) {
            int compare = [Common stringA:[NSString stringWithFormat:@"%.2f",[self.investMoeny doubleValue]] ComparedStringB:@"1000.00"];
            if (compare == 1 || compare == 0 ) {
                [self showLastAlert:self.investMoeny];
            } else {
                [self getNormalBidNetData];
            }
        }
    }
}
@end
