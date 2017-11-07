//
//  UCFHomeViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeViewController.h"
#import "UCFCycleImageViewController.h"
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
#import "UCFInvestViewController.h"
#import "HSHelper.h"
#import "RiskAssessmentViewController.h"
#import "UCFUserPresenter.h"
#import "UCFHomeListPresenter.h"
#import "UCFHomeListCellPresenter.h"
#import "UserInfoSingle.h"
#import "UCFFacCodeViewController.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UCFHomeListNavView.h"
#import "MaskView.h"
#import "MongoliaLayerCenter.h"
#import "UCFGoldAccountViewController.h"
#import "UCFUserInfoListItem.h"
#import "Touch3DSingle.h"
#import "BJGridItem.h"
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "FullWebViewController.h"
#import "UCFBatchBidController.h"
#import "UCFPurchaseBidViewController.h"
#import "UCFGoldDetailViewController.h"
#import "UCFGoldPurchaseViewController.h"
#import  "UCFGoldCalculatorView.h"
#import "UCFCollectionDetailViewController.h"
#import "UCFFacReservedViewController.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFGoldCashViewController.h"
#import "UCFHomeIconPresenter.h"
#import "UCFNoticeModel.h"
@interface UCFHomeViewController () <UCFHomeListViewControllerDelegate, UCFHomeListNavViewDelegate, UCFCycleImageViewControllerDelegate,BJGridItemDelegate, UIAlertViewDelegate,MjAlertViewDelegate>
@property (strong, nonatomic) UCFCycleImageViewController *cycleImageVC;
@property (strong, nonatomic) UCFHomeListViewController *homeListVC;

@property (strong, nonatomic) NSMutableDictionary *stateDict;
@property (weak, nonatomic) UCFHomeListNavView *navView;
@property (strong, nonatomic)BJGridItem *dragBtn;
@property (strong,nonatomic) NSString *intoVCStr;
@end

@implementation UCFHomeViewController

- (NSMutableDictionary *)stateDict
{
    if (!_stateDict) {
        _stateDict = [[NSMutableDictionary alloc] init];
    }
    return _stateDict;
}

#pragma mark - 系统方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.intoVCStr isEqualToString:@"ProjectDetailVC"]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), queue, ^{
        DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
        [[MongoliaLayerCenter sharedManager] showLogic];
        [MongoliaLayerCenter sharedManager].tableView = self.homeListVC.tableView;
    });
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"getPersonalCenterNetData" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responds3DTouchClick) name:@"responds3DTouchClick" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultState:) name:@"setDefaultViewData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"refreshUserState" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgSkipToNativeAPP:) name:@"msgSkipToNativeAPP" object:nil];

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
    [self addDragBtn];
}


#pragma mark Dragbtn
- (void)addDragBtn
{
    _dragBtn = [[BJGridItem alloc] initWithTitle:nil withImageName:@"home_icon_rebate" atIndex:0 editable:NO];
    
    [_dragBtn setFrame:CGRectMake(ScreenWidth - 62 - 6, ScreenHeight - 49 - 65 - 6, 62, 65)];
    _dragBtn.delegate = self;
    [self.view addSubview: _dragBtn];
}
- (void)gridItemDidMoved:(BJGridItem *)gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer *)recognizer{
    CGRect frame = _dragBtn.frame;
    CGPoint curPoint = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            DLog(@"press long began");
            break;
        case UIGestureRecognizerStateEnded:
            DLog(@"press long ended");
            break;
        case UIGestureRecognizerStateFailed:
            DLog(@"press long failed");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            frame.origin.x = curPoint.x - point.x;
            frame.origin.y = curPoint.y - point.y;
            _dragBtn.frame = frame;
            break;
        default:
            DLog(@"press long else");
            break;
    }
}
- (void) gridItemDidEndMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer{
    CGPoint _point = [recognizer locationInView:self.view];
    if (_point.x < ScreenWidth / 2) {
        _point.x = 6;
    } else {
        _point.x = ScreenWidth - gridItem.frame.size.width - 6;
    }
    
    if (_point.y < 0) {
        _point.y = 0;
    }
    
    CGFloat yPoint = _point.y - point.y;
    if (yPoint < 0) {
        yPoint = 0;
    } else if (yPoint > ScreenHeight - 49 - 65 - 6) {
        yPoint = ScreenHeight - 49 - 65 - 6;
    }
    [UIView animateWithDuration:0.2 animations:^{
        gridItem.frame = CGRectMake(_point.x, yPoint, gridItem.frame.size.width, gridItem.frame.size.height);
    }];
}

