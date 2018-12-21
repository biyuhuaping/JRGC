//
//  UCFMicroMoneyViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMicroMoneyViewController.h"
#import "UCFMicroMoneyHeaderView.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFFacReservedViewController.h"

#import "UCFHomeListHeaderSectionView.h"
#import "UCFHomeListCell.h"
#import "UCFInvestMicroMoneyCell.h"
#import "UCFHomeInvestCell.h"
#import "AppDelegate.h"

#import "UCFInvestAPIManager.h"
#import "UCFMicroMoneyGroup.h"
#import "UCFMicroMoneyModel.h"
#import "HSHelper.h"
#import "UCFToolsMehod.h"
#import "UCFNoPermissionViewController.h"
#import "UCFLoginViewController.h"
#import "UCFProjectDetailViewController.h"
#import "UCFPurchaseBidViewController.h"
#import "RiskAssessmentViewController.h"
#import "UCFCollectionDetailViewController.h"
#import "UCFBatchBidController.h"
#import "UCFOrdinaryBidController.h"
#import "UCFGoldDetailViewController.h"
#import "UCFNewUserCell.h"
#import "UCFRegisterStepOneViewController.h"
#import "UCFMicroMoneyCell.h"
#import "NewPurchaseBidController.h"
@interface UCFMicroMoneyViewController () <UITableViewDataSource, UITableViewDelegate, UCFInvestAPIWithMicroMoneyManagerDelegate, UCFInvestMicroMoneyCellDelegate,UCFHomeListHeaderSectionViewDelegate, UCFHomeInvestCellDelegate,UCFNewUserCellDelegate,UCFInvestMicroMoneyCellDelegate>

@property (strong, nonatomic) UCFMicroMoneyHeaderView *microMoneyHeaderView;
@property (strong, nonatomic) UCFInvestAPIManager *apiManager;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UCFMicroMoneyModel *model;
@property (strong,nonatomic) NSString *colPrdClaimIdStr;
@end

@implementation UCFMicroMoneyViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.tableview.header isRefreshing]) {
        [self.tableview.header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - 设置界面
- (void)createUI {
    self.accoutType = SelectAccoutTypeP2P;
    UCFMicroMoneyHeaderView *microMoneyHeaderView = (UCFMicroMoneyHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMicroMoneyHeaderView" owner:self options:nil] lastObject];
    microMoneyHeaderView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/16*5);
    self.tableview.tableHeaderView = microMoneyHeaderView;
    self.microMoneyHeaderView = microMoneyHeaderView;
    
    self.tableview.tableFooterView = [self createFootView];
    
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    //=========  下拉刷新、上拉加载更多  =========
//    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) errorTitle:@"敬请期待..."]
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    
    UCFInvestAPIManager *apiManager = [[UCFInvestAPIManager alloc] init];
    apiManager.microMoneyDelegate = self;
    self.apiManager = apiManager;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableview.header beginRefreshing];
//    });
}
-(void)reloadData{
    [self.microMoneyHeaderView getNormalBannerData];
   [ self.apiManager getNewMicroMoneyFromNet];
}

#pragma mark - tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.dataArray.count;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return self.dataArray.count;
//    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
//    return group.prdlist.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
//    if (group.prdlist.count > 0) {
//        return 39;
//    }
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (kIS_IOS8) {
//        static NSString* viewId = @"homeListHeader";
//        UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
//        if (nil == view) {
//            view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
//        }
//        view.section = section;
//        UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
//        view.downView.hidden = YES;
//        view.des = group.desc;
//        [view.headerImageView sd_setImageWithURL:[NSURL URLWithString:group.iconUrl]];
//        view.homeListHeaderMoreButton.hidden = !group.showMore;
//        [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
//        [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
//        [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
//        view.delegate = self;
//        if (group.prdlist.count > 0) {
//            view.frame = CGRectMake(0, 0, ScreenWidth, 39);
//        }
//        else {
//            view.frame = CGRectZero;
//        }
//        view.headerTitleLabel.text = group.title;
//        return view;
//    } else {
//        UCFHomeListHeaderSectionView *view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
//        view.section = section;
//        UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
//        view.downView.hidden = YES;
//        view.des = group.desc;
//        [view.headerImageView sd_setImageWithURL:[NSURL URLWithString:group.iconUrl]];
//        view.homeListHeaderMoreButton.hidden = !group.showMore;
//        [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
//        [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
//        [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
//        view.delegate = self;
//        if (group.prdlist.count > 0) {
////            view.frame = CGRectMake(0, 0, ScreenWidth, 39);
//        }
//        else {
//            view.frame = CGRectZero;
//        }
//        view.headerTitleLabel.text = group.title;
//        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
//        baseView.backgroundColor = [UIColor clearColor];
//        [baseView addSubview:view];
//        return baseView;
//    }
//
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
    footerView.backgroundColor = UIColorWithRGB(0xebebee);
    return footerView;
}

- (void)homeListHeader:(UCFHomeListHeaderSectionView *)homeListHeader didClickedMoreWithType:(NSString *)type{
    if ([homeListHeader.headerTitleLabel.text isEqualToString:@"一键投标"]) {
        UCFBatchBidController *batchBidVc = [[UCFBatchBidController alloc]initWithNibName:@"UCFBatchBidController" bundle:nil];
        batchBidVc.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:batchBidVc animated:YES];
    }
    else if ([homeListHeader.headerTitleLabel.text isEqualToString:@"预约宝"]) {
        NSString *userId = [UserInfoSingle sharedManager].userId;
        if (nil == userId) {
            UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
            UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
            return;
        }
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
        NSString *url = PRERESERVE_PRODUCTS_URL;
        UCFMicroMoneyGroup  *microMoneyG = [self.dataArray objectAtIndex:homeListHeader.section];
        UCFMicroMoneyModel *model = [microMoneyG.prdlist firstObject];
        facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", url, model.Id];
        [self.navigationController pushViewController:facReservedWeb animated:YES];
    }
    else{
        UCFOrdinaryBidController *ordinaryBidVC = [[UCFOrdinaryBidController alloc]initWithNibName:@"UCFOrdinaryBidController" bundle:nil];
        ordinaryBidVC.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:ordinaryBidVC animated:YES];
        
    }    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
