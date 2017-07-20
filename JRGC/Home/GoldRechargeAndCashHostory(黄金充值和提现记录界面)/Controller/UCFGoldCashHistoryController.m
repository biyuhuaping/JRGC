//
//  UCFGoldCashHistoryController.m
//  JRGC
//
//  Created by njw on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashHistoryController.h"
#import "UCFGoldCashRecordCell.h"
#import "UCFGoldRecordHeaderFooterView.h"
#import "UCFGoldCashHistoryModel.h"

@interface UCFGoldCashHistoryController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSUInteger currentPage;
@end

@implementation UCFGoldCashHistoryController

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
    static NSString *cellId = @"goldCashRecord";
    UCFGoldCashRecordCell *hisCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == hisCell) {
        hisCell = (UCFGoldCashRecordCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashRecordCell" owner:self options:nil] lastObject];
        hisCell.tableview = tableView;
    }
    hisCell.indexPath = indexPath;
    NSArray *array = [self.dataArray objectAtIndex:indexPath.section];
    hisCell.model = [array objectAtIndex:indexPath.row];
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
    UCFGoldCashHistoryModel *model = [[self.dataArray objectAtIndex:section] firstObject];
    NSArray *dateArr = [model.withdrawMonth componentsSeparatedByString:@"-"];
    recordView.monthLabel.text = [NSString stringWithFormat:@"%@年%d月", [dateArr firstObject], [[dateArr objectAtIndex:1] intValue]];
    return recordView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}

- (void)getDataFromNet
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    if (!userId) {
        return;
    }
    if ([self.tableview.header isRefreshing]) {
        self.currentPage = 1;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentPage], @"pageNo", @"20", @"pageSize", userId, @"userId", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldCashHistory owner:self signature:YES Type:SelectAccoutDefault];
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
    if (tag.integerValue == kSXTagGoldCashHistory) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *temp in resut) {
                UCFGoldCashHistoryModel *goldhistory = [UCFGoldCashHistoryModel goldCashHistoryModelWithDict:temp];
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

-(void)errorPost:(NSError *)err tag:(NSNumber *)tag
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
        UCFGoldCashHistoryModel *firstModel = [array firstObject];
        NSMutableArray *tempDataArray = [NSMutableArray array];
        NSMutableArray *tempMonthArray = [NSMutableArray array];
        for (UCFGoldCashHistoryModel *model in array) {
            if ([model.withdrawMonth isEqualToString:firstModel.withdrawMonth]) {
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
