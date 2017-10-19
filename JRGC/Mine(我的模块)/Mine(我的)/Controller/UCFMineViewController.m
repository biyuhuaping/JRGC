//
//  UCFMineViewController.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineViewController.h"
#import "UCFMineHeaderView.h"
#import "UCFMineCell.h"
#import "UCFMineFuncCell.h"
#import "UCFMineFuncSecCell.h"
#import "UCFSecurityCenterViewController.h"
#import "UCFLoginBaseView.h"
#import "UCFCalendarViewController.h"
#import "UCFMineAPIManager.h"
#import "UCFUserAssetModel.h"
#import "UCFUserBenefitModel.h"
#import "UCFRechargeOrCashViewController.h"
#import "UCFGoldAccountViewController.h"
#import "UCFP2POrHonerAccoutViewController.h"
#import "HSHelper.h"
#import "UCFAccountPieCharViewController.h"
#import "UCFCouponViewController.h"
#import "UCFWorkPointsViewController.h"
#import "UCFMessageCenterViewController.h"
#import "UCFMyFacBeanViewController.h"
#import "UCFInvitationRebateViewController.h"
#import "UCFMyReservedViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "AppDelegate.h"
#import "UITabBar+TabBarBadge.h"
#import "Touch3DSingle.h"
#import "UCFFacCodeViewController.h"
@interface UCFMineViewController () <UITableViewDelegate, UITableViewDataSource, UCFMineHeaderViewDelegate, UCFMineFuncCellDelegate, UCFMineAPIManagerDelegate, UCFMineFuncSecCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UCFMineHeaderView   *mineHeaderView;
@property (strong, nonatomic) UCFLoginBaseView  *loginView;
@property (strong, nonatomic) UCFMineAPIManager *apiManager;

@property (strong, nonatomic) UCFUserBenefitModel *benefitModel;
@property (strong, nonatomic) UCFUserAssetModel *assetModel;
@end

@implementation UCFMineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"getPersonalCenterNetData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responds3DTouchClick) name:@"responds3DTouchClick" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultState:) name:@"setDefaultViewData" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"refreshUserState" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgSkipToNativeAPP:) name:@"msgSkipToNativeAPP" object:nil];
        
    }
    return self;
}

- (void)responds3DTouchClick
{
    if ([Touch3DSingle sharedTouch3DSingle].isLoad) {
        [Touch3DSingle sharedTouch3DSingle].isLoad = NO;
    }else
        return;
    int type = [[Touch3DSingle sharedTouch3DSingle].type intValue];
    [self.navigationController popToRootViewControllerAnimated:NO];
    switch (type) {
        case 0:{//工场码
            UCFFacCodeViewController *subVC = [[UCFFacCodeViewController alloc] initWithNibName:@"UCFFacCodeViewController" bundle:nil];
            subVC.urlStr = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/mycode.jsp?pcode=%@&sex=%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"gcmCode"], [[UserInfoSingle sharedManager].gender intValue]];
            [self.navigationController pushViewController:subVC animated:YES];
        }
            break;
        case 1:{//签到
            if ([UserInfoSingle sharedManager].userId) {
//                [self.userInfoVC signForRedBag];
            }
        }
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    self.navigationController.navigationBarHidden = YES;
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        if (_loginView) {
            [_loginView removeFromSuperview];
            _loginView = nil;
         }
    } else {
        if (!_loginView) {
            [self.view addSubview:self.loginView];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)refreshUI:(NSNotification *)noti
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
    });
    
}

- (void)setDefaultState:(NSNotification *)noti
{
    [self.mineHeaderView setDefaultState];
    [self.tableView reloadData];
}

