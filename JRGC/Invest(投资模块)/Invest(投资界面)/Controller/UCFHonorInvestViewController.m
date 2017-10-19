//
//  UCFHonorInvestViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHonorInvestViewController.h"
#import "UCFHonorHeaderView.h"
#import "UCFHomeListHeaderSectionView.h"
#import "UCFHomeListCell.h"
#import "UCFProjectDetailViewController.h"
#import "UCFPurchaseBidViewController.h"
#import "UCFMicroMoneyModel.h"
#import "UCFNoDataView.h"
#import "UCFSettingGroup.h"
#import "HSHelper.h"
#import "UCFToolsMehod.h"
#import "UCFNoPermissionViewController.h"
#import "UCFLoginViewController.h"
#import "RiskAssessmentViewController.h"
#import "UCFInvestMicroMoneyCell.h"

@interface UCFHonorInvestViewController () <UITableViewDelegate, UITableViewDataSource,UCFInvestMicroMoneyCellDelegate>
@property (strong, nonatomic) UCFHonorHeaderView *honorHeaderView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic)  NSInteger currentPage;
// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (strong, nonatomic) UCFMicroMoneyModel *honerListModel;
@end

@implementation UCFHonorInvestViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - 设置界面
- (void)createUI {
    self.accoutType = SelectAccoutTypeHoner;
    UCFHonorHeaderView *honorHeaderView = (UCFHonorHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHonorHeaderView" owner:self options:nil] lastObject];
    honorHeaderView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/16*5+20);
    self.honorHeaderView = honorHeaderView;
    self.tableView.tableHeaderView = honorHeaderView;
    
    self.tableView.backgroundColor = UIColorWithRGB(0xebebee);
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) errorTitle:@"敬请期待..."];
    
    self.currentPage = 1;
    
    // 添加传统的下拉刷新
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getHonerInvestHTTPRequst)];
    // 添加上拉加载更多
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getHonerInvestHTTPRequst];
    }];
    
    self.tableView.footer.hidden = YES;
    [self.tableView.header beginRefreshing];

}
- (void)getHonerInvestHTTPRequst{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if ([self.tableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.tableView.footer resetNoMoreData];
        [self.honorHeaderView getNormalBannerData];
    }
    else if ([self.tableView.footer isRefreshing]) {
        self.currentPage ++;
    }
    
    if (uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"12", @"type", nil];
    }
    else {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"12", @"type", nil];
    }
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagProjectHonerPlanList owner:self signature:YES Type:SelectAccoutTypeHoner];
}

