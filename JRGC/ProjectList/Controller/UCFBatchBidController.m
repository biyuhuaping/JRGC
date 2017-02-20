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

@interface UCFBatchBidController () <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_colPrdClaimIdStr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (nonatomic, assign) NSInteger currentPage;
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

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - setting UI
    // setting tableview style
    [self settingTableViewStyle];
    // add nodata view
    [self addNoDataView];
    // add refreshing and load more
    [self addRefreshingAndLoadMore];
    
}

#pragma mark - setting tableview
- (void)settingTableViewStyle
{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    self.tableview.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
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
    self.currentPage = 1;
    // 添加上拉加载更多
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getNetDataFromNet];
    }];
    
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNetDataFromNet)];
    [self.tableview.header beginRefreshing];
}

#pragma mark - tableView method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr1 = @"projectlist";
    UCFProjectListCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellStr1];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFProjectListCell" owner:self options:nil][0];
    }
//    UCFProjectListModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    cell.model = model;
//    cell.delegate = self;
    cell.type = UCFProjectListCellTypeProject;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    
    if (uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", _colPrdClaimIdStr, @"colPrdClaimId", nil];
    }
     [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagColPrdclaimsDetail owner:self signature:YES];
    
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

    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagColPrdclaimsList owner:self signature:YES];
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
    
    if (tag.intValue == kSXTagColPrdclaimsList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in list_result) {
                //                DBLOG(@"%@", dict);
//                UCFTransferModel *model = [UCFTransferModel transferWithDict:dict];
//                model.isAnim = YES;
                [self.dataArray addObject:dict];
            }
            
            _colPrdClaimIdStr = [NSString stringWithFormat:@"%@",(NSString *)[[list_result firstObject] objectSafeForKey:@"id"]];
            
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
    }  else if (tag.intValue == kSXTagColPrdclaimsDetail){
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        bool rstcode = [dic[@"ret"] boolValue];
        NSString *rsttext = dic[@"message"];
        if (rstcode) {
            UCFCollectionDetailViewController *controller = [[UCFCollectionDetailViewController alloc] initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
            controller.souceVC = @"P2PVC";
            controller.colPrdClaimId = _colPrdClaimIdStr;
            controller.detailDataDict = [dic objectSafeDictionaryForKey:@"data"];
            [self.navigationController pushViewController:controller animated:YES];
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
