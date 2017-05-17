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
#import "UCFNoPermissionViewController.h"
#import "UCFProjectDetailViewController.h"
#import "UCFLoginViewController.h"
#import "UCFPurchaseBidViewController.h"
#import "UCFBankDepositoryAccountViewController.h"
#import "UCFOldUserGuideViewController.h"
#import "HSHelper.h"
#import "RiskAssessmentViewController.h"
@interface UCFOrdinaryBidController () <UITableViewDelegate, UITableViewDataSource, UCFProjectListCellDelegate>
{
    UCFProjectListModel *_projectListModel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@property (nonatomic, assign) NSInteger currentPage;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@end

@implementation UCFOrdinaryBidController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    self.tableview.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
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
    [self.view bringSubviewToFront:_loadingView];
    [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:LoadingSecond];
}
-(void)removeLoadingView
{
    for (UIView *view in self.loadingView.subviews) {
        [view removeFromSuperview];
    }
    [self.loadingView removeFromSuperview];
    [self.tableview.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr1 = @"projectlist";
    UCFProjectListCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellStr1];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFProjectListCell" owner:self options:nil][0];
    }
    UCFProjectListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.type = UCFProjectListCellTypeProject;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
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
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
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
                //                DBLOG(@"%@", dict);
                UCFProjectListModel *model = [UCFProjectListModel projectListWithDict:dict];
                model.isAnim = YES;
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
    }else if (tag.intValue == kSXTagPrdClaimsDetail){
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        if ([rstcode intValue] == 1) {
            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)_projectListModel.prdLabelsList];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
            CGFloat platformSubsidyExpense = [_projectListModel.platformSubsidyExpense floatValue];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
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
            UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
            purchaseViewController.rootVc = self.parentViewController.parentViewController;
            purchaseViewController.dataDict = dic;
            purchaseViewController.bidType = 0;
            purchaseViewController.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:purchaseViewController animated:YES];
            
        }else if ([dic[@"status"] integerValue] == 21 || [dic[@"status"] integerValue] == 22){
            [self checkUserCanInvestIsDetail:NO];
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
        
        if ([self checkUserCanInvestIsDetail:YES]) {
            _projectListModel = [self.dataArray objectAtIndex:indexPath.row];
            NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
            NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@", _projectListModel.Id,userid];
            if ([_projectListModel.status intValue ] != 2) {
                NSInteger isOrder = [_projectListModel.isOrder integerValue];
                if (isOrder > 0) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:SelectAccoutDefault];
                } else {
                    UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对投资人开放"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            } else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:SelectAccoutDefault];
            }
        }
    }
}
- (void)cell:(UCFProjectListCell *)cell clickInvestBtn:(UIButton *)button withModel:(UCFProjectListModel *)model
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        HSHelper *helper = [HSHelper new];
        if (![helper checkP2POrWJIsAuthorization:self.accoutType]) {//先授权
            [helper pushP2POrWJAuthorizationType:self.accoutType nav:self.navigationController];
            return;
        }
        if ([self checkUserCanInvestIsDetail:NO]) {
            if ([model.status integerValue] != 2) {
                return;
            }
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _projectListModel = model;
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],_projectListModel.Id];
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self Type:SelectAccoutDefault];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
