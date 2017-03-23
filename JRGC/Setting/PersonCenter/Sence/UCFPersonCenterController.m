//
//  UCFPersonCenterController.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPersonCenterController.h"

#import "UCFPCListModel.h"

#import "UCFUserInfoController.h"
#import "UCFPCListViewController.h"

#import "UCFFacCodeViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "UCFFeedBackViewController.h"
#import "UCFRedEnvelopeViewController.h"
#import "UCFMoreViewController.h"
#import "UCFSecurityCenterViewController.h"
#import "UCFP2POrHonerAccoutViewController.h"

@interface UCFPersonCenterController () <UCFPCListViewControllerCallBack>

@property (nonatomic, strong) UCFUserInfoController *userInfoVC;
@property (strong, nonatomic) UCFPCListViewController *pcListVC;
@end

@implementation UCFPersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Utils

- (void)configuration {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
  
    
    self.pcListVC = [UCFPCListViewController instanceWithPresenter:[UCFPCListViewPresenter presenter]];
    self.pcListVC.delegate = self;//BlogViewController走的是Protocol绑定方式

    self.userInfoVC = [UCFUserInfoController instanceWithPresenter:[UCFPCListViewPresenter presenter]];
    [self.userInfoVC setUserInfoVCGenerator:^UIViewController *(id params) {
        UCFSecurityCenterViewController *personMessageVC = [[UCFSecurityCenterViewController alloc] initWithNibName:@"UCFSecurityCenterViewController" bundle:nil];
        personMessageVC.title = @"个人信息";
        return personMessageVC;
    }];
    [self addChildViewController:self.userInfoVC];//userInfo还是用的MVC 毕竟上面把block和protocol都交代过了
}

- (void)addUI {
    
    CGFloat userInfoViewHeight = [UCFUserInfoController viewHeight];
    self.userInfoVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, userInfoViewHeight);
    
    self.pcListVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-49);
    [self.view addSubview:self.pcListVC.tableView];
    
    self.pcListVC.tableView.tableHeaderView = self.userInfoVC.view;
}

- (void)fetchData {
    
//    [self.userInfoVC fetchData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];;//上层交互逻辑
    [self.pcListVC.presenter fetchDataWithCompletionHandler:^(NSError *error, id result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;//上层交互逻辑
    }];
}

#pragma mark - UCFPCListViewControllerCallBack

- (void)pcListViewControllerdidSelectItem:(UCFPCListModel *)pcListModel
{
    NSString *title = pcListModel.title;
    if ([title isEqualToString:@"P2P账户"]) {
        UCFP2POrHonerAccoutViewController *subVC = [[UCFP2POrHonerAccoutViewController alloc] initWithNibName:@"UCFP2POrHonerAccoutViewController" bundle:nil];
        subVC.accoutType =  SelectAccoutTypeP2P;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([title isEqualToString:@"尊享账户"]) {
        UCFP2POrHonerAccoutViewController *subVC = [[UCFP2POrHonerAccoutViewController alloc] initWithNibName:@"UCFP2POrHonerAccoutViewController" bundle:nil];
        subVC.accoutType =  SelectAccoutTypeHoner;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([title isEqualToString:@"会员等级"]) {
        UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        subVC.url = LEVELURL;
        subVC.navTitle = @"会员等级";
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([title isEqualToString:@"邀请返利"]) {
        UCFFeedBackViewController *subVC = [[UCFFeedBackViewController alloc] initWithNibName:@"UCFFeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([title isEqualToString:@"工场码"]) {
        //我的工场码
//        fixedScreenLight = [UIScreen mainScreen].brightness;
        UCFFacCodeViewController *subVC = [[UCFFacCodeViewController alloc] initWithNibName:@"UCFFacCodeViewController" bundle:nil];
//        subVC.urlStr = [NSString stringWithFormat:@"https://m.9888.cn/mpwap/mycode.jsp?pcode=%@&sex=%@",_gcm,_sex];
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([title isEqualToString:@"红包"]) {
        UCFRedEnvelopeViewController *subVC = [[UCFRedEnvelopeViewController alloc] initWithNibName:@"UCFRedEnvelopeViewController" bundle:nil];
        subVC.title = @"我的红包";
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([title isEqualToString:@"更多"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UCFMoreViewController" bundle:nil];
        UCFMoreViewController *moreVC = [storyboard instantiateViewControllerWithIdentifier:@"more_main"];
        moreVC.title = @"更多";
        moreVC.sourceVC = @"UCFSettingViewController";
        [self.navigationController pushViewController:moreVC animated:YES];
    }
}

@end
