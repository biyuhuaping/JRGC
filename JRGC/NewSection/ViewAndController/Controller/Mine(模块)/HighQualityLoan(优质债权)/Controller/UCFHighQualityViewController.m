//
//  UCFHighQualityViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHighQualityViewController.h"
#import "UCFHighQualityBidHeaderView.h"
#import "UCFHighQualityTableViewCell.h"
#import "UCFSegementBtnView.h"
@interface UCFHighQualityViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,UCFSegementBtnViewDelegate>
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, strong)BaseTableView *showTableView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@end

@implementation UCFHighQualityViewController
- (void)loadView
{
    [super loadView];
    
    MyRelativeLayout *headView = [MyRelativeLayout new];
    headView.heightSize.equalTo(@(131 +57));
    headView.myHorzMargin = 0;

    UCFHighQualityBidHeaderView *board = [UCFHighQualityBidHeaderView new];
    board.heightSize.equalTo(@(131));
    board.myHorzMargin = 0;
    board.topPos.equalTo(@0);
    [headView addSubview:board];
    
    UCFSegementBtnView *segeView = [[UCFSegementBtnView alloc] initWithTitleArray:@[@"回款中",@"未起息",@"已回款"] delegate:self];
    segeView.heightSize.equalTo(@57);
    segeView.myHorzMargin = 0;
    segeView.topPos.equalTo(board.bottomPos);
    [headView addSubview:segeView];
    self.showTableView.tableHeaderView = headView;

    
    self.showTableView.leftPos.equalTo(@0);
    self.showTableView.rightPos.equalTo(@0);
    self.showTableView.topPos.equalTo(@0);
    self.showTableView.bottomPos.equalTo(@0);
    
    [self.rootLayout addSubview:self.showTableView];
    [self.showTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.showTableView beginRefresh];
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
- (void)segementBtnView:(UCFSegementBtnView *)segeView selectIndex:(NSInteger)index
{
    
}
- (void)fetchData
{
    /*
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
        } else {
            ShowMessage(model.message);
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    api.animatingView = self.view;
    [api start];
     */
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
    return 5;
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 224;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    UCFHighQualityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UCFHighQualityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
@end
