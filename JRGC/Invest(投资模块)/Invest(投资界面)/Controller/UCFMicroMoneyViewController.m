//
//  UCFMicroMoneyViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMicroMoneyViewController.h"
#import "UCFMicroMoneyHeaderView.h"

#import "UCFHomeListHeaderSectionView.h"
#import "UCFHomeListCell.h"

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
@interface UCFMicroMoneyViewController () <UITableViewDataSource, UITableViewDelegate, UCFInvestAPIWithMicroMoneyManagerDelegate, UCFHomeListCellHonorDelegate,UCFHomeListHeaderSectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - 设置界面
- (void)createUI {
    self.accoutType = SelectAccoutTypeP2P;
    UCFMicroMoneyHeaderView *microMoneyHeaderView = (UCFMicroMoneyHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMicroMoneyHeaderView" owner:self options:nil] lastObject];
    microMoneyHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 120);
    self.tableview.tableHeaderView = microMoneyHeaderView;
    self.microMoneyHeaderView = microMoneyHeaderView;
    
    //=========  下拉刷新、上拉加载更多  =========
//    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) errorTitle:@"敬请期待..."]
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.header beginRefreshing];
    });
    
    UCFInvestAPIManager *apiManager = [[UCFInvestAPIManager alloc] init];
    apiManager.microMoneyDelegate = self;
    self.apiManager = apiManager;
    [apiManager getMicroMoneyFromNet];
}
-(void)reloadData{
   [ self.apiManager getMicroMoneyFromNet];
}

#pragma mark - tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
    return group.prdlist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
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
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:section];
    view.headerTitleLabel.text = group.title;
    if (group.desc) {
        view.honerLabel.hidden = NO;
        view.honerLabel.text = group.desc;
        view.honerLineImageView.hidden = NO;
    }else{
        view.honerLabel.hidden = YES;
        view.honerLineImageView.hidden = YES;
    }
    [view.headerImageView sd_setImageWithURL:[NSURL URLWithString:group.iconUrl]];
    view.homeListHeaderMoreButton.hidden = !group.showMore;
    [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
    [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
    [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    view.delegate = self;
    view.frame = CGRectMake(0, 0, ScreenWidth, 30);
    return view;
}
- (void)homeListHeader:(UCFHomeListHeaderSectionView *)homeListHeader didClickedMoreWithType:(NSString *)type{
    if ([homeListHeader.headerTitleLabel.text isEqualToString:@"一键投标"]) {
        UCFBatchBidController *batchBidVc = [[UCFBatchBidController alloc]initWithNibName:@"UCFBatchBidController" bundle:nil];
        batchBidVc.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:batchBidVc animated:YES];
    }else{
        UCFOrdinaryBidController *ordinaryBidVC = [[UCFOrdinaryBidController alloc]initWithNibName:@"UCFOrdinaryBidController" bundle:nil];
        ordinaryBidVC.accoutType = SelectAccoutTypeP2P;
        [self.navigationController pushViewController:ordinaryBidVC animated:YES];
        
    }    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeListCell";
    UCFHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFHomeListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListCell" owner:self options:nil] lastObject];
        cell.tableView = tableView;
        cell.honorDelegate = self;
    }
    cell.indexPath = indexPath;
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.prdlist objectAtIndex:indexPath.row];
    if ([group.type isEqualToString:@"13"]) {
        model.modelType = UCFMicroMoneyModelTypeNew;
    }
    else if ([group.type isEqualToString:@"14"]) {
        model.modelType = UCFMicroMoneyModelTypeBatchBid;
    }
    else if ([group.type isEqualToString:@"11"]) {
        model.modelType = UCFMicroMoneyModelTypeNormal;
    }
    cell.microMoneyModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark - tableview 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFMicroMoneyGroup *group = [self.dataArray objectAtIndex:indexPath.section];
    UCFMicroMoneyModel *model = [group.prdlist objectAtIndex:indexPath.row];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        //如果未登录，展示登录页面
        [self showLoginView];
        return;
    }
    
    if (model.modelType == UCFMicroMoneyModelTypeBatchBid ) {//批量出借标
        [self gotoCollectionDetailViewContoller:model];
    }else {//新手标 或普通标
                self.model = model;
                if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
                    NSString *userid = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
                    NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@",model.Id,userid];
                    NSInteger isOrder = [model.isOrder integerValue];
                    if ([model.status intValue ] != 2) {
                        if (isOrder <= 0) {
                            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对投资人开放"];
                            [self.navigationController pushViewController:controller animated:YES];
                            return;
                        }
                    }
                    if ([self checkUserCanInvestIsDetail:YES type:self.accoutType]) {
                        if ([model.status intValue ] != 2) {
                            if (isOrder > 0) {
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:SelectAccoutTypeP2P];
                            }
                        }else {
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:SelectAccoutTypeP2P];
                    }
                   }
               }
        }
}
#pragma mark - 去批量投资集合详情
-(void)gotoCollectionDetailViewContoller:(UCFMicroMoneyModel *)model{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    self.accoutType = SelectAccoutTypeP2P;
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
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }

    [self.tableview reloadData];
}

#pragma mark - cell的代理

- (void)homelistCell:(UCFHomeListCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath
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
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagPrdClaimsDetail){
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        if ([rstcode intValue] == 1) {
            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)self.model.prdLabelsList];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
            CGFloat platformSubsidyExpense = [self.model.platformSubsidyExpense floatValue];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
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
            UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
            purchaseViewController.rootVc = self.rootVc;
            purchaseViewController.dataDict = dic;
            purchaseViewController.bidType = 0;
            purchaseViewController.baseTitleType = @"detail_heTong";
            purchaseViewController.accoutType = SelectAccoutTypeP2P;
            [self.navigationController pushViewController:purchaseViewController animated:YES];
            
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}


@end
