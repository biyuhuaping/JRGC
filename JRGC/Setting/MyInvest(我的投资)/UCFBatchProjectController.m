//
//  UCFBatchProjectController.m
//  JRGC
//
//  Created by njw on 2017/2/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBatchProjectController.h"
#import "UCFInvestmentDetailViewController.h"

#import "UCFSelectItemView.h"
#import "UCFNoDataView.h"

@interface UCFBatchProjectController () <UITableViewDelegate, UITableViewDataSource, UCFSelectItemViewDelegate>
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;
@property (strong, nonatomic) UITableView *tableView3;
@property (weak, nonatomic) IBOutlet UCFSelectItemView *selectItemView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (strong, nonatomic) NSMutableArray *dataArr1;
@property (strong, nonatomic) NSMutableArray *dataArr2;
@property (strong, nonatomic) NSMutableArray *dataArr3;

@property (assign, nonatomic) NSInteger pageNum1;
@property (assign, nonatomic) NSInteger pageNum2;
@property (assign, nonatomic) NSInteger pageNum3;

@property (strong, nonatomic) NSMutableArray *didClickBtns;

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@end

@implementation UCFBatchProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - set scrollview
    
    CGFloat height = ScreenHeight -240 ;
    self.bgScrollView.contentSize = CGSizeMake(ScreenWidth*3, height);
#pragma mark - init tableview
    [self addAndSetTablesWithHeight:height andWidth:ScreenWidth];
#pragma mark - setting selectItem
    self.selectItemView.delegate = self;
#pragma mark - init no data view
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:self.tableView1.bounds errorTitle:@"暂无数据"];
#pragma mark - init item did click array 
    [self.didClickBtns addObject:@(0)];
#pragma mark - init Net request
    [self initNetRequest];
    
    // 马上进入刷新状态
    [_tableView1.header beginRefreshing];
}

#pragma mark - add and set tableviews

- (void)addAndSetTablesWithHeight:(CGFloat)height andWidth:(CGFloat)width
{
    UITableView *tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height) style:UITableViewStylePlain];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [self.bgScrollView addSubview:tableView1];
    self.tableView1 = tableView1;
    
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(width, 0, width, height) style:UITableViewStylePlain];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    [self.bgScrollView addSubview:tableView2];
    self.tableView2 = tableView2;
    
    UITableView *tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(width*2, 0, width, height) style:UITableViewStylePlain];
    tableView3.delegate = self;
    tableView3.dataSource = self;
    [self.bgScrollView addSubview:tableView3];
    self.tableView3 = tableView3;
    
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView1.backgroundColor = UIColorWithRGB(0xebebee);
    tableView2.backgroundColor = UIColorWithRGB(0xebebee);
    tableView3.backgroundColor = UIColorWithRGB(0xebebee);
    
    // 是否支持点击状态栏回到最顶端
    tableView1.scrollsToTop = YES;
    tableView2.scrollsToTop = NO;
    tableView3.scrollsToTop = NO;
}

#pragma mark - init Net request
- (void)initNetRequest
{
    self.pageNum1 = 1;
    self.pageNum2 = 1;
    self.pageNum3 = 1;
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    // 添加上拉加载更多
    [_tableView1 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getBatchInvestDataList];
    }];
    
    // 添加上拉加载更多
    [_tableView2 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getBatchInvestDataList];
    }];
    
    // 添加上拉加载更多
    [_tableView3 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getBatchInvestDataList];
    }];
    
    [_tableView1 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getBatchInvestDataList)];
    [_tableView2 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getBatchInvestDataList)];
    [_tableView3 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getBatchInvestDataList)];
    
    _tableView1.footer.hidden = YES;
    _tableView2.footer.hidden = YES;
    _tableView3.footer.hidden = YES;
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView1) {
        return 2;
    }
    else if (tableView == self.tableView2) {
        return 3;
    }
    else if (tableView == self.tableView3) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.tableView1 == tableView) {
//
//    }
//    else if (self.tableView2 == tableView) {
//        
//    }
//    else if (self.tableView3 == tableView) {
//        
//    }
    static NSString *cellID = @"cel";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSMutableArray *temp = nil;
    if (_tableView1 == tableView) {
        temp = _dataArr1;
    }
    else if (_tableView2 == tableView) {
        temp = _dataArr2;
    }
    else if (_tableView3 == tableView) {
        temp = _dataArr3;
    }
//    NSDictionary *dict = temp[indexPath.row];
    UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
//    controller.billId = dict[@"prdOrderId"];
//    controller.detailType = @"2";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - net request
- (void)getBatchInvestDataList
{
    
}

#pragma mark - selectItem delegate
- (void)selectItemView:(UCFSelectItemView *)selectItemView selectedButton:(UIButton *)button
{
    NSInteger index = button.tag - 110;
    CGFloat offset = ScreenWidth*index;
    [self.bgScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    // 是否支持点击状态栏回到最顶端
    _tableView1.scrollsToTop = NO;
    _tableView2.scrollsToTop = NO;
    _tableView3.scrollsToTop = NO;
    
    // 是否支持点击状态栏回到最顶端
    switch (index) {
        case 0:{
            self.tableView1.scrollsToTop = YES;
        }
            break;
        case 1:{
            self.tableView2.scrollsToTop = YES;
        }
            break;
        case 2:{
            self.tableView3.scrollsToTop = YES;
        }
            break;
    }
    
    if (![_didClickBtns containsObject:@(index)]) {
        [_didClickBtns addObject:@(index)];
        switch (index) {
            case 0:{
                [self.tableView1.header beginRefreshing];
            }
                break;
            case 1:{
                [self.tableView2.header beginRefreshing];
            }
                break;
            case 2:{
                [self.tableView3.header beginRefreshing];
            }
                break;
        }
    }
}

#pragma mark - lazying load 
- (NSMutableArray *)dataArr1
{
    if (!_dataArr1) {
        _dataArr1 = [NSMutableArray array];
    }
    return _dataArr1;
}

- (NSMutableArray *)dataArr2
{
    if (!_dataArr2) {
        _dataArr2 = [NSMutableArray array];
    }
    return _dataArr2;
}

- (NSMutableArray *)dataArr3
{
    if (!_dataArr3) {
        _dataArr3 = [NSMutableArray array];
    }
    return _dataArr3;
}

- (NSMutableArray *)didClickBtns
{
    if (!_didClickBtns) {
        _didClickBtns = [NSMutableArray array];
    }
    return _didClickBtns;
}

@end
