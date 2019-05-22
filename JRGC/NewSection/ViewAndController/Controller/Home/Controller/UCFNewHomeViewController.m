//
//  UCFNewHomeViewController.m
//  JRGC
//
//  Created by zrc on 2019/1/10.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewHomeViewController.h"
#import "HomeHeadCycleView.h"
#import "UCFNewHomeSectionView.h"
#import "CellConfig.h"
#import "HomeFootView.h"
#import "UCFHomeListRequest.h"
#import "BaseTableViewCell.h"
#import "UCFHomeViewModel.h"
#import "UCFBidDetailRequest.h"
#import "UCFBidDetailAndInvestPageLogic.h"
#import "UCFNewNoticeViewController.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFHighQualityContainerViewController.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFWebViewJavascriptBridgeController.h"
#import "UCFInvitationRebateViewController.h"
#import "UCFMineIntoCoinPageApi.h"
#import "UCFMineIntoCoinPageModel.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "NSString+Misc.h"
#import "UCFInvestViewController.h"
#import "RTRootNavigationAddPushController.h"
#import "HSHelper.h"
#import "RiskAssessmentViewController.h"
#import "UCFDiscoveryViewController.h"
#import "UCFCouponPopup.h"
#import "UCFNewLockContainerViewController.h"
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "UCFRequestSucceedDetection.h"
//#import "UCFCreateLockViewController.h"
//#import "UCFUnlockViewController.h"
//#import "UCFTouchIDViewController.h"
//#import "UCFNewLockContainerViewController.h"
@interface UCFNewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,YTKRequestDelegate,HomeHeadCycleViewDelegate,BaseTableViewCellDelegate,UCFNewHomeSectionViewDelegate>
@property(nonatomic, strong)HomeHeadCycleView *homeHeadView;
@property(nonatomic, strong)UCFHomeViewModel  *homeListViewModel;
//@property(nonatomic, strong)UCFBannerViewModel*bannerViewModel;

@property(nonatomic, strong)BaseTableView     *showTableView;
@property(nonatomic, strong)NSMutableArray    *dataArray;
@property (strong, nonatomic)  UCFCouponPopup *ucfCp;
/**
 商城推荐查看更多URL
 */
@property(nonatomic, copy)NSString      *remcommendUrl;

/**
 商城精选查看更多URL
 */
@property(nonatomic, copy)NSString      *boutiqueUrl;
@end

@implementation UCFNewHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.showTableView reloadData];
    UIViewController *contro = [self jsd_getCurrentViewController];
    if (![contro isKindOfClass:[UCFNewLockContainerViewController class]]) {
        [self homeCouponPopup];
    }
}

- (void)loadView
{
    [super loadView];
}

- (NSString *)getDeiveName {
    UIDevice *device = UIDevice.currentDevice;
    return device.name;
}

- (void)rightBarClicked:(UIButton *)button
{
    
    if (button.tag == 100) {
        if (SingleUserInfo.loginData.userInfo.userId) {
            UCFNewNoticeViewController *vc = [[UCFNewNoticeViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
        } else {
            [SingleUserInfo loadLoginViewController];
        }
    } else {
        UCFNewNoticeViewController *vc = [[UCFNewNoticeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
    }

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButtonTitle:@"首页"];
//    [self addRightbuttonImageName:@"home_icon_news"];
    if (SingleUserInfo.loginData.userInfo.userId) {
        [self addrightButtonWithImageArray:@[@"home_icon_news"]];
    } else {
        [self addrightButtonWithImageArray:@[@"home_icon_sgin",@"home_icon_news"]];

    }
    self.showTableView.myVertMargin = 0;
    self.showTableView.myHorzMargin = 0;
    [self.rootLayout addSubview:self.showTableView];
    self.showTableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.navigationController.navigationBar.tintColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    HomeHeadCycleView *homeHeadView = [HomeHeadCycleView new];
    homeHeadView.myTop = 0;
    CGFloat height =  ((([[UIScreen mainScreen] bounds].size.width - 54) * 9)/16);
    homeHeadView.heightSize.equalTo([NSNumber numberWithFloat:height]);
    homeHeadView.leftPos.equalTo(@0);
    homeHeadView.rightPos.equalTo(@0);
    [homeHeadView createSubviews];
    homeHeadView.delegate = self;
    self.homeHeadView = homeHeadView;
    
    self.showTableView.tableHeaderView = self.homeHeadView;
    HomeFootView *homefootView = [HomeFootView new];
    homefootView.myHeight = 181;
    homefootView.myHorzMargin = 0;
    [homefootView createSubviews];
    self.showTableView.tableFooterView = homefootView;
    
    [self blindVM];
    [self fetchData];
    [self blindUserStatue];
    self.ucfCp = [[UCFCouponPopup alloc]init];
}

- (void)blindVM
{
    self.homeListViewModel = [UCFHomeViewModel new];
    self.homeListViewModel.loaingSuperView = self.view;
    [self.homeHeadView showView:self.homeListViewModel];
    self.homeListViewModel.rootViewController = self;
    [self showView:_homeListViewModel];
}
- (void)showView:(UCFHomeViewModel *)viewModel
{
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"modelListArray",@"remcommendUrl",@"boutiqueUrl"] options:NSKeyValueObservingOptionNew  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"modelListArray"]) {
            NSArray *modelListArray = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (modelListArray.count > 0) {
                [selfWeak.showTableView endRefresh];
                selfWeak.dataArray = [NSMutableArray arrayWithArray:modelListArray];
                [selfWeak.showTableView reloadData];
            }
        }   else if ([keyPath isEqualToString:@"remcommendUrl"]) {
            NSString *remcommendUrl = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            selfWeak.remcommendUrl = remcommendUrl;
        } else if ([keyPath isEqualToString:@"boutiqueUrl"]) {
            NSString *boutiqueUrl = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            selfWeak.boutiqueUrl = boutiqueUrl;
        }
    }];
}
- (void)fetchData
{
    [self.homeListViewModel fetchNetData];
}
#pragma BaseTableViewDelegate
- (void)refreshTableViewHeader
{
    [self fetchData];
}