//    UCFMicroMoneyModel *model = [group.prdlist objectAtIndex:indexPath.row];
//    if (group.type.intValue == 13) {
//        static NSString *cellId = @"newusercell";
//        UCFNewUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (nil == cell) {
//            cell = (UCFNewUserCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFNewUserCell" owner:self options:nil] lastObject];
//            cell.delegate = self;
//            cell.tableview = tableView;
//        }
//        cell.microMoneyModel = model;
//        cell.indexPath = indexPath;
//        return cell;
//    }
//    else if (group.type.intValue == 16) {
//        static NSString *cellId1 = @"homeListInvestCell";
//        UCFHomeInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
//        if (nil == cell) {
//            cell = (UCFHomeInvestCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeInvestCell" owner:self options:nil] lastObject];
//            cell.delegate = self;
//        }
//        cell.microModel = model;
//        return cell;
//    }
//    else {
        static NSString *cellId2 = @"MicroMoneyCell";
        UCFMicroMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (nil == cell) {
            cell = (UCFMicroMoneyCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMicroMoneyCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.delegate = self;
        }
       UCFMicroMoneyModel *model = [self.dataArray objectAtIndex:indexPath.row];
       cell.microModel = model;
    
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
//    if (group.type.intValue == 16) {
//        return 150;
//    }
//    else if (group.type.intValue == 13) {
//        return 130;
//    }
//    return 100;
    
    return 188;
}
- (UIView *)createFootView
{
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 98)];
    footView.backgroundColor = UIColorWithRGB(0xebebee);
    
    UILabel *firstProtocolLabel = [[UILabel alloc] init];
    firstProtocolLabel.font = [UIFont systemFontOfSize:12.0f];
    CGSize size = [Common getStrHeightWithStr:@"市场有风险 投资需谨慎" AndStrFont:12 AndWidth:ScreenWidth- 23 -15];
    firstProtocolLabel.numberOfLines = 0;
    firstProtocolLabel.textAlignment  = NSTextAlignmentCenter;
    firstProtocolLabel.frame = CGRectMake(15, 0, ScreenWidth - 15*2, size.height);
    firstProtocolLabel.text = @"市场有风险 投资需谨慎";
    firstProtocolLabel.textColor = UIColorWithRGB(0x999999);
    
    [footView addSubview:firstProtocolLabel];
    
    return footView;
}
#pragma mark - 预约按钮的点击代理方法
//- (void)microMoneyListCell:(UCFHomeInvestCell *)microMoneyCell didClickedInvestButtonWithModel:(UCFMicroMoneyModel *)model
//{
//    NSString *userId = [UserInfoSingle sharedManager].userId;
//    if (nil == userId) {
//        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
//        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
//        return;
//    }
//    self.accoutType = SelectAccoutTypeP2P;
//    BOOL b = [self checkUserCanInvestIsDetail:NO type:self.accoutType];
//    if (!b) {
//        return;
//    }
//    if (![UserInfoSingle sharedManager].isRisk) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        self.accoutType = SelectAccoutTypeP2P;
//        alert.tag =  9000;
//        [alert show];
//        return;
//    }
//    if (![UserInfoSingle sharedManager].isAutoBid) {
//        UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
//        batchInvestment.isStep = 1;
//        batchInvestment.accoutType = SelectAccoutTypeP2P;
//        [self.navigationController pushViewController:batchInvestment animated:YES];
//        return;
//    }
//    UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
//    NSString *url = PRERESERVE_APPLY_URL;
//    facReservedWeb.url = [NSString stringWithFormat:@"%@", url];
//    [self.navigationController pushViewController:facReservedWeb animated:YES];
//}
-(void)microMoneyListCell:(UCFHomeInvestCell *)microMoneyCell didClickedInvestButtonWithModel:(UCFMicroMoneyModel *)model
{
    [self gotoReservedVCOrIntelligentBaoVC:model isDetail:NO];
}

