//
//  UCFTransBidListViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransBidListViewController.h"
#import "UCFHighQualityBidHeaderView.h"
#import "UCFHighQualityTableViewCell.h"
#import "UCFSegementBtnView.h"
#import "UCFToolsMehod.h"
#import "UCFInvestmentDetailViewController.h"
@interface UCFTransBidListViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,UCFSegementBtnViewDelegate>
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, strong)BaseTableView *showTableView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@property(nonatomic, strong)UCFHighQualityBidHeaderView *board;
@end

@implementation UCFTransBidListViewController

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
    self.board = board;
    
    UCFSegementBtnView *segeView = [[UCFSegementBtnView alloc] initWithTitleArray:@[@"回款中",@"已回款"] delegate:self];
    segeView.heightSize.equalTo(@57);
    segeView.myHorzMargin = 0;
    segeView.topPos.equalTo(board.bottomPos);
    [headView addSubview:segeView];
    
    [self.rootLayout addSubview:headView];
    
    self.showTableView.leftPos.equalTo(@0);
    self.showTableView.rightPos.equalTo(@0);
    self.showTableView.topPos.equalTo(headView.bottomPos);
    self.showTableView.bottomPos.equalTo(@0);
    
    [self.rootLayout addSubview:self.showTableView];
    [self.showTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    [self getHeaderInfoRequest];
    [self.showTableView beginRefresh];
    
}
- (void)getHeaderInfoRequest
{
    if (SingleUserInfo.loginData.userInfo.userId) {
        NSString *strParameters = [NSString stringWithFormat:@"userId=%@",SingleUserInfo.loginData.userInfo.userId];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagMyInvestHeaderInfo owner:self Type:self.accoutType];
    }
}
- (void)beginPost:(kSXTag)tag
{
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    if (tag.integerValue == kSXTagMyInvestHeaderInfo) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] intValue] == 1)
        {
            NSDictionary *data = [dic objectSafeDictionaryForKey:@"data"];
            //            id interests = data[@"interests"];
            //            self.interestsLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:interests]];//累计收益
            id principal = data[@"noPrincipal"];
            self.board.principalValueLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:principal]];//待收本金
            [self.board.principalValueLab sizeToFit];
            
            id noInterests = data[@"noInterests"];
            self.board.interestValueLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:noInterests]];//待收利息
            [self.board.interestValueLab sizeToFit];
            
        }
    }else if (tag.integerValue == kSXTagTransfersOrder) {
        [self.showTableView endRefresh];
        NSMutableDictionary *dic = [result objectFromJSONString];
        NSString *rstcode = dic[@"status"];
        if ([rstcode intValue] == 1) {
            if (_currentPage == 1) {
                [self.dataArray removeAllObjects];
                [self.showTableView reloadData];
            }
            BOOL hasNextPage = [dic[@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
            if (hasNextPage) {
                _currentPage++;
                self.showTableView.enableRefreshFooter = YES;
            } else {
                self.showTableView.enableRefreshFooter = NO;
            }

            NSArray *dataArr = dic[@"pageData"][@"result"];
            [self.dataArray addObjectsFromArray:dataArr];
            [self.showTableView cyl_reloadData];
        } else {
//            ShowMessage(rsttext);
            [self.showTableView cyl_reloadData];

        }
        
        
        
    }
    HideHUD(self.view);
    
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    ShowMessage(@"网络连接异常");
    
}
- (void)refreshTableViewHeader
{
    _currentPage = 1;
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
    _index = index;
    [self.showTableView beginRefresh];
}
- (void)fetchData
{
    ShowHUD(self.view);
    
//    NSArray *tempArr = @[@"3",@"100",@"4"];
//    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
//    NSString *strParameters = [NSString stringWithFormat:@"page=%ld&rows=20&userId=%@&flag=%@&typeFlag=", (long)_currentPage,userId,tempArr[_index]];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdOrderUinvest owner:self Type:SelectAccoutTypeP2P];
    
    
    
    NSArray *tempArr = @[@"5",@"6"];
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    NSString *strParameters = [NSString stringWithFormat:@"page=%ld&rows=20&userId=%@&orderUserId=%@&typeFlag=3&callStatus=%@", (long)_currentPage,userId,userId,tempArr[_index]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagTransfersOrder owner:self Type:self.accoutType];
    
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
    controller.billId = dict[@"prdOrderId"];
    controller.accoutType = self.accoutType;
    controller.detailType = @"2";
    [self.navigationController pushViewController:controller animated:YES];
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
    return 224;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    UCFHighQualityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UCFHighQualityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    [cell setDataDict:self.dataArray[indexPath.row] isTrans:YES];
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

@end