- (BaseTableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.tableRefreshDelegate = self;
        _showTableView.enableRefreshFooter = NO;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _showTableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArr = self.dataArray[section];
    CellConfig *data = sectionArr[0];
    if (data.title.length > 0) {
        return 54;
    } else {
        return 0.001;

    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArr = self.dataArray[section];
    CellConfig *data = sectionArr[0];
    if (data.title.length > 0) {
        UCFNewHomeSectionView *sectionView = [[UCFNewHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
        sectionView.section = section;
        sectionView.delegate = self;
        NSArray *sectionArr = self.dataArray[section];
        CellConfig *data = sectionArr[0];
        if (data) {
            sectionView.titleLab.text = data.title;
        }
        if (SingleUserInfo.loginData.userInfo.isRisk && !([data.title isEqualToString:@"内容推荐"] || [data.title isEqualToString:@"新手入门"])) {
            [sectionView showMore];
        } else {
            if ([data.title isEqualToString:@"商城精选"] || [data.title isEqualToString:@"商城特惠"] || [data.title isEqualToString:@"智能出借"] || [data.title isEqualToString:@"优质债权"]) {
                [sectionView showMore];
            }
        }
        return sectionView;
    } else {
        return nil;
    }

}

- (void)showMoreViewSection:(NSInteger)section andTitle:(NSString *)title
{
    if ([title isEqualToString:@"商城精选"]) {
        if ([self.boutiqueUrl containsString:@"http"]) {
            [self pushWebViewWithUrl:self.boutiqueUrl Title:@"商城精选"];
        } else {
            [SingGlobalView.tabBarController setSelectedIndex:3];
        }
    } else if([title isEqualToString:@"商城特惠"]){
        if ([self.remcommendUrl containsString:@"http"]) {
            [self pushWebViewWithUrl:self.remcommendUrl Title:@"商城特惠"];
        } else {
            [SingGlobalView.tabBarController setSelectedIndex:3];
        }
    } else if ([title isEqualToString:@"智能出借"] || [title isEqualToString:@"优质债权"]) {
        RTRootNavigationAddPushController *nav = SingGlobalView.tabBarController.viewControllers[1];
        RTContainerController *container = nav.viewControllers[0];
        UCFInvestViewController *vc  = container.contentViewController;
        vc.selectedType  = [title isEqualToString:@"智能出借"] ? @"IntelligentLoan" : @"QualityClaims";
        if ([vc isViewLoaded]) {
            [vc changeView];
        }
        [SingGlobalView.tabBarController setSelectedIndex:1];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArr = self.dataArray[section];
    return sectionArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.dataArray[indexPath.section];
    CellConfig *data = sectionArr[indexPath.row];
    return data.heightOfCell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.dataArray[indexPath.section];
    CellConfig *config = sectionArr[indexPath.row];
    BaseTableViewCell *cell = (BaseTableViewCell *)[config cellOfCellConfigWithTableView:tableView dataModel:config.dataModel];
    cell.bc = self;
    cell.deleage = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.dataArray[indexPath.section];
    CellConfig *config = sectionArr[indexPath.row];
    if (config.dataModel) {
        [UCFBidDetailAndInvestPageLogic bidDetailAndInvestPageLogicUseDataModel:config.dataModel detail:YES rootViewController:self];
    }
}
#pragma mark BaseTableViewCellDelegate
- (void)baseTableViewCell:(BaseTableViewCell *)cell buttonClick:(UIButton *)button withModel:(id)model
{    
    if ([model isKindOfClass:[UCFNewHomeListPrdlist class]]) {
        [UCFBidDetailAndInvestPageLogic bidDetailAndInvestPageLogicUseDataModel:model detail:NO rootViewController:self];
    } else if ([model isKindOfClass:[NSString class]]) {
        NSString *userId = SingleUserInfo.loginData.userInfo.userId;
        if(nil == userId) {
            [SingleUserInfo loadLoginViewController];
        } else {
            NSString *title = model;

            if ([title isEqualToString:@"豆哥商城"]) {
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                NSURLCache * cache = [NSURLCache sharedURLCache];
                [cache removeAllCachedResponses];
                [cache setDiskCapacity:0];
                [cache setMemoryCapacity:0];
                
                UCFWebViewJavascriptBridgeMall *mallController = [[UCFWebViewJavascriptBridgeMall alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
                mallController.url      = @"https://m.dougemall.com";//请求地址;
                mallController.navTitle = @"商城";
                mallController.isFromBarMall = NO;
                [self.navigationController pushViewController:mallController animated:YES];
            } else if ([title isEqualToString:@"领券中心"]) {
                UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
                web.url = COUPON_CENTER;
                web.isHidenNavigationbar = YES;
                [self.navigationController pushViewController:web animated:YES];
            } else if ([title isEqualToString:@"邀请返利"]) {
                UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
                feedBackVC.title = @"邀请获利";
                feedBackVC.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:feedBackVC animated:YES];
            } else if ([title isEqualToString:@"工力工贝"]) {
                if(SingleUserInfo.loginData.userInfo.isCompanyAgent)//如果是机构用户
                {//吐司：此活动暂时未对企业用户开放
                    ShowMessage(@"此活动暂时未对企业用户开放");
                } else {
                    UCFMineIntoCoinPageApi * request = [[UCFMineIntoCoinPageApi alloc] initWithPageType:@""];
                    
                    request.animatingView = self.view;
                    //    request.tag =tag;
                    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        // 你可以直接在这里使用 self
                        UCFMineIntoCoinPageModel *model = [request.responseJSONModel copy];
                        //        DDLogDebug(@"---------%@",model);
                        if (model.ret == YES) {
                            
                            //            NSDictionary *coinRequestDicData = [dataDict objectSafeDictionaryForKey:@"coinRequest"];
                            UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
                            //            NSDictionary *paramDict = [coinRequestDicData objectSafeDictionaryForKey:@"param"];
                            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
                            [data setValue:[NSString urlEncodeStr:model.data.coinRequest.param.encryptParam ] forKey:@"encryptParam"];
                            [data setObject:[NSString stringWithFormat:@"%zd",model.data.coinRequest.param.fromApp] forKey:@"fromApp"];
                            [data setObject:model.data.coinRequest.param.userId forKey:@"userId"];
                            NSString * requestStr = [Common getParameterByDictionary:data];
                            web.url  = [NSString stringWithFormat:@"%@/#/?%@",model.data.coinRequest.urlPath,requestStr];
                            web.isHidenNavigationbar = YES;
                            [self.navigationController pushViewController:web animated:YES];
                        }
                        else{
                            ShowCodeMessage(model.code, model.message);
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        // 你可以直接在这里使用 self
                        
                    }];
                }
            } else if ([title isEqualToString:@"京元"]) {
                [self skipToJY];
            }
        }
    } else if ([model isKindOfClass:[UCFHomeMallrecommends class]]) {
        UCFHomeMallrecommends *mallModel = model;
        [self pushWebViewWithUrl:mallModel.bizUrl Title:mallModel.title];
    } else if ([model isKindOfClass:[UCFhomeMallbannerlist class]]) {
         UCFhomeMallbannerlist *mallModel = model;
        [self pushWebViewWithUrl:mallModel.url Title:mallModel.title];
    } else if ([model isKindOfClass:[UCFHomeMallsale class]]) {
        UCFHomeMallsale *mallModel = model;
        [self pushWebViewWithUrl:mallModel.bizUrl Title:mallModel.title];
    }
}
- (void)pushWebViewWithUrl:(NSString *)url Title:(NSString *)title
{
    if ([url containsString:@"http"]) {
        UCFWebViewJavascriptBridgeBanner *web = [[UCFWebViewJavascriptBridgeBanner alloc] initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        web.url = [NSString stringWithFormat:@"%@",url];
        web.title = title;
        //    web.isHidenNavigationbar = YES;
        [self.navigationController pushViewController:web animated:YES];
        
    } else {
        [SingGlobalView.tabBarController setSelectedIndex:3];
    }

}
- (void)homeViewDataBidClickModel:(UCFNewHomeListModel *)model type:(UCFNewHomeListType)type
{
    
}
#pragma mark HomeHeadCycleViewDelegate
- (void)homeHeadCycleView:(HomeHeadCycleView *)cycleView didSelectIndex:(NSInteger)index
{
    
}
#pragma mark 新手引导cell的点击事件
- (void)userGuideCellClickButton:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"注册领券"] || [title isEqualToString:@"存管开户"] || [title isEqualToString:@"风险评测"] || [title isEqualToString:@"新人专享"]) {
        [self skipNewUserGuideWebPageTitle:@"新手入门指引" URL:@"https://m.9888.cn/static/wap/invest/index.html#/new-guide/guide"];
    } else if ([title isEqualToString:@"注册领优惠券"]) {
        [SingleUserInfo loadRegistViewController];
    } else if ([title isEqualToString:@"开通存管账户"]){
        [HSHelper  goToWeijinOpenAccount:self.rt_navigationController];
    }  else if ([title isEqualToString:@"设置交易密码"]){
        [HSHelper  goToWeijinOpenAccount:self.rt_navigationController];
    }
    else if ([title isEqualToString:@"进行风险评测"]) {
        RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
        vc.accoutType = SelectAccoutTypeP2P;
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
}
- (void)skipNewUserGuideWebPageTitle:(NSString *)title URL:(NSString *)url
{
    UCFWebViewJavascriptBridgeMallDetails *webView = [[UCFWebViewJavascriptBridgeMallDetails alloc]initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
//    webView.rootVc = self;
    webView.url = url;
    webView.navTitle = title;
    webView.isHidenNavigationbar = NO;
    [self.rt_navigationController pushViewController:webView animated:YES];
    
    

}
- (void)homeCouponPopup
{
    if ([UserInfoSingle sharedManager].isShowCouple) {
        [self.ucfCp request];
    }
}
- (void)refreshRightBtn
{
    if (SingleUserInfo.loginData.userInfo.userId) {
        [self addrightButtonWithImageArray:@[@"home_icon_news"]];
    } else {
        [self addrightButtonWithImageArray:@[@"home_icon_sgin",@"home_icon_news"]];
        
    }
}
- (void)monitorUserLogin
{
    [self fetchData];
    [self refreshRightBtn];
}
- (void)monitorUserGetOut
{
    [self fetchData];
    [self refreshRightBtn];

}
- (void)monitorOpenStatueChange
{
    [self fetchData];
}
- (void)monitorRiskStatueChange
{
    [self fetchData];
}
- (void)refreshPageData
{
    [self fetchData];

}
- (UIViewController *)jsd_getCurrentViewController{
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}
- (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

- (void)skipToJY
{
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self presentViewController:flutterViewController animated:false completion:nil];
    
    
    
    FlutterMethodChannel *presentChannel = [FlutterMethodChannel methodChannelWithName:@"com.eten.jingyuan/crayfish" binaryMessenger:flutterViewController];
    __weak typeof(self) weakSelf = self;
    // 注册方法等待flutter页面调用
    [presentChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"%@", call.method);
        NSLog(@"%@", result);
        NSDictionary *dic = call.arguments;
        if ([call.method isEqualToString:@"getTokenInfo"])
        {
            NSString *name = [weakSelf getDeiveName];
            if (name == nil) {
                FlutterError *error = [FlutterError errorWithCode:@"UNAVAILABLE" message:@"Device info unavailable" details:nil];
                result(error);
            } else {
                // 通过result返回给Flutter回调结果
                NSDictionary *parameterDic;
                if (SingleUserInfo.loginData.userInfo.userId == nil)
                {
                    parameterDic = @{@"imei": [Encryption getKeychain],@"version": [Encryption getIOSVersion]};
                }
                else
                {
                    parameterDic = @{@"imei": [Encryption getKeychain],@"version": [Encryption getIOSVersion],@"userId": SingleUserInfo.loginData.userInfo.userId,@"token": SingleUserInfo.signatureStr};
                }
                NSString *str =  [parameterDic JSONString];
                result(str);
            }
        }
        else if ([call.method isEqualToString:@"showPDFView"])
        {
            
            NSLog(@"%@", dic);
        }
        else if ([call.method isEqualToString:@"showWebView"])
        {
            UCFWebViewJavascriptBridgeController *web = [[UCFWebViewJavascriptBridgeController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeController" bundle:nil];
            web.title = [dic objectSafeForKey:@"title"];
            web.url = [dic objectSafeForKey:@"url"];
            [self.rt_navigationController pushViewController:web animated:YES];
        }
        else if ([call.method isEqualToString:@"showBankApp"])
        {
            
        }
        else if ([call.method isEqualToString:@"logout"])
        {
            UCFRequestSucceedDetection *re = [[UCFRequestSucceedDetection alloc] init];
            [re requestSucceedDetection:dic];
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
}
@end