-(void)gotoReservedVCOrIntelligentBaoVC:(UCFMicroMoneyModel *)model isDetail:(BOOL)isDetail
{
    if (model.modelType == UCFMicroMoneyModelTypeBatchBid ) {//批量出借标
        [self gotoCollectionDetailViewContoller:model];
    }
    else  {//预约宝和智存宝
        
        NSString *userId = [UserInfoSingle sharedManager].userId;
        if (nil == userId) {
            [self showLoginView];
            return;
        }
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
        
        NSString *url = @"";
        if (model.modelType  == UCFMicroMoneyModelTypeIntelligent) {//智存宝
            url = isDetail ?  INTELLIGENTDETAIL_APPLY_URL : INTELLIGENTLOAN_APPLY_URL;
        }
        else if (model.modelType  == UCFMicroMoneyModelTypeReserve) {//预约宝
            url =  isDetail ?  RESERVEDETAIL_APPLY_URL : RESERVEINVEST_APPLY_URL;
        }
        facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", url, model.Id];
        [self.navigationController pushViewController:facReservedWeb animated:YES];
    }
}

#pragma mark - tableview 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UCFMicroMoneyModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [self gotoReservedVCOrIntelligentBaoVC:model isDetail:YES];
    
    return;
    
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
//        //如果未登录，展示登录页面
//        [self showLoginView];
//        return;
//    }
//
//
//
//    if (model.modelType == UCFMicroMoneyModelTypeBatchBid ) {//批量出借标
//        [self gotoCollectionDetailViewContoller:model];
//    }
//    else if (model.type.intValue == 0) {
//        self.accoutType = SelectAccoutTypeP2P;
//        if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
//
//            self.accoutType = SelectAccoutTypeP2P;
//            BOOL b = [self checkUserCanInvestIsDetail:NO type:self.accoutType];
//            if (!b) {
//                return;
//            }
//            if (![UserInfoSingle sharedManager].isRisk) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                self.accoutType = SelectAccoutTypeP2P;
//                alert.tag =  9000;
//                [alert show];
//                return;
//            }
//            if (![UserInfoSingle sharedManager].isAutoBid) {
//                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
//                batchInvestment.isStep = 1;
//                batchInvestment.accoutType = SelectAccoutTypeP2P;
//                [self.navigationController pushViewController:batchInvestment animated:YES];
//                return;
//            }
//            UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
//            NSString *url = @"";
//            if ([model.type isEqualToString:@"13"]) {
//                url = NEWUSER_PRODUCTS_URL;
//            }
//            else if ([model.type isEqualToString:@"16"]) {
//                url = PRERESERVE_PRODUCTS_URL;
//            }
//            facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", url, model.Id];
//            [self.navigationController pushViewController:facReservedWeb animated:YES];
//        }
//    }
//    else {//新手标 或普通标
//                self.model = model;
//                 HSHelper *helper = [HSHelper new];
//                //检查企业老用户是否开户
//                NSString *messageStr =  [helper checkCompanyIsOpen:self.accoutType];
//                if (![messageStr isEqualToString:@""]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
//                    [alert show];
//                    return;
//                }
//
//                if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
//                    NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
////                    NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@",model.Id,userid];
//                    NSString *prdClaimsIdStr = [NSString stringWithFormat:@"%@",model.Id];
//                    NSDictionary *praramDic = @{@"userId":userid,@"prdClaimsId":prdClaimsIdStr};
//
//
//                    NSInteger isOrder = [model.isOrder integerValue];
//
//
//                    if ([model.status intValue ] != 2) {
//                        if (isOrder <= 0) {
//                            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对出借人开放"];
//                            [self.navigationController pushViewController:controller animated:YES];
//                            return;
//                        }
//                    }
//                    if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
//                        if ([model.status intValue ] != 2) {
//                            if (isOrder > 0) {
//                                [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
//                                [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdBaseDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
//                            }
//                        }else {
//                            [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
//                            [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdBaseDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
//                    }
//                   }
//               }
//        }
}
#pragma mark - 去批量投资集合详情
-(void)gotoCollectionDetailViewContoller:(UCFMicroMoneyModel *)model{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    self.accoutType = SelectAccoutTypeP2P;
    //检查企业老用户是否开户
    NSString *messageStr =  [[HSHelper new] checkCompanyIsOpen:self.accoutType];
    if (![messageStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
            _colPrdClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
            NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", _colPrdClaimIdStr, @"colPrdClaimId", nil];
            [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagColPrdclaimsDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
    }
}

#pragma mark -去登录页面
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
}
#pragma mark -开户判断
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
    
    if (alertView.tag == 7000) {
        [self.apiManager getMicroMoneyFromNet];
    } else if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
    }else if (alertView.tag == 9000) {
        if(buttonIndex == 1){ //测试
            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            vc.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(alertView.tag == 9001){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
        }
    }
}


