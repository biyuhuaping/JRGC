//
//  UCFNewBatchBidListViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBatchBidListViewController.h"
#import "UCFNewBatchTableViewCell.h"
#import "UCFMyBatchBidListRequest.h"
#import "UCFMyBatchBidModel.h"
#import "UCFMyInvestBatchBidDetailViewController.h"
#import "UCFMyBatchInvestDetailRequest.h"
#import "UCFMyInvestBatchBidDetailViewController.h"
@interface UCFNewBatchBidListViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
{
    
}
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, strong)BaseTableView *showTableView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@end

@implementation UCFNewBatchBidListViewController

- (void)loadView
{
    [super loadView];
    self.showTableView.leftPos.equalTo(@0);
    self.showTableView.rightPos.equalTo(@0);
    self.showTableView.topPos.equalTo(@0);
    self.showTableView.bottomPos.equalTo(@0);

    [self.rootLayout addSubview:self.showTableView];
    [self.showTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.showTableView beginRefresh];
}
- (void)refreshTableViewHeader
{
    _currentPage = 0;
    self.showTableView.enableRefreshFooter = YES;
    [self fetchData];
}
/**
 *  上提刷新的回调
 *
 */
- (void)refreshTableViewFooter
{
    [self fetchData];
}
- (void)fetchData
{
    @PGWeakObj(self);
    UCFMyBatchBidListRequest *api = [[UCFMyBatchBidListRequest alloc] initWithPageIndex:_currentPage];
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        UCFMyBatchBidModel *model = request.responseJSONModel;
        if (model.ret) {
            if (selfWeak.currentPage == 0) {
                [selfWeak.dataArray removeAllObjects];
            }
            for (UCFMyBatchBidResult *dataModel in model.data.pageData.result) {
                [self.dataArray addObject:dataModel];
            }
            
            [selfWeak.showTableView endRefresh];
            if (!model.data.pageData.pagination.hasNextPage) {
                selfWeak.showTableView.enableRefreshFooter = NO;
            } else {
                selfWeak.showTableView.enableRefreshFooter = YES;
            }
            [selfWeak.showTableView reloadData];
        } else {
//            ShowMessage(model.message);
        }

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    api.animatingView = self.view;
    [api start];
}
- (BaseTableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.tableRefreshDelegate = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _showTableView.estimatedRowHeight = 60;
//        _showTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _showTableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:20];
    }
    return _dataArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    UCFNewBatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UCFNewBatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFMyBatchBidResult *dataModel = self.dataArray[indexPath.row];
    if ([dataModel.status intValue] == 1) {
        NSString *colPrdClaimIdStr  = [NSString stringWithFormat:@"%ld",dataModel.colId];
        NSString *batchOrderIdStr = [NSString stringWithFormat:@"%ld",dataModel.ID];
        UCFMyBatchInvestDetailRequest *api = [[UCFMyBatchInvestDetailRequest alloc] initWithColPrdClaimsId:colPrdClaimIdStr BatchOrderId:batchOrderIdStr];
        [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            UCFMyBtachBidRoot *model = request.responseJSONModel;
            if (model.ret) {
                UCFMyInvestBatchBidDetailViewController *vc = [[UCFMyInvestBatchBidDetailViewController alloc] init];
                vc.dataModel = model;
                vc.colPrdClaimIdStr = colPrdClaimIdStr;
                vc.batchOrderIdStr = batchOrderIdStr;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
//                ShowMessage(model.message);
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        [api start];
    }
}
@end
