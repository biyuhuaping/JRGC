//
//  UCFAppleHomeViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2018/8/21.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFAppleHomeViewController.h"
#import "UCFHomeListNavView.h"
#import "UCFHomeListPresenter.h"
#import "UCFCycleImageViewController.h"
#import "UCFHomeListViewController.h"
#import "UCFLoginViewController.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
#import "P2PWalletHelper.h"
#import "UCFWebViewJavascriptBridgeLoanDetails.h"
@interface UCFAppleHomeViewController ()<UCFHomeListNavViewDelegate,UCFCycleImageViewControllerDelegate,UCFHomeListViewControllerDelegate>
@property (nonatomic,strong)UCFHomeListNavView *navView;
@property (nonatomic,strong)UCFCycleImageViewController * cycleImageVC;
@property (nonatomic,strong)UCFHomeListViewController *homeListVC;
@end

@implementation UCFAppleHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[P2PWalletHelper sharedManager] getUserWalletData:[P2PWalletHelper sharedManager].source];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"refreshHomeData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"getPersonalCenterNetData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultState:) name:@"setDefaultViewData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"refreshUserState" object:nil];
    
    [self configuration];
    [self addUI];
    [self fetchData];

}
- (void)configuration
{
    self.navigationController.navigationBar.hidden = YES;
    
    UCFHomeListNavView *navView = [[UCFHomeListNavView alloc] initWithFrame:CGRectZero];
    navView.delegate = self;
    [self.view addSubview:navView];
    self.navView = navView;
    
    UCFHomeListPresenter *listViewPresenter = [UCFHomeListPresenter presenter];
    self.cycleImageVC = [UCFCycleImageViewController instanceWithPresenter:listViewPresenter];
    self.cycleImageVC.delegate = self;
    
    self.homeListVC = [UCFHomeListViewController instanceWithPresenter:listViewPresenter];
    self.homeListVC.delegate = self; //HomeListViewController走的是Protocol绑定方式
    [self.view addSubview:self.homeListVC.tableView];
    
    [self addChildViewController:self.cycleImageVC];
}
- (void)addUI {
    self.homeListVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-49);
    self.homeListVC.tableView.tableFooterView.frame = CGRectMake(0, 0, ScreenWidth, 0.01);
    CGFloat cycleImageViewHeight = [UCFCycleImageViewController viewHeight];
    self.cycleImageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, cycleImageViewHeight);
    self.homeListVC.tableView.tableHeaderView = self.cycleImageVC.view;
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        self.navView.giftButton.hidden = NO;
        self.navView.giftButton.alpha = 0.7;
        self.navView.loginAndRegisterButton.hidden = YES;
    }
    else {
        self.navView.giftButton.hidden = YES;
        self.navView.loginAndRegisterButton.hidden = NO;
    }
    //        self.navView.frame = CGRectMake(0, 0, self.view.width,64);
    self.navView.frame = CGRectMake(0, 0, self.view.width,[[UIApplication sharedApplication] statusBarFrame].size.height +  44);
    [self.view bringSubviewToFront:self.navView];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.homeListVC.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
}
- (void)fetchData
{
    [self.homeListVC.presenter getDefaultShowListSection:nil];
}
#pragma mark - homelistVC的代理方法
- (void)homeListRefreshDataWithHomelist:(UCFHomeListViewController *)homelist
{
    [self.cycleImageVC getNormalBannerData];
    [self fetchData];
}
- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didScrollWithYOffSet:(CGFloat)offSet
{
    self.navView.offset = offSet;
}
// 活期详情
- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedGoldIncreaseWithModel:(UCFHomeListCellModel *)model
{

}
- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedWithModel:(UCFHomeListCellModel *)model withType:(UCFHomeListType)type
{
//    UCFWebViewJavascriptBridgeLoanDetails *loan = [[UCFWebViewJavascriptBridgeLoanDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
//    loan.isHidenNavigationbar = YES;
//    loan.url = @"https://static.gongchangp2p.com/pages/auditing/detail.html";
//    [self.navigationController pushViewController:loan animated:YES];
    
    
    
    UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
    webView.rootVc = self.parentViewController;
    webView.baseTitleType = @"lunbotuhtml";
    webView.url = @"https://static.gongchangp2p.com/pages/auditing/detail.html";;
//    webView.navTitle = modell.title;
//    webView.dicForShare = modell;
    [self.navigationController pushViewController:webView animated:YES];
//
}
#pragma mark UCFHomeListNavViewDelegate
- (void)homeListNavView:(UCFHomeListNavView *)navView didClicked:(UIButton *)loginAndRegister
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
- (void)homeListNavView:(UCFHomeListNavView *)navView didClickedGiftButton:(UIButton *)giftButton
{
    
}
#pragma mark - 刷新界面
- (void)refreshUI:(NSNotification *)noty
{
    __weak typeof(self) weakSelf = self;
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        self.navView.giftButton.hidden = YES;
        self.navView.giftButton.alpha = 0.7;
        self.navView.loginAndRegisterButton.hidden = YES;
    }
    else {
        self.navView.giftButton.hidden = YES;
        self.navView.loginAndRegisterButton.hidden = NO;
    }
    [weakSelf fetchData];
    
}

- (void)setDefaultState:(NSNotification *)noty
{
    __weak typeof(self) weakSelf = self;
    
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        self.navView.giftButton.hidden = NO;
        self.navView.giftButton.alpha = 0.7;
        self.navView.loginAndRegisterButton.hidden = YES;
    }
    else {
        self.navView.giftButton.hidden = YES;
        self.navView.loginAndRegisterButton.hidden = NO;
    }
    [weakSelf fetchData];
}

@end