#pragma mark - 网络请求代理

- (void)investApiManager:(UCFInvestAPIManager *)apiManager didSuccessedReturnMicroMoneyResult:(id)result withTag:(NSUInteger)tag
{
    self.dataArray = (NSMutableArray *)result;
    
    if ([self.tableview.header isRefreshing]){
        [self.tableview.header endRefreshing];
    }

    [self.tableview reloadData];
}

#pragma mark - cell的代理

- (void)homelistCell:(UCFInvestMicroMoneyCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath
{
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.prdlist objectAtIndex:indexPath.row];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
        return;
    }
    
    if (model.modelType == UCFMicroMoneyModelTypeBatchBid) {
          [self gotoCollectionDetailViewContoller:model];
    }else{
        
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
           self.model = model;
            NSInteger isOrder = [model.isOrder integerValue];
            if ([model.status intValue ] != 2) {
                if (isOrder <= 0) {
                    return;
                }
            }
            if ([self checkUserCanInvestIsDetail:NO type:self.accoutType]) {
                
                [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
                NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
                NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@", model.Id,userid];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self Type:self.accoutType];
            }
    }
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
     if (tag.intValue == kSXTagPrdClaimsGetPrdBaseDetail){
        
        NSDictionary *dataDic = [dic objectSafeForKey:@"data"];
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode boolValue]) {
            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)self.model.prdLabelsList];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dataDic isTransfer:NO withLabelList:prdLabelsListTemp];
            CGFloat platformSubsidyExpense = [self.model.platformSubsidyExpense floatValue];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            controller.rootVc = self.rootVc;;
            controller.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
    else if (tag.intValue == kSXTagPrdClaimsDealBid){
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] integerValue] == 1)
        {
            if (self.accoutType == SelectAccoutTypeP2P) {
                NewPurchaseBidController *vc = [[NewPurchaseBidController alloc] init];
                vc.bidDetaiModel = [UCFBidModel yy_modelWithJSON:result];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
                purchaseViewController.rootVc = self.rootVc;
                purchaseViewController.dataDict = dic;
                purchaseViewController.bidType = 0;
                purchaseViewController.baseTitleType = @"detail_heTong";
                purchaseViewController.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:purchaseViewController animated:YES];
            }
            

            
        }else if ([dic[@"status"] integerValue] == 21 || [dic[@"status"] integerValue] == 22){
            [self checkUserCanInvestIsDetail:NO type:SelectAccoutTypeP2P];
        } else {
            if ([dic[@"status"] integerValue] == 15) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else if ([dic[@"status"] integerValue] == 19) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag =7000;
                [alert show];
            }else if ([dic[@"status"] integerValue] == 30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
                alert.tag = 9000;
                [alert show];
            }else if ([dic[@"status"] integerValue] == 40) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
                alert.tag = 9001;
                [alert show];
            }else {
                [AuxiliaryFunc showAlertViewWithMessage:dic[@"statusdes"]];
            }
        }
    }else if (tag.intValue == kSXTagColPrdclaimsDetail) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            
            UCFCollectionDetailViewController *collectionDetailVC = [[UCFCollectionDetailViewController alloc]initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
            collectionDetailVC.souceVC = @"P2PVC";
            collectionDetailVC.colPrdClaimId = _colPrdClaimIdStr;
            collectionDetailVC.detailDataDict = [dic objectSafeDictionaryForKey:@"data"];
            collectionDetailVC.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:collectionDetailVC  animated:YES];
            
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

- (void)newUserCell:(UCFNewUserCell *)newUserCell didClickedRegisterButton:(UIButton *)button withModel:(UCFHomeListCellModel *)model
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (nil == userId) {
        UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
        registerControler.sourceVC = @"fromHomeView";
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:registerControler] ;
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UINavigationController *nav = app.tabBarController.selectedViewController ;
        [nav presentViewController:loginNaviController animated:YES completion:nil];
        return;
    }
    else {
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
        NSString *url = NEWUSER_APPLY_URL;
        facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@", url, model.Id];
        facReservedWeb.navTitle = @"工场预约";
        [self.navigationController pushViewController:facReservedWeb animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
