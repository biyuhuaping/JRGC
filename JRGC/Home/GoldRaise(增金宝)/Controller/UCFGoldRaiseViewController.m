//
//  UCFGoldRaiseViewController.m
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRaiseViewController.h"
#import "UCFGoldRaiseView.h"
#import "UCFGoldRaiseSectionHeaderView.h"
#import "UCFGoldRaiseTransDetailController.h"
#import "UCFGoldIncreaseAccountInfoModel.h"
#import "UCFNoDataView.h"
#import "UCFGoldIncreaseListModel.h"
#import "UCFGoldIncreListCell.h"

@interface UCFGoldRaiseViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UCFGoldRaiseView *raiseHeaderView;
@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (strong, nonatomic) NSMutableArray *listArray;
@end

@implementation UCFGoldRaiseViewController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat height = [UCFGoldRaiseView viewHeight];
    self.raiseHeaderView.frame = CGRectMake(0, 0, ScreenWidth, height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self createUI];
    self.currentPage = 1;
    [self.tableview.header beginRefreshing];
}

- (void)createUI {
    UCFGoldRaiseView *view = (UCFGoldRaiseView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRaiseView" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = view;
    self.raiseHeaderView = view;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 88, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:@"交易详情" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initGoldWithFrame:CGRectMake(0, 200, ScreenWidth, ScreenHeight - 264) errorTitle:@"你还没有交易记录" buttonTitle:@""];
    self.noDataView = noDataView;
    
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataFromNet)];
    __weak typeof(self) weakSelf = self;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getGoldIncreaseList];
    }];
    self.tableview.footer.hidden = YES;
}

- (void)clickRightBtn {
    UCFGoldRaiseTransDetailController *transDetail = [[UCFGoldRaiseTransDetailController alloc] initWithNibName:@"UCFGoldRaiseTransDetailController" bundle:nil];
    transDetail.baseTitleText = @"交易详情";
    [self.navigationController pushViewController:transDetail animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerId = @"goldraisesectionheader";
    UCFGoldRaiseSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    NSMutableArray *array = [self.listArray objectAtIndex:section];
    UCFGoldIncreaseListModel *model = [array firstObject];
    if (nil == header) {
        header = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRaiseSectionHeaderView" owner:self options:nil] lastObject];
    }
    header.titleStrLabel.text = [NSString stringWithFormat:@"%@收益明细", model.yearMonth];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [self.listArray objectAtIndex:section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldIncreaseListCell";
    UCFGoldIncreListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (UCFGoldIncreListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldIncreListCell" owner:self options:nil] lastObject];
    }
    NSMutableArray *array = [self.listArray objectAtIndex:indexPath.section];
    UCFGoldIncreaseListModel *model = [array objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)getDataFromNet {
    [self getGoldIncreaseAccount];
    [self getGoldIncreaseList];
}

- (void)getGoldIncreaseAccount {
    NSString *userId = [UserInfoSingle sharedManager].userId;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", @"20", @"pageSize", [NSString stringWithFormat:@"%d", self.currentPage], @"pageNo", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldIncrease owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)getGoldIncreaseList {
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    if ([self.tableview.header isRefreshing]) {
        self.currentPage = 1;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", @"20", @"pageSize", @"1", @"pageNo", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldIncreaseList owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    if (tag == kSXTagGoldIncreaseList) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.integerValue == kSXTagGoldIncrease) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            UCFGoldIncreaseAccountInfoModel *goldAccount = [[UCFGoldIncreaseAccountInfoModel alloc] init];
            goldAccount.allGiveMoney = [dict objectSafeForKey:@"allGiveMoney"];
            goldAccount.dealPrice = [dict objectSafeForKey:@"dealPrice"];
            goldAccount.floatingPL = [dict objectSafeForKey:@"floatingPL"];
            goldAccount.goldAmount = [dict objectSafeForKey:@"goldAmount"];
            self.raiseHeaderView.goldIncreModel = goldAccount;
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
        }
    }
    else if (tag.integerValue == kSXTagGoldIncreaseList) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *temp in resut) {
                UCFGoldIncreaseListModel *model = [UCFGoldIncreaseListModel goldIncreseListModelWithDict:temp];
                [self.dataArray addObject:model];
            }
            BOOL hasNextPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            if (hasNextPage) {
                self.currentPage ++;
                self.tableview.footer.hidden = YES;
                [self.tableview.footer resetNoMoreData];
                self.listArray = [self arrayWithDataArray:self.dataArray];
            }
            else {
                if (self.dataArray.count > 0) {
                    [self.tableview.footer noticeNoMoreData];
                }
                else
                    self.tableview.footer.hidden = YES;
                self.listArray = [self arrayWithDataArray:self.dataArray];
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

- (NSMutableArray *)arrayWithDataArray:(NSMutableArray *)data
{
    if (data.count > 0) {
        NSMutableArray *tempGroups = [NSMutableArray array];
        NSMutableArray *tempGroup = [[NSMutableArray alloc] init];
        for (UCFGoldIncreaseListModel *model in data) {
            NSDateComponents *comps = [self dateComponentsWithDateStr:model.profitDate];
            model.yearMonth = [NSString stringWithFormat:@"%ld年%ld月",(long)comps.year, (long)comps.month];
            model.monthDay = [NSString stringWithFormat:@"%ld-%ld", (long)comps.month, (long)comps.day];
        }
        UCFGoldIncreaseListModel *modelFirst = [self.dataArray firstObject];
        for (UCFGoldIncreaseListModel *model in self.dataArray) {
            if ([model.yearMonth isEqualToString:modelFirst.yearMonth]) {
                [tempGroup addObject:model];
            }
            else {
                [tempGroups addObject:tempGroup];
                modelFirst = model;
                tempGroup = [[NSMutableArray alloc] init];
                [tempGroup addObject:model];
            }
        }
        return tempGroups;
    }
    return nil;
}



- (NSDateComponents *)dateComponentsWithDateStr:(NSString *)dateStr {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:dateStr];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:date];
    return comp;
}


@end
