//
//  UCFHandingInViewController.m
//  JRGC
//
//  Created by njw on 2017/11/8.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFHandingInViewController.h"
#import "UCFNoDataView.h"
#import "UCFExtractGoldModel.h"
#import "UCFExtractGoldFrameModel.h"
#import "UCFExtractGoldCell.h"
#import "UCFExtractGoldDetailController.h"
#import "MjAlertView.h"
#import "UCFGoldRechargeViewController.h"

@interface UCFHandingInViewController () <UITableViewDelegate, UITableViewDataSource, UCFExtractGoldCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *needAmountStr;
@end

@implementation UCFHandingInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) errorTitle:@"敬请期待..."];
    self.noDataView = noDataView;
    
    self.currentPage = 1;
    
    [self.tableview setContentInset:UIEdgeInsetsMake(5, 0, 5, 0)];
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getExtractGoldListHandingInFromNet)];
    // 添加上拉加载更多
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getExtractGoldListHandingInFromNet];
    }];
    
    self.tableview.footer.hidden = YES;
    [self.tableview.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"extractgold";
    UCFExtractGoldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFExtractGoldCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFExtractGoldCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    UCFExtractGoldFrameModel *frameModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.frameModel = frameModel;
    return cell;
}

- (void)bottomButton:(UIButton *)button ClickedWithModel:(UCFExtractGoldModel *)extractGoldModel
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    NSDictionary *param = @{@"orderId": extractGoldModel.takeRecordOrderId, @"userId": userId};
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagExtractSubmit owner:self signature:YES Type:SelectAccoutTypeGold];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFExtractGoldFrameModel *frameModel = [self.dataArray objectAtIndex:indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *userId = [UserInfoSingle sharedManager].userId;
    UCFExtractGoldFrameModel *frameModel = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary *param = @{@"orderId": frameModel.item.takeRecordOrderId, @"userId": userId};
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagExtractSubmit owner:self signature:YES Type:SelectAccoutTypeGold];
}

- (void)getExtractGoldListHandingInFromNet
{
    if ([self.tableview.header isRefreshing]) {
        self.currentPage = 1;
    }
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.currentPage];
    NSString *userId = [UserInfoSingle sharedManager].userId;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId, @"userId", pageNo, @"pageNo", @"2", @"status", @"20", @"pageSize", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagExtractGoldList owner:self signature:YES Type:SelectAccoutTypeGold];
}

- (void)beginPost:(kSXTag)tag
{
    UCFBaseViewController *vc = self.rootVc;
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    UCFBaseViewController *vc = self.rootVc;
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rsttext = dic[@"message"];
    NSString *rstcode = [dic objectSafeForKey:@"code"];
    if (tag.integerValue == kSXTagExtractGoldList) {
        if ([dic[@"ret"] boolValue] == 1) {
            self.tableview.footer.hidden = NO;
            NSDictionary *data = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"];
            NSDictionary *pageData = [data objectSafeDictionaryForKey:@"pagination"];
            BOOL hasNextPage = [[pageData objectSafeForKey:@"hasNextPage"] boolValue];
            NSArray *resut = [data objectSafeArrayForKey:@"result"];
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in resut) {
                UCFExtractGoldModel *extractGold = [UCFExtractGoldModel extractGoldWithDict:dict];
                UCFExtractGoldFrameModel *frameModel = [UCFExtractGoldFrameModel extractGoldFrameWithModel:extractGold];
                [self.dataArray addObject:frameModel];
            }
            if (hasNextPage) {
                self.currentPage ++;
                [self.tableview.footer resetNoMoreData];
            }
            else {
                if (self.dataArray.count > 0) {
                    [self.tableview.footer noticeNoMoreData];
                    [self.noDataView hide];
                }
                else {
                    [self.noDataView showInView:self.tableview];
                }
            }
            [self.tableview reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    else if (tag.integerValue == kSXTagExtractGoldDetail) {
        if ([dic[@"ret"] boolValue] == 1) {
            NSDictionary *data = [dic objectSafeDictionaryForKey:@"data"];
            UCFExtractGoldDetailController *extractGoldDetailWeb = [[UCFExtractGoldDetailController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
            extractGoldDetailWeb.url = [data objectSafeForKey:@"url"];
            UCFBaseViewController *baseVc = self.rootVc;
            [baseVc.navigationController pushViewController:extractGoldDetailWeb animated:YES];
        }
    }
    else if (tag.integerValue == kSXTagExtractSubmit) {
        if ([dic[@"ret"] boolValue] == 1) {
            NSDictionary *data = [dic objectSafeDictionaryForKey:@"data"];
            UCFExtractGoldDetailController *extractGoldDetailWeb = [[UCFExtractGoldDetailController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
            extractGoldDetailWeb.url = [data objectSafeForKey:@"url"];
            extractGoldDetailWeb.rootVc = self.rootVc;
            UCFBaseViewController *baseVc = self.rootVc;
            [baseVc.navigationController pushViewController:extractGoldDetailWeb animated:YES];
        }
        else {
            if (rstcode.integerValue == -102) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
            else if (rstcode.integerValue == -103) {
                self.needAmountStr = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"needAmount"];
                MjAlertView *alertView = [[MjAlertView alloc]initDrawGoldRechangeAlertType:MjAlertViewTypeDrawGoldRechane withMessage:rsttext delegate:self];
                [alertView show];
            }
        }
    }
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    else if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index
{
    if (index == 101) {
        UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
        goldRecharge.baseTitleText = @"充值";
        goldRecharge.needToRechareStr =self.needAmountStr;
        goldRecharge.rootVc = self;
        [self.navigationController pushViewController:goldRecharge animated:YES];
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    UCFBaseViewController *vc = self.rootVc;
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    else if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
