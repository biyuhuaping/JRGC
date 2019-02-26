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
#import "UCFBannerViewModel.h"
#import "BaseTableViewCell.h"
#import "UCFOldUserNoticeCell.h"
#import "UCFNewProjectDetailViewController.h"
#import "UCFHomeViewModel.h"
#import "HSHelper.h"
#import "RiskAssessmentViewController.h"
#import "InvestPageInfoApi.h"
#import "UCFBidModel.h"
#import "UCFBatchInvestmentViewController.h"
#import "NewPurchaseBidController.h"
#import "UCFFacReservedViewController.h"
#import "UCFBidDetailRequest.h"
#import "UCFBidDetailAndInvestPageLogic.h"
@interface UCFNewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,YTKRequestDelegate,HomeHeadCycleViewDelegate,BaseTableViewCellDelegate>
@property(nonatomic, strong)HomeHeadCycleView *homeHeadView;
@property(nonatomic, strong)UCFHomeViewModel  *homeListViewModel;
@property(nonatomic, strong)UCFBannerViewModel*bannerViewModel;

@property(nonatomic, strong)BaseTableView     *showTableView;
@property(nonatomic, strong)NSMutableArray    *dataArray;
@end

@implementation UCFNewHomeViewController
- (void)loadView
{
    [super loadView];
    
    HomeHeadCycleView *homeHeadView = [HomeHeadCycleView new];
    homeHeadView.myTop = 0;
    homeHeadView.myHeight = ((([[UIScreen mainScreen] bounds].size.width - 54) * 9)/16);
    homeHeadView.myHorzMargin = 0;
    [homeHeadView createSubviews];
    homeHeadView.delegate = self;
    self.homeHeadView = homeHeadView;
    
    self.showTableView.myVertMargin = 0;
    self.showTableView.myHorzMargin = 0;
    [self.rootLayout addSubview:self.showTableView];
    self.showTableView.backgroundColor = [UIColor clearColor];
    self.showTableView.tableHeaderView = self.homeHeadView;
    
    HomeFootView *homefootView = [HomeFootView new];
    homefootView.myHeight = 181;
    homefootView.myHorzMargin = 0;
    [homefootView createSubviews];
    self.showTableView.tableFooterView = homefootView;
    [self addLeftButtonTitle:@"首页"];
    [self addrightButtonWithImageArray:[NSArray arrayWithObjects:@"home_icon_gift",@"home_icon_news", nil]];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self blindVM];
    [self fetchData];
}

