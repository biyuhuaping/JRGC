//
//  UCFPurchaseTranBidViewController.m
//  JRGC
//
//  Created by 金融工场 on 15/5/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFPurchaseTranBidViewController.h"
#import "InvestmentItemInfo.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "UCFInvestmentView.h"
#import "InvestmentCell.h"
#import "MoneyBoardCell.h"
#import "FullWebViewController.h"
#import "UCFCompleteBidViewCtrl.h"//投标成功页
#import "CalculatorView.h"
#import "AppDelegate.h"
#import "UCFTopUpViewController.h"
#import "SubInvestmentCell.h"
#import "ToolSingleTon.h"
#import "UCFPrdTransferBIdWebView.h"
@interface UCFPurchaseTranBidViewController ()<MoneyBoardCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL        isHasOverdueGongDou;        //是否有过期工豆
    BOOL        isGongDouSwitch;
    UILabel     *tipLabel;
    double      needToRechare;
    BOOL        isSucessInvest;             //是否投资成功

}
@property (weak, nonatomic) IBOutlet UITableView *bidTableView;

@end

@implementation UCFPurchaseTranBidViewController
//是否有过期工豆
- (BOOL)checkOverdueGongDou
{
    return NO;
    /*
    NSString *beancount = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"beancount"]]];
    if (beancount.length == 0 || [beancount isEqualToString:@"0"]) {
        return NO;
    } else {
        return YES;
    }
    return NO;
     */
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    [self addLeftButton];
    baseTitleLabel.text = @"投标";
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    isHasOverdueGongDou = [self checkOverdueGongDou];
    NSDictionary *dict = [_dataDict objectForKey:@"data"];
    self.bidArray = [NSMutableArray array];
    [self.bidArray addObject:dict];


    _bidTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bidTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bidTableView.userInteractionEnabled = YES;
    _bidTableView.backgroundColor = UIColorWithRGBA(242, 242, 242, 1);
    if ([_bidTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_bidTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_bidTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_bidTableView setLayoutMargins: UIEdgeInsetsZero];
    }
    _bidTableView.tableFooterView = [self createFootView];
    [_bidTableView reloadData];
    [self cretateInvestmentView];
    UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
    [_bidTableView addGestureRecognizer:frade];
    [ToolSingleTon sharedManager].apptzticket = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"apptzticket"]];

}
- (void)fadeKeyboard
{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 109.0f;
    } else if (indexPath.row == 1) {
        return 202.0f - 43 - 54;
    } else if (indexPath.row == 2) {
        return 30;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isHasOverdueGongDou) {
        return 3;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellStr1 = @"cell1";
        SubInvestmentCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr1];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SubInvestmentCell" owner:self options:nil][0];
        }
        NSDictionary *info =  self.bidArray[0];
        [cell setTransInvestItemInfo:info];
        return cell;
    } else if(indexPath.row == 1){
        static NSString *cellStr2 = @"cell2";
        MoneyBoardCell *cell = [self.bidTableView dequeueReusableCellWithIdentifier:cellStr2];
        if (cell == nil) {
            cell = [[MoneyBoardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.dataDict = _dataDict;
            cell.isTransid = YES;
            /*
            double gondDouBalance = [[[_dataDict objectForKey:@"data"] objectForKey:@"beanBalance"] doubleValue];
            if (gondDouBalance > 0.0) {
                isGongDouSwitch = YES;
            }else {
                cell.gongDouSwitch.userInteractionEnabled = NO;
            }
            cell.gongDouSwitch.on = isGongDouSwitch;
            */
            cell.inputMoneyTextFieldLable.text = [self GetDefaultText];
        }
        cell.dataDict = _dataDict;
        cell.isTransid = YES;
        /*
        if (isGongDouSwitch) {
            cell.gongDouAccout.textColor = UIColorWithRGB(0x333333);
            cell.gongDouCountLabel.textColor = UIColorWithRGB(0x333333);

        } else {
            cell.gongDouAccout.textColor = UIColorWithRGB(0x999999);
            cell.gongDouCountLabel.textColor = UIColorWithRGB(0x999999);
        }
         */
        return cell;
    } else {
        static NSString *cellStr = @"tipCell";
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.contentView.backgroundColor = UIColorWithRGBA(92, 106, 145, 1);
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        NSString *beancount = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"beancount"]];
        NSString *showStr = [NSString stringWithFormat:@"价值¥%.2f工豆即将过期，请尽快使用",[beancount doubleValue]/100.0f];
        cell.textLabel.text = showStr;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        return cell;
        
    }
    
}
- (void)allInvestOrGotoPay:(NSInteger)mark
{
    if (mark == 500) {
        MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.inputMoneyTextFieldLable.text = [self GetDefaultText];
    } else if (mark == 501) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
        UCFTopUpViewController *topUpView  = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
        //topUpView.isGoBackShowNavBar = YES;
        topUpView.title = @"充值";
        topUpView.uperViewController = self;
        [self.navigationController pushViewController:topUpView animated:YES];
    }
}
- (NSString *)GetDefaultText
{
    NSString *cantranMoney = [[_dataDict objectForKey:@"data"] objectForKey:@"cantranMoney"];
    long long int keTouJinE = round(([cantranMoney doubleValue]) * 100) ;
    long long int keYongZiJin = round([[[self.dataDict objectForKey:@"data"] objectForKey:@"actBalance"] doubleValue] * 100);
    NSString*  investAmt = [[_dataDict objectForKey:@"data"] objectForKey:@"investAmt"];
    long long int minInVestNum = round([investAmt intValue]* 100);
    double gongDouCount = [[[_dataDict objectForKey:@"data"] objectForKey:@"beanBalance"] doubleValue] * 100;
    if (!isGongDouSwitch) {
        gongDouCount = 0;
    }
    keYongZiJin += gongDouCount;
    //可用金额<起投额 && 可用金额<标剩余 && 标剩余-起投额>=起投额
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
- (void)showCalutorView
{
    [self.view endEditing:YES];
    
    NSString *annualRate = [[_dataDict objectForKey:@"data"] objectForKey:@"transfereeYearRate"];
    NSString *repayMode = [[_dataDict objectForKey:@"data"] objectForKey:@"repayMode"];
    NSString *repayPeriod = [[_dataDict objectForKey:@"data"] objectForKey:@"lastDays"];
    MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *investAmt = cell.inputMoneyTextFieldLable.text;
    if (cell.inputMoneyTextFieldLable.text.length == 0 || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0"] || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0.0"] || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0.00"]) {
        
        [MBProgressHUD displayHudError:@"请输入投资金额"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *parmStr = [NSString stringWithFormat:@"annualRate=%@&repayMode=%@&repayPeriod=%@&investAmt=%@",annualRate,repayMode,repayPeriod,investAmt];
    
    [[NetworkModule sharedNetworkModule] postReq:parmStr tag:kSXTagPrdClaimsComputeIntrest owner:self];
}
- (void)cretateInvestmentView
{
    UIView *preView = (UIView *)[self.view viewWithTag:9000];
    if (preView) {
        [preView removeFromSuperview];
    }
    
    UIView *investBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight -NavigationBarHeight - 67, ScreenWidth, 67)];
    investBaseView.backgroundColor = [UIColor clearColor];
    investBaseView.tag = 9000;
    [self.view addSubview:investBaseView];
    
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 57)];
    bkView.backgroundColor = [UIColor whiteColor];
    [investBaseView addSubview:bkView];
    
    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.frame = CGRectMake(XPOS, 20,ScreenWidth - XPOS*2, 37);
    investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
    investmentButton.layer.cornerRadius = 2.0;
    investmentButton.layer.masksToBounds = YES;
    [investmentButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [investmentButton addTarget:self action:@selector(investmentViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [investBaseView addSubview:investmentButton];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 10)];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    [investBaseView addSubview:shadowView];
    
}
- (void)investmentViewClick:(UIButton *)view
{
    [self checkIsCanInvest];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 1000) {
            MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell.inputMoneyTextFieldLable becomeFirstResponder];
        } else if (alertView.tag == 2000) {
            
        } else if (alertView.tag == 10023) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignmentUpdate" object:nil];

        }
    } else if (buttonIndex == 1) {
        if (alertView.tag == 3000) {
            [self getNormalBidNetData];
            return;
        }
        if (alertView.tag == 2000) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
            UCFTopUpViewController *topUpView  = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
            topUpView.defaultMoney = [NSString stringWithFormat:@"%.2f",needToRechare];
            //topUpView.isGoBackShowNavBar = YES;
            topUpView.title = @"充值";
            topUpView.uperViewController = self;
            [self.navigationController pushViewController:topUpView animated:YES];
        }
        if (alertView.tag == 4000) {
            MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            int compare = [Common stringA:cell.inputMoneyTextFieldLable.text ComparedStringB:@"1000"];
            if (compare == 1 || compare == 0 ) {
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"投资金额%@元,确认投资吗？",cell.inputMoneyTextFieldLable.text] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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

- (void)checkIsCanInvest
{
    NSDictionary *aItemInfo = [_dataDict objectForKey:@"data"];
    MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *investMoney = cell.inputMoneyTextFieldLable.text;
    if ([Common isPureNumandCharacters:investMoney]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return;
    }
    investMoney = [NSString stringWithFormat:@"%.2f",[investMoney doubleValue]];
    if ([Common stringA:@"0.01" ComparedStringB:investMoney] == 1) {
        [MBProgressHUD displayHudError:@"请输入投资金额"];
        return;
    }
    //剩余比例
    NSString *keTouJinE = [NSString stringWithFormat:@"%.2f",[[aItemInfo objectForKey:@"cantranMoney"] doubleValue]];
    NSString *minInVestNum = [NSString stringWithFormat:@"%@",[aItemInfo objectForKey:@"investAmt"]];
    if([Common stringA:minInVestNum ComparedStringB:investMoney] == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投资金额不可低于起投金额" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    double inputMoney = [cell.inputMoneyTextFieldLable.text doubleValue];
    if([Common stringA:[NSString stringWithFormat:@"%.2f",inputMoney] ComparedStringB:keTouJinE] == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不可以这么任性哟，投资金额已超过剩余可投金额了" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
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
    double availableBala= [[aItemInfo objectForKey:@"actBalance"] doubleValue];
    double gondDouBalance = [[aItemInfo objectForKey:@"beanBalance"] doubleValue];
    NSString *availableBalance = nil;
    if (cell.gongDouSwitch.on) {
        availableBalance = [NSString stringWithFormat:@"%.2f",availableBala + gondDouBalance];
    } else {
        availableBalance = [NSString stringWithFormat:@"%.2f",availableBala];
    }
    if([Common stringA:cell.inputMoneyTextFieldLable.text ComparedStringB:availableBalance] == 1)
    {
        NSString *keyongMoney = availableBalance;
        needToRechare = [cell.inputMoneyTextFieldLable.text doubleValue] - [keyongMoney doubleValue];
        NSString *showStr = [NSString stringWithFormat:@"总计投资金额¥%@\n可用金额%@\n另需充值金额¥%.2f",cell.inputMoneyTextFieldLable.text,cell.KeYongMoneyLabel.text,needToRechare];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可用金额不足" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
        alert.tag = 2000;
        [alert show];
        return;
    }
    int compare = [Common stringA:cell.inputMoneyTextFieldLable.text ComparedStringB:@"1000"];
    if (compare == 1 || compare == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"本次投资金额¥%@,确认投资吗？",[UCFToolsMehod AddComma:investMoney]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即投资", nil];
        alert.tag = 3000;
        [alert show];
    } else {
        [self getNormalBidNetData];
    }
}

- (void)getNormalBidNetData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *prdTransferId = [[_dataDict objectForKey:@"data"] objectForKey:@"id"];
    MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //double gongDouCount = [[[_dataDict objectForKey:@"data"] objectForKey:@"beanBalance"] doubleValue];
    NSString *totalInvestAmt = nil;
    double totalMoney = [cell.inputMoneyTextFieldLable.text doubleValue];
    totalInvestAmt = [NSString stringWithFormat:@"%.2lf",totalMoney];
    NSString *investBeans = @"0";
    /*
    if (isGongDouSwitch) {
        investBeans = [NSString stringWithFormat:@"%.2f",gongDouCount];
    } else {
        investBeans = @"0";
    }
    */
    NSString *investMoney = cell.inputMoneyTextFieldLable.text;
//    NSString *annualRate = [[_dataDict objectForKey:@"data"] objectForKey:@"transfereeYearRate"];
//    NSString *repayPeriod = [[_dataDict objectForKey:@"data"] objectForKey:@"lastDays"];
//    NSString *parmStr = [NSString stringWithFormat:@"userId=%@&prdTransferId=%@&totalInvestAmt=%@&investBeans=%@&investMoney=%@&annualRate=%@&repayPeriod=%@",userId,prdTransferId,totalInvestAmt,investBeans,investMoney,annualRate,repayPeriod];
//    parmStr = [parmStr stringByAppendingString:[NSString stringWithFormat:@"&apptzticket=%@",[ToolSingleTon sharedManager].apptzticket]];
//      [[NetworkModule sharedNetworkModule] postReq:parmStr tag:kSXTagSaveTransferDeals owner:self];
    NSString *investTranTicketStr = [self.dataDict objectSafeForKey:@"apptzticket"];
    NSDictionary *dataDic = @{@"userId": [[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"prdTransferId":prdTransferId,@"investAmt":investMoney,@"investBeans":investBeans,@"investTranTicket":investTranTicketStr};
     [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagTraClaimsSubmit owner:self signature:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    
    if (tag.intValue == kSXTagSaveTransferDeals) {
        if ([rstcode intValue] == 1) {
            //跳转投标成功页
            DBLOG(@"投标成功页的数据字典:%@",dic);
            UCFCompleteBidViewCtrl *compl = [[UCFCompleteBidViewCtrl alloc]initWithNibName:@"UCFCompleteBidViewCtrl" bundle:nil];
            compl.isTransid = YES;
            compl.dataDict = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.navigationController pushViewController:compl animated:YES];
            isSucessInvest = YES;
        } else {
            if ([rstcode intValue] == 2) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
                alert.tag = 10023;
                [alert show];
            } else {
                [self reloadMainView];
                [AuxiliaryFunc showAlertViewWithMessage:dic[@"statusdes"]];
            }
        }
    } else if (tag.intValue == kSXTagPrdClaimsComputeIntrest) {
        
        if ([rstcode isEqualToString:@"1"]) {
            CalculatorView * view = [[CalculatorView alloc] init];
            MoneyBoardCell *cell = (MoneyBoardCell *)[_bidTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            NSString *taotalIntrest = [NSString stringWithFormat:@"%@",dic[@"taotalIntrest"]];
            view.tag = 173924;
            view.isTransid = YES;
            [view reloadViewWithData:_dataDict AndNowMoney:cell.inputMoneyTextFieldLable.text AndPreMoney:taotalIntrest BankMoney:dic[@"bankBaseIntrest"]];
            AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.window addSubview:view];
        } else {
            [MBProgressHUD displayHudError:dic[@"statusdes"]];
        }


    } else if (tag.intValue == kSXTagDealTransferBid) {
        
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] integerValue] == 1)
        {
            if ([rstcode isEqualToString:@"1"]) {
                self.dataDict = dic;
                isHasOverdueGongDou = [self checkOverdueGongDou];
                NSDictionary *dict = [_dataDict objectForKey:@"data"];
                self.bidArray = [NSMutableArray array];
                [self.bidArray addObject:dict];
                [self.bidTableView reloadData];
                
            }
        } else {
            [MBProgressHUD displayHudError:[dic valueForKey:@"statusdes"]];
        }
    } else if (tag.intValue == kSXTagTraClaimsSubmit) {//债权转让webView确认
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        if([rstcode intValue] == 1)
        {
            NSDictionary  *dataDict = dic[@"data"][@"tradeReq"];
            NSString *urlStr = dic[@"data"][@"url"];
            UCFPrdTransferBIdWebView *webView = [[UCFPrdTransferBIdWebView alloc]initWithNibName:@"UCFPrdTransferBIdWebView" bundle:nil];
            webView.url = urlStr;
            webView.webDataDic = dataDict;
            webView.navTitle = @"即将跳转";
            [self.navigationController pushViewController:webView animated:YES];
            
            NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            [navVCArray removeObjectAtIndex:navVCArray.count-2];
            [self.navigationController setViewControllers:navVCArray animated:NO];
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD displayHudError:[dic objectSafeForKey:@"message"]];
                [self reloadMainView];
            });
        }
    }

}

