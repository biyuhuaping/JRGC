//
//  UCFGoldenViewController.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldenViewController.h"
#import "UCFGoldenHeaderView.h"
#import "UCFHomeListCell.h"
#import "UCFHomeListHeaderSectionView.h"
#import "UCFGoldModel.h"
#import "UCFGoldPurchaseViewController.h"
#import "UCFGoldAuthorizationViewController.h"
#import "HSHelper.h"
#import "UCFGoldDetailViewController.h"
#import "ToolSingleTon.h"
#import "UCFNoPermissionViewController.h"
#import "UCFGoldFlexibleCell.h"
#import "UCFInvestMicroMoneyCell.h"
#import "UCFAccountPieCharViewController.h"
#import "UCFRechargeOrCashViewController.h"
#import "AppDelegate.h"
#import "UCFProjectLabel.h"
@interface UCFGoldenViewController () <UITableViewDelegate, UITableViewDataSource, UCFHomeListCellHonorDelegate,UIAlertViewDelegate, UCFGoldFlexibleCellDelegate>
@property (weak, nonatomic) UCFGoldenHeaderView *goldenHeader;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) UCFGoldModel *fliexGoldModel;
@end

@implementation UCFGoldenViewController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [self.tableview.header beginRefreshing];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.goldenHeader.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/16*5+81);
}

#pragma mark - 初始化UI
- (void)createUI {
//    CGFloat height = [UCFGoldenHeaderView viewHeight];
    UCFGoldenHeaderView *goldenHeader = (UCFGoldenHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldenHeaderView" owner:self options:nil] lastObject];
    self.goldenHeader = goldenHeader;
    if (kIS_IOS8) {
        self.tableview.tableHeaderView = goldenHeader;
    } else {
        UIView *headView = [[UIView alloc]init];
        _goldenHeader.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/16*5+101);
        headView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/16*5+101);
//        [headView addSubview:_goldenHeader];
        headView.backgroundColor = [UIColor clearColor];

        self.tableview.tableHeaderView = headView;
    }
    goldenHeader.hostVc = self;
    
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    __weak typeof(self) weakSelf = self;
    self.tableview.footer.hidden = YES;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadNetData];
    }];
}

#pragma mark - tableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.fliexGoldModel.nmPrdClaimName.length>0) {
            return 1;
        }
        return 0;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.fliexGoldModel.nmPrdClaimName.length>0) {
            return 145.0;
        }
        return 0;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"goldflexible";
        UCFGoldFlexibleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldFlexibleCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldFlexibleCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        if (self.fliexGoldModel) {
            cell.goldmodel = self.fliexGoldModel;
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = @"investmicromoney";
        UCFInvestMicroMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFInvestMicroMoneyCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFInvestMicroMoneyCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        cell.tableView = tableView;
        cell.indexPath = indexPath;
        cell.goldModel = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}