- (void)blindVM
{
    self.bannerViewModel = [UCFBannerViewModel new];
    self.homeListViewModel = [UCFHomeViewModel new];
    self.homeListViewModel.loaingSuperView = self.view;
    self.bannerViewModel.rootViewController = self;
    [self.homeHeadView showView:_bannerViewModel];
    [self showView:_homeListViewModel];
}
- (void)showView:(UCFHomeViewModel *)viewModel
{
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"modelListArray",] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"modelListArray"]) {
            NSArray *modelListArray = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (modelListArray.count > 0) {
                selfWeak.dataArray = [NSMutableArray arrayWithArray:modelListArray];
                [selfWeak.showTableView reloadData];
            }
        }
    }];
}
- (void)fetchData
{
    
    [self.homeListViewModel fetchNetData];
    [self.bannerViewModel fetchNetData];
}
#pragma BaseTableViewDelegate
- (void)refreshTableViewHeader
{
    [_showTableView endRefresh];
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
        NSArray *sectionArr = self.dataArray[section];
        CellConfig *data = sectionArr[0];
        if (data) {
            sectionView.titleLab.text = data.title;
        }
        return sectionView;
    } else {
        return nil;
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

    /*
    
    if ([config.dataModel isKindOfClass:[UCFNewHomeListPrdlist class]]) {
        if (!SingleUserInfo.loginData.userInfo.userId) {
            [SingleUserInfo loadLoginViewController];
            return;
        }
        
        UCFNewHomeListPrdlist *model = config.dataModel;
        NSInteger type = [model.type integerValue];
        if (type == 1 || type == 14) {
                HSHelper *helper = [HSHelper new];
                NSString *messageStr =  [helper checkCompanyIsOpen:SelectAccoutTypeP2P];
                if (![messageStr isEqualToString:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                if(type == 14)
                { //集合标详情
                    [self gotoCollectionDetailViewContoller:model];
                }
                else
                {
                    @PGWeakObj(self);
                    NSInteger step = SingleUserInfo.loginData.userInfo.openStatus;
                    if (step == 1 || step == 2) {
                        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:P2PTIP1 cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
                            if (index == 1) {
                                HSHelper *helper = [HSHelper new];
                                
                                [helper pushOpenHSType:SelectAccoutTypeP2P Step:step nav:selfWeak.navigationController];
                            }
                        } otherButtonTitles:@"确认"];
                        [alert show];
                        return;
                    }
//                    查看标详情
                    UCFBidDetailRequest *api = [[UCFBidDetailRequest alloc] initWithProjectId:model.ID bidState:model.status];
                    api.animatingView = self.view;
                    
                    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        UCFBidDetailModel *model =  request.responseJSONModel;
                        NSString *message = model.message;
                        if (model.ret) {
                            UCFNewProjectDetailViewController *vc = [[UCFNewProjectDetailViewController alloc] init];
                            vc.model = model;
                            vc.accoutType = SelectAccoutTypeP2P;
                            vc.hidesBottomBarWhenPushed = YES;
                            [selfWeak.navigationController pushViewController:vc animated:YES];
                        } else {
                            [AuxiliaryFunc showAlertViewWithMessage:message];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                    }];
                    [api start];
                 }
            
            
        } else if (type == 0 || type == 3) { //0预约宝 3智存宝
            self.accoutType = SelectAccoutTypeP2P;
            BOOL b = [self checkUserCanInvestIsDetail:NO type:self.accoutType];
            if (!b) {
                return;
            }
            if (!SingleUserInfo.loginData.userInfo.isAutoBid) {
                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                batchInvestment.isStep = 1;
                batchInvestment.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:batchInvestment animated:YES];
                return;
            }
            if (!SingleUserInfo.loginData.userInfo.isRisk) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                self.accoutType = SelectAccoutTypeP2P;
                alert.tag =  9000;
                [alert show];
                return;
            }
            UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
            if ([model.groupType  isEqualToString:@"1"]) {
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", NEWUSER_PRODUCTS_URL, model.ID,model.status];
            }
            else if (type == 0) {//预约宝
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", RESERVEDETAIL_APPLY_URL, model.ID,model.status];
            }else if(type == 3) {//智存宝
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", INTELLIGENTDETAIL_APPLY_URL, model.ID,model.status];
            }
            [self.navigationController pushViewController:facReservedWeb animated:YES];
        }
    }
     */
}
#pragma mark BaseTableViewCellDelegate
- (void)baseTableViewCell:(BaseTableViewCell *)cell buttonClick:(UIButton *)button withModel:(id)model
{
    if (model) {
        [UCFBidDetailAndInvestPageLogic bidDetailAndInvestPageLogicUseDataModel:model detail:NO rootViewController:self];
    }
    /*
    if ([model isKindOfClass:[UCFNewHomeListPrdlist class]]) {
        if (!SingleUserInfo.loginData.userInfo.userId) {
            [SingleUserInfo loadLoginViewController];
            return;
        }
        UCFNewHomeListPrdlist *tmpModel =  (UCFNewHomeListPrdlist *)model;
        NSInteger type = [tmpModel.type integerValue];
        if (type  == 1 || type == 14) { //14 集合标  1 p2p散标

            HSHelper *helper = [HSHelper new];
            NSString *messageStr =  [helper checkCompanyIsOpen:SelectAccoutTypeP2P];
            if (![messageStr isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
                return;
            }
            if (type == 14) {
                [self gotoCollectionDetailViewContoller:tmpModel];
            } else {
                if ([tmpModel.status intValue ] != 2){
                    return;
                }
                if([self checkUserCanInvestIsDetail:NO type:SelectAccoutTypeP2P]){//
                    @PGWeakObj(self);
                    
                    InvestPageInfoApi *api = [[InvestPageInfoApi alloc] initWithProjectId:tmpModel.ID type:SelectAccoutTypeP2P];
                    api.animatingView = self.view;
                    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [selfWeak dealInvestInfoData:model];
                        
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                    }];
                    [api start];
                }
            }
        }else if (type == 0 || type == 3) {   // 0 预约宝 3智存宝
            self.accoutType = SelectAccoutTypeP2P;
            BOOL b = [self checkUserCanInvestIsDetail:NO type:self.accoutType];
            if (!b) {
                return;
            }
            if (!SingleUserInfo.loginData.userInfo.isRisk) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                self.accoutType = SelectAccoutTypeP2P;
                alert.tag =  9000;
                [alert show];
                return;
            }
            if (!SingleUserInfo.loginData.userInfo.isAutoBid) {
                UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                batchInvestment.isStep = 1;
                batchInvestment.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:batchInvestment animated:YES];
                return;
            }
            UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
            if ([tmpModel.groupType isEqualToString:@"1"]) {
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", NEWUSER_APPLY_URL, tmpModel.ID,tmpModel.status];
            } else {
                facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", PRERESERVE_APPLY_URL, tmpModel.ID,tmpModel.status];
            }
            [self.navigationController pushViewController:facReservedWeb animated:YES];
        }
    }
     */
}
- (void)homeViewDataBidClickModel:(UCFNewHomeListModel *)model type:(UCFNewHomeListType)type
{
    
}
#pragma mark HomeHeadCycleViewDelegate
- (void)homeHeadCycleView:(HomeHeadCycleView *)cycleView didSelectIndex:(NSInteger)index
{
    
}
- (void)userGuideCellClickButton:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"注册领券"]) {
        
    } else if ([title isEqualToString:@"存管开户"]) {
        
    } else if ([title isEqualToString:@"风险评测"]) {
        
    } else if ([title isEqualToString:@"新人专享"]) {
        
    } else {
        
    }
}

