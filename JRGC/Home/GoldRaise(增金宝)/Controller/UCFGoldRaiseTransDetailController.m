//
//  UCFGoldRaiseTransDetailController.m
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRaiseTransDetailController.h"
#import "UCFNoDataView.h"
#import "UCFGoldIncreTransListModel.h"
#import "UCFGoldIncreTransListCell.h"

@interface UCFGoldRaiseTransDetailController () <UITableViewDelegate, UITableViewDataSource, UCFGoldIncreTransListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) UCFNoDataView *noDataView;
@end

@implementation UCFGoldRaiseTransDetailController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    self.currentPage = 1;
    [self getDataFromNet];
    [self.tableview.header beginRefreshing];
}

- (void)createUI
{
    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initGoldWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) errorTitle:@"你还没有交易记录" buttonTitle:@""];
    self.noDataView = noDataView;
    
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataFromNet)];
    __weak typeof(self) weakSelf = self;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataFromNet];
    }];
    self.tableview.footer.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFGoldIncreTransListModel *listModel = [self.dataArray objectAtIndex:section];
    if ([listModel.orderTypeName isEqualToString:@"购买活期"]) {
        return 4 + listModel.nmContractModelList.count;
    }
    else {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFGoldIncreTransListModel *listModel = [self.dataArray objectAtIndex:indexPath.row];
    static NSString *cellId = @"goldIncreTransList";
    UCFGoldIncreTransListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFGoldIncreTransListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldIncreTransListCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    cell.tableview = tableView;
    cell.indexPath = indexPath;
    cell.model = listModel;
    return cell;
}

#pragma mark - 合同的代理方法
- (void)goldIncreTransListCellDidClickedConstractWithModel:(UCFGoldIncreContractModel *)model
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 30;
    }
    return 32;
}

- (void)getDataFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    if ([self.tableview.header isRefreshing]) {
        self.currentPage = 1;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", @"20", @"pageSize", [NSString stringWithFormat:@"%lu", (unsigned long)self.currentPage], @"pageNo", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldIncreTransList owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.integerValue == kSXTagGoldIncreTransList) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *temp in resut) {
                UCFGoldIncreTransListModel *listModel = [UCFGoldIncreTransListModel goldIncreseListContractModelWithDict:temp];
                [self.dataArray addObject:listModel];
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
            if (!self.dataArray.count) {
                [self.noDataView showInView:self.tableview];
            }
            else {
                [self.noDataView hide];
            }
            [self.tableview reloadData];
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
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
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
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