- (UCFLoginBaseView *)loginView
{
    if (!_loginView) {
        _loginView = [[UCFLoginBaseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return _loginView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self configure];
    
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mineHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 195);
}

#pragma mark - 设置界面
- (void)createUI {
    lineViewAA.hidden = YES;
    
    UCFMineHeaderView *mineHeader = (UCFMineHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineHeaderView" owner:self options:nil] lastObject];
    mineHeader.delegate = self;
    self.tableView.tableHeaderView = mineHeader;
    self.mineHeaderView = mineHeader;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
}

- (void)refreshData {
    [self.apiManager getAssetFromNet];
    [self.apiManager getBenefitFromNet];
}

- (void)configure {
    UCFMineAPIManager *apiManager = [[UCFMineAPIManager alloc] init];
    apiManager.delegate = self;
    self.apiManager = apiManager;
    [self.apiManager getAssetFromNet];
    [self.apiManager getBenefitFromNet];
}

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedReturnAssetResult:(id)result withTag:(NSUInteger)tag
{
    [self.tableView.header endRefreshing];
    if ([result isKindOfClass:[UCFUserAssetModel class]]) {
        self.assetModel = result;
        self.mineHeaderView.userAssetModel = result;
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }
}

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedReturnBenefitResult:(id)result withTag:(NSUInteger)tag
{
    [self.tableView.header endRefreshing];
    if ([result isKindOfClass:[UCFUserBenefitModel class]]) {
        self.benefitModel = result;
        self.mineHeaderView.userBenefitModel = result;
        
        if ([self.mineHeaderView.userBenefitModel.unReadMsgCount intValue] == 0) {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
        } else {
            [self.tabBarController.tabBar showBadgeOnItemIndex:4];
        }
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }
}

#pragma mark - tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        
        case 1:
            return 1;
        
        case 2:
            return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"minecellfirst";
        UCFMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineCell" owner:self options:nil] lastObject];
            cell.tableview = tableView;
            cell.valueLabel.textColor = UIColorWithRGB(0xfd4d4c);
        }
        cell.indexPath = indexPath;
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_wj"];
            cell.titleDesLabel.text = @"微金账户";
            if ([UserInfoSingle sharedManager].openStatus > 2) {
                cell.valueLabel.text = self.assetModel.p2pCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.p2pCashBalance] : [NSString stringWithFormat:@"¥0.00"];
                cell.describeLabel.text = self.benefitModel.repayPerDateWJ.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.benefitModel.repayPerDateWJ] : @"最近无回款";
                cell.descriLabel.hidden = NO;
            }
            else {
                cell.valueLabel.text = @"未开户";
                cell.describeLabel.text = @"";
                cell.descriLabel.hidden = YES;
            }
        }
        else if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_zx"];
            cell.titleDesLabel.text = @"尊享账户";
            if ([UserInfoSingle sharedManager].enjoyOpenStatus > 2) {
                cell.valueLabel.text = self.assetModel.zxCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.zxCashBalance] : [NSString stringWithFormat:@"¥0.00"];
                cell.describeLabel.text = self.benefitModel.repayPerDateZX.length > 0 ? [NSString stringWithFormat:@"最近回款日%@", self.benefitModel.repayPerDateZX] : @"最近无回款";
                cell.descriLabel.hidden = NO;
            }
            else {
                cell.valueLabel.text = @"未开户";
                cell.describeLabel.text = @"";
                cell.descriLabel.hidden = YES;
            }
        }
        else if (indexPath.row == 2) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_gold"];
            cell.valueLabel.textColor = UIColorWithRGB(0xffa811);
            cell.titleDesLabel.text = @"黄金账户";
            if ([UserInfoSingle sharedManager].openStatus < 3 && [UserInfoSingle sharedManager].enjoyOpenStatus < 3 )
            {
                cell.valueLabel.text = @"未开户";
                cell.describeLabel.text = @"";
                cell.descriLabel.hidden = YES;
            }else{
                cell.valueLabel.text = self.assetModel.nmCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.nmCashBalance] : [NSString stringWithFormat:@"¥0.00"];
                cell.describeLabel.text = self.benefitModel.repayPerDateNM;
                cell.descriLabel.hidden = NO;
            }
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = @"minefunccell";
        UCFMineFuncCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineFuncCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineFuncCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.tableview = tableView;
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *cellId = @"minefuncseccell";
        UCFMineFuncSecCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFMineFuncSecCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineFuncSecCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.tableview = tableView;
        }
        cell.indexPath = indexPath;
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_bean"];
            cell.icon2ImageView.image = [UIImage imageNamed:@"uesr_icon_coupon"];
            cell.titleDesLabel.text = @"工豆";
            cell.title2DesLabel.text = @"优惠券";
            cell.valueLabel.text = self.benefitModel.beanAmount ? [NSString stringWithFormat:@"¥%@", self.benefitModel.beanAmount] : @"¥0.00";
            cell.value2Label.text = self.benefitModel.couponNumber ? [NSString stringWithFormat:@"%@张可用", self.benefitModel.couponNumber] : @"0张可用";
            if (self.benefitModel.beanExpiring.integerValue > 0) {
                cell.signView.hidden = NO;
            }
            else {
                cell.signView.hidden = YES;
            }
            if (self.benefitModel.couponExpringNum.integerValue > 0) {
                cell.sign2View.hidden = NO;
            }
            else {
                cell.sign2View.hidden = YES;
            }
        }
        else if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_score"];
            cell.icon2ImageView.image = [UIImage imageNamed:@"uesr_icon_rebate"];
            cell.titleDesLabel.text = @"工分";
            cell.valueLabel.text = self.benefitModel.score ? [NSString stringWithFormat:@"%@分", self.benefitModel.score] : @"0分";
            cell.title2DesLabel.text = @"邀请返利";
            cell.value2Label.text = self.benefitModel.promotionCode.length > 0 ? [NSString stringWithFormat:@"工场码%@", self.benefitModel.promotionCode] : @"";
            cell.signView.hidden = YES;
            cell.sign2View.hidden = YES;
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50;
    }
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        UCFMineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        if ([cell.titleDesLabel.text hasPrefix:@"微金"])
        {
            self.accoutType =  SelectAccoutTypeP2P;
        }
        else if([cell.titleDesLabel.text hasPrefix:@"尊享"]){
            self.accoutType = SelectAccoutTypeHoner;
        }
        else if([cell.titleDesLabel.text hasPrefix:@"黄金"]){
            
            if ([UserInfoSingle sharedManager].openStatus < 3 && [UserInfoSingle sharedManager].enjoyOpenStatus < 3 )
            {
                HSHelper *helper = [HSHelper new];
                if (![helper checkP2POrWJIsAuthorization:SelectAccoutTypeHoner]) {//先授权
                    [helper pushP2POrWJAuthorizationType:SelectAccoutTypeHoner nav:self.navigationController];
                    return;
                }
                [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        
            }
            else
            {
                UCFGoldAccountViewController *subVC = [[UCFGoldAccountViewController alloc] initWithNibName:@"UCFGoldAccountViewController" bundle:nil];
                subVC.homeView = weakSelf;
                [self.navigationController pushViewController:subVC animated:YES];
            }
            return;
        }
        
        HSHelper *helper = [HSHelper new];
        //检查企业老用户是否开户
        NSString *messageStr =  [helper checkCompanyIsOpen:self.accoutType];
        if (![messageStr isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        if (![helper checkP2POrWJIsAuthorization:self.accoutType]) {//先授权
            [helper pushP2POrWJAuthorizationType:self.accoutType nav:self.navigationController];
            return;
        }

        if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
            UCFP2POrHonerAccoutViewController *subVC = [[UCFP2POrHonerAccoutViewController alloc] initWithNibName:@"UCFP2POrHonerAccoutViewController" bundle:nil];
            subVC.accoutType = self.accoutType;
            [self.navigationController pushViewController:subVC animated:YES];
        }

    }
}
#pragma mark -去消息中心
-(void)gotoMessageCenterViewController
{
    UCFMessageCenterViewController *messagecenterVC = [[UCFMessageCenterViewController alloc]initWithNibName:@"UCFMessageCenterViewController" bundle:nil];
    messagecenterVC.title =@"消息中心";
    [self.navigationController pushViewController:messagecenterVC animated:YES];
}
#pragma mark - 我的页面的头部视图代理方法
- (void)mineHeaderViewDidClikedUserInfoWithCurrentVC:(UCFMineHeaderView *)mineHeaderView
{
    UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
    personMessageVC.title = @"个人信息";
    [self.navigationController pushViewController:personMessageVC animated:YES];
}
#pragma mark -饼图点击事件
-(void)gotoAccountPieCharView:(NSInteger )selectedIndex{
        UCFAccountPieCharViewController * accoutPieChartVC = [[UCFAccountPieCharViewController alloc]initWithNibName:@"UCFAccountPieCharViewController" bundle:nil];
        accoutPieChartVC.selectedSegmentIndex = selectedIndex ;
    
        [self.navigationController pushViewController:accoutPieChartVC animated:YES];
}
- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedTopUpButton:(UIButton *)rechargeButton
{
    //获取充值绑卡页面数据
    [self.apiManager getRecharngeBindingBankCardNet];
}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedCashButton:(UIButton *)cashButton
{
    //获取提现绑卡页面数据
    if([UserInfoSingle sharedManager].openStatus < 3 && [UserInfoSingle sharedManager].enjoyOpenStatus < 3 && ![UserInfoSingle sharedManager].goldAuthorization)//微金未开通账户
    {
        [AuxiliaryFunc showToastMessage:@"没有可提现的账户" withView:self.view];
        return;
    }
    [self.apiManager getCashAccoutBalanceNet];
}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedTotalAssetButton:(UIButton *)totalAssetButton
{
    [self gotoAccountPieCharView:0];
}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedAddedProfitButton:(UIButton *)totalProfitButton
{
    [self gotoAccountPieCharView:1];
}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView tappedMememberLevelView:(UIView *)memberLevelView
{
    //跳转到会员等级
    UCFWebViewJavascriptBridgeLevel*vc = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
    vc.url = LEVELURL;
    vc.navTitle = @"会员等级";
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedMessageButton:(UIButton *)totalProfitButton
{
    [self gotoMessageCenterViewController];
}

- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail type:(SelectAccoutType)accout;
{
    
    NSString *tipStr1 = accout == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = accout == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;
    
    NSInteger openStatus = accout == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus :[UserInfoSingle sharedManager].enjoyOpenStatus;
    
    switch (openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:tipStr1];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:tipStr2];
                return NO;
            }
        }
            break;
        default:
            return YES;
            break;
    }
}
- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag =  self.accoutType == SelectAccoutTypeP2P ? 8000 :8010;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
    }else if (alertView.tag == 8010) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        }
    }
}