#pragma mark - 黄金活期购买的代理
- (void)goldList:(UCFGoldFlexibleCell *)goldListCell didClickedBuyFilexGoldWithModel:(UCFGoldModel *)model
{
    if (!SingleUserInfo.loginData.userInfo.userId) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else  {
        
        NSString *tipStr1 = ZXTIP1;
        NSInteger openStatus = [SingleUserInfo.loginData.userInfo.openStatus integerValue];
        NSInteger enjoyOpenStatus = [SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue];
        if (  enjoyOpenStatus < 3  && openStatus < 3) {
            [self showHSAlert:tipStr1];
            return;
        }

        [self getGoldCurrentProClaimDetailHttpRequest:self.fliexGoldModel];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.fliexGoldModel.nmPrdClaimName.length > 0) {
            return 39;
        }
        else return 0.001;
    }
    else {
        if (self.dataArray.count>0) {
            return 39;
        }
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (self.dataArray.count > 0) {
//        return 10;
//    }
    if (section == 0) {
        if (self.fliexGoldModel.nmPrdClaimName.length > 0) {
            return 8;
        }
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (kIS_IOS8) {
        static NSString* viewId = @"homeListHeader";
        UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
        if (nil == view) {
            view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
        }
        view.downView.hidden = YES;
        [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
        [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
        view.frame = CGRectMake(0, 0, ScreenWidth, 39);
        if (section == 0) {
            if (self.fliexGoldModel.nmPrdClaimName.length > 0) {
                view.homeListHeaderMoreButton.hidden = YES;
                view.headerTitleLabel.text = @"增金宝";
                view.headerImageView.image = [UIImage imageNamed:@"mine_icon_gold_current"];
                
                if (_fliexGoldModel.prdLabelsList.count > 0) {
                    UCFProjectLabel *projectLabel = [_fliexGoldModel.prdLabelsList firstObject];
                    if ([projectLabel.labelPriority integerValue] == 1) {
                        view.goldSignView.hidden = NO;
                        view.goldSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
                        CGSize size = [view.goldSignLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
                        view.goldSignViewW.constant = size.width + 11;
                    }
                    else {
                        view.goldSignView.hidden = YES;
                    }
                }
                else {
                    view.goldSignView.hidden = YES;
                }
                
                [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
                return view;
            }
        }
        else if (section == 1) {
            if (self.dataArray.count > 0) {
                view.homeListHeaderMoreButton.hidden = YES;
                view.headerTitleLabel.text = @"尊享金";
                view.headerImageView.image = [UIImage imageNamed:@"mine_icon_gold"];
                [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
                return view;
            }
        }
        return nil;
    } else {
        UCFHomeListHeaderSectionView *view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];

        view.downView.hidden = YES;
        [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
        [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
        view.frame = CGRectMake(0, 0, ScreenWidth, 39);
        if (section == 0) {
            if (self.fliexGoldModel.nmPrdClaimName.length > 0) {
                view.homeListHeaderMoreButton.hidden = YES;
                view.headerTitleLabel.text = @"增金宝";
                view.headerImageView.image = [UIImage imageNamed:@"mine_icon_gold_current"];
                
                if (_fliexGoldModel.prdLabelsList.count > 0) {
                    UCFProjectLabel *projectLabel = [_fliexGoldModel.prdLabelsList firstObject];
                    if ([projectLabel.labelPriority integerValue] == 1) {
                        view.goldSignView.hidden = NO;
                        view.goldSignLabel.text = [NSString stringWithFormat:@"%@", projectLabel.labelName];
                        CGSize size = [view.goldSignLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
                        view.goldSignViewW.constant = size.width + 11;
                    }
                    else {
                        view.goldSignView.hidden = YES;
                    }
                }
                else {
                    view.goldSignView.hidden = YES;
                }
                
                [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
                UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
                baseView.backgroundColor = [UIColor clearColor];
                [baseView addSubview:view];
                return baseView;
            }
        }
        else if (section == 1) {
            if (self.dataArray.count > 0) {
                view.homeListHeaderMoreButton.hidden = YES;
                view.headerTitleLabel.text = @"尊享金";
                view.headerImageView.image = [UIImage imageNamed:@"mine_icon_gold"];
                [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
                UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
                baseView.backgroundColor = [UIColor clearColor];
                [baseView addSubview:view];
                return baseView;
            }
        }
        return nil;
        
        
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!SingleUserInfo.loginData.userInfo.userId) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else  {
        
        NSString *tipStr1 = ZXTIP1;
        NSInteger openStatus = [SingleUserInfo.loginData.userInfo.openStatus integerValue];
        NSInteger enjoyOpenStatus = [SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue];
        if (  enjoyOpenStatus < 3 && openStatus < 3) {
            [self showHSAlert:tipStr1];
            return;
        }
        
        
        if (indexPath.section == 0) {//活期详情
            [self getGoldCurrentPrdClaimInfoHttpRequest:self.fliexGoldModel];
        }else{

        UCFGoldModel *goldModel = [self.dataArray objectAtIndex:indexPath.row];
        
        NSString *nmProClaimIdStr = goldModel.nmPrdClaimId;
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:SingleUserInfo.loginData.userInfo.userId, @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
        [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldPrdClaimDetail owner:self signature:YES Type:SelectAccoutTypeGold];
        }
        
    }

    
}

- (void)homelistCell:(UCFInvestMicroMoneyCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath
{
    if (!SingleUserInfo.loginData.userInfo.userId) {
        //如果未登录，展示登录页面
        [self showLoginView];
    } else  {
        
        NSString *tipStr1 = ZXTIP1;
        NSInteger openStatus = [SingleUserInfo.loginData.userInfo.openStatus integerValue];
        NSInteger enjoyOpenStatus = [SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue];
        if (enjoyOpenStatus < 3 && openStatus < 3) {//去开户页面
            [self showHSAlert:tipStr1];
            return;
        }
        
        UCFGoldModel *goldModel = [self.dataArray objectAtIndex:indexPath.row];
        if ([goldModel.status intValue] == 2 || [goldModel.status intValue] == 21 ) {
                return;
        }
            
        NSString *nmProClaimIdStr = goldModel.nmPrdClaimId;
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:SingleUserInfo.loginData.userInfo.userId, @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
            
        [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldProClaimDetail owner:self signature:YES Type:SelectAccoutDefault];
    }
}
#pragma mark -活期详情页面数据请求
-(void)getGoldCurrentPrdClaimInfoHttpRequest:(UCFGoldModel *)goldModel
{
    
    NSString *nmProClaimIdStr = goldModel.nmPrdClaimId;
    
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:SingleUserInfo.loginData.userInfo.userId, @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGoldCurrentPrdClaimInfo owner:self signature:YES Type:SelectAccoutTypeGold];

}
#pragma mark -活期投资页面数据请求
-(void)getGoldCurrentProClaimDetailHttpRequest:(UCFGoldModel *)goldModel
{
    
    NSString *nmProClaimIdStr = goldModel.nmPrdClaimId;
    
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:SingleUserInfo.loginData.userInfo.userId, @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGoldCurrentProClaimDetail owner:self signature:YES Type:SelectAccoutTypeGold];
    
}
#pragma mark -去登录页面
- (void)showLoginView
{
    [SingleUserInfo loadLoginViewController];
}
- (BOOL)checkUserCanInvestIsDetailType:(SelectAccoutType)accout;
{
    return NO;
}
- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 8000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] nav:self.navigationController];
        }
    }
}

- (void)refreshData {
    [self.goldenHeader getNormalBannerData];
    self.currentPage = 1;
    [self getGoldProFromNetWithPage:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentPage]];
}

- (void)loadNetData {
    [self getGoldProFromNetWithPage:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentPage]];
}

- (void)getGoldProFromNetWithPage:(NSString *)page
{
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    NSDictionary * param;
    if (nil == userId) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:@"20", @"pageSize", page, @"pageNo", nil];
    }
    else {
        param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", @"20", @"pageSize", page, @"pageNo", nil];
    }
    
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldList owner:self signature:NO Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    if(tag != kSXTagGoldList)
    {
        [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
        
    }
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.integerValue == kSXTagGoldList) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            
            UCFGoldModel *goldFliexModel = [UCFGoldModel goldModelWithDict:[dict objectSafeDictionaryForKey:@"nmCurrentPrdInfo"]];
            self.fliexGoldModel = goldFliexModel;
            for (NSDictionary *temp in resut) {
                UCFGoldModel *gold = [UCFGoldModel goldModelWithDict:temp];
                [self.dataArray addObject:gold];
            }
            BOOL hasNextPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            if (hasNextPage) {
                self.currentPage ++;
                self.tableview.footer.hidden = YES;
                [self.tableview.footer resetNoMoreData];
            }
            else {
                if (self.dataArray.count > 0) {
                    [self.tableview.footer noticeNoMoreData];
                }
                else
                    self.tableview.footer.hidden = YES;
            }
            [self.tableview reloadData];
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
        }
    }else if (tag.integerValue == kSXTagGetGoldProClaimDetail){
        
        NSMutableDictionary *dic = [result objectFromJSONString];
        NSString *rsttext = dic[@"message"];
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue]) {
            UCFGoldPurchaseViewController *goldPurchaseVC = [[UCFGoldPurchaseViewController alloc]initWithNibName:@"UCFGoldPurchaseViewController" bundle:nil];
            goldPurchaseVC.dataDic = dataDict;
            goldPurchaseVC.isGoldCurrentAccout = NO;
            [self.navigationController pushViewController:goldPurchaseVC  animated:YES];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
    else if (tag.integerValue == kSXTagGetGoldPrdClaimDetail){
        
        NSMutableDictionary *dic = [result objectFromJSONString];
        NSString *rsttext = dic[@"message"];
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue]) {
            UCFGoldDetailViewController*goldDetailVC = [[UCFGoldDetailViewController alloc]initWithNibName:@"UCFGoldDetailViewController" bundle:nil];
            goldDetailVC.dataDict = dataDict;
            goldDetailVC.isGoldCurrentAccout = NO;
            [self.navigationController pushViewController:goldDetailVC  animated:YES];
        }
        else
        {
            if([[dic objectSafeForKey:@"code"]  intValue] == 11112)
            {
                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [AuxiliaryFunc showAlertViewWithMessage:rsttext];
            }
        }
    }else if (tag.integerValue == kSXTagGoldCurrentProClaimDetail){//活期投资页面
        
        NSMutableDictionary *dic = [result objectFromJSONString];
        NSString *rsttext = dic[@"message"];
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue]) {
            UCFGoldPurchaseViewController *goldPurchaseVC = [[UCFGoldPurchaseViewController alloc]initWithNibName:@"UCFGoldPurchaseViewController" bundle:nil];
            goldPurchaseVC.dataDic = dataDict;
            goldPurchaseVC.isGoldCurrentAccout = YES;
            [self.navigationController pushViewController:goldPurchaseVC  animated:YES];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
    else if (tag.integerValue == kSXTagGoldCurrentPrdClaimInfo){//活期详情页面
        
        NSMutableDictionary *dic = [result objectFromJSONString];
        NSString *rsttext = dic[@"message"];
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue]) {
            UCFGoldDetailViewController*goldDetailVC = [[UCFGoldDetailViewController alloc]initWithNibName:@"UCFGoldDetailViewController" bundle:nil];
            goldDetailVC.dataDict = dataDict;
            goldDetailVC.isGoldCurrentAccout = YES;
            [self.navigationController pushViewController:goldDetailVC  animated:YES];
        }
        else
        {
            if([[dic objectSafeForKey:@"code"]  intValue] == 11112)
            {
                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [AuxiliaryFunc showAlertViewWithMessage:rsttext];
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
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
