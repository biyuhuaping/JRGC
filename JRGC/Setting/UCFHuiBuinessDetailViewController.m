//
//  UCFHuiBuinessDetailViewController.m
//  JRGC
//
//  Created by NJW on 16/8/10.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFHuiBuinessDetailViewController.h"
#import "UCFTableCellTwo.h"
#import "UCFToolsMehod.h"
#import "UCFNoDataView.h"


@interface UCFHuiBuinessDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) UCFNoDataView *noDataView;                 // 无数据界面
@end

@implementation UCFHuiBuinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.accoutType == SelectAccoutTypeHoner ) {
         baseTitleLabel.text = @"尊享徽商资金流水";
    }else{
         baseTitleLabel.text = @"微金徽商资金流水";
    }
    [self addLeftButton];
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    
    __weak UCFHuiBuinessDetailViewController *weakSelf = self;
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    // 添加上拉加载更多
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        _currentPage++;
        [weakSelf getHuiBuinessListDataFromNetWithPage:_currentPage];
    }];
    
//    self.tableView.footer.hidden = YES;
    [self.tableView.header beginRefreshing];
    
     _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight-NavigationBarHeight) errorTitle:@"暂无数据"];
}

- (void)refreshData
{
    _currentPage = 1;
    [self getHuiBuinessListDataFromNetWithPage:_currentPage];
}

- (void)getHuiBuinessListDataFromNetWithPage:(NSInteger)page;
{
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)page];
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId, @"page":pageStr, @"pageSize":@"20"} tag:kSXTagGetHSAccountList owner:self signature:YES Type:self.accoutType];
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
    NSMutableDictionary *dic = [result objectFromJSONString];
    //    DDLogDebug(@"新用户开户：%@",data);
    
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagGetHSAccountList) {
        if (ret) {
//            DDLogDebug(@"%@",dic[@"data"]);
            NSDictionary *dataDic  = [dic objectSafeDictionaryForKey:@"data"];
            NSArray *resultListArr = [[dataDic objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            BOOL hasNextP = [[[[dataDic objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"hasNextPage"] boolValue];
//            BOOL hasNextP = [dataDic[@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
            
            if (_currentPage == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *data in resultListArr) {
                UCFHuiBuinessListModel *listModel = [UCFHuiBuinessListModel hsAssetBeanWithDict:data];
                [_dataArray addObject:listModel];
            }
            if (!hasNextP) {
                [self.tableView.footer noticeNoMoreData];
            }
            else
                [self.tableView.footer resetNoMoreData];
            [self.tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
        [self endRefreshing];
        [self setNoDataView];
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [AuxiliaryFunc showToastMessage:err.userInfo[@"NSLocalizedDescription"] withView:self.view];
//    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self endRefreshing];
    [self setNoDataView];
}

#pragma mark - tableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFTableCellTwo *cell =  [UCFTableCellTwo cellWithTableView:tableView];
    cell.isHasData = YES;
    cell.indexPath = indexPath;
    
    UCFHuiBuinessListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.listModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark 暂无数据页面
- (void)setNoDataView{
    if (_dataArray.count == 0)
    {
        [self.noDataView showInView:self.tableView];
        self.tableView.footer.hidden = YES;
    }
    else
    {
        [self.noDataView hide];
    }
}
#pragma mark 停止刷新
- (void)endRefreshing{
    if (self.tableView.header.isRefreshing) {
        [self.tableView.header endRefreshing];
    }
    if (self.tableView.footer.isRefreshing) {
        [self.tableView.footer endRefreshing];
    }
    
}

@end
