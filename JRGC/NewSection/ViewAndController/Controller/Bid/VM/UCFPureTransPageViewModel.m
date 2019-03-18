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
#import "UCFNewRechargeViewController.h"
#import "UCFTopUpViewController.h"
@interface UCFPureTransPageViewModel ()
{
    double  needToRechare;
}

@end

@interface UCFPureTransPageViewModel ()<NetworkModuleDelegate>
@property(nonatomic, strong)UCFPureTransBidRootModel *model;
@property (nonatomic, strong)UCFContractTypleModel *contractTmpModel;
@property (nonatomic, strong)NSString       *investMoeny;
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
    self.investMoeny = allMoneyInputNum;
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
    self.investMoeny = currentText;
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
- (void)dealInvestLogic
{
    [self checkIsCanInvest];
}
- (void)checkIsCanInvest
{

    NSString *zxOrP2pStr = [self.model.data.type isEqualToString:@"2"] ? @"购买" : @"出借";
    if ([Common isPureNumandCharacters:self.investMoeny]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return;
    }
    self.investMoeny = [NSString stringWithFormat:@"%.2f",[self.investMoeny doubleValue]];
    if ([Common stringA:@"0.01" ComparedStringB:self.investMoeny] == 1) {
        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"请输入%@金额",zxOrP2pStr]];
        return;
    }
    //剩余比例
    NSString *keTouJinE = self.model.data.cantranMoney;
    NSString *minInVestNum = self.model.data.investAmt;
    if([Common stringA:minInVestNum ComparedStringB:self.investMoeny] == 1){
        NSString *messageStr = [NSString stringWithFormat:@"%@金额不可低于起投金额",zxOrP2pStr];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    double inputMoney = [self.investMoeny doubleValue];
    if([Common stringA:[NSString stringWithFormat:@"%.2f",inputMoney] ComparedStringB:keTouJinE] == 1)
    {
        NSString *messageStr = [NSString stringWithFormat:@"不可以这么任性哟，%@金额已超过剩余可投金额了",zxOrP2pStr];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    if ([keTouJinE doubleValue] - [self.investMoeny doubleValue] < [minInVestNum doubleValue] && [Common stringA:keTouJinE ComparedStringB:self.investMoeny] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标剩余的金额已不足起投额，不差这一点了亲，全投了吧！" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    double availableBala= [self.model.data.actBalance doubleValue];
    NSString *availableBalance = [NSString stringWithFormat:@"%.2f",availableBala];
    
    if([Common stringA:self.investMoeny ComparedStringB:availableBalance] == 1)
    {
        NSString *keyongMoney = availableBalance;
        needToRechare = inputMoney - [keyongMoney doubleValue];
        NSString *showStr = [NSString stringWithFormat:@"总计%@金额¥%@\n可用金额%@\n另需充值金额¥%.2f",zxOrP2pStr,self.investMoeny,availableBalance,needToRechare];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可用金额不足" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
        alert.tag = 2000;
        [alert show];
        return;
    }
    int compare = [Common stringA:self.investMoeny ComparedStringB:@"1000"];
    if (compare == 1 || compare == 0 ) {
        NSString *buttontitleStr = [NSString stringWithFormat:@"立即%@",zxOrP2pStr];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"本次%@金额¥%@,确认%@吗？",zxOrP2pStr,[NSString AddComma:self.investMoeny],zxOrP2pStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:buttontitleStr, nil];
        alert.tag = 3000;
        [alert show];
    } else {
        [self getNormalBidNetData];
    }
}
- (void)getNormalBidNetData
{
    NSString *investTranTicketStr = self.model.apptzticket;
    SelectAccoutType type = [self.model.data.type isEqualToString:@"2"] ? SelectAccoutTypeHoner : SelectAccoutTypeP2P;
    NSDictionary *dataDic = @{@"userId": SingleUserInfo.loginData.userInfo.userId,@"prdTransferId":self.model.data.ID,@"investAmt":self.investMoeny,@"investBeans":@"0",@"investTranTicket":investTranTicketStr};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagTraClaimsSubmit owner:self signature:YES Type:type];
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
    //            [self reloadVMData];
                [MBProgressHUD displayHudError:[dic objectSafeForKey:@"message"]];
            }
        }
    }
}

-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:_superView animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 1000) {
//            MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//            [cell.inputMoneyTextFieldLable becomeFirstResponder];
        } else if (alertView.tag == 2000) {
            
        } else if (alertView.tag == 10023) {
            [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
            
        }
    } else if (buttonIndex == 1) {
        if (alertView.tag == 3000) {
            [self getNormalBidNetData];
            return;
        }
        if (alertView.tag == 2000) {
            SelectAccoutType type = [self.model.data.type isEqualToString:@"2"] ? SelectAccoutTypeHoner : SelectAccoutTypeP2P;
            
            if (type == SelectAccoutTypeP2P) {
                UCFNewRechargeViewController *vc = [[UCFNewRechargeViewController alloc] initWithNibName:@"UCFNewRechargeViewController" bundle:nil];
                vc.uperViewController = self.parentViewController;
                vc.defaultMoney = [NSString stringWithFormat:@"%.2f",needToRechare];
                vc.accoutType = SelectAccoutTypeP2P;
                [self.parentViewController.navigationController pushViewController:vc animated:YES];
            } else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
                UCFTopUpViewController *topUpView  = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
                topUpView.defaultMoney = [NSString stringWithFormat:@"%.2f",needToRechare];
                topUpView.title = @"充值";
                //topUpView.isGoBackShowNavBar = YES;
                topUpView.uperViewController = self.parentViewController;
                topUpView.accoutType = type;
                [self.parentViewController.navigationController pushViewController:topUpView animated:YES];
            }
        }
        if (alertView.tag == 4000) {
            SelectAccoutType type = [self.model.data.type isEqualToString:@"2"] ? SelectAccoutTypeHoner : SelectAccoutTypeP2P;
            NSString *showStr =( type == SelectAccoutTypeP2P ? @"出借":@"购买");
            int compare = [Common stringA:self.investMoeny ComparedStringB:@"1000"];
            if (compare == 1 || compare == 0 ) {
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@金额%@元,确认%@吗？",showStr,self.investMoeny,showStr] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert1.tag = 3000;
                [alert1 show];
            } else {
                [self getNormalBidNetData];
            }
        }
        if (alertView.tag == 5000) {
            
        }
    }
    
}
@end
