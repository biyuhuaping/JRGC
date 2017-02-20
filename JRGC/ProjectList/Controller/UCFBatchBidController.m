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

@interface UCFBatchBidController () <UITableViewDataSource, UITableViewDelegate>
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
//        [weakSelf getNetDataFromNet];
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


@end
