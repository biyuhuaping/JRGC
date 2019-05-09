//
//  UCFCouponReturn.m
//  JRGC
//
//  Created by biyuhuaping on 16/4/19.
//  Copyright © 2016年 qinwei. All rights reserved.
//  返现券

#import "UCFCouponReturn.h"
#import "UCFCouponUseCell.h"
#import "UCFGivingPointCell.h"

#import "MJRefresh.h"
#import "NetworkModule.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "NZLabel.h"
#import "UCFToolsMehod.h"
#import "UCFCouponExchangeToFriends.h"
#import "UCFInvitationRebateViewController.h"//邀请返利
#import "UCFWebViewJavascriptBridgeMallDetails.h"
// 错误界面
#import "UCFNoDataView.h"
#import "UCFNewCouponList.h"
#import "UCFNewCouponTableViewCell.h"
#import "BaseTableView.h"
@interface UCFCouponReturn ()<NetworkModuleDelegate,BaseTableViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet BaseTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger currentPage;                   //当前页码
@property (strong, nonatomic) NSMutableArray *selectedStateArray;       // 已选中状态存储数组

@property (strong, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (strong, nonatomic) IBOutlet NZLabel *unUserFxCount;          // 总张数
@property (assign, nonatomic) BOOL presentFriendExist;                  //是否有可赠送好友（0：否 1：是）

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@end

@implementation UCFCouponReturn

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray arrayWithCapacity:20];
    // Do any additional setup after loading the view from its nib.
    _selectedStateArray = [[NSMutableArray alloc] init];// 已选中状态存储数组
    _currentPage = 1;
    if (_sourceVC == 1) {
        _unUserFxCount.textColor = [Color color:PGColorOptionTitleBlack];
    } else {
        _unUserFxCount.textColor = [Color color:PGColorOptionTitlerRead];
    }
    _unUserFxCount.font = [Color gc_Font:32];
    [_unUserFxCount setFont:[UIFont systemFontOfSize:12] string:@"张"];
    _couponNameLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
    [_couponCenterBtn setTitleColor:[Color color:PGColorOptionInputDefaultBlackGray] forState:UIControlStateNormal];
    
    [self initTableView];
    _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-176) errorTitle:@"暂无数据"];
    
    switch ([_status intValue]) {
        case 1:{
            _couponNameLabel.text = @"可用返现券";
        }
            break;
        case 2:{
            _couponNameLabel.text = @"已用返现券";
        }
            break;
        case 3:{
            _couponNameLabel.text = @"过期返现券";
        }
            break;
        case 4:{
            _couponNameLabel.text = @"已赠送返现券";
        }
            break;
    }
}
- (IBAction)fetchCouponCenter:(UIButton *)sender {
    UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
    web.url = COUPON_CENTER;
    web.isHidenNavigationbar = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)initTableView{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    _tableView.tableRefreshDelegate = self;
    _tableView.enableRefreshHeader = YES;
    _tableView.enableRefreshFooter = NO;
    _tableView.isShowDefaultPlaceHolder = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (_sourceVC == 1) {
        _couponCenterBtn.hidden = YES;
    }
    [_tableView beginRefresh];

}

#pragma mark - UITableViewDelegate
// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_status intValue]== 4) {
        return 92;
    }
    return 125;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_status intValue] == 4) {
        UCFGivingPointCell *cell = [UCFGivingPointCell cellWithTableView:tableView];
        UCFCouponModel *model = _dataArr[indexPath.row];
        cell.couponModel = model;
        return cell;
    }else{
        

        static NSString *cellStr = @"CouponCell";
        UCFNewCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[UCFNewCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            [cell.donateButton addTarget:self action:@selector(toUCFCouponExchangeToFriendsView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.investButton addTarget:self action:@selector(skipToHome:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        cell.donateButton.tag = 100 + indexPath.row;
        cell.model = _dataArr[indexPath.row];
        return cell;
        
//        [cell.donateButton addTarget:self action:@selector(toUCFCouponExchangeToFriendsView:) forControlEvents:UIControlEventTouchUpInside];
//        UCFCouponModel *model = _dataArr[indexPath.row];
//        cell.couponModel = model;
//        return cell;
    }
}
- (void)skipToHome:(UIButton *)button
{
    [self.parentViewController.rt_navigationController popToRootViewControllerAnimated:NO complete:^(BOOL finished) {
        [SingGlobalView.tabBarController setSelectedIndex:1];
    }];
}
- (void)toUCFCouponExchangeToFriendsView:(id)sender
{
    if (!_presentFriendExist) {
        BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:nil message:@"当前暂无好友，快邀请好友来工场吧~" cancelButtonTitle:@"知道了" clickButton:^(NSInteger index) {
            if (index == 1) {
                UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
                feedBackVC.title = @"邀请获利";
                [self.navigationController pushViewController:feedBackVC animated:YES];

            }
        } otherButtonTitles:@"邀友注册"];
        [alert_bankbrach show];
        return;
    }

    NSInteger row = ((UIButton *)sender).tag - 100;
    UCFCouponExchangeToFriends *vc = [[UCFCouponExchangeToFriends alloc]initWithNibName:@"UCFCouponExchangeToFriends" bundle:nil];
    vc.quanData = _dataArr[row];
    vc.couponType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 请求网络及回调
//下拉刷新
- (void)refreshTableViewHeader{
    _currentPage = 1;
    [self refreshTableViewFooter];
}
// 上拉加载更多
- (void)refreshTableViewFooter{

    UCFNewCouponList *api = [[UCFNewCouponList alloc] initWithCouponType:@"1" CurrentPage:_currentPage PageSize:20 Statue:_status];
    @PGWeakObj(self);
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_tableView endRefresh];
        UCFCouponListModel *model = request.responseJSONModel;
        if (model.ret) {
            BOOL hasNextPage = [model.data.pageData.pagination.hasNextPage boolValue];
            if (hasNextPage) {
                selfWeak.tableView.enableRefreshFooter = YES;
                selfWeak.currentPage ++ ;
            } else {
                selfWeak.tableView.enableRefreshFooter = NO;
            }
            selfWeak.presentFriendExist = [model.data.presentFriendExist boolValue];
            NSArray *dataArr = model.data.pageData.result;
            NSMutableArray *temp1 = [NSMutableArray array];
            for (UCFCouponListResult *couponModel in dataArr) {
                couponModel.couponType = 0;
                [temp1 addObject:couponModel];
            }
            id unUserFxCount = model.data.unUserFxCount;
            selfWeak.unUserFxCount.text = [NSString stringWithFormat:@"%@ 张",unUserFxCount?unUserFxCount:@"0"];
            [selfWeak.unUserFxCount setFont:[UIFont systemFontOfSize:12] string:@" 张"];
            if (_currentPage == 1) {
                selfWeak.dataArr = [NSMutableArray arrayWithArray:temp1];
            }else{
                [selfWeak.tableView endRefresh];
                [selfWeak.dataArr addObjectsFromArray:temp1];
            }
            [selfWeak.tableView cyl_reloadData];
        } else {
            [AuxiliaryFunc showToastMessage:model.message withView:self.view];
            [selfWeak.tableView cyl_reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [selfWeak.tableView cyl_reloadData];
    }];
    [api start];
}


- (void)dealloc {
    
}
@end
