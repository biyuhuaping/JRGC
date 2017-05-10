//
//  UCFHomeViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeViewController.h"
#import "UCFCycleImageViewController.h"
#import "UCFUserInformationViewController.h"
#import "UCFHomeListViewController.h"
#import "UCFLoginViewController.h"
#import "UCFSecurityCenterViewController.h"
#import "UCFMessageCenterViewController.h"

#import "UCFUserPresenter.h"
#import "UCFHomeListPresenter.h"
#import "UserInfoSingle.h"

#import "UCFHomeListNavView.h"
#import "MaskView.h"
#import "MongoliaLayerCenter.h"

@interface UCFHomeViewController () <UCFHomeListViewControllerDelegate, UCFHomeListNavViewDelegate>
@property (strong, nonatomic) UCFCycleImageViewController *cycleImageVC;
@property (strong, nonatomic) UCFUserInformationViewController *userInfoVC;
@property (strong, nonatomic) UCFHomeListViewController *homeListVC;

@property (weak, nonatomic) UCFHomeListNavView *navView;
@end

@implementation UCFHomeViewController

#pragma mark - 系统方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [[MongoliaLayerCenter sharedManager] showLogic];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"refreshUIWithLoginAndOut" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - 设置
    [self configuration];
#pragma mark - 添加界面
    [self addUI];
#pragma mark - 请求数据
    [self fetchData];
}

#pragma mark - configuration 设置
- (void)configuration
{
    self.navigationController.navigationBar.hidden = YES;
    
    UCFHomeListNavView *navView = [[UCFHomeListNavView alloc] initWithFrame:CGRectZero];
    navView.delegate = self;
    [self.view addSubview:navView];
    self.navView = navView;
    
    UCFUserPresenter *userPresenter = [UCFUserPresenter presenter];
    
    self.cycleImageVC = [UCFCycleImageViewController instanceWithPresenter:userPresenter];
    self.userInfoVC = [UCFUserInformationViewController instanceWithPresenter:userPresenter];
    [self.userInfoVC setPersonInfoVCGenerator:^UIViewController *(id params) {
        UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
        personMessageVC.title = @"个人信息";
        return personMessageVC;
    }];
    [self.userInfoVC setMessageVCGenerator:^UIViewController *(id params) {
        UCFMessageCenterViewController *messagecenterVC = [[UCFMessageCenterViewController alloc]initWithNibName:@"UCFMessageCenterViewController" bundle:nil];
        messagecenterVC.title =@"消息中心";
        return messagecenterVC;
    }];
    
    UCFHomeListPresenter *listViewPresenter = [UCFHomeListPresenter presenter];
    self.homeListVC = [UCFHomeListViewController instanceWithPresenter:listViewPresenter];
    self.homeListVC.delegate = self; //HomeListViewController走的是Protocol绑定方式
    [self.view addSubview:self.homeListVC.tableView];

    [self addChildViewController:self.cycleImageVC];
    [self addChildViewController:self.userInfoVC];
}

#pragma mark - addUI 添加界面
- (void)addUI {
    self.homeListVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-49);
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        
        CGFloat userInfoViewHeight = [UCFUserInformationViewController viewHeight];
        self.userInfoVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, userInfoViewHeight);
        self.navView.hidden = YES;
        self.homeListVC.tableView.tableHeaderView = self.userInfoVC.view;
    }
    else {
        CGFloat cycleImageViewHeight = [UCFCycleImageViewController viewHeight];
        self.cycleImageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, cycleImageViewHeight);
        self.navView.hidden = NO;
        self.homeListVC.tableView.tableHeaderView = self.cycleImageVC.view;
    }
    self.navView.frame = CGRectMake(0, 0, self.view.width, 64);
    [self.view bringSubviewToFront:self.navView];
}

#pragma mark - homelistVC的代理方法

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didScrollWithYOffSet:(CGFloat)offSet
{
    self.navView.offset = offSet;
}

- (void)homeListRefreshDataWithHomelist:(UCFHomeListViewController *)homelist
{
    [self fetchData];
}

#pragma mark - UCFHomeListNavViewDelegate

- (void)homeListNavView:(UCFHomeListNavView *)navView didClicked:(UIButton *)loginAndRegister
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}

#pragma mark - 刷新界面
- (void)refreshUI:(NSNotification *)noty
{
    [self addUI];
}

#pragma mark - 请求数据
- (void)fetchData
{
    __weak typeof(self) weakSelf = self;
    [self.homeListVC.presenter fetchHomeListDataWithCompletionHandler:^(NSError *error, id result) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];//上层交互逻辑
        if ([result isKindOfClass:[NSDictionary class]]) {
            //请求成功
        }
        else if ([result isKindOfClass:[NSString class]]) {
            [AuxiliaryFunc showToastMessage:result withView:weakSelf.view];
        }
    }];
}
@end
