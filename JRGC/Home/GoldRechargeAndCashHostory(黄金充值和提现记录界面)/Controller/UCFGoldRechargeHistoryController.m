//
//  UCFGoldRechargeHistoryController.m
//  JRGC
//
//  Created by njw on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeHistoryController.h"
#import "UCFGoldRechargeRecordCell.h"
#import "UCFGoldRechargeHistoryModel.h"
#import "UCFGoldRecordHeaderFooterView.h"
#import "UCFNoDataView.h"

@interface UCFGoldRechargeHistoryController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UCFNoDataView *noDataView;
@end

@implementation UCFGoldRechargeHistoryController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    self.currentPage = 1;
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataFromNet)];
    __weak typeof(self) weakSelf = self;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataFromNet];
    }];
    self.tableview.footer.hidden = YES;
    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initGoldWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) errorTitle:@"你还没有交易记录" buttonTitle:@""];
    self.noDataView = noDataView;
    [self.tableview.header beginRefreshing];
}

#pragma mark - tableview 的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.dataArray objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldRechargeRecord";
    UCFGoldRechargeRecordCell *hisCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == hisCell) {
        hisCell = (UCFGoldRechargeRecordCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeRecordCell" owner:self options:nil] lastObject];
        hisCell.tableview = tableView;
    }
    hisCell.indexPath = indexPath;
    NSArray *monthArray = [self.dataArray objectAtIndex:indexPath.section];
    hisCell.model = [monthArray objectAtIndex:indexPath.row];
    return hisCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *viewId = @"goldRecordHeaderFooterView";
    UCFGoldRecordHeaderFooterView *recordView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == recordView) {
        recordView = (UCFGoldRecordHeaderFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRecordHeaderFooterView" owner:self options:nil] lastObject];
    }
    UCFGoldRechargeHistoryModel *model = [[self.dataArray objectAtIndex:section] firstObject];
    NSArray *dateArr = [model.rechargeMonth componentsSeparatedByString:@"-"];
    recordView.monthLabel.text = [NSString stringWithFormat:@"%@年%d月", [dateArr firstObject], [[dateArr objectAtIndex:1] intValue]];
    return recordView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
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
    NSDictionary *dictory = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", @"20", @"pageSize", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"pageNo", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dictory tag:kSXTagGoldRechargeHistory owner:self signature:YES Type:SelectAccoutDefault];
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
    if (tag.integerValue == kSXTagGoldRechargeHistory) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *temp in resut) {
                UCFGoldRechargeHistoryModel *goldhistory = [UCFGoldRechargeHistoryModel goldRechargeHistoryModelWithDict:temp];
                [self.dataArray addObject:goldhistory];
            }
            BOOL hasNextPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            if (hasNextPage) {
                self.currentPage ++;
                self.tableview.footer.hidden = YES;
                [self.tableview.footer resetNoMoreData];
                self.dataArray = [self arrayGroupWithArray:self.dataArray];
            }
            else {
                if (self.dataArray.count > 0) {
                    [self.tableview.footer noticeNoMoreData];
                }
                else
                    self.tableview.footer.hidden = YES;
                self.dataArray = [self arrayGroupWithArray:self.dataArray];
                if (!self.dataArray.count) {
                    [self.noDataView showInView:self.tableview];
                }
                else {
                    [self.noDataView hide];
                }
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

- (NSMutableArray *)arrayGroupWithArray:(NSMutableArray *)array
{
    if (array.count>0) {
        UCFGoldRechargeHistoryModel *firstModel = [array firstObject];
        NSMutableArray *tempDataArray = [NSMutableArray array];
        NSMutableArray *tempMonthArray = [NSMutableArray array];
        for (UCFGoldRechargeHistoryModel *model in array) {
            if ([model.rechargeMonth isEqualToString:firstModel.rechargeMonth]) {
                [tempMonthArray addObject:model];
                if ([model isEqual:[array lastObject]]) {
                    [tempDataArray addObject:tempMonthArray];
                }
            }
            else {
                firstModel = model;
                [tempDataArray addObject:tempMonthArray];
                tempMonthArray = [NSMutableArray array];
                [tempMonthArray addObject:model];
                if ([model isEqual:[array lastObject]]) {
                    [tempDataArray addObject:tempMonthArray];
                }
            }
        }
        return tempDataArray;
    }
    
    return nil;
}

@end