- (void) gridItemDidEnterEditingMode:(BJGridItem *) gridItem
{
    
}

- (void) gridItemDidDeleted:(BJGridItem *) gridItem atIndex:(NSInteger)index
{
    
}

- (void) gridItemDidClicked:(BJGridItem *) gridItem
{
    
//    FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:HOMEINVITATIONURL title:@"邀请返利"];
//    webView.flageHaveShareBut = @"分享";
//    webView.sourceVc = @"UCFLatestProjectViewController";
//    [self.navigationController pushViewController:webView animated:YES];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
        web.url = COUPON_CENTER;
        web.isHidenNavigationbar = YES;
        [self.navigationController pushViewController:web animated:YES];
    } else {
        [self showLoginView];
    }

}

- (void)msgSkipToNativeAPP:(NSNotification *)noti
{
    NSDictionary *dic = (NSDictionary *)noti.object;
    if ([dic[@"type"] isEqualToString:@"coupon"]) {
        UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *nav = app.tabBarController.selectedViewController;
        [nav pushViewController:coupon animated:YES];
    } else if ([dic[@"type"] isEqualToString:@"webUrl"]){
        UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
        NSString *decodeURL = [dic[@"value"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        web.url = decodeURL;
        web.isHidenNavigationbar = YES;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *nav = app.tabBarController.selectedViewController;
        [nav pushViewController:web animated:YES];
    } else if ([dic[@"type"] isEqualToString:@"bidID"]){
        if ([UserInfoSingle sharedManager].openStatus > 3) {
            UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
//            facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", PRERESERVE_URL, dic[@"value"]];
            facReservedWeb.navTitle = @"工场预约";
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UINavigationController *nav = app.tabBarController.selectedViewController;
            [nav pushViewController:facReservedWeb animated:YES];
        }
    }
}

#pragma mark - configuration 设置
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

#pragma mark - addUI 添加界面
- (void)addUI {
    self.homeListVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-49);
    self.homeListVC.tableView.tableFooterView.frame = CGRectMake(0, 0, ScreenWidth, 140);
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
    self.navView.frame = CGRectMake(0, 0, self.view.width, 64);
    [self.view bringSubviewToFront:self.navView];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.homeListVC.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
}

#pragma mark - homelistVC的代理方法

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didScrollWithYOffSet:(CGFloat)offSet
{
    self.navView.offset = offSet;
}
// 活期详情
- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedGoldIncreaseWithModel:(UCFHomeListCellModel *)model
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        [self gotoGoldDetailVC:model];
    }
}

