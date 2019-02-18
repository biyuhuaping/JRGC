//
//  UCFQuickRechargeViewController.m
//  JRGC
//
//  Created by 金融工场 on 2018/11/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFQuickRechargeViewController.h"
#import "QuickRechargeHeadView.h"
#import "QuickIntroduceTableViewCell.h"
#import "UCFToolsMehod.h"
#import "UCFModifyReservedBankNumberViewController.h"
#import "FMDeviceManager.h"
#import "UCFRechargeWebViewController.h"
#import "NSString+Misc.h"
#import "AppDelegate.h"
#import "HSHelper.h"
@interface UCFQuickRechargeViewController ()<QuickRechargeHeadViewDelegate,UITableViewDelegate,UITableViewDataSource,UCFModifyReservedBankNumberDelegate,QuickIntroduceTableViewCellDelegate>
{
    NSString *telNum;
    NSString *minRecharge;
    NSString *fee;
    BOOL isSpecial;
}
@property (weak, nonatomic) IBOutlet UITableView *showTableView;
@property (strong, nonatomic)QuickRechargeHeadView *showHeadView;
@property (strong, nonatomic)NSMutableArray *dataArr;
@end

@implementation UCFQuickRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    _showTableView.delegate = self;
    _showTableView.dataSource = self;
    _showTableView.delaysContentTouches = NO;

    _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _showTableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
    _showTableView.backgroundColor = UIColorWithRGB(0xebebee);

    self.showHeadView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QuickRechargeHeadView class]) owner:nil options:nil][0];
    _showHeadView.frame = CGRectMake(0, 0, ScreenWidth, 230);
    _showHeadView.backgroundColor = UIColorWithRGB(0xebebee);

    _showHeadView.delegate = self;
    _showTableView.tableHeaderView = _showHeadView;

}
- (void)setDefaultMoney:(NSString *)defaultMoney
{
    if ([defaultMoney doubleValue] > 0) {
        _showHeadView.moneyTextField.text = defaultMoney;
        _defaultMoney = defaultMoney;
    }
}
- (void)fetchData
{
    SingleUserInfo.bankNumTip = @"88888";
    self.dataArr = [NSMutableArray arrayWithCapacity:7];
    [self.dataArr addObject:@"温馨提示"];
    [self.dataArr addObject:@"● 使用快捷支付充值最低金额应大于等于1元；"];
    [self.dataArr addObject:@"● 对充值后未出借的提现，由第三方平台收取0.4%的手续费；"];
    [self.dataArr addObject:@"● 充值/提现必须为银行借记卡，不支持存折、信用卡充值；"];
    [self.dataArr addObject:@"● 充值需开通银行卡网上支付功能，如有疑问请咨询开户行客服；"];
    [self.dataArr addObject:@"● 单笔充值不可超过该银行充值限额；"];
    [self.dataArr addObject:@"● 如果手机快捷支付充值失败，可使用网银、手机银行转账等其他方式进行充值。"];
    [self.dataArr addObject:@"● 如果充值金额没有及时到账，请拨打客服查询。"];

    [self getMyBindCardMessage];
}
- (void)quickRechargeHeadView:(QuickRechargeHeadView *)view fixButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    UCFModifyReservedBankNumberViewController *modifyBankNumberVC = [[UCFModifyReservedBankNumberViewController alloc]initWithNibName:@"UCFModifyReservedBankNumberViewController" bundle:nil];
    modifyBankNumberVC.title = @"修改银行预留手机号";
    modifyBankNumberVC.tellNumber = telNum;
    modifyBankNumberVC.delegate = self;
    modifyBankNumberVC.accoutType = self.accoutType;
    [((UIViewController *)self.rootVc).navigationController pushViewController:modifyBankNumberVC animated:YES];
}
- (void)quickRechargeHeadView:(QuickRechargeHeadView *)view rechargeButtonClick:(UIButton *)button
{
//    fff
    if ( self.accoutType == SelectAccoutTypeP2P &&  SingleUserInfo.loginData.userInfo.openStatus == 3 && [self checkOrderIsLegitimate]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:P2PTIP2 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag =  8000;
        [alert show];
        return;
    }
    if ([self checkOrderIsLegitimate]) {
        [self.view endEditing:YES];
        FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
        //#warning 同盾修改
        //        manager->getDeviceInfoAsync(nil, self);
        NSString *blackBox = manager->getDeviceInfo();
        //        NSLog(@"同盾设备指纹数据: %@", blackBox);
        [self didReceiveDeviceBlackBox:blackBox];
    }
}
- (void) didReceiveDeviceBlackBox: (NSString *) blackBox {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *inputMoney = [Common deleteStrHeadAndTailSpace:_showHeadView.moneyTextField.text];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setValue:inputMoney forKey:@"payAmount"];
    [paraDict setValue:_showHeadView.mobileTextField.text forKey:@"phoneNo"];
    [paraDict setValue:SingleUserInfo.loginData.userInfo.userId forKey:@"userId"];
    [paraDict setValue:blackBox forKey:@"token_id"];
    [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:kSXTagP2PAccountrechargeNew owner:self signature:YES Type:self.accoutType];
    
}
//检查订单状态是否合法
- (BOOL)checkOrderIsLegitimate
{
    NSString *inputMoney = [Common deleteStrHeadAndTailSpace:_showHeadView.moneyTextField.text];
    if ([Common isPureNumandCharacters:inputMoney]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return NO;
    }
    inputMoney = [NSString stringWithFormat:@"%.2f",[inputMoney doubleValue]];
    NSComparisonResult comparResult = [minRecharge compare:[Common deleteStrHeadAndTailSpace:inputMoney] options:NSNumericSearch];
    //ipa 版本号 大于 或者等于 Apple 的版本，返回，不做自己服务器检测
    if (comparResult == NSOrderedDescending) {
        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"单笔充值金额不低于%@元",minRecharge]];
        return NO;
    }
    comparResult = [inputMoney compare:@"10000000.00" options:NSNumericSearch];
    if (comparResult == NSOrderedDescending || comparResult == NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值金额不可大于1000万" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (_showHeadView.mobileTextField.text.length != 11) {
        [MBProgressHUD displayHudError:@"请输入正确手机号"];
        return NO;
    }
    return YES;
}
-(void)modifyReservedBankNumberSuccess:(NSString *)reservedBankNumber{
    _showHeadView.mobileTextField.text = reservedBankNumber;
}
/**
 *  获取银行卡信息
 */
