//
//  UCFP2PTransferViewController.m
//  JRGC
//
//  Created by NJW on 2016/11/17.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFP2PTransferViewController.h"
#import "UCFNoDataView.h"
#import "UCFToolsMehod.h"
#import "UCFProjectListCell.h"
#import "UCFTransferModel.h"
#import "UCFProjectDetailViewController.h"
#import "UCFPurchaseTranBidViewController.h"
#import "UCFNoPermissionViewController.h"
#import "UCFLoginViewController.h"
//#import "UCFBankDepositoryAccountViewController.h"
#import "UCFOldUserGuideViewController.h"
#import "HSHelper.h"
@interface UCFP2PTransferViewController () <UITableViewDataSource, UITableViewDelegate, UCFProjectListCellDelegate>
{
    UCFTransferModel *_transferModel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation UCFP2PTransferViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadP2PTransferData) name:@"reloadP2PTransferData" object:nil];
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
    [self.tableview.header beginRefreshing];
//    self.tableview.footer.hidden = YES;
    
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
    UCFTransferModel *model = [self.dataArray objectAtIndex:indexPath.row];
    model.isAnim = YES;
    cell.transferModel = model;
    cell.delegate = self;
    cell.type = UCFProjectListCellTypeTransfer;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
       if ([self checkUserCanInvestIsDetail:YES]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        //            _indexPath = indexPath;
        _transferModel = [self.dataArray objectAtIndex:[indexPath row]];
        NSInteger status = [_transferModel.status integerValue];
        NSString *strParameters = [NSString stringWithFormat:@"tranid=%@&userId=%@",_transferModel.Id,[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
        if (status != 0) {
            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前债权转让的详情只对投资人开放"];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdTransferDetail owner:self Type:SelectAccoutDefault];
         }
     }
  }
}
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
-(void)reloadP2PTransferData{
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
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"1", @"type", nil];
    }
    else {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"1", @"type", nil];
    }

    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagTransferList owner:self signature:YES Type:SelectAccoutTypeP2P];
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
    
    if (tag.intValue == kSXTagTransferList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in list_result) {
                //                DBLOG(@"%@", dict);
                UCFTransferModel *model = [UCFTransferModel transferWithDict:dict];
                model.isAnim = YES;
                [self.dataArray addObject:model];
            }
            
            [self.tableview reloadData];
            
            BOOL hasNext = [[[[[dic objectForKey:@"data"] objectForKey:@"pageData"] objectForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            
            if (self.dataArray.count > 0) {
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
    }  else if (tag.intValue == kSXTagPrdTransferDetail) {
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        if ([rstcode intValue] == 1) {
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:YES withLabelList:nil];
            controller.sourceVc = @"transiBid";
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }else if(tag.intValue == kSXTagDealTransferBid) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSString *rsttext = dic[@"statusdes"];
        if([dic[@"status"] integerValue] == 1)
        {
            UCFPurchaseTranBidViewController *purchaseViewController = [[UCFPurchaseTranBidViewController alloc] initWithNibName:@"UCFPurchaseTranBidViewController" bundle:nil];
            purchaseViewController.dataDict = dic;
            purchaseViewController.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:purchaseViewController animated:YES];
        } else if ([dic[@"status"] integerValue] == 3 || [dic[@"status"] integerValue] == 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 7000;
            [alert show];
        } else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
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

- (void)cell:(UCFProjectListCell*)cell clickInvestBtn1:(UIButton *)button withModel:(UCFTransferModel *)model
{
    if ([model.stopStatus intValue] != 0) {
        return;
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginNaviController animated:YES completion:nil];
    } else {
        if ([self checkUserCanInvestIsDetail:NO]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _transferModel = model  ;          //普通表
                NSString *strParameters = [NSString stringWithFormat:@"userId=%@&tranId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],_transferModel.Id];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagDealTransferBid owner:self Type:SelectAccoutDefault];
            }
      }
}
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    switch ([UserInfoSingle sharedManager].openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:@"请先开通徽商存管账户"];
            return NO;
            break;
        }
            
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:@"请先设置交易密码"];
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
        [self reloadP2PTransferData];
    } else if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
           HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
        
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadP2PTransferData" object:nil];
}
 @end