-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (UIView *)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 98)];
    footView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    NSString *transferConsultingName = @"";
    if ([UCFToolsMehod isNullOrNilWithString:[_dataDict objectForKey:@"transferConsultingName"]] != 0) {
        transferConsultingName = [_dataDict objectForKey:@"transferConsultingName"];
    }
    NSString *buyerTransferConsultingName = @"";
    if ([UCFToolsMehod isNullOrNilWithString:[_dataDict objectForKey:@"buyerTransferConsultingName"]] != 0) {
        buyerTransferConsultingName = [_dataDict objectForKey:@"buyerTransferConsultingName"];
    }
    NSArray *contractArray = [NSArray arrayWithObjects:transferConsultingName,buyerTransferConsultingName,nil];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(15, 19, 5, 5);
    imageView1.image = [UIImage imageNamed:@"point.png"];
    [footView addSubview:imageView1];
    
    NSString *str1 = [NSString stringWithFormat:@"《%@》",[contractArray objectAtIndex:0]];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame),15, ScreenWidth-25, 12)];
    label1.attributedText = [UCFToolsMehod getAcolorfulStringWithText1:@"本人同意签署" Color1:UIColorWithRGB(0x777777) Font1:[UIFont systemFontOfSize:12] Text2:str1 Color2:UIColorWithRGB(0x108bd8) Font2:[UIFont systemFontOfSize:12] AllText:[NSString stringWithFormat:@"本人同意签署%@",str1]];
    label1.tag = 4000;
    NSString *lengStr = [NSString stringWithFormat:@"本人同意签署%@",str1];
    
    label1.frame = CGRectMake(CGRectGetMaxX(imageView1.frame) + 5,15, [Common getStrWitdth:lengStr TextFont:[UIFont systemFontOfSize:12]].width, 12);
    [footView addSubview:label1];
    label1.backgroundColor = [UIColor clearColor];
    label1.userInteractionEnabled = YES;

    UITapGestureRecognizer *jieChu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHeTong:)];
    [label1 addGestureRecognizer:jieChu];
    

    
    NSString *str2 = [NSString stringWithFormat:@"《%@》",[contractArray objectAtIndex:1]];
    UILabel *label2 = [[UILabel alloc] init];
    label2.tag = 4001;
    label2.userInteractionEnabled = YES;
    label2.textColor = UIColorWithRGB(0x108bd8);
    [footView addSubview:label2];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = str2;
    label2.font = [UIFont systemFontOfSize:12];
    label2.frame = CGRectMake(CGRectGetMaxX(label1.frame),label1.frame.origin.y, [Common getStrWitdth:str2 TextFont:[UIFont systemFontOfSize:12]].width, 12);
    if (CGRectGetMaxX(label2.frame) > ScreenWidth) {
        label2.frame = CGRectMake(CGRectGetMinX(label1.frame) - 6, CGRectGetMaxY(label1.frame) + 5, CGRectGetWidth(label2.frame), CGRectGetHeight(label2.frame));
    }
    UITapGestureRecognizer *baoZheng = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHeTong:)];
    [label2 addGestureRecognizer:baoZheng];
    
    return footView;
}
- (void)showHeTong:(UITapGestureRecognizer *)tap
{
    UILabel *targetLabel = (UILabel *)tap.view;
    NSInteger tag = targetLabel.tag;
    NSString *title = @"";
    NSString *html = @"";
    if(tag == 4001) {
        title = [_dataDict objectForKey:@"buyerTransferConsultingName"];
        html = [_dataDict objectForKey:@"buyerTransferConsulting"];
    } else if (tag == 4000) {
        title = [_dataDict objectForKey:@"transferConsultingName"];
        html = [_dataDict objectForKey:@"transferConsulting"];
    }
    FullWebViewController *webController = [[FullWebViewController alloc] initWithHtmlStr:html title:title];
    webController.baseTitleType = @"detail_heTong";

    [self.navigationController pushViewController:webController animated:YES];
}
- (void)changeGongDouSwitchStatue:(UISwitch *)sender
{
    isGongDouSwitch = sender.on;
    [_bidTableView reloadData];
}

- (void)reloadMainView
{
    NSString *strParameters = nil;
    strParameters = [NSString stringWithFormat:@"userId=%@&tranId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],[[_dataDict objectForKey:@"data"] objectForKey:@"id"]];//101943
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagDealTransferBid owner:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isSucessInvest) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