- (void)homeListRefreshDataWithHomelist:(UCFHomeListViewController *)homelist
{
    [self fetchData];
}
- (void)skipToOtherPage:(UCFHomeListType)type
{
    [self homeList:nil tableView:nil didClickedWithModel:nil withType:type];
}
#pragma mark - 黄金活期 购买点击事件
- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedBuyGoldWithModel:(UCFHomeListCellModel *)model
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
            [self gotoGoldInvestVC:model];
    }
}

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedWithModel:(UCFHomeListCellModel *)model withType:(UCFHomeListType)type
{
     __weak typeof(self) weakSelf = self;
    switch ([model.type intValue]) {
        case 0:
        case 1:
            self.accoutType = SelectAccoutTypeP2P;
            break;
        case 2:
            self.accoutType = SelectAccoutTypeHoner;
            break;
        case 3://黄金定期
            self.accoutType = SelectAccoutTypeGold;
            break;
        case 6://黄金活期
            self.accoutType = SelectAccoutTypeGold;
            break;
        case 14:
            self.accoutType = SelectAccoutTypeP2P;
            break;
    }
    NSString *noPermissionTitleStr = self.accoutType == SelectAccoutTypeP2P ? @"目前标的详情只对出借人开放":@"目前标的详情只对认购人开放";
    if (type == UCFHomeListTypeDetail) {
        if (model.moedelType == UCFHomeListCellModelTypeDefault) {
        
            if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                //如果未登录，展示登录页面
                [self showLoginView];
            } else {
                
                if (self.accoutType == SelectAccoutTypeGold) {
                    
                    [self gotoGoldDetailVC:model];
                    
                }else{
                    
                    HSHelper *helper = [HSHelper new];
                    
                    NSString *messageStr =  [helper checkCompanyIsOpen:self.accoutType];
                    if (![messageStr isEqualToString:@""]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                    
                    if (![helper checkP2POrWJIsAuthorization:self.accoutType]) {
                        [helper pushP2POrWJAuthorizationType:self.accoutType nav:self.navigationController];
                        return;
                    }
                    NSInteger isOrder = [model.isOrder integerValue];
                    if ([model.status intValue ] != 2){
                        if (isOrder <= 0) {
                            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:noPermissionTitleStr];
                            [self.navigationController pushViewController:controller animated:YES];
                            
                            return;
                        }
                    }
                if([model.type intValue] == 14){ //集合标详情
                    [self gotoCollectionDetailViewContoller:model];
                }else{
                    NSInteger isOrder = [model.isOrder integerValue];
                    if ([model.status intValue ] != 2){
                        if (isOrder <= 0) {
                            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:noPermissionTitleStr];
                            [self.navigationController pushViewController:controller animated:YES];
                            
                            return;
                        }
                    }
                    if([self.cycleImageVC.presenter checkIDAAndBankBlindState:self.accoutType]){//           在这里需要 判断授权 以及开户,需要重新梳理
                        NSInteger isOrder = [model.isOrder integerValue];
                        if ([model.status intValue ] != 2){
                            if (isOrder > 0) {
                                NSDictionary *parameter = @{@"Id": model.Id, @"userId": [UserInfoSingle sharedManager].userId, @"proType": model.type,@"type":@"3"};
                                [self.cycleImageVC.presenter fetchProDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
                                    
                                    NSDictionary *dic = (NSDictionary *)result;
                                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                    
                                    NSString *rstcode = dic[@"status"];
                                    NSString *rsttext = dic[@"statusdes"];
                                    if ([rstcode intValue] == 1) {
                                        NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)model.prdLabelsList];
                                        UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
                                        CGFloat platformSubsidyExpense = [model.platformSubsidyExpense floatValue];
                                        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
                                        self.intoVCStr = @"ProjectDetailVC";
                                        controller.accoutType = self.accoutType;
                                        controller.rootVc = self;
                                        
                                        
                                        [weakSelf.navigationController pushViewController:controller animated:YES];
                                    }else {
                                        [AuxiliaryFunc showAlertViewWithMessage:rsttext];
                                    }
                                    
                                }];
                            }
                        }
                        else{
                            {
                                NSDictionary *parameter = @{@"Id": model.Id, @"userId": [UserInfoSingle sharedManager].userId, @"proType": model.type,@"type":@"3"};
                                [self.cycleImageVC.presenter fetchProDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
                                    NSDictionary *dic = (NSDictionary *)result;
                                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                    
                                    NSString *rstcode = dic[@"status"];
                                    NSString *rsttext = dic[@"statusdes"];
                                    if ([rstcode intValue] == 1) {
                                        NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)model.prdLabelsList];
                                        UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
                                        CGFloat platformSubsidyExpense = [model.platformSubsidyExpense floatValue];
                                        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
                                        self.intoVCStr = @"ProjectDetailVC";
                                        controller.accoutType = self.accoutType;
                                        controller.rootVc = self;
                                        [weakSelf.navigationController pushViewController:controller animated:YES];
                                    }else {
                                        [AuxiliaryFunc showAlertViewWithMessage:rsttext];
                                    }
                                }];
                            }
                        }
                    }
                }
                    
                    
               }
            }
          }
        else if (model.moedelType == UCFHomeListCellModelTypeReserved  || model.moedelType == UCFHomeListCellModelTypeNewUser) {
            self.accoutType = SelectAccoutTypeP2P;
            BOOL b = [self checkUserCanInvestIsDetail:YES type:self.accoutType];
            if (!b) {
                return;
            }
            if (![UserInfoSingle sharedManager].isRisk) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                self.accoutType = SelectAccoutTypeP2P;
                alert.tag =  9000;
                [alert show];
                return;
            }
            if (![UserInfoSingle sharedManager].isAutoBid) {
                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                batchInvestment.isStep = 1;
                batchInvestment.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:batchInvestment animated:YES];
                return;
            }
            
            UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
            if (model.moedelType == UCFHomeListCellModelTypeNewUser) {
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", NEWUSER_PRODUCTS_URL, model.Id];
            }
            else if (model.moedelType == UCFHomeListCellModelTypeReserved) {
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", PRERESERVE_PRODUCTS_URL, model.Id];
            }
            [self.navigationController pushViewController:facReservedWeb animated:YES];
        }
    }
    else if (type == UCFHomeListTypeInvest) {
        if (model.moedelType == UCFHomeListCellModelTypeDefault) {
            if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                //如果未登录，展示登录页面
                [self showLoginView];
            } else {
                
                if (self.accoutType == SelectAccoutTypeGold) {
                    [self gotoGoldInvestVC:model];
                }else{
                    HSHelper *helper = [HSHelper new];
                    NSString *messageStr =  [helper checkCompanyIsOpen:self.accoutType];
                    if (![messageStr isEqualToString:@""]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                    if (![helper checkP2POrWJIsAuthorization:self.accoutType]) {
                        [helper pushP2POrWJAuthorizationType:self.accoutType nav:self.navigationController];
                        return;
                    }
                if ([model.type intValue] == 14) { //集合标
                    [self gotoCollectionDetailViewContoller:model];
                }else{
                    
                    NSInteger isOrder = [model.isOrder integerValue];
                    if ([model.status intValue ] != 2){
                        if (isOrder <= 0) {
                            return;
                        }
                    }
                    if([self checkUserCanInvestIsDetail:NO type:self.accoutType]){//

                        NSDictionary *parameter = @{@"Id": model.Id, @"userId": [UserInfoSingle sharedManager].userId, @"proType": model.type,@"type":@"4"};
                        [self.cycleImageVC.presenter fetchProDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
                            NSString *rstcode = [result objectForKey:@"status"];
                            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                            if ([rstcode intValue] == 1) {
                                UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
                                purchaseViewController.dataDict = result;
                                purchaseViewController.bidType = 0;
                                purchaseViewController.baseTitleType = @"detail_heTong";
                                purchaseViewController.accoutType = self.accoutType;
                                purchaseViewController.accoutType = self.accoutType;
                                purchaseViewController.rootVc = self;
                                [weakSelf.navigationController pushViewController:purchaseViewController animated:YES];
                            }
                        }];
                        
                    }
                  }
                }
            }
            
        }
        else if (model.moedelType == UCFHomeListCellModelTypeReserved  || model.moedelType == UCFHomeListCellModelTypeNewUser) {
            self.accoutType = SelectAccoutTypeP2P;
            BOOL b = [self checkUserCanInvestIsDetail:NO type:self.accoutType];
            if (!b) {
                return;
            }
            if (![UserInfoSingle sharedManager].isRisk) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                self.accoutType = SelectAccoutTypeP2P;
                alert.tag =  9000;
                [alert show];
                return;
            }
            if (![UserInfoSingle sharedManager].isAutoBid) {
                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                batchInvestment.isStep = 1;
                batchInvestment.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:batchInvestment animated:YES];
                return;
            }
            
            UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
            if (model.moedelType == UCFHomeListCellModelTypeNewUser) {
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", NEWUSER_APPLY_URL, model.Id];
            }
            else if (model.moedelType == UCFHomeListCellModelTypeReserved) {
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", PRERESERVE_APPLY_URL, model.Id];
            }
            [self.navigationController pushViewController:facReservedWeb animated:YES];
        }
    }
    else if (type == UCFHomeListTypeP2PMore)
    {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UCFInvestViewController *invest = (UCFInvestViewController *)[[appdel.tabBarController.childViewControllers objectAtIndex:1].childViewControllers firstObject];
        invest.selectedType = @"P2P";
        if ([invest isViewLoaded]) {
            [invest changeView];
        }
        [appdel.tabBarController setSelectedIndex:1];
    }
    else if (type == UCFHomeListTypeZXMore)
    {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UCFInvestViewController *invest = (UCFInvestViewController *)[[appdel.tabBarController.childViewControllers objectAtIndex:1].childViewControllers firstObject];
        invest.selectedType = @"ZX";
        if ([invest isViewLoaded]) {
            [invest changeView];
        }
        [appdel.tabBarController setSelectedIndex:1];
    }
    else if (type == UCFHomeListTypeGlodMore) {
    
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UCFInvestViewController *invest = (UCFInvestViewController *)[[appdel.tabBarController.childViewControllers objectAtIndex:1].childViewControllers firstObject];
        invest.selectedType = @"Gold";
        if ([invest isViewLoaded]) {
            [invest changeView];
        }
        [appdel.tabBarController setSelectedIndex:1];
    }
}

