//
//  UCFPersonCenterController.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPersonCenterController.h"

#import "UCFPCListModel.h"

#import "UCFLoginShaowView.h"

#import "UCFUserInfoController.h"
#import "UCFPCListViewController.h"

#import "UCFFacCodeViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "UCFFeedBackViewController.h"
#import "UCFRedEnvelopeViewController.h"
#import "UCFMoreViewController.h"
#import "UCFSecurityCenterViewController.h"
#import "UCFP2POrHonerAccoutViewController.h"
#import "UCFMessageCenterViewController.h"
#import "UCFMyFacBeanViewController.h"
#import "UCFCouponViewController.h"
#import "UCFWorkPointsViewController.h"

#import "UCFLoginViewController.h"
#import "UCFRegisterStepOneViewController.h"
#import "MJRefresh.h"
#import "AuxiliaryFunc.h"

@interface UCFPersonCenterController () <UCFPCListViewControllerCallBack,LoginShadowDelegate>
{
    NSDictionary *_dataDict;
}

@property (nonatomic, strong) UCFUserInfoController *userInfoVC;
@property (strong, nonatomic) UCFPCListViewController *pcListVC;
@end

@implementation UCFPersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
//    [self fetchData];
    
    [_pcListVC.tableView
      addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchData)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
//        [self hideShadowView];
//    } else {
//        [self addShadowViewAndLoginBtn];
//    }
}

#pragma mark - Utils

- (void)configuration {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UCFPCListViewPresenter *listViewPresenter = [UCFPCListViewPresenter presenter];
    
    self.pcListVC = [UCFPCListViewController instanceWithPresenter:listViewPresenter];
    self.pcListVC.delegate = self;//BlogViewController走的是Protocol绑定方式

    self.userInfoVC = [UCFUserInfoController instanceWithPresenter:listViewPresenter];
    [self.userInfoVC setUserInfoVCGenerator:^UIViewController *(id params) {
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
    
    /* 返回数据
     data =     {
     beanAmount = 0;
     couponNumber = 0;
     enjoyAmount = 0;
     enjoyOpenStatus = "";
     enjoyRepayPerDate = "2017-04-21";
     gcm = C0700WR;
     headurl = "https://www.9888.cn/img/app/man.png";
     isCompanyAgent = 0;
     loginName = BA0070;
     memberLever = 0;
     mobile = "185****0070";
     p2pAmount = "550819.05";
     p2pOpenStatus = 4;
     p2pRepayPerDate = "2017-04-21";
     score = "2.9\U4e07";
     sex = "\U7537";
     unReadMsgCount = 0;
     userId = 918332;
     userName = "\U97e9\U5148\U751f";
     };
     */
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];;//上层交互逻辑
    
    __weak typeof(self) weakSelf = self;
    [self.pcListVC.presenter fetchDataWithCompletionHandler:^(NSError *error, id result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;//上层交互逻辑
        
        if (weakSelf.pcListVC.tableView.header.isRefreshing) {
               [weakSelf.pcListVC.tableView.header endRefreshing];
        }
        BOOL rstcode = [result[@"ret"] boolValue];
        NSString *messageStr = result[@"message"];
        if (rstcode) { //返回成功
            _dataDict = (NSDictionary *)result[@"data"];

        }else{
             [AuxiliaryFunc showToastMessage:messageStr withView:self.view];
        }
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
        /*
         UN_OPEN:1,未开户；OPEN：2,开户；BIND_CARD:3,已绑定银行卡；HAS_PWD:4,设置交易密码；
         */
        if([_dataDict objectSafeForKey:@"enjoyOpenStatus"]){ //尊享开户状态判断
            
            
            return;
        }
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

#pragma mark - 无奈的代码

//未登录状态添加阴影和登录按钮
- (void)addShadowViewAndLoginBtn
{
    BOOL hasHideView = NO;
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UCFLoginShaowView class]]) {
            hasHideView = YES;
        }
    }
    //遍历当前view的所有子view 没有loginshashow才add
    if (!hasHideView) {
        UCFLoginShaowView *shadowView = [[UCFLoginShaowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        shadowView.delegate = self;
        [self.view addSubview:shadowView];
    }
}

//移除shadowview
- (void)hideShadowView
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UCFLoginShaowView class]]) {
            [view setHidden:YES];
            [view removeFromSuperview];
        }
    }
}

#pragma mark -loginbtnClicked

- (void)btnShadowClicked:(id)sender
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    loginViewController.sourceVC = @"fromPersonCenter";
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}


- (void)regBtnclicked:(id)sender
{
    UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
    registerControler.sourceVC = @"fromPersonCenter";
    UINavigationController *regNaviController = [[UINavigationController alloc] initWithRootViewController:registerControler];
    [self presentViewController:regNaviController animated:YES completion:nil];
}

- (void)moreBtnclicked:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UCFMoreViewController" bundle:nil];
    UCFMoreViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"more_main"];
    controller.sourceVC = @"fromPersonCenter";
    UINavigationController *moreNaviController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:moreNaviController animated:YES completion:nil];
}

@end
