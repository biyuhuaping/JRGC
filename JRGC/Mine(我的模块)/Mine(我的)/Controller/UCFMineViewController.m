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
//#import "UCFMineFuncSecCell.h"
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
#import "KTAlertController.h"
#import <StoreKit/StoreKit.h>
#import "UCFAccountAssetsProofViewController.h"
#import "UCFMineFuncView.h"
#import "UCFTopUpViewController.h"
#import "UCFCashViewController.h"
#import "ToolSingleTon.h"
#import "UCFCalendarModularViewController.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "NSString+Misc.h"
@interface UCFMineViewController () <UITableViewDelegate, UITableViewDataSource, UCFMineHeaderViewDelegate, UCFMineFuncCellDelegate, UCFMineAPIManagerDelegate, UCFMineFuncViewDelegate, UIAlertViewDelegate, SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UCFMineHeaderView   *mineHeaderView;
@property (weak, nonatomic) UCFMineFuncView   *mineFooterView;
@property (strong, nonatomic) UCFLoginBaseView  *loginView;
@property (strong, nonatomic) UCFMineAPIManager *apiManager;

@property (strong, nonatomic) UCFUserBenefitModel *benefitModel;
@property (strong, nonatomic) UCFUserAssetModel *assetModel;
@property (assign, nonatomic) BOOL assetProofCanClick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSapce;
@end

@implementation UCFMineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"getPersonalCenterNetData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responds3DTouchClick) name:@"responds3DTouchClick" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultState:) name:@"setDefaultViewData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"reloadP2PData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"reloadP2PTransferData" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHonerTransferData" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redbag_unfold_close:) name:@"UCFRedBagViewController_unfold_close" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgSkipToNativeAPP:) name:@"msgSkipToNativeAPP" object:nil];
        
    }
    return self;
}

- (void)redbag_unfold_close:(NSNotification *)noty {
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.navigationController.presentedViewController) {
        if (self.navigationController.presentedViewController.presentedViewController) {
            [self.navigationController.presentedViewController.presentedViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
//    [self.navigationController dismissViewControllerAnimated:NO completion:^{
//
//    }];
    [self refresh];
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
            subVC.urlStr = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/mycode.jsp?pcode=%@&sex=%d",[[NSUserDefaults standardUserDefaults] objectForKey:GCMCODE], [[UserInfoSingle sharedManager].gender intValue]];
            [self.navigationController pushViewController:subVC animated:YES];
        }
            break;
        case 1:{//签到
//            if ([UserInfoSingle sharedManager].userId) {
////                [self.userInfoVC signForRedBag];
//            }
            UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
            feedBackVC.title = @"邀请获利";
            feedBackVC.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:feedBackVC animated:YES];
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
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"tapMineNum"];
    if (index == 0 && [UserInfoSingle sharedManager].userId != nil) {
        index += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"tapMineNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (index == 5) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"亲爱的工友，喜欢就去给个好评吧！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"冷漠拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"tapMineNum"];
            index += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"tapMineNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"表白金融工场" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"tapMineNum"];
            index += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"tapMineNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_RATING_URL]];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }
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

//取消按钮监听方法
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)refreshUI:(NSNotification *)noti
{
    [[UserInfoSingle sharedManager] checkUserLevelOnSupervise];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
    });
    
}

- (void)setDefaultState:(NSNotification *)noti
{
    [[UserInfoSingle sharedManager] checkUserLevelOnSupervise];
    [self.mineHeaderView setDefaultState];
    [self.tableView reloadData];
    [self.mineFooterView clearData];
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
    self.mineFooterView.height = 240;
    if ([[UIApplication sharedApplication] statusBarFrame].size.height > 21) {
        
    } else {
        self.topSapce.constant = - 20;
    }
}

- (void)refresh
{
    [self.tableView.header beginRefreshing];
}