- (void)homeList:(UCFHomeListViewController *)homeList didClickReservedWithModel:(UCFHomeListCellModel *)model
{
    self.accoutType = SelectAccoutTypeP2P;
    BOOL b = [self checkUserCanInvestIsDetail:NO type:self.accoutType];
    if (!b) {
        return;
    }
    if (![UserInfoSingle sharedManager].isRisk) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        self.accoutType = SelectAccoutTypeP2P;
        alert.tag =  9000;
        [alert show];
        return;
    }
    if (![UserInfoSingle sharedManager].isAutoBid) {
        UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
        batchInvestment.isStep = 1;
        batchInvestment.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:batchInvestment animated:YES];
        return;
    }
    UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
//    NSString *url = [PRERESERVE_URL stringByReplacingOccurrencesOfString:@"/info" withString:@"/apply"];
    facReservedWeb.url = [NSString stringWithFormat:@"%@", PRERESERVE_APPLY_URL];
    [self.navigationController pushViewController:facReservedWeb animated:YES];
}

//- (void)homeList:(UCFHomeListViewController *)homeList didClickNewUserWithModel:(UCFHomeListCellModel *)model
//{
//    
//}

-(void)gotoGoldInvestVC:(UCFHomeListCellModel *)model{
    
    NSString *tipStr1 = ZXTIP1;
    NSInteger openStatus = [UserInfoSingle sharedManager].openStatus ;
    NSInteger enjoyOpenStatus = [UserInfoSingle sharedManager].enjoyOpenStatus;
    if ( enjoyOpenStatus < 3  && openStatus < 3) {
        [self showHSAlert:tipStr1];
        return;
    }
    
     __weak typeof(self) weakSelf = self;
    
    if ([model.type intValue] == 6) {
        NSString *nmProClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",@"8",@"type",nil];
        
        [self.cycleImageVC.presenter fetchProDetailDataWithParameter:strParameters completionHandler:^(NSError *error, id result) {
            NSDictionary *dic = (NSDictionary *)result;
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSString *rsttext = [dic objectSafeForKey:@"message"];
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            if ( [dic[@"ret"] boolValue]) {
                UCFGoldPurchaseViewController *goldPurchaseVC = [[UCFGoldPurchaseViewController alloc]initWithNibName:@"UCFGoldPurchaseViewController" bundle:nil];
                goldPurchaseVC.dataDic = dataDict;
                goldPurchaseVC.isGoldCurrentAccout = YES;
                [self.navigationController pushViewController:goldPurchaseVC  animated:YES];
            }
            else
            {
                [AuxiliaryFunc showAlertViewWithMessage:rsttext];
            }
        }];
    }
    else{
        
        if ([model.status intValue] == 2 || [model.status intValue] == 21) {
            return;
        }
        NSString *nmProClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",@"6",@"type",nil];
        
        [self.cycleImageVC.presenter fetchProDetailDataWithParameter:strParameters completionHandler:^(NSError *error, id result) {
            NSDictionary *dic = (NSDictionary *)result;
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSString *rsttext = [dic objectSafeForKey:@"message"];
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            if ( [dic[@"ret"] boolValue]) {
                UCFGoldPurchaseViewController *goldPurchaseVC = [[UCFGoldPurchaseViewController alloc]initWithNibName:@"UCFGoldPurchaseViewController" bundle:nil];
                goldPurchaseVC.dataDic = dataDict;
                goldPurchaseVC.isGoldCurrentAccout = NO;
                [self.navigationController pushViewController:goldPurchaseVC  animated:YES];
            }
            else
            {
                [AuxiliaryFunc showAlertViewWithMessage:rsttext];
            }
        }];
    }
}
-(void)gotoGoldDetailVC:(UCFHomeListCellModel *)model{
    
    NSString *tipStr1 = ZXTIP1;
    NSInteger openStatus = [UserInfoSingle sharedManager].openStatus ;
    NSInteger enjoyOpenStatus = [UserInfoSingle sharedManager].enjoyOpenStatus;
    if ( enjoyOpenStatus < 3  && openStatus < 3) {
        [self showHSAlert:tipStr1];
        return;
    }
//    if ([model.status intValue] == 2) {
//        UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
//        [self.navigationController pushViewController:controller animated:YES];
//        return;
//    }
    __weak typeof(self) weakSelf = self;
    NSString *typeStr = model.type;
    
    if ([typeStr intValue] == 6) {//黄金活期标
        NSString *nmProClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",@"7",@"type",nil];
        
        [self.cycleImageVC.presenter fetchProDetailDataWithParameter:strParameters completionHandler:^(NSError *error, id result) {
            NSDictionary *dic = (NSDictionary *)result;
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            NSString *rsttext = dic[@"message"];
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            if ( [dic[@"ret"] boolValue])
            {
                UCFGoldDetailViewController*goldDetailVC = [[UCFGoldDetailViewController alloc]initWithNibName:@"UCFGoldDetailViewController" bundle:nil];
                goldDetailVC.dataDict = dataDict;
                goldDetailVC.isGoldCurrentAccout = YES;
                [weakSelf.navigationController pushViewController:goldDetailVC  animated:YES];
            }
            else
            {
                if([[dic objectSafeForKey:@"code"]  intValue] == 11112)
                {
                    UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }else{
                    [AuxiliaryFunc showAlertViewWithMessage:rsttext];
                }
                
            }
        }];

        
    }else{
        NSString *nmProClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",@"5",@"type",nil];
        
        [self.cycleImageVC.presenter fetchProDetailDataWithParameter:strParameters completionHandler:^(NSError *error, id result) {
            NSDictionary *dic = (NSDictionary *)result;
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            NSString *rsttext = dic[@"message"];
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            if ( [dic[@"ret"] boolValue])
            {
                UCFGoldDetailViewController*goldDetailVC = [[UCFGoldDetailViewController alloc]initWithNibName:@"UCFGoldDetailViewController" bundle:nil];
                goldDetailVC.dataDict = dataDict;
                goldDetailVC.isGoldCurrentAccout = NO;
                [weakSelf.navigationController pushViewController:goldDetailVC  animated:YES];
            }
            else
            {
                if([[dic objectSafeForKey:@"code"]  intValue] == 11112)
                {
                    UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }else{
                    [AuxiliaryFunc showAlertViewWithMessage:rsttext];
                }
                
            }
        }];
    }
}
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
#pragma mark - 去批量投资集合详情
-(void)gotoCollectionDetailViewContoller:(UCFHomeListCellModel *)model{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    self.accoutType = SelectAccoutTypeP2P;
    __weak typeof(self) weakSelf = self;
    if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
        NSString  *colPrdClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
        NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", colPrdClaimIdStr, @"colPrdClaimId", nil];
        [self.cycleImageVC.presenter fetchCollectionDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *dic = (NSDictionary *)result;
            NSString *rstcode = dic[@"ret"];
            NSString *rsttext = dic[@"message"];
            if ([rstcode intValue] == 1) {
                
                UCFCollectionDetailViewController *collectionDetailVC = [[UCFCollectionDetailViewController alloc]initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
                collectionDetailVC.souceVC = @"P2PVC";
                collectionDetailVC.colPrdClaimId = colPrdClaimIdStr;
                collectionDetailVC.detailDataDict = [dic objectSafeDictionaryForKey:@"data"];
                collectionDetailVC.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:collectionDetailVC  animated:YES];
            }else {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
        }];
    }
}
#pragma mark - UCFHomeListNavViewDelegate

