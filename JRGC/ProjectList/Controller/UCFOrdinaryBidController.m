//
//  UCFOrdinaryBidController.m
//  JRGC
//
//  Created by njw on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFOrdinaryBidController.h"
#import "UCFNoDataView.h"
#import "UCFToolsMehod.h"
#import "UCFProjectListCell.h"
#import "UCFProjectListModel.h"
#import "UCFMicroMoneyModel.h"
#import "UCFNoPermissionViewController.h"
#import "UCFProjectDetailViewController.h"
#import "UCFLoginViewController.h"
#import "UCFPurchaseBidViewController.h"
#import "UCFBankDepositoryAccountViewController.h"
#import "UCFOldUserGuideViewController.h"
#import "HSHelper.h"
#import "RiskAssessmentViewController.h"
//#import "UCFHonorHeaderView.h"
#import "UCFHomeListCell.h"
#import "NewPurchaseBidController.h"
#import "UCFInvestTableViewCell.h"
@interface UCFOrdinaryBidController () <UITableViewDelegate, UITableViewDataSource, UCFProjectListCellDelegate,UCFHomeListCellHonorDelegate>
{
    UCFMicroMoneyModel *_microMoneyModel;
}


@property (nonatomic, strong) NSMutableArray *dataArray;

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@property (nonatomic, assign) NSInteger currentPage;
@property (strong, nonatomic) IBOutlet UIView *loadingView;

//@property (strong, nonatomic) UCFHonorHeaderView *ordinaryHeaderView;
@end

