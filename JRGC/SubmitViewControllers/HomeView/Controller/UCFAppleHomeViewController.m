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
#import "UCFZiZHIViewController.h"
@interface UCFAppleHomeViewController ()<UCFHomeListNavViewDelegate,UCFCycleImageViewControllerDelegate,UCFHomeListViewControllerDelegate,UCFNoticeViewDelegate>
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
    self.edgesForExtendedLayout = UIRectEdgeNone;

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
- (void)noticeView:(UCFNoticeView *)noticeView didClickedNotice:(UCFNoticeModel *)notice
{
    UCFZiZHIViewController *vc = [[UCFZiZHIViewController alloc] initWithNibName:@"UCFZiZHIViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addUI {
    UCFNoticeView *noticeView = (UCFNoticeView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFNoticeView" owner:self options:nil] lastObject];
    noticeView.delegate = self;
    for (UIView *view in noticeView.subviews) {
        view.hidden = NO;
    }
    noticeView.noticeLabell.text = @"查看公司资质";
    self.homeListVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight - 49);
    self.homeListVC.tableView.tableFooterView.frame = CGRectMake(0, 0, ScreenWidth, 0.01);
    CGFloat cycleImageViewHeight = [UCFCycleImageViewController viewHeight];
    self.cycleImageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, cycleImageViewHeight + 45);
    noticeView.frame =CGRectMake(0, cycleImageViewHeight, SCREEN_WIDTH, 45);
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, cycleImageViewHeight + 45)];
    headView.backgroundColor = [UIColor clearColor];

    [headView addSubview:self.cycleImageVC.view];
    [headView addSubview:noticeView];

    self.homeListVC.tableView.tableHeaderView = headView;

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
    self.navView.frame = CGRectMake(0, 0, self.view.width,[[UIApplication sharedApplication] statusBarFrame].size.height +  44);
    [self.view bringSubviewToFront:self.navView];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.homeListVC.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
    
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
//    footView.backgroundColor = [UIColor lightTextColor];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, ScreenWidth, 100);
//    [button setTitleColor:UIColorWithRGB(0x5A86F4) forState:UIControlStateNormal];
//    [button setTitle:@"查看公司资质" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(checkDetai:) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:button];
//    self.homeListVC.tableView.tableFooterView = footView;
    
}
- (void)checkDetai:(UIButton *)button
{
    UCFZiZHIViewController *vc = [[UCFZiZHIViewController alloc] initWithNibName:@"UCFZiZHIViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
    UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
    webView.rootVc = self.parentViewController;
    webView.baseTitleType = @"lunbotuhtml";
    webView.url = @"https://static.9888.cn/pages/auditing/detail.html";
    [self.navigationController pushViewController:webView animated:YES];
    
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
