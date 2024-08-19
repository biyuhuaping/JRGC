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
#import "UCFNoPermissionViewController.h"
#import "UCFBidDetailRequest.h"
#import "UCFNewProjectDetailViewController.h"
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
//    [self setTopLineViewHide];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.showTableView beginRefresh];
}

- (UITableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc]init];
        _showTableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
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
        [selfWeak.showTableView cyl_reloadData];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFCollcetionResult * model = self.dataArray[indexPath.row];
    [self gotoProjectDetailVC:model];
}
- (void)gotoProjectDetailVC:(UCFCollcetionResult *)dataModel
{
    NSInteger isOrder = dataModel.isOrder;
    NSInteger status = [dataModel.status intValue];
    if (status != 2) {
        if (isOrder == 1) { //0不可看 1可看
            [self goToProjectView:dataModel];
        } else {
            NSString *titleStr = [UserInfoSingle sharedManager].isSubmitTime ? @"目前标的详情只对购买人开放":@"目前标的详情只对出借人开放";
            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:titleStr];
//            self.intoViewControllerStr = @"NoPermissionVC";
            controller.souceVC = @"CollectionDetailVC";
            [self.parentViewController.navigationController pushViewController:controller animated:YES];
        }
    } else {
        [self goToProjectView:dataModel];
    }

}
- (void)goToProjectView:(UCFCollcetionResult *)model
{
    UCFBidDetailRequest *api = [[UCFBidDetailRequest alloc] initWithProjectId:[NSString stringWithFormat:@"%ld",model.childPrdClaimId]];
    api.animatingView = self.parentViewController.view;
    @PGWeakObj(self);
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        UCFBidDetailModel *model =  request.responseJSONModel;
        NSString *message = model.message;
        if (model.ret) {
            UCFNewProjectDetailViewController *vc = [[UCFNewProjectDetailViewController alloc] init];
            vc.model = model;
            vc.accoutType = SelectAccoutTypeP2P;
            [selfWeak.parentViewController.navigationController pushViewController:vc animated:YES];
        } else {
            [AuxiliaryFunc showAlertViewWithMessage:message];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    [api start];
}
@end