#pragma mark - tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFSettingGroup *group = [self.dataArray objectSafeAtIndex:section];
    return group.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.001;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* viewId = @"homeListHeader";
    UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
    }
    [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
    [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
    view.homeListHeaderMoreButton.hidden = YES;
    view.downView.hidden = YES;
    view.frame = CGRectMake(0, 0, ScreenWidth, 39);
    
    if (self.dataArray.count == 1) {
        view.headerTitleLabel.text =@"尊享优选";
         view.headerImageView.image = [UIImage imageNamed:@"mine_icon_enjoy"];
        view.honerLabel.hidden = NO;
        view.honerLineImageView.hidden = NO;
    }else{
        if(section == 0)
        {
            view.headerTitleLabel.text =@"新手专享";
            view.headerImageView.image = [UIImage imageNamed:@"mine_icon_new"];
        }else{
            view.headerTitleLabel.text =@"尊享优选";
            view.headerImageView.image = [UIImage imageNamed:@"mine_icon_enjoy"];
            view.honerLabel.hidden = NO;
            view.honerLineImageView.hidden = NO;
        }
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString* viewId = @"homeListFooter";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
    }
    view.contentView.backgroundColor = UIColorWithRGB(0xebebee);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"investmicromoney";
    UCFInvestMicroMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFInvestMicroMoneyCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFInvestMicroMoneyCell" owner:self options:nil] lastObject];
        cell.tableView = tableView;
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    UCFSettingGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.items objectAtIndex:indexPath.row];
    cell.honerListModel = model;
//    cell.type = UCFProjectListCellTypeProject;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


#pragma mark - tableview 代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else  {
        
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
        UCFSettingGroup *group = [self.dataArray objectAtIndex:indexPath.section];
        UCFMicroMoneyModel *model = [group.items objectAtIndex:indexPath.row];
        self.honerListModel = model;
        if ([model.status intValue ] != 2) {
            NSInteger isOrder = [model.isOrder integerValue];
            if (isOrder <= 0) {
                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
                [self.navigationController pushViewController:controller animated:YES];
                return;
            }
        }
        
        if ([self checkUserCanInvestIsDetail:YES])
        {
            NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
            NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@", model.Id,userid];
            if ([model.status intValue ] != 2) {
                NSInteger isOrder = [model.isOrder integerValue];
                if (isOrder > 0) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:self.accoutType];
                } else {
                    UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            } else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:self.accoutType];
            }
        }
    }
}
#pragma mark 认购点击事件
- (void)homelistCell:(UCFInvestMicroMoneyCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath{
    
    UCFSettingGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.items objectAtIndex:indexPath.row];
    
    if ([model.status integerValue]!=2) {
        return;
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else  {
        HSHelper *helper = [HSHelper new];
        
         //检查企业老用户是否开户--未开户去主站开户
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
        if ([model.status intValue ] != 2) {
            NSInteger isOrder = [model.isOrder integerValue];
            if (isOrder <= 0) {
                return;
            }
        }
        if ([self checkUserCanInvestIsDetail:NO]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.honerListModel= model;
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],model.Id];//101943
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self Type:self.accoutType];
        }
    }
}
#pragma mark -去登录页面
- (void)showLoginView
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    switch ([UserInfoSingle sharedManager].enjoyOpenStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:ZXTIP1];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:ZXTIP2];
                return NO;
            }
        }
            break;
        default:
            return YES;
            break;
    }
}- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 8000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7000) {
//        [self reloadHonerPlanData];
    } else if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        }
    } else if (alertView.tag == 9000) {
        if(buttonIndex == 1){ //测试
            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            vc.accoutType = SelectAccoutTypeHoner;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -网络请求开始
//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
}
#pragma mark -网络请求结果
//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagProjectHonerPlanList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
        
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            BOOL isShowNew = [dataDict isExistenceforKey:@"newPrdClaim"];
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                //此时openStatus为尊享的开户状态
                NSString *oepnState =  [dataDict objectSafeForKey:@"openStatus"];
                [UserInfoSingle sharedManager].enjoyOpenStatus = [oepnState integerValue];
            }
            
            if ([self.tableView.header isRefreshing]) {//每次刷新初始化状态
                [self.dataArray removeAllObjects];
                if (isShowNew) {
                    UCFSettingGroup *group1 = [[UCFSettingGroup alloc]init];
                    group1.items = [NSMutableArray arrayWithCapacity:0];;
                    [self.dataArray addObject:group1];
                    UCFSettingGroup *group2 = [[UCFSettingGroup alloc]init];
                    group2.items = [NSMutableArray arrayWithCapacity:0];
                    [self.dataArray addObject:group2];
                }else{
                    UCFSettingGroup *group1 = [[UCFSettingGroup alloc]init];
                    group1.items = [NSMutableArray arrayWithCapacity:0];;
                    [self.dataArray addObject:group1];
                }
            }

            if (self.currentPage == 1) {
                
                if (self.dataArray.count == 2) {
                    UCFSettingGroup *group1 = [self.dataArray firstObject];
                    UCFSettingGroup *group2 = [self.dataArray lastObject];
                    [group1.items removeAllObjects];
                    [group2.items removeAllObjects];
                    UCFMicroMoneyModel *model = [UCFMicroMoneyModel microMoneyModelWithDict:[dataDict objectSafeDictionaryForKey:@"newPrdClaim"]];
                    
                    [group1.items addObject:model];
                    for (NSDictionary *dict in list_result) {
                        
                        UCFProjectListModel *model = [UCFProjectListModel projectListWithDict:dict];
                        model.isAnim = YES;
                        [group2.items addObject:model];
                    }
                }else{
                    UCFSettingGroup *group1 = [self.dataArray firstObject];
                    [group1.items removeAllObjects];
                    for (NSDictionary *dict in list_result) {
                        
                        UCFProjectListModel *model = [UCFProjectListModel projectListWithDict:dict];
                        model.isAnim = YES;
                        [group1.items addObject:model];
                    }
                }
            }else{
                if (self.dataArray.count == 1) {
                     UCFSettingGroup *group1 = [self.dataArray firstObject];
                    for (NSDictionary *dict in list_result) {
                        UCFProjectListModel *model = [UCFProjectListModel projectListWithDict:dict];
                        model.isAnim = YES;
                        [group1.items addObject:model];
                    }
                }else{
                    UCFSettingGroup *group1 = [self.dataArray lastObject];
                    for (NSDictionary *dict in list_result) {
                        UCFProjectListModel *model = [UCFProjectListModel projectListWithDict:dict];
                        model.isAnim = YES;
                        [group1.items addObject:model];
                    }
                }
            }
            [self.tableView reloadData];
            
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            
            if (self.dataArray.count >0) {
                self.tableView.footer.hidden = NO;
                [self.noDataView hide];
                if (!hasNext) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            else {
                [self.noDataView showInView:self.tableView];
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        if ([self.tableView.header isRefreshing]) {
            [self.tableView.header endRefreshing];
        }
        if ([self.tableView.footer isRefreshing]) {
            [self.tableView.footer endRefreshing];
        }
    }else if (tag.intValue == kSXTagPrdClaimsDetail){
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        if ([rstcode intValue] == 1) {
            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)self.honerListModel.prdLabelsList];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
            CGFloat platformSubsidyExpense = [self.honerListModel.platformSubsidyExpense floatValue];
            controller.accoutType = self.accoutType;
            controller.rootVc = self.rootVc;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }else if (tag.intValue == kSXTagPrdClaimsDealBid){
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] integerValue] == 1)
        {
            UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
            purchaseViewController.rootVc = self.rootVc;
            purchaseViewController.dataDict = dic;
            purchaseViewController.bidType = 0;
            purchaseViewController.baseTitleType = @"detail_heTong";
            purchaseViewController.accoutType = self.accoutType;
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
            } else if ([dic[@"status"] integerValue] == 30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
                alert.tag =9000;
                [alert show];
                
            }
            else {
                [AuxiliaryFunc showAlertViewWithMessage:dic[@"statusdes"]];
            }
        }
    }
}
#pragma mark -网络请求失败处理
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}


@end
