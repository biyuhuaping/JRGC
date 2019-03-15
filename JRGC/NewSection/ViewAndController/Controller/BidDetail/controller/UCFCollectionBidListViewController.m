//
//  UCFCollectionBidListViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionBidListViewController.h"
#import "UCFNewCollectionChildBidListRequest.h"
#import "UCFCollectionRootModel.h"
#import "UCFCollectionChildCell.h"
@interface UCFCollectionBidListViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
{
    NSInteger currentIndex;
}
@property(nonatomic,strong)BaseTableView *showTableView;
@property(nonatomic, strong)NSMutableArray  *dataArray;
@end

@implementation UCFCollectionBidListViewController
- (void)loadView
{
    [super loadView];
    [self.rootLayout addSubview:self.showTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.showTableView beginRefresh];
}

- (UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc]init];
        _showTableView.backgroundColor = UIColorWithRGB(0xebebee);
        _showTableView.delegate = self;
        _showTableView.dataSource =self;
        _showTableView.tableRefreshDelegate = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.enableRefreshHeader = YES;
        _showTableView.enableRefreshFooter = YES;
        _showTableView.topPos.equalTo(@0);
        _showTableView.leftPos.equalTo(@0);
        _showTableView.rightPos.equalTo(@0);
        _showTableView.bottomPos.equalTo(@0);
    }
    return _showTableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)refreshDataWithOrderStr:(NSString *)prdClaimsOrderStr andListType:(NSString *)listType
{
    self.prdClaimsOrderStr = prdClaimsOrderStr;
    self.listType = listType;
    [self.showTableView beginRefresh];
}
- (void)refreshTableViewHeader
{
    if ([self checkUserState]) {
        currentIndex = 0;
        [self fetchData];
    }
    
}
- (void)refreshTableViewFooter
{
    if ([self checkUserState]) {
        [self fetchData];
    }
}
-(void)fetchData
{
    @PGWeakObj(self);
    UCFNewCollectionChildBidListRequest *api = [[UCFNewCollectionChildBidListRequest alloc] initWithColPrdClaimId:self.colPrdClaimId Page:currentIndex PrdClaimsOrder:self.prdClaimsOrderStr Statue:self.listType];
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [selfWeak.showTableView endRefresh];
        UCFCollectionRootModel *model = request.responseJSONModel;
        if (currentIndex == 0) {
            [selfWeak.dataArray removeAllObjects];
        }
        BOOL hasNext = model.data.pageData.pagination.hasNextPage;
        if (hasNext) {
            currentIndex++;
            selfWeak.showTableView.enableRefreshFooter = YES;
        } else {
            selfWeak.showTableView.enableRefreshFooter = NO;

        }
        for (UCFCollcetionResult *tmpModel in model.data.pageData.result) {
            [selfWeak.dataArray addObject:tmpModel];
        }
        [selfWeak.showTableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    [api start];
}
- (BOOL)checkUserState
{
    if (!SingleUserInfo.loginData.userInfo.userId.length) { //如果为空 去登录页面
        [self.showTableView endRefresh];
        [SingleUserInfo loadLoginViewController];
        return NO;
    }
    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"collect";
    UCFCollectionChildCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UCFCollectionChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.dataModel = self.dataArray[indexPath.row];
    return cell;
}
@end