#pragma mark - 设置界面
- (void)createUI {
    lineViewAA.hidden = YES;
    
    UCFMineHeaderView *mineHeader = (UCFMineHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineHeaderView" owner:self options:nil] lastObject];
    mineHeader.delegate = self;
    self.tableView.tableHeaderView = mineHeader;
    self.tableView.backgroundColor = UIColorWithRGB(0xebebee);
    self.mineHeaderView = mineHeader;
    
    UCFMineFuncView *mineFooter = (UCFMineFuncView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMineFuncView" owner:self options:nil] lastObject];
    mineFooter.delegate = self;
//    mineFooter.frame = CGRectMake(0, 0, ScreenWidth, mineFooter.height);
    self.tableView.tableFooterView = mineFooter;
    self.mineFooterView = mineFooter;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)refreshData {
    self.assetProofCanClick = NO;
    [self.apiManager getAssetFromNet];
    [self.apiManager getBenefitFromNet];
}

- (void)configure {
    UCFMineAPIManager *apiManager = [[UCFMineAPIManager alloc] init];
    apiManager.delegate = self;
    self.apiManager = apiManager;
    self.assetProofCanClick = NO;
    [self.apiManager getAssetFromNet];
    [self.apiManager getBenefitFromNet];
}

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedReturnAssetResult:(id)result withTag:(NSUInteger)tag
{
    self.assetProofCanClick = YES;
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
        [UserInfoSingle sharedManager].gcm_code = self.benefitModel.promotionCode;
        self.mineFooterView.benefit = result;
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
    return 2;
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
        case 0: {
            if ([UserInfoSingle sharedManager].userId) {
                if ([UserInfoSingle sharedManager].superviseSwitch) {
                        if ([UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                            return 1;
                        }
                        else if ([UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                            return 2;
                        }
                        else if (![UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                            return 2;
                        }
                        else if (![UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                            return 3;
                        }
                }
                else {
                    return 3;
                }
            }
            else {
                if ([UserInfoSingle sharedManager].superviseSwitch) {
                    return 1;
                }
                else {
                    return 3;
                }
            }
        }
        case 1:
            return 1;
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
            if ([UserInfoSingle sharedManager].superviseSwitch) {
                if (![UserInfoSingle sharedManager].zxIsNew) {
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
                else {
                    cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_gold"];
                    cell.valueLabel.textColor = UIColorWithRGB(0xffa811);
                    cell.titleDesLabel.text = @"黄金账户";
                    if ([UserInfoSingle sharedManager].goldAuthorization)
                    {
                        cell.valueLabel.text = self.assetModel.nmCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.nmCashBalance] : [NSString stringWithFormat:@"¥0.00"];
                        cell.describeLabel.text = self.benefitModel.repayPerDateNM;
                        cell.descriLabel.hidden = NO;
                    }else{
                        cell.valueLabel.text = @"未开户";
                        cell.describeLabel.text = @"";
                        cell.descriLabel.hidden = YES;
                    }
                }
            }
            else {
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
        }
        else if (indexPath.row == 2) {
            cell.iconImageView.image = [UIImage imageNamed:@"uesr_icon_gold"];
            cell.valueLabel.textColor = UIColorWithRGB(0xffa811);
            cell.titleDesLabel.text = @"黄金账户";
            if ([UserInfoSingle sharedManager].goldAuthorization)
            {
                cell.valueLabel.text = self.assetModel.nmCashBalance.length > 0 ? [NSString stringWithFormat:@"¥%@", self.assetModel.nmCashBalance] : [NSString stringWithFormat:@"¥0.00"];
                cell.describeLabel.text = self.benefitModel.repayPerDateNM;
                cell.descriLabel.hidden = NO;
            }else{
                cell.valueLabel.text = @"未开户";
                cell.describeLabel.text = @"";
                cell.descriLabel.hidden = YES;
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
            
            if([UserInfoSingle sharedManager].goldAuthorization)
            {
                UCFGoldAccountViewController *subVC = [[UCFGoldAccountViewController alloc] initWithNibName:@"UCFGoldAccountViewController" bundle:nil];
                subVC.homeView = weakSelf;
                [self.navigationController pushViewController:subVC animated:YES];
            }
            else
            {
                    HSHelper *helper = [HSHelper new];
                    if ([UserInfoSingle sharedManager].openStatus < 3 && [UserInfoSingle sharedManager].enjoyOpenStatus < 3 )
                    {
                       
                        if (![helper checkP2POrWJIsAuthorization:SelectAccoutTypeHoner]) {//先授权
                            [helper pushP2POrWJAuthorizationType:SelectAccoutTypeHoner nav:self.navigationController];
                            return;
                        }
                        [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
                    }
                    else
                    {
                        [helper pushGoldAuthorizationType:SelectAccoutTypeGold nav:self.navigationController sourceVC:@"MinViewController"];
                    }
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
    
    //监管开关 打开时 等级不足VIP1 且未投资过尊享且未投资过黄金项目的用户 直接进入充值页面
   
    if([UserInfoSingle sharedManager].superviseSwitch)
    {
        self.mineHeaderView.rechargeButton.enabled = YES;
        self.accoutType = SelectAccoutTypeP2P;
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
         
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
            UCFTopUpViewController * rechargeVC = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
            rechargeVC.title = @"充值";
            rechargeVC.uperViewController = self;
            rechargeVC.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
    }
    else{
        [self.apiManager getRecharngeBindingBankCardNet];//获取充值绑卡页面数据
    }
}

- (void)mineHeaderView:(UCFMineHeaderView *)mineHeaderView didClikedCashButton:(UIButton *)cashButton
{
   
    
    //监管开关 打开时 等级不足VIP1 且未投资过尊享且未投资过黄金项目的用户 直接进入充值页面
    if([UserInfoSingle sharedManager].superviseSwitch && [UserInfoSingle sharedManager].zxIsNew && [UserInfoSingle sharedManager].goldIsNew)
    {
        self.mineHeaderView.cashButton.enabled = YES;
        if([UserInfoSingle sharedManager].openStatus < 3 )//微金未开通账户
        {
            [AuxiliaryFunc showToastMessage:@"没有可提现的账户" withView:self.view];
            return;
        }
        self.accoutType = SelectAccoutTypeP2P;
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
        
        if ([self checkUserCanInvestIsDetail:NO type:self.accoutType])
        {
            [self.apiManager getP2PAccoutCashRuqestHTTP];// //获取微金提现页面数据
        }
    }
    else{
        if([UserInfoSingle sharedManager].openStatus < 3 && [UserInfoSingle sharedManager].enjoyOpenStatus < 3 && ![UserInfoSingle sharedManager].goldAuthorization)//微金未开通账户
        {
            [AuxiliaryFunc showToastMessage:@"没有可提现的账户" withView:self.view];
            self.mineHeaderView.cashButton.enabled = YES;
            return;
        }
         [self.apiManager getCashAccoutBalanceNet];// //获取提现绑卡页面数据
    }
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
    else if (alertView.tag == 9000) {
        if (buttonIndex == 1) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006766988"];
            if ([UserInfoSingle sharedManager].superviseSwitch) {
                if ([UserInfoSingle sharedManager].zxIsNew && [UserInfoSingle sharedManager].goldIsNew) {
                    str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006766988"];
                }
                else {
                    str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
                }
            }
            else {
                str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

#pragma mark - UCFMineFuncCell的代理方法

- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedCalendarButton:(UIButton *)button
{
    if ([UserInfoSingle sharedManager].superviseSwitch) {
        if (![UserInfoSingle sharedManager].zxIsNew) {
            UCFCalendarViewController *backMoneyCalendarVC = [[UCFCalendarViewController alloc] initWithNibName:@"UCFCalendarViewController" bundle:nil];
            //        backMoneyDetailVC.superViewController = self;
            //    backMoneyCalendarVC.accoutType = self.accoutType;
            [self.navigationController pushViewController:backMoneyCalendarVC animated:YES];
        }
        else {
            UCFCalendarModularViewController *backMoneyCalendarVC = [[UCFCalendarModularViewController alloc] initWithNibName:@"UCFCalendarModularViewController" bundle:nil];
            backMoneyCalendarVC.accoutType = self.accoutType;
            backMoneyCalendarVC.baseTitleText = @"回款日历";
            [self.navigationController pushViewController:backMoneyCalendarVC animated:YES];
        }
    }
    else {
        UCFCalendarViewController *backMoneyCalendarVC = [[UCFCalendarViewController alloc] initWithNibName:@"UCFCalendarViewController" bundle:nil];
        //        backMoneyDetailVC.superViewController = self;
        //    backMoneyCalendarVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:backMoneyCalendarVC animated:YES];
    }
    
    
    
}

- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedMyReservedButton:(UIButton *)button
{
    UCFMyReservedViewController *myserved = [[UCFMyReservedViewController alloc] initWithNibName:@"UCFMyReservedViewController" bundle:nil];
    myserved.url = [NSString stringWithFormat:@"https://m.9888.cn/static/wap/p2p/index.html#/reserve-bid/records"];
    myserved.navTitle = @"我的预约";
    [self.navigationController pushViewController:myserved animated:YES];
}

- (void)mineFuncView:(UCFMineFuncView *)funcView didClickItemWithTitle:(NSString *)title
{
    if ([title isEqualToString:@"工豆"]) {
        UCFMyFacBeanViewController *bean = [[UCFMyFacBeanViewController alloc] initWithNibName:@"UCFMyFacBeanViewController" bundle:nil];
        bean.title = @"我的工豆";
        [self.navigationController pushViewController:bean animated:YES];

    }
    else if ([title isEqualToString:@"我的工贝"]){
        
        if([UserInfoSingle sharedManager].companyAgent)//如果是机构用户
        {//吐司：此活动暂时未对企业用户开放
            [MBProgressHUD displayHudError:@"此活动暂时未对企业用户开放"];
        }
        else{
            if([self checkUserCanInvestIsDetail:YES type:SelectAccoutDefault])//判断是否开户
            {
                [self.apiManager getUserIntoGoCoinPageHTTP];
            }
        }
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
    else   if ([title isEqualToString:@"签到"]){
        [self.apiManager signWithToken:self.benefitModel.userCenterTicket];
    }
    else  if ([title isEqualToString:@"联系我们"]){//邀请返利
        NSString *teleNo = nil;
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            if ([UserInfoSingle sharedManager].zxIsNew && [UserInfoSingle sharedManager].goldIsNew) {
                teleNo = @"呼叫400-6766-988";
            }
            else {
                teleNo = @"呼叫400-0322-988";
            }
        }
        else {
            teleNo = @"呼叫400-0322-988";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:teleNo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
        alert.tag = 9000;
        [alert show];
    }
    else  if ([title isEqualToString:@"资产证明"]){//资产证明
        if (!self.assetProofCanClick) {
            return;
        }
        if ([UserInfoSingle sharedManager].companyAgent) {
            [AuxiliaryFunc showToastMessage:@"企业用户暂不支持开通资产证明，请在个人账户查看" withView:self.view];
            return;
        }
            UCFAccountAssetsProofViewController * assetProofVC = [[UCFAccountAssetsProofViewController alloc]initWithNibName:@"UCFAccountAssetsProofViewController" bundle:nil];
        assetProofVC.totalAssetStr = self.assetModel.total;
            [self.navigationController pushViewController:assetProofVC animated:YES];
    }
    else  if ([title isEqualToString:@"计算器"]){//投资计算器
        KTAlertController *alert = [KTAlertController alertControllerWithTitle:@"这是一个alert" description:@"又如何？" cancel:@"取消" button:@"好的" action:^{
//            NSLog(@"tap button");
        }];
        alert.animationType = KTAlertControllerAnimationTypeCenterShow;
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedUserIntoGoCoinPageResult:(id)result withTag:(NSUInteger)tag
{
     NSDictionary *dataDict = (NSDictionary *)result;
    switch (tag) {
        case 0://网络异常情况
        {
            [MBProgressHUD displayHudError:result];
        }
            break;
        case 1://返回数据成功
        {
            NSDictionary *coinRequestDicData = [dataDict objectSafeDictionaryForKey:@"coinRequest"];
            UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
            NSDictionary *paramDict = [coinRequestDicData objectSafeDictionaryForKey:@"param"];
            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
            [data setValue:[NSString urlEncodeStr:[paramDict objectSafeForKey:@"encryptParam"]] forKey:@"encryptParam"];
            [data setObject:[paramDict objectSafeForKey:@"fromApp"] forKey:@"fromApp"];
            [data setObject:[paramDict objectSafeForKey:@"userId"] forKey:@"userId"];
            NSString * requestStr = [Common getParameterByDictionary:data];
            web.url  = [NSString stringWithFormat:@"%@/#/?%@",[coinRequestDicData objectSafeForKey:@"urlPath"],requestStr];
            web.isHidenNavigationbar = YES;
            [self.navigationController pushViewController:web animated:YES];
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

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedCashAccoutBalanceResult:(id)result withTag:(NSUInteger)tag
{
    self.mineHeaderView.cashButton.enabled = YES;
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
- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedP2PAccoutCashBalanceResult:(id)result withTag:(NSUInteger)tag;
{
    self.mineHeaderView.cashButton.enabled = YES;
    switch (tag) {
        case 0://网络异常情况
        {
            [MBProgressHUD displayHudError:result];
        }
            break;
        case 1://返回数据成功
        {
            NSDictionary *dataDict = (NSDictionary *)result;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TopUpAndCash" bundle:nil];
            UCFCashViewController *crachViewController  = [storyboard instantiateViewControllerWithIdentifier:@"cash"];
            [ToolSingleTon sharedManager].apptzticket = dataDict[@"apptzticket"];
            crachViewController.title = @"提现";
            crachViewController.cashInfoDic =  [[NSMutableDictionary alloc] initWithDictionary:@{@"data":dataDict}];
            crachViewController.accoutType = self.accoutType;
            [self.navigationController pushViewController:crachViewController animated:YES];
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
