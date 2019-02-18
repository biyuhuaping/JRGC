//
//  UCFBatchBidController.m
//  JRGC
//
//  Created by njw on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBatchBidController.h"
#import "UCFNoDataView.h"
#import "UCFProjectListCell.h"
#import "UCFCollectionDetailViewController.h"

#import "UCFBatchBidModel.h"
#import "UCFOldUserGuideViewController.h"
#import "UCFBankDepositoryAccountViewController.h"
#import "UCFLoginViewController.h"
#import "HSHelper.h"
@interface UCFBatchBidController () <UITableViewDataSource, UITableViewDelegate, UCFProjectListCellDelegate>
{
    NSString *_colPrdClaimIdStr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (nonatomic, assign) NSInteger currentPage;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@end

@implementation UCFBatchBidController

#pragma mark - lazy upload data source
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
#pragma mark - setting UI
    baseTitleLabel.text = @"一键投标";
    [self addLeftButton];
    // setting tableview style
    [self settingTableViewStyle];
    // add nodata view
    [self addNoDataView];
    // add refreshing and load more
    [self addRefreshingAndLoadMore];
//    [self.tableview.header beginRefreshing];
//显示loading页面
//    [self.view bringSubviewToFront:_loadingView];
//    [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:LoadingSecond];
    
//隐藏loading页面
    [self.view sendSubviewToBack:_loadingView];
    _loadingView.hidden = YES;
    [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0];
}
-(void)removeLoadingView
{
    for (UIView *view in self.loadingView.subviews) {
        [view removeFromSuperview];
    }
    [self.loadingView removeFromSuperview];
    [self.tableview.header beginRefreshing];
}
#pragma mark - setting tableview
- (void)settingTableViewStyle
{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    self.tableview.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    self.tableview.footer.hidden = YES;
}

#pragma mark - add nodata view
- (void)addNoDataView {
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) errorTitle:@"暂无数据"];
}

#pragma mark - add refresh and load more
- (void)addRefreshingAndLoadMore
{
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加上拉加载更多
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getNetDataFromNet];
    }];
    self.currentPage = 1;
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNetDataFromNet)];
    self.tableview.footer.hidden = YES;
}

#pragma mark - tableView method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr1 = @"projectlist";
    UCFProjectListCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellStr1];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFProjectListCell" owner:self options:nil][0];
    }
    UCFBatchBidModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.batchBidModel = model;
    cell.delegate = self;
    cell.type = UCFProjectListCellTypeBatchBid;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCFBatchBidModel *model = [self.dataArray objectAtIndex:indexPath.row];
      [self  gotoCollectionDetailVC:model];
    
}
-(void)cell:(UCFProjectListCell *)cell clickInvestBtn2:(UIButton *)button withModel:(UCFBatchBidModel *)model
{
    if (model.full || model.canBuyAmt.integerValue == 0) {
        return;
    }
    [self  gotoCollectionDetailVC:model];
 
}
-(void)gotoCollectionDetailVC:(UCFBatchBidModel *)model{
    
    if (!SingleUserInfo.loginData.userInfo.userId) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
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
        if ([self checkUserCanInvestIsDetail:YES]) {
            
            NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
            NSDictionary *strParameters;
            _colPrdClaimIdStr = [NSString stringWithFormat:@"%@",model.batchBidId];
            strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", _colPrdClaimIdStr, @"colPrdClaimId", nil];
            [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagColPrdclaimsDetail owner:self signature:YES Type:SelectAccoutTypeP2P] ;
        }
    }
}

#pragma mark - net request
- (void)getNetDataFromNet
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if ([self.tableview.header isRefreshing]) {
        self.currentPage = 1;
        [self.tableview.footer resetNoMoreData];
    }
    if (uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", nil];
    }
    else {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", nil];
    }
    
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagProjectListBatchBid owner:self signature:YES Type:SelectAccoutTypeP2P];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
    if(tag == kSXTagColPrdclaimsDetail){
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DDDLogDebugDebug(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagProjectListBatchBid) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            self.currentPage ++;
            for (NSDictionary *dict in list_result) {
                UCFBatchBidModel *model = [UCFBatchBidModel batchWithDict:dict];
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
    }else if (tag.intValue == kSXTagColPrdclaimsDetail) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
           
            UCFCollectionDetailViewController *collectionDetailVC = [[UCFCollectionDetailViewController alloc]initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
            collectionDetailVC.souceVC = @"P2PVC";
            collectionDetailVC.colPrdClaimId = _colPrdClaimIdStr;
            collectionDetailVC.detailDataDict = [dic objectSafeDictionaryForKey:@"data"];
            collectionDetailVC.rootVc = self;
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
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    switch (SingleUserInfo.loginData.userInfo.openStatus)
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
        [self reloadBatchBidData];
    } else if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:SingleUserInfo.loginData.userInfo.openStatus nav:self.navigationController];
        }
    }
}
-(void)reloadBatchBidData{
    [self.tableview.header beginRefreshing];
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

@end