#pragma mark - UCFMineFuncCell的代理方法

- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedCalendarButton:(UIButton *)button
{
    UCFCalendarViewController *backMoneyCalendarVC = [[UCFCalendarViewController alloc] initWithNibName:@"UCFCalendarViewController" bundle:nil];
//        backMoneyDetailVC.superViewController = self;
//    backMoneyCalendarVC.accoutType = self.accoutType;
    [self.navigationController pushViewController:backMoneyCalendarVC animated:YES];
}

- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedMyReservedButton:(UIButton *)button
{
    UCFMyReservedViewController *myserved = [[UCFMyReservedViewController alloc] initWithNibName:@"UCFMyReservedViewController" bundle:nil];
    myserved.url = [NSString stringWithFormat:@"https://m.9888.cn/static/wap/invest/index.html#/reserve/records"];
    myserved.navTitle = @"我的预约";
    [self.navigationController pushViewController:myserved animated:YES];
}

- (void)mineFuncSecCell:(UCFMineFuncSecCell *)funcSecCell didClickedButtonWithTitle:(NSString *)title
{
    if ([title isEqualToString:@"工豆"]) {
        UCFMyFacBeanViewController *bean = [[UCFMyFacBeanViewController alloc] initWithNibName:@"UCFMyFacBeanViewController" bundle:nil];
        bean.title = @"我的工豆";
        [self.navigationController pushViewController:bean animated:YES];
        
    }
    else if ([title isEqualToString:@"工分"]){
        //跳转到工分
        UCFWorkPointsViewController *subVC = [[UCFWorkPointsViewController alloc]initWithNibName:@"UCFWorkPointsViewController" bundle:nil];
        subVC.title = @"我的工分";
        [self.navigationController pushViewController:subVC animated:YES];
        
    }
    else   if ([title isEqualToString:@"优惠券"]){
        
        UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        [self.navigationController pushViewController:coupon animated:YES];
        
    }
    else  if ([title isEqualToString:@"邀请返利"]){//邀请返利
        UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
        feedBackVC.title = @"邀请获利";
        feedBackVC.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }

}

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedCashAccoutBalanceResult:(id)result withTag:(NSUInteger)tag
{
    self.mineHeaderView.cashButton.enabled = YES;
    switch (tag) {
        case 0://网络异常情况
        {
             [MBProgressHUD displayHudError:result];
        }
            break;
        case 1://返回数据失败
        {
            NSDictionary *dataDict = (NSDictionary *)result;
            UCFRechargeOrCashViewController * rechargeCashVC = [[UCFRechargeOrCashViewController alloc]initWithNibName:@"UCFRechargeOrCashViewController" bundle:nil];
            rechargeCashVC.dataDict = dataDict;
            rechargeCashVC.isRechargeOrCash = YES;//提现
            UINavigationController *rechargeCashNavController = [[UINavigationController alloc] initWithRootViewController:rechargeCashVC];
            rechargeCashNavController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [app.tabBarController presentViewController:rechargeCashNavController animated:NO completion:^{
            }];
        }
            break;
        case 2://返回数据失败
        {
             [AuxiliaryFunc showToastMessage:result withView:self.view];
        }
            break;
            
        default:
            break;
    }
    

}
-(void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedRechargeBindingBankCardResult:(id)result withTag:(NSUInteger)tag
{
    self.mineHeaderView.rechargeButton.enabled = YES;
    switch (tag) {
        case 0://网络异常情况
        {
            [MBProgressHUD displayHudError:result];
        }
            break;
        case 1://返回数据成功
        {

            NSDictionary *dataDict = (NSDictionary *)result;
            UCFRechargeOrCashViewController * rechargeCashVC = [[UCFRechargeOrCashViewController alloc]initWithNibName:@"UCFRechargeOrCashViewController" bundle:nil];
            rechargeCashVC.dataDict = dataDict;
            rechargeCashVC.isRechargeOrCash = NO;//充值
            UINavigationController *rechargeCashNavController = [[UINavigationController alloc] initWithRootViewController:rechargeCashVC];
            rechargeCashNavController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [app.tabBarController presentViewController:rechargeCashNavController animated:NO completion:^{
            }];
        }
            break;
        case 2://返回数据失败
        {
            [AuxiliaryFunc showToastMessage:result withView:self.view];
        }
            break;
            
        default:
            break;
    }


}
@end
