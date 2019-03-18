//
//  UCFCollectionViewModel.m
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionViewModel.h"
#import "UCFBatchPageRootModel.h"
#import "UCFToolsMehod.h"
#import "UCFNewRechargeViewController.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFCollectionPureRequest.h"
#import "UCFBatchBidWebViewController.h"
@interface UCFCollectionViewModel()<NetworkModuleDelegate>
{
    CGFloat needToRechare;
}
@property(nonatomic, strong)UCFBatchPageRootModel *dataModel;
@property (nonatomic, strong)NSString       *investMoeny;
@property (strong ,nonatomic)NSString *maxBatchAmount;
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
    
    [self dealMyRecommendView];
    //我的合同
    [self dealMyContract];
}
- (void)dealMyRecommendView
{
    BOOL isLimit = [self checkIsFirstInvest];
    self.isLimit = !isLimit;
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
    
    self.investMoeny = [NSString stringWithFormat:@"%.2f",[investMoney doubleValue]];;
}
//全投按钮
- (void)calculateTotalMoney
{
    NSString *str = [self GetDefaultText];
    self.allMoneyInputNum = str;
    self.investMoeny = [NSString stringWithFormat:@"%.2f",[str doubleValue]];;;
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

- (void)dealInvestLogic
{
    if ([Common isPureNumandCharacters:self.investMoeny]) {
        ShowMessage(@"请输入正确金额");
        return;
    }
    if ([Common stringA:@"0.01" ComparedStringB:self.investMoeny] == 1) {
        
        NSString *errorStr =  @"请输入出借金额";
        ShowMessage(errorStr);
        return;
    }
    NSString *keTouJinE = [NSString stringWithFormat:@"%.2f",self.dataModel.data.colPrdClaimDetail.canBuyAmt];
    NSString *colMinInvestStr =[NSString stringWithFormat:@"%.2f",self.dataModel.data.colPrdClaimDetail.colMinInvest];
    NSString *minInVestNum = [NSString stringWithFormat:@"%.2f",[colMinInvestStr doubleValue]];
    if([Common stringA:minInVestNum ComparedStringB:self.investMoeny] == 1){
        NSString *messageStr =  @"出借金额不可低于起投金额";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    if([Common stringA:self.investMoeny ComparedStringB:keTouJinE] == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不可以这么任性哟，出借金额已超过剩余可投金额了" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
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
    
    //可用金额
    CGFloat availableBala= self.dataModel.data.availableBalance;
    NSString *availableBalance = [NSString stringWithFormat:@"%.2f",availableBala];
    if([Common stringA:self.investMoeny ComparedStringB:availableBalance] == 1)
    {
        NSString *keyongMoney = availableBalance;
        needToRechare = [self.investMoeny doubleValue] - [keyongMoney doubleValue];
        NSString *showStr = [NSString stringWithFormat:@"总计出借金额¥%@\n可用金额%@\n另需充值金额¥%.2f",self.investMoeny,availableBalance,needToRechare];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可用金额不足" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
        alert.tag = 2000;
        [alert show];
        return;
    }
    BOOL isOpenBatchStr = self.dataModel.data.isOpenBatch;
    if(!isOpenBatchStr){ //是否开启一键投标
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未开启批量出借，暂不能出借" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
        alertView.tag = 5001;
        [alertView show];
        return;
    }
      self.maxBatchAmount =[NSString stringWithFormat:@"%@",self.dataModel.data.batchAmount];
    if ([self.maxBatchAmount longLongValue] > 0  && !SingleUserInfo.loginData.userInfo.isCompanyAgent) {
        if ([Common stringA:self.investMoeny ComparedStringB:self.maxBatchAmount] == 1 ) {
            
            NSString *mesageStr = [NSString stringWithFormat:@"出借金额超过批量出借单笔限额，您设置的批量出借金额单笔限额为%@元",self.maxBatchAmount];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mesageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
            alert.tag = 5002;
            [alert show];
            return;
        }
    }
    BOOL isNewUser = self.dataModel.data.isNewUser;
    if(isNewUser){
        NSString *mesageStr = [NSString stringWithFormat:@"批量出借可能会导致用户无法获得首次奖励，确认继续支付吗？"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mesageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续出借", nil];
        alert.tag = 4000;
        [alert show];
        return;
    }
    int compare = [Common stringA:self.investMoeny ComparedStringB:@"1000.00"];
    if (compare == 1 || compare == 0 ) {
        [self showLastAlert:self.investMoeny];
    } else {
        [self getNormalBidNetData];
    }
}
//投资超过1000最后的提醒框
- (void)showLastAlert:(NSString *)investMoney
{
    NSString *showStr = @"";
    showStr = [NSString stringWithFormat:@"出借金额¥%@,确认出借吗?",[UCFToolsMehod AddComma:investMoney]];
    
    NSString *buttonTitle = @"批量出借";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:buttonTitle, nil];
    alert.tag = 3000;
    [alert show];
}
- (void)getNormalBidNetData
{
    if (self.isLimit) {
        if ([self.recommendStr length] > 0) {
            [self checkGongchangCode:self.recommendStr];
        } else {
            [self sendBuyDataToService];
        }
    } else {
         [self sendBuyDataToService];
    }
}
- (void)sendBuyDataToService
{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString *prdClaimsId = [NSString stringWithFormat:@"%ld",self.dataModel.data.colPrdClaimDetail.ID];
    NSString *investAmt = self.investMoeny;
    [paramDict setValue:prdClaimsId forKey:@"tenderId"];
    [paramDict setValue:investAmt forKey:@"investAmount"];
    if (_isLimit) {
        NSString *recommendCode = self.recommendStr;
        if (recommendCode.length > 0) {
            [paramDict setValue:recommendCode forKey:@"recomendFactoryCode"];
        }
        
    } else {
        NSString *recommendCode = self.dataModel.data.recomendFactoryCode;
        [paramDict setValue:recommendCode forKey:@"recomendFactoryCode"];
    }
    NSString *apptzticket = self.dataModel.data.apptzticket;
    [paramDict setValue:apptzticket forKey:@"investClaimsTicket"];
    [paramDict setValue:@"1" forKey:@"fromSite"];
    
    @PGWeakObj(self);
    UCFCollectionPureRequest *api =  [[UCFCollectionPureRequest alloc] initWithParmDict:paramDict];
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        UCFCollectRootModel *model = request.responseJSONModel;
        if (model.ret) {
            NSString *applyAmount = [NSString stringWithFormat:@"%.2f",model.data.applyAmount];
             NSString *investAmount =[NSString stringWithFormat:@"%.2f",model.data.investAmount];
            NSArray *orderIds =  model.data.orderIds;
            NSMutableString *orderIdsArryStr = [[NSMutableString alloc] initWithCapacity:0];
            [orderIdsArryStr setString:@"["];
            for ( int i = 0 ;i < orderIds.count;i++) {
                NSString *orderIdStr =  [NSString stringWithFormat:@"%@",orderIds[i]];
                if (i == 0) {
                    [orderIdsArryStr appendFormat:@"%@",orderIdStr];
                }else{
                    [orderIdsArryStr appendFormat:@",%@",orderIdStr];
                }
            }
            [orderIdsArryStr appendString:@"]"];
            NSDictionary *reqDict =  @{@"userId":SingleUserInfo.loginData.userInfo.userId,@"applyAmount":applyAmount,@"investAmount":investAmount,@"orderIds":orderIdsArryStr};
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",SERVER_IP,BATCHINVESTSTATUS];
            UCFBatchBidWebViewController *webView = [[UCFBatchBidWebViewController alloc]initWithNibName:@"UCFBatchBidWebViewController" bundle:nil];
            webView.url =  urlStr;
            webView.webDataDic = reqDict;
            webView.navTitle = @"集合标匹配中";
            webView.rootVc = selfWeak.parentViewController;
            [selfWeak.parentViewController.navigationController pushViewController:webView animated:YES];
            NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:selfWeak.parentViewController.navigationController.viewControllers];
            [navVCArray removeObjectAtIndex:navVCArray.count-2];
            [selfWeak.parentViewController.navigationController setViewControllers:navVCArray animated:NO];
        } else {
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
    [api start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 1000) {
//            MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//            [cell.inputMoneyTextFieldLable becomeFirstResponder];
        } else if (alertView.tag == 2000) {
            
        } else if (alertView.tag == 10023) {
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
            [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
        }
        if (alertView.tag == 6000) {
//            [_gCCodeTextField becomeFirstResponder];
        }
    } else if (buttonIndex == 1) {
        if (alertView.tag == 3000) {
            [self getNormalBidNetData];
        }
        if (alertView.tag == 2000) {
            
            UCFNewRechargeViewController *vc = [[UCFNewRechargeViewController alloc] initWithNibName:@"UCFNewRechargeViewController" bundle:nil];
            vc.uperViewController = self.parentViewController;
            vc.defaultMoney = [NSString stringWithFormat:@"%.2f",needToRechare];
            vc.accoutType = SelectAccoutTypeP2P;
            [self.parentViewController.navigationController pushViewController:vc animated:YES];
        }
        if (alertView.tag == 4000) {
           
            int compare = [Common stringA:[NSString stringWithFormat:@"%.2f",[self.investMoeny doubleValue]] ComparedStringB:@"1000.00"];
            if (compare == 1 || compare == 0 ) {
                [self showLastAlert:self.investMoeny];
            } else {
                [self getNormalBidNetData];
            }
        }
        if (alertView.tag == 5001) {//开通批量投资限额页面
            UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
            batchInvestment.isStep = 1 ;
            [self.parentViewController.navigationController pushViewController:batchInvestment animated:YES];
        }
        if (alertView.tag == 5002) {//开通批量投资限额页面第二步
            UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
            batchInvestment.isStep = 2 ;
            [self.parentViewController.navigationController pushViewController:batchInvestment animated:YES];
        }
    }
}
- (BOOL)checkIsFirstInvest
{
    NSString *recommendCode = self.dataModel.data.recomendFactoryCode;
    BOOL isLimit = self.dataModel.data.isLimit;
    if ([recommendCode isEqualToString:@""] && !isLimit) {
        return YES;
    } else {
        return NO;
    }
}
- (void)outputRecommendCode:(NSString *)recommendStr
{
    self.recommendStr = [Common deleteStrHeadAndTailSpace:recommendStr];
}


- (void)checkGongchangCode:(NSString *)str
{
    NSString *parStr = [NSString stringWithFormat:@"pomoCode=%@",str];
    [[NetworkModule sharedNetworkModule] postReq:parStr tag:kSXTagCheckPomoCode owner:self Type:SelectAccoutDefault];
}
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == kSXTagCheckPomoCode) {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        if ([dic[@"status"] isEqualToString:@"1"]) {
            [self sendBuyDataToService];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"  message:@"工场码不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
            alert.tag = 6000;
            [alert show];
        }
    }
}
@end