@implementation UCFOrdinaryBidController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    baseTitleLabel.text = @"微金项目";
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
//    UCFHonorHeaderView *honorHeaderView = (UCFHonorHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHonorHeaderView" owner:self options:nil] lastObject];
//    honorHeaderView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/16*5+10);
//    self.ordinaryHeaderView = honorHeaderView;
//    self.tableview.tableHeaderView = honorHeaderView;

    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) errorTitle:@"暂无数据"];
    
    self.currentPage = 1;
    // 添加上拉加载更多
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getNetDataFromNet];
    }];
    
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNetDataFromNet)];
    self.tableview.footer.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadP2PData) name:@"reloadP2PData" object:nil];
    
     [self.tableview.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *cellId = @"homeListCell";
    UCFInvestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell =  [[UCFInvestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
//    cell.tableView = tableView;
//    cell.indexPath = indexPath;
//    cell.honorDelegate = self;
//
//    UCFMicroMoneyModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    cell.microMoneyModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
-(void)reloadP2PData{
    [self.tableview.header beginRefreshing];
}
- (void)getNetDataFromNet{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if ([self.tableview.header isRefreshing]) {
        self.currentPage = 1;
        [self.tableview.footer resetNoMoreData];
    }
    else if ([self.tableview.footer isRefreshing]) {
        self.currentPage ++;
    }
    
    if (uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"11", @"type", nil];
    }
    else {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"11", @"type", nil];
    }
    
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagProjectList owner:self signature:YES Type:SelectAccoutTypeP2P];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DDDLogDebugDebug(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagProjectList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                [UserInfoSingle sharedManager].openStatus = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"openStatus"] integerValue];
            }
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in list_result) {
                //                DDDLogDebugDebug(@"%@", dict);
                UCFMicroMoneyModel *model = [UCFMicroMoneyModel microMoneyModelWithDict:dict];
//                model.isAnim = YES;
                model.modelType =  UCFMicroMoneyModelTypeNormal;
                [self.dataArray addObject:model];
            }
            
            [self.tableview reloadData];
            
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            
            if (self.dataArray.count > 0) {
                self.tableview.footer.hidden = NO;
                [self.noDataView hide];
                if (!hasNext) {
                    [self.tableview.footer noticeNoMoreData];
                }
            }
            else {
                [self.noDataView showInView:self.tableview];
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }else if (tag.intValue == kSXTagPrdClaimsGetPrdBaseDetail){
        NSDictionary *dataDic = [dic objectSafeForKey:@"data"];
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)_microMoneyModel.prdLabelsList];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dataDic isTransfer:NO withLabelList:prdLabelsListTemp];
            CGFloat platformSubsidyExpense = [_microMoneyModel.platformSubsidyExpense floatValue];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
            controller.rootVc = self.rootVc;
            controller.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
    else if (tag.intValue == kSXTagP2PPrdClaimsDealBid){
        UCFBidModel *model = [UCFBidModel yy_modelWithJSON:result];
        NSInteger code= model.code;
        NSString *message = model.message;
        if (model.ret) {
            NewPurchaseBidController *vc = [[NewPurchaseBidController alloc] init];
            vc.bidDetaiModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (code == 21 || code == 22){
            [self checkUserCanInvestIsDetail:NO];
        } else {
            if (code== 15) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else if (code == 19) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag =7000;
                [alert show];
            }else if (code == 30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
                alert.tag = 9000;
                [alert show];
            }else if (code == 40) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
                alert.tag = 9001;
                [alert show];
            } else {
            [MBProgressHUD displayHudError:model.message withShowTimes:3];
        }
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        HSHelper *helper = [HSHelper new];
        if (![helper checkP2POrWJIsAuthorization:self.accoutType]) {//先授权
            [helper pushP2POrWJAuthorizationType:self.accoutType nav:self.navigationController];
            return;
        }
        
        _microMoneyModel = [self.dataArray objectAtIndex:indexPath.row];
        NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
//        NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@", _projectListModel.Id,userid];
        NSInteger isOrder = [_microMoneyModel.isOrder integerValue];
        NSString *prdClaimsIdStr = [NSString stringWithFormat:@"%@",_microMoneyModel.Id];
        NSDictionary *praramDic = @{@"userId":userid,@"prdClaimsId":prdClaimsIdStr};
  
        if ([_microMoneyModel.status intValue ] != 2) {
            if (isOrder <= 0) {
                NSString *titleStr = [UserInfoSingle sharedManager].isSubmitTime ? @"目前标的详情只对购买人开放":@"目前标的详情只对出借人开放";
                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:titleStr];
                [self.navigationController pushViewController:controller animated:YES];
                return;
            }
        }
        if ([self checkUserCanInvestIsDetail:YES]) {
            if ([_microMoneyModel.status intValue ] != 2) {
                if (isOrder > 0) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdBaseDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
                }
            }else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdBaseDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
          
            }
        }
    }
}
-(void)homelistCell:(UCFHomeListCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath
//{

//}
//- (void)cell:(UCFProjectListCell *)cell clickInvestBtn:(UIButton *)button withModel:(UCFProjectListModel *)model
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        UCFMicroMoneyModel *model = [self.dataArray objectAtIndex:indexPath.row];
        HSHelper *helper = [HSHelper new];
        if (![helper checkP2POrWJIsAuthorization:self.accoutType]) {//先授权
            [helper pushP2POrWJAuthorizationType:self.accoutType nav:self.navigationController];
            return;
        }
        _microMoneyModel = model;
  
        NSInteger isOrder = [_microMoneyModel.isOrder integerValue];
        if ([_microMoneyModel.status intValue ] != 2) {
            if (isOrder <= 0) {
                return;
            }
        }
        if ([self checkUserCanInvestIsDetail:NO]) {
            
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
//            NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@", _microMoneyModel.Id,userid];
//            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagP2PPrdClaimsDealBid owner:self Type:SelectAccoutDefault];
            
            NSDictionary *paraDict = @{
                                       @"id":_microMoneyModel.Id,
                                       @"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],
                                       };
            [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:kSXTagP2PPrdClaimsDealBid owner:self signature:YES Type:SelectAccoutTypeP2P];
        }
    }
}
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    switch ([UserInfoSingle sharedManager].openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:P2PTIP1];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:P2PTIP2];
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
    alert.tag = 8000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7000) {
        [self reloadP2PData];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadP2PData" object:nil];
}
@end