- (void)homeListNavView:(UCFHomeListNavView *)navView didClicked:(UIButton *)loginAndRegister
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}

- (void)homeListNavView:(UCFHomeListNavView *)navView didClickedGiftButton:(UIButton *)giftButton
{
    MjAlertView *alertView = [[MjAlertView alloc] initADViewAlertWithDelegate:self];
    alertView.delegate = self;
    [alertView show];
}
- (void)mjalertView:(MjAlertView *)alertview withObject:(NSDictionary *)dic
{
    NSString *url = dic[@"url"];
    if (url.length > 0) {
        UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
        web.url = dic[@"url"];
        web.navTitle = dic[@"title"];
        web.isHidenNavigationbar = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}
#pragma mark - 刷新界面
- (void)refreshUI:(NSNotification *)noty
{
    __weak typeof(self) weakSelf = self;
//    [self addUI];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf fetchData];
    });
//    BOOL hasSign = [self.stateDict objectForKey:@"sign"];
//    if (hasSign) {
//        
//    }
}

- (void)setDefaultState:(NSNotification *)noty
{
    __weak typeof(self) weakSelf = self;
//    [self.userInfoVC setDefaultState];
//    [self addUI];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf fetchData];
    });
}

#pragma mark - 请求数据
- (void)fetchData
{
    __weak typeof(self) weakSelf = self;
    
//    [self.userInfoVC.presenter fetchUserInfoOneDataWithCompletionHandler:^(NSError *error, id result) {
//    }];
//    
//    [self.userInfoVC.presenter fetchUserInfoTwoDataWithCompletionHandler:^(NSError *error, id result) {
//    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.homeListVC.presenter fetchHomeIconListDataWithCompletionHandler:^(NSError *error, id result) {
            //请求成功
            UCFNoticeModel *notice = [result objectForKey:@"siteNotice"];
            if (notice.siteNotice.length > 0) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowNotice"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [weakSelf refreshNoticeWithShow:YES];
                    weakSelf.cycleImageVC.noticeView.noticeModel = notice;
                    weakSelf.cycleImageVC.noticeStr = notice.siteNotice;
                });
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowNotice"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [weakSelf refreshNoticeWithShow:NO];
            }
        }];
    });
    

    
    [self.homeListVC.presenter fetchHomeListDataWithCompletionHandler:^(NSError *error, id result) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];//上层交互逻辑
        if ([result isKindOfClass:[NSDictionary class]]) {
            
        }
        else if ([result isKindOfClass:[NSString class]]) {
            [AuxiliaryFunc showToastMessage:result withView:weakSelf.view];
        }
    }];
}

