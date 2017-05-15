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
#import "UCFMyFacBeanViewController.h"
#import "UCFCouponViewController.h"
#import "UCFWorkPointsViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "UCFNoPermissionViewController.h"
#import "UCFProjectDetailViewController.h"
#import "UCFHonerViewController.h"
#import "UCFP2PViewController.h"
#import "UCFP2POrHonerAccoutViewController.h"
#import "HSHelper.h"
#import "RiskAssessmentViewController.h"
#import "UCFUserPresenter.h"
#import "UCFHomeListPresenter.h"
#import "UCFHomeListCellPresenter.h"
#import "UserInfoSingle.h"

#import "UCFHomeListNavView.h"
#import "MaskView.h"
#import "MongoliaLayerCenter.h"

#import "UCFUserInfoListItem.h"


@interface UCFHomeViewController () <UCFHomeListViewControllerDelegate, UCFHomeListNavViewDelegate, UCFUserInformationViewControllerDelegate>
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
    self.userInfoVC.delegate = self;
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
    
    [self.userInfoVC setBeansVCGenerator:^UIViewController *(id params) {
        UCFMyFacBeanViewController *bean = [[UCFMyFacBeanViewController alloc] initWithNibName:@"UCFMyFacBeanViewController" bundle:nil];
        bean.title = @"我的工豆";
        return bean;
    }];
    
    [self.userInfoVC setCouponVCGenerator:^UIViewController *(id params) {
        UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        return coupon;
    }];
    
    [self.userInfoVC setWorkPointInfoVCGenerator:^UIViewController *(id params) {
        UCFWorkPointsViewController *workPoint = [[UCFWorkPointsViewController alloc]initWithNibName:@"UCFWorkPointsViewController" bundle:nil];
        workPoint.title = @"我的工分";
        return workPoint;
    }];
    
    [self.userInfoVC setMyLevelVCGenerator:^UIViewController *(id params) {
        UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        subVC.url = LEVELURL;
        subVC.navTitle = @"会员等级";
        return subVC;
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

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedWithModel:(UCFHomeListCellModel *)model withType:(UCFHomeListType)type
{
     __weak typeof(self) weakSelf = self;
    self.accoutType = [model.type intValue] == 2 ?SelectAccoutTypeHoner:SelectAccoutTypeP2P;
    
    if (type == UCFHomeListTypeDetail) {
        if (model.moedelType == UCFHomeListCellModelTypeDefault) {
        
            if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                //如果未登录，展示登录页面
                [self showLoginView];
            } else {
//                if([self.userInfoVC.presenter checkIDAAndBankBlindState:self.accoutType]){//           在这里需要 判断授权 以及开户,需要重新梳理
                        NSInteger isOrder = [model.isOrder integerValue];
                        if ([model.status intValue ] != 2){
                        if (isOrder > 0) {
                            NSDictionary *parameter = @{@"Id": model.Id, @"userId": [UserInfoSingle sharedManager].userId, @"proType": model.type,@"type":@"3"};
                            [self.userInfoVC.presenter fetchProDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
                                NSDictionary *dic = (NSDictionary *)result;
                                
                                
                                NSString *rstcode = dic[@"status"];
                                NSString *rsttext = dic[@"statusdes"];
                                if ([rstcode intValue] == 1) {
                                    NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)model.prdLabelsList];
                                    UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
                                    CGFloat platformSubsidyExpense = [model.platformSubsidyExpense floatValue];
                                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
                                    [weakSelf.navigationController pushViewController:controller animated:YES];
                                }else {
                                    [AuxiliaryFunc showAlertViewWithMessage:rsttext];
                                }
                                
                            }];
                        } else {
                            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对投资人开放"];
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                    }else{
                        {
                            NSDictionary *parameter = @{@"Id": model.Id, @"userId": [UserInfoSingle sharedManager].userId, @"proType": model.type,@"type":@"3"};
                            [self.userInfoVC.presenter fetchProDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
                                NSDictionary *dic = (NSDictionary *)result;
                                
                                
                                NSString *rstcode = dic[@"status"];
                                NSString *rsttext = dic[@"statusdes"];
                                if ([rstcode intValue] == 1) {
                                    NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)model.prdLabelsList];
                                    UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
                                    CGFloat platformSubsidyExpense = [model.platformSubsidyExpense floatValue];
                                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
                                    [weakSelf.navigationController pushViewController:controller animated:YES];
                                }else {
                                    [AuxiliaryFunc showAlertViewWithMessage:rsttext];
                                }
                            }];
                         }
                     }
                }
          }
        else if (model.moedelType == UCFHomeListCellModelTypeOneImageBatchLending) {
            // 批量出借
            UCFP2PViewController *p2PVC = [[UCFP2PViewController alloc] initWithNibName:@"UCFP2PViewController" bundle:nil];
            p2PVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            p2PVC.viewType = @"2";
            [p2PVC setCurrentViewForBatchBid];
            [self.navigationController pushViewController:p2PVC animated:YES];
            
            
            
        }
        else if (model.moedelType == UCFHomeListCellModelTypeOneImageBondTransfer) {
            // 债券转让
            UCFP2PViewController *p2PVC = [[UCFP2PViewController alloc] initWithNibName:@"UCFP2PViewController" bundle:nil];
            p2PVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            p2PVC.viewType = @"3";
            [p2PVC setCurrentViewForBatchBid];
            [self.navigationController pushViewController:p2PVC animated:YES];

        }
        else if (model.moedelType == UCFHomeListCellModelTypeOneImageHonorTransfer) {
            // 尊享转让
            UCFHonerViewController *horner = [[UCFHonerViewController alloc] initWithNibName:@"UCFHonerViewController" bundle:nil];
            horner.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
            horner.baseTitleText = @"工场尊享";
            horner.viewType = @"2";
            horner.accoutType = SelectAccoutTypeHoner;
            [horner setCurrentViewForHornerTransferVC];
            [self.navigationController pushViewController:horner animated:YES];
        }
        else if (model.moedelType == UCFHomeListCellModelTypeOneImageBatchCycle) {
            
        }
    }
    else if (type == UCFHomeListTypeInvest) {
        if (model.moedelType == UCFHomeListCellModelTypeDefault) {
            
            if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                //如果未登录，展示登录页面
                [self showLoginView];
            } else {
//                [self.userInfoVC.presenter checkIDAAndBankBlindState:self.accoutType]){//           在这里需要 判断授权 以及开户
                NSDictionary *parameter = @{@"Id": model.Id, @"userId": [UserInfoSingle sharedManager].userId, @"proType": model.type,@"type":@"4"};
                [self.userInfoVC.presenter fetchProDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
                    NSString *rstcode = [result objectForKey:@"status"];
                    if ([rstcode intValue] == 1) {
                        UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
                        purchaseViewController.dataDict = result;
                        purchaseViewController.bidType = 0;
                        purchaseViewController.baseTitleType = @"detail_heTong";
                        purchaseViewController.accoutType = self.accoutType;
                    [weakSelf.navigationController pushViewController:purchaseViewController animated:YES];
                   }
                }];
            }
        }
