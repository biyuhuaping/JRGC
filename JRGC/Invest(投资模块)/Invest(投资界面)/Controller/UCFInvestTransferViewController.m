//
//  UCFInvestTransferViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvestTransferViewController.h"
#import "UCFTransferHeaderView.h"
#import "UCFTransfeTableViewCell.h"
#import "UCFTransferModel.h"
#import "HSHelper.h"
#import "UCFToolsMehod.h"
#import "UCFNoPermissionViewController.h"
#import "RiskAssessmentViewController.h"
#import "UCFLoginViewController.h"
#import "UCFProjectDetailViewController.h"
@interface UCFInvestTransferViewController () <UITableViewDelegate, UITableViewDataSource, UCFTransferHeaderViewDelegate>
{
    NSInteger currentPage;
}
@property (strong, nonatomic) UCFTransferHeaderView *transferHeaderView;

@property (strong, nonatomic) NSMutableArray    *dataArray;
@property (copy, nonatomic) NSString *sortType;
@end

@implementation UCFInvestTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 设置界面
- (void)createUI {
    UCFTransferHeaderView *transferHeaderView = (UCFTransferHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFTransferHeaderView" owner:self options:nil] lastObject];
    transferHeaderView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth /16*5 + 105);
    self.tableview.tableHeaderView = transferHeaderView;
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    transferHeaderView.delegate = self;
    self.transferHeaderView = transferHeaderView;
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    __weak typeof(self) weakSelf = self;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadNetData];
    }];

    [self.tableview setSeparatorColor:[UIColor clearColor]];
//    [transferHeaderView initData];
    [self.tableview.header beginRefreshing];

}
- (void)initData
{
    self.sortType = @"";
    currentPage = 1;
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
}
#pragma mark - tableview 数据源
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeListCell";
    UCFTransfeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFTransfeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFTransfeTableViewCell" owner:self options:nil] lastObject];
    }
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UCFTransferModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else {
        if ([model.busType intValue] == 1) {
            self.accoutType = SelectAccoutTypeP2P;
        }else{//type 包括2 3，3为委托尊享标
            self.accoutType = SelectAccoutTypeHoner;
        }
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
        NSString *noPermissionTitleStr = self.accoutType == SelectAccoutTypeP2P ? @"目前标的详情只对出借人开放":@"目前标的详情只对认购人开放";
        if ([model.status integerValue] == 0 && [model.stopStatus intValue] != 0) {
            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:noPermissionTitleStr];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
            
            
            //            NSInteger status = [_transferModel.status integerValue];
            NSString *strParameters = [NSString stringWithFormat:@"tranid=%@&userId=%@",model.Id,[UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
            //            if (status == 0 && [_transferModel.stopStatus intValue] != 0) {
            //                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前债权转让的详情只对投资人开放"];
            //                [self.navigationController pushViewController:controller animated:YES];
            //            } else {
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdTransferDetail owner:self Type:self.accoutType];
            //            }
        }
    }

}
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
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
    
    if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[UserInfoSingle sharedManager].openStatus nav:self.navigationController];
        }
    }
    if (alertView.tag == 8010) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        }
    }
}


#pragma mark - tableview 代理

#pragma mark - header 代理
- (void)transferHeaderView:(UCFTransferHeaderView *)transferHeader didClickOrderButton:(UIButton *)orderBtn andIsIncrease:(BOOL)isUp
{
    switch (orderBtn.tag - 100) {
            // 利率 YES 升序 NO 降序
        case 0: {
            if (isUp) {
                DBLOG(@"利率  升序");
                self.sortType = @"32";
            }
            else {
                DBLOG(@"利率  降序");
                self.sortType = @"31";
            }
        }
            break;
            // 期限 YES 升序 NO 降序
        case 1: {
            if (isUp) {
                DBLOG(@"期限  升序");
                self.sortType = @"12";
            }
            else {
                DBLOG(@"期限  降序");
                self.sortType = @"11";
            }
        }
            break;
            // 金额 NO 升序 YES 降序
        case 2: {
            if (isUp) {
                DBLOG(@"金额  降序");
                self.sortType = @"21";
            }
            else {
                DBLOG(@"金额  升序");
                self.sortType = @"22";
            }
        }
            break;
    }
    [self refreshData];
}

#pragma mark NetWorkDelegate
- (void)refreshData
{
    currentPage = 1;
    if ([self.tableview.header isRefreshing]) {
        [self initData];
        [_transferHeaderView initData];
        [_transferHeaderView getNormalBannerData];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNetData];
    });
}
- (void)loadNetData
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSMutableDictionary *strParameters = [NSMutableDictionary dictionary];
    if (!uuid) {
        [strParameters setValue:@"" forKey:@"userId"];
    }
    else {
        [strParameters setValue:uuid forKey:@"userId"];
    }
    [strParameters setValue:self.sortType forKey:@"sortType"];
    [strParameters setValue:@"20" forKey:@"rows"];
    [strParameters setValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"page"];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagPrdTransferList owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagPrdTransferList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                NSString *oepnState =  [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"openStatus"];
                NSString *enjoyOpenStatus =  [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"zxOpenStatus"];
                [UserInfoSingle sharedManager].openStatus = [oepnState integerValue];
                [UserInfoSingle sharedManager].enjoyOpenStatus = [enjoyOpenStatus integerValue];
            }
            if (currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
//            if ([self.tableview.header isRefreshing]) {
//                [self.dataArray removeAllObjects];
//            }
            for (NSDictionary *dict in list_result) {
                UCFTransferModel *model = [UCFTransferModel transferWithDict:dict];
                [self.dataArray addObject:model];
            }
            
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            
            if (self.dataArray.count > 0) {
                self.tableview.footer.hidden = NO;
                if (!hasNext) {
                    [self.tableview.footer noticeNoMoreData];
                } else {
                    [self.tableview.footer resetNoMoreData];
                    currentPage++;
                }
            }
            [self.tableview reloadData];
        } else {
            [MBProgressHUD displayHudError:rsttext];
        }
    
    }else if (tag.intValue == kSXTagPrdTransferDetail) {
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = [dic objectSafeForKey:@"statusdes"];
        if ([rstcode intValue] == 1) {
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:YES withLabelList:nil];
            controller.sourceVc = @"transiBid";
            controller.rootVc = self.rootVc;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
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
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}
@end