#pragma mark - 刷新公告
- (void)refreshNoticeWithShow:(BOOL)show
{
//    BOOL isShowNotice = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowNotice"];
    CGFloat userInfoViewHeight = [UCFCycleImageViewController viewHeight];
    if (show) {
        self.cycleImageVC.view.frame = CGRectMake(0, 0, ScreenWidth, userInfoViewHeight+45);
        [self.cycleImageVC refreshNotice];
    }
    else {
        self.cycleImageVC.view.frame = CGRectMake(0, 0, ScreenWidth, userInfoViewHeight);
        [self.cycleImageVC refreshNotice];
    }
    self.homeListVC.tableView.tableHeaderView = self.cycleImageVC.view;
}

#pragma mark - userInfoVC 的代理方法
- (void)userInfotableView:(UITableView *)tableView didSelectedItem:(UCFUserInfoListItem *)item
{

    if (!item.isShow) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if ([item.title isEqualToString:@"微金账户"]) {
        self.accoutType =  SelectAccoutTypeP2P;
    } else if ([item.title isEqualToString:@"尊享账户"]) {
        self.accoutType = SelectAccoutTypeHoner;
    } else if ([item.title isEqualToString:@"黄金账户"]) {
        UCFGoldAccountViewController *subVC = [[UCFGoldAccountViewController alloc] initWithNibName:@"UCFGoldAccountViewController" bundle:nil];
        subVC.homeView = weakSelf;
        [self.navigationController pushViewController:subVC animated:YES];
        return;
    }

    if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
        UCFP2POrHonerAccoutViewController *subVC = [[UCFP2POrHonerAccoutViewController alloc] initWithNibName:@"UCFP2POrHonerAccoutViewController" bundle:nil];
        subVC.accoutType = self.accoutType;
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

- (void)cycleImageVC:(UCFCycleImageViewController *)cycleImageVC didClickedIconWithIconPresenter:(UCFHomeIconPresenter *)iconPresenter
{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UCFInvestViewController *invest = (UCFInvestViewController *)[[appdel.tabBarController.childViewControllers objectAtIndex:1].childViewControllers firstObject];
    switch (iconPresenter.type) {
        case 1:
            invest.selectedType = @"P2P";
            break;
        case 2:
            invest.selectedType = @"ZX";
            break;
        case 3:
            invest.selectedType = @"Gold";
            break;
        case 4:
            invest.selectedType = @"Trans";
            break;
            
        case 5: {
            NSString *userId = [UserInfoSingle sharedManager].userId;
            if (nil == userId) {
                UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
                UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
                return;
            }
            self.accoutType = SelectAccoutTypeP2P;
            BOOL b = [self checkUserCanInvestIsDetail:YES type:self.accoutType];
            if (!b) {
                return;
            }
            if (![UserInfoSingle sharedManager].isRisk) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                self.accoutType = SelectAccoutTypeP2P;
                alert.tag =  9000;
                [alert show];
                return;
            }
            if (![UserInfoSingle sharedManager].isAutoBid) {
                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                batchInvestment.isStep = 1;
                batchInvestment.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:batchInvestment animated:YES];
                return;
            }
            UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
            facReservedWeb.url = [NSString stringWithFormat:@"%@", iconPresenter.url];
            [self.navigationController pushViewController:facReservedWeb animated:YES];
            return;
        }
            
    }
    if ([invest isViewLoaded]) {
        [invest changeView];
    }
    [appdel.tabBarController setSelectedIndex:1];
}

//- (void)userInfoClickAssetDetailButton:(UIButton *)button withInfomation:(id)infomation
//{
//    __weak typeof(self) weakSelf = self;
//    MjAlertView *alertView = [[MjAlertView alloc] initCustomAlertViewWithBlock:^(id blockContent) {
//        UIView *view = (UIView *)blockContent;
//        view.frame = CGRectMake(0, 0, 265, 220);
//        UCFAssetTipView *tipview = (UCFAssetTipView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFAssetTipView" owner:self options:nil] lastObject];
//        tipview.frame = view.bounds;
//        tipview.delegate = weakSelf;
//        [view addSubview:tipview];
//    }];
//    [alertView show];
//}

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

- (void)closeNotice
{
//    [self refreshNotice];
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
        if(buttonIndex == 1){ //测试
            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            vc.accoutType = self.accoutType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