//- (void)dealInvestInfoData:(UCFBidModel *)model
//{
//    NSInteger code = model.code;
//    NSString *message = model.message;
//    if (model.ret) {
//        NewPurchaseBidController *vc = [[NewPurchaseBidController alloc] init];
//        vc.bidDetaiModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if (code == 21 || code == 22){
//        //        [self checkUserCanInvest];
//    } else if (code == 15) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//    } else if (code == 19) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
//        alert.tag =7000;
//        [alert show];
//    } else if (code == 30) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
//        alert.tag = 9000;
//        [alert show];
//    }else if (code == 40) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
//        alert.tag = 9001;
//        [alert show];
//    } else {
//        [MBProgressHUD displayHudError:model.message withShowTimes:3];
//    }
//}
//#pragma mark - 去批量投资集合详情
//-(void)gotoCollectionDetailViewContoller:(UCFNewHomeListPrdlist *)model{
    /*
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    self.accoutType = SelectAccoutTypeP2P;
    __weak typeof(self) weakSelf = self;
    if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
        NSString  *colPrdClaimIdStr = [NSString stringWithFormat:@"%@",model.Id];
        NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", colPrdClaimIdStr, @"colPrdClaimId",model.status,@"status", nil];
        [self.cycleImageVC.presenter fetchCollectionDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
            [MBProgressHUD hideOriginAllHUDsForView:weakSelf.view animated:YES];
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
     */
//}
//- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail type:(SelectAccoutType)accout;
//{
//
//    NSString *tipStr1 = P2PTIP1;
//    NSString *tipStr2 = P2PTIP2;
//
//    NSInteger openStatus = SingleUserInfo.loginData.userInfo.openStatus;
//
//    switch (openStatus)
//    {// ***hqy添加
//        case 1://未开户-->>>新用户开户
//        case 2://已开户 --->>>老用户(白名单)开户
//        {
//            [self showHSAlert:tipStr1];
//            return NO;
//            break;
//        }
//        case 3://已绑卡-->>>去设置交易密码页面
//        {
//            if (isDetail) {
//                return YES;
//            }else
//            {
//                [self showHSAlert:tipStr2];
//                return NO;
//            }
//        }
//            break;
//        default:
//            return YES;
//            break;
//    }
//}
//- (void)showHSAlert:(NSString *)alertMessage
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    alert.tag =  8000;
//    [alert show];
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (alertView.tag == 8000) {
//        if (buttonIndex == 1) {
//            HSHelper *helper = [HSHelper new];
//            [helper pushOpenHSType:SelectAccoutTypeP2P Step:SingleUserInfo.loginData.userInfo.openStatus nav:self.navigationController];
//        }
//    }
//    else if (alertView.tag == 9000) {
//        if(buttonIndex == 1){ //测试
//            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
//            vc.accoutType = self.accoutType;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
//}

@end