//        else if (model.moedelType == UCFHomeListCellModelTypeOneImage) {
//            
//        }
    }
    else if (type == UCFHomeListTypeP2PMore)
    {
        UCFP2PViewController *p2PVC = [[UCFP2PViewController alloc] initWithNibName:@"UCFP2PViewController" bundle:nil];
        p2PVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
        p2PVC.viewType = @"1";
        [p2PVC setCurrentViewForBatchBid];
        [self.navigationController pushViewController:p2PVC animated:YES];
    }
    else if (type == UCFHomeListTypeZXMore)
    {
        UCFHonerViewController *horner = [[UCFHonerViewController alloc] initWithNibName:@"UCFHonerViewController" bundle:nil];
        horner.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
        horner.baseTitleText = @"工场尊享";
        horner.viewType = @"1";
        horner.accoutType = SelectAccoutTypeHoner;
         [horner setCurrentViewForHornerTransferVC];
        [self.navigationController pushViewController:horner animated:YES];
    }
}
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
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
    [self.userInfoVC.presenter fetchUserInfoOneDataWithCompletionHandler:^(NSError *error, id result) {
    }];
    
    [self.userInfoVC.presenter fetchUserInfoTwoDataWithCompletionHandler:^(NSError *error, id result) {
    }];
    
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

#pragma mark - userInfoVC 的代理方法
- (void)userInfotableView:(UITableView *)tableView didSelectedItem:(UCFUserInfoListItem *)item
{
    if (!item.isShow) {
        return;
    }
    UCFP2POrHonerAccoutViewController *subVC = [[UCFP2POrHonerAccoutViewController alloc] initWithNibName:@"UCFP2POrHonerAccoutViewController" bundle:nil];
    if ([item.title isEqualToString:@"P2P账户"]) {
        subVC.accoutType =  SelectAccoutTypeP2P;
    }
    else if ([item.title isEqualToString:@"尊享账户"]) {
        subVC.accoutType = SelectAccoutTypeHoner;
    }
    [self.navigationController pushViewController:subVC animated:YES];
}

- (void)proInvestAlert:(UIAlertView *)alertView didClickedWithTag:(NSInteger)tag withIndex:(NSInteger)index
{
    if (alertView.tag == 7000) {
        [self fetchData];
    } else if (alertView.tag == 8000) {
        if (index == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
    }else if (alertView.tag == 8010) {
        if (index == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        }
    }
    else if (alertView.tag == 9000) {
        if(index == 1){ //测试
            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            vc.accoutType = self.accoutType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(alertView.tag == 9001){
        if (index == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
        }
    }
}

@end
