//
//  UCFBatchProjectController.m
//  JRGC
//
//  Created by njw on 2017/2/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBatchProjectController.h"
#import "UCFInvestmentDetailViewController.h"
#import "UCFNoDataView.h"
#import "UCFMyInvestBatchBidModel.h"
#import "UCFMyInvestBatchCell.h"
#import "UCFCollectionDetailViewController.h"
#import "NZLabel.h"
@interface UCFBatchProjectController () <UITableViewDelegate, UITableViewDataSource>
{
    NSString *_colPrdClaimIdStr;
    NSString *_batchOrderIdStr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NZLabel *totalCountLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger pageNum;

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@end

@implementation UCFBatchProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - set scrollview
    
    CGFloat height = ScreenHeight -240+44;
    self.tableView.backgroundColor = UIColorWithRGB(0xebebee);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
#pragma mark - init no data view
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height) errorTitle:@"暂无数据"];
#pragma mark - init Net request
    [self initNetRequest];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}

#pragma mark - init Net request
- (void)initNetRequest
{
    self.pageNum = 1;
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    // 添加上拉加载更多
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getBatchInvestDataList];
    }];
    
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getBatchInvestDataList)];
//    self.tableView.footer.hidden = YES;
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"myInvestBatchBid";
    UCFMyInvestBatchCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFMyInvestBatchCell" owner:self options:nil] lastObject];
    }
    UCFMyInvestBatchBidModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    UCFMyInvestBatchBidModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if([model.status intValue] == 1){ //等于1 匹配成功
        _colPrdClaimIdStr = [NSString stringWithFormat:@"%@",model.colId];
        _batchOrderIdStr = [NSString stringWithFormat:@"%@",model.Id ];
        NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId",_colPrdClaimIdStr, @"colPrdClaimsId", _batchOrderIdStr, @"batchOrderId",@"1",@"page", @"20", @"pageSize",nil];
        [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagMyBatchInvestDetail owner:self signature:YES Type:SelectAccoutDefault];
    }
}

#pragma mark - net request
- (void)getBatchInvestDataList
{
    if (self.tableView.header.isRefreshing) {
        _pageNum = 1;
    }else if (self.tableView.footer.isRefreshing){
        _pageNum ++;
    }
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if ([self.tableView.header isRefreshing]) {
        self.pageNum = 1;
        [self.tableView.footer resetNoMoreData];
    }
    strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.pageNum], @"page", @"20", @"pageSize", nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagMyInvestBatchBid owner:self signature:YES Type:SelectAccoutDefault];
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
    
    if (tag.intValue == kSXTagMyInvestBatchBid) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            
            if ([self.tableView.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            self.pageNum ++;
            for (NSDictionary *dict in list_result) {
                UCFMyInvestBatchBidModel *model = [UCFMyInvestBatchBidModel investBatchListWithDict:dict];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
            
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            NSNumber *totalCount = [[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"totalCount"];
            
            self.totalCountLabel.text = [NSString stringWithFormat:@"共%@笔记录",totalCount];
            [self.totalCountLabel setFont:[UIFont boldSystemFontOfSize:12] string:[totalCount stringValue]];
            
            if (self.dataArray.count > 0) {
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
    }
    else if (tag.intValue == kSXTagMyBatchInvestDetail) {
            NSString *rstcode = dic[@"ret"];
            NSString *rsttext = dic[@"message"];
            if ([rstcode intValue] == 1) {
                UCFCollectionDetailViewController *collectionDetailVC = [[UCFCollectionDetailViewController alloc]initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
                collectionDetailVC.souceVC = @"BatchProjectVC";
                collectionDetailVC.colPrdClaimId = _colPrdClaimIdStr;
                collectionDetailVC.batchOrderIdStr = _batchOrderIdStr;
                collectionDetailVC.detailDataDict = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"colPrdClaimDetail"];
                [self.navigationController pushViewController:collectionDetailVC  animated:YES];
            }else {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
        }
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}

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



#pragma mark - lazying load 
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
