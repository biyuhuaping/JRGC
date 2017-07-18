//
//  UCFGoldRechargeHistoryController.m
//  JRGC
//
//  Created by njw on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeHistoryController.h"
#import "UCFGoldReCashHisCell.h"
#import "UCFGoldHistoryModel.h"

@interface UCFGoldRechargeHistoryController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger currentPage;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldRechargeAndCash";
    UCFGoldReCashHisCell *hisCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == hisCell) {
        hisCell = (UCFGoldReCashHisCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldReCashHisCell" owner:self options:nil] lastObject];
        hisCell.tableview = tableView;
    }
    hisCell.indexPath = indexPath;
    return hisCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)getDataFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    NSDictionary *dictory = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", @"20", @"pageSize", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"pageNo", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dictory tag:kSXTagGoldRechargeHistory owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    
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
                UCFGoldHistoryModel *goldhistory = [UCFGoldHistoryModel goldHistoryModelWithDict:temp];
                goldhistory.type = UCFGoldHistoryModelTypeRecharge;
                [self.dataArray addObject:goldhistory];
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