- (void)getMyBindCardMessage
{
    NSString *uuid = SingleUserInfo.loginData.userInfo.userId;
    if(uuid == nil)
    {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dataDict =@{@"userId":uuid};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagBankTopInfo owner:self signature:YES Type:self.accoutType];
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    if (tag.intValue == kSXTagBankTopInfo) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([[dic valueForKey:@"ret"] boolValue]) {
            NSDictionary *coreDict = dic[@"data"][@"bankInfo"];
            NSString *bankUrl = coreDict[@"bankLogo"];
            if (![bankUrl isEqual:[NSNull null]]) {
                [_showHeadView.bankLogoImage sd_setImageWithURL:[NSURL URLWithString:bankUrl]];
            }
            if (![coreDict[@"bankName"] isEqual:[NSNull null]]) {
                _showHeadView.bankName.text = [UCFToolsMehod isNullOrNilWithString:coreDict[@"bankName"]];
            }
            SingleUserInfo.loginData.userInfo.realName = [coreDict objectSafeForKey: @"realName"];
            _showHeadView.bankName.text = [NSString stringWithFormat:@"%@(尾号%@)",_showHeadView.bankName.text,[UCFToolsMehod isNullOrNilWithString:coreDict[@"bankBehindFour"]]];
            SingleUserInfo.bankNumTip = [NSString stringWithFormat:@"尾号(%@)的%@",[UCFToolsMehod isNullOrNilWithString:coreDict[@"bankBehindFour"]],[UCFToolsMehod isNullOrNilWithString:coreDict[@"bankName"]]];
            
            _showHeadView.bankRechargeLimitLab.text = coreDict[@"limitMess"];
            
            telNum = [NSString stringWithFormat:@"%@",dic[@"data"][@"customerServiceNo"]];
            minRecharge = [NSString stringWithFormat:@"%@",dic[@"data"][@"minAmt"]];
            fee = [NSString stringWithFormat:@"%@",dic[@"data"][@"fee"]];
            if (self.accoutType == SelectAccoutTypeP2P)
            {
                SingleUserInfo.loginData.userInfo.openStatus = [[coreDict objectSafeForKey:@"openStatus"] integerValue];
            }
            NSString *bankPhone =  [dic[@"data"][@"bankInfo"] objectSafeForKey:@"bankPhone"];
            isSpecial = [[dic[@"data"][@"bankInfo"] objectSafeForKey:@"isSpecial"] boolValue];
            BOOL isCompanyAgent  = [[dic[@"data"][@"bankInfo"] objectSafeForKey:@"isCompanyAgent"] boolValue];
            if (isSpecial || isCompanyAgent) {
                
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请直接转账至徽商电子账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看账户", nil];
                alerView.tag = 1002;
                [alerView show];
            }
            if([bankPhone isEqualToString:@""]){
                _showHeadView.fixButton.hidden = YES;
            }else{
                _showHeadView.mobileTextField.text = bankPhone;
                _showHeadView.fixButton.hidden = NO;
                _showHeadView.mobileTextField.textColor = UIColorWithRGB(0x999999);
                _showHeadView.mobileTextField.userInteractionEnabled = NO;
            }
            
            [self.dataArr removeAllObjects];
            [self.dataArr addObject:@"温馨提示"];
            [self.dataArr addObject:[NSString stringWithFormat:@"● 使用快捷支付充值最低金额应大于等于%@元；",minRecharge]];
            [self.dataArr addObject:[NSString stringWithFormat:@"● 对充值后未出借的提现，由第三方平台收取%@%%的手续费；",fee]];
            [self.dataArr addObject:@"● 充值/提现必须为银行借记卡，不支持存折、信用卡充值；"];
            [self.dataArr addObject:@"● 充值需开通银行卡网上支付功能，如有疑问请咨询开户行客服；"];
            [self.dataArr addObject:@"● 单笔充值不可超过该银行充值限额；"];
            [self.dataArr addObject:@"● 如果手机快捷支付充值失败，可使用网银、手机银行转账等其他方式进行充值。"];
            [self.dataArr addObject:@"● 如果充值金额没有及时到账，请拨打客服查询。"];
            
            [_showTableView reloadData];
        } else {
            [MBProgressHUD displayHudError:dic[@"message"]];
        }
    } else if (tag.intValue == kSXTagP2PAccountrechargeNew) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        if([rstcode intValue] == 1)
        {
            NSDictionary  *dataDict = dic[@"data"][@"tradeReq"];
            NSString *urlStr = dic[@"data"][@"url"];
            UCFRechargeWebViewController *rechargeWebVC = [[UCFRechargeWebViewController alloc]initWithNibName:@"UCFRechargeWebViewController" bundle:nil];
            NSString *SIGNStr =   dataDict[@"SIGN"];
            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
            [data setValue: dic[@"data"][@"tradeReq"][@"PARAMS"]  forKey:@"PARAMS"];
            [data setValue:[NSString  urlEncodeStr:SIGNStr] forKey:@"SIGN"];
            rechargeWebVC.webDataDic = data;
            //            rechargeWebVC.navTitle = @"即将跳转";
            rechargeWebVC.url = urlStr;
            rechargeWebVC.accoutType = self.accoutType;
            rechargeWebVC.rootVc = self.uperViewController;
            [((UIViewController *)self.rootVc).navigationController pushViewController:rechargeWebVC animated:YES];
        }
        else{
            NSString *messageStr = [dic objectSafeForKey:@"message"];
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
         if (buttonIndex == 1) {
            NSString *className = [NSString stringWithUTF8String:object_getClassName(_uperViewController)];
            if ([className hasSuffix:@"UCFPurchaseBidViewController"] || [className hasSuffix:@"UCFPurchaseTranBidViewController"] || [className hasSuffix:@"UCFSelectPayBackController"] || [className hasSuffix:@"UCFFacReservedViewController"]) {
                [((UIViewController *)self.rootVc).navigationController popToViewController:_uperViewController animated:YES];
            }
            else if([className hasSuffix:@"UCFRechargeOrCashViewController"])
            {
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                    NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
                    UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
                    [nav popToRootViewControllerAnimated:NO];
                    [appDelegate.tabBarController setSelectedIndex:0];
                }];
            }
            else{
                [((UIViewController *)self.rootVc).navigationController popToRootViewControllerAnimated:NO];
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                [appDelegate.tabBarController setSelectedIndex:0];
            }
        }
    } else if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            
        }
    }else if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:self.accoutType Step:SingleUserInfo.loginData.userInfo.openStatus nav: ((UIViewController *)self.rootVc).navigationController];
        }
    }else {
        if (buttonIndex == 1) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[telNum  stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _showHeadView.frame = CGRectMake(0, 0, ScreenWidth, 230);
    _showTableView.tableHeaderView = _showHeadView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cee";
    QuickIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QuickIntroduceTableViewCell class]) owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.delegate = self;
    cell.showLabel.text = self.dataArr[indexPath.row];
    [cell.showLabel setLineSpace:3 string:cell.showLabel.text];

    if ([cell.showLabel.text containsString:@"如果充值金额没有及时到账，请拨打客服查询"]) {
        [cell.showLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"拨打客服"];
    
    }
    
    return cell;
}
- (void)telServiceNo
{
    NSString *telStr = [NSString stringWithFormat:@"呼叫%@",telNum];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:telStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
    [alert show];
}
- (void)quickIntroduceTableViewCell:(QuickIntroduceTableViewCell *)cell withButton:(UIButton *)button
{
    [self telServiceNo];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *str = self.dataArr[indexPath.row];
//    if ([str containsString:@"如果充值金额没有及时到账，请拨打客服查询"]) {
//        [self telServiceNo];
//    }
//}
@end
