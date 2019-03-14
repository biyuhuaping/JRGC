//
//  UCFCouponInterest.m
//  JRGC
//
//  Created by biyuhuaping on 16/2/23.
//  Copyright © 2016年 qinwei. All rights reserved.
//  返息券

#import "UCFCouponInterest.h"
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
#import "UCFInvitationRebateViewController.h"//邀请获利
#import "UCFWebViewJavascriptBridgeMallDetails.h"
// 错误界面
#import "UCFNoDataView.h"
#import "UCFNewCouponTableViewCell.h"
#import "UCFNewCouponList.h"
@interface UCFCouponInterest ()<NetworkModuleDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger currentPage;                   // 当前页码
@property (strong, nonatomic) NSMutableArray *selectedStateArray;       // 已选中状态存储数组

@property (strong, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (strong, nonatomic) IBOutlet NZLabel *unUserFxCount;          // 总张数
@property (assign, nonatomic) BOOL presentFriendExist;                  //是否有可赠送好友（0：否 1：是）

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@end

@implementation UCFCouponInterest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectedStateArray = [[NSMutableArray alloc] init];// 已选中状态存储数组
    _currentPage = 1;
    if (_sourceVC == 1) {
        _unUserFxCount.textColor = [Color color:PGColorOptionTitleBlack];
    } else {
        _unUserFxCount.textColor = [Color color:PGColorOptionCellContentBlue];
    }
    _unUserFxCount.font = [Color gc_Font:32];
    [_unUserFxCount setFont:[UIFont systemFontOfSize:12] string:@"张"];
    _couponNameLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
    [_couponCenterBtn setTitleColor:[Color color:PGColorOptionInputDefaultBlackGray] forState:UIControlStateNormal];

    [self initTableView];
    _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-176) errorTitle:@"暂无数据"];
    
    switch ([_status intValue]) {
        case 1:{
            _couponNameLabel.text = @"可用返息券";
        }
            break;
        case 2:{
            _couponNameLabel.text = @"已用返息券";
        }
            break;
        case 3:{
            _couponNameLabel.text = @"过期返息券";
        }
            break;
        case 4:{
            _couponNameLabel.text = @"已赠送返息券";
        }
            break;
    }
}

- (void)initTableView{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorWithRGB(0xebebee);
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    // 添加上拉加载更多
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCouponDataList];
    }];
    
    // 添加传统的下拉刷新
    [_tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshingData)];
    [_tableView.header beginRefreshing];
    _tableView.footer.hidden = YES;
    if (_sourceVC == 1) {
        _couponCenterBtn.hidden = YES;
    }
}

#pragma mark - UITableViewDelegate
// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

        }
        cell.model = _dataArr[indexPath.row];
        return cell;
    }
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
    
    UITableViewCell * cell = nil;
    if (kIS_IOS8) {
        cell = (UITableViewCell *)[[sender superview] superview];
    } else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }

    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UCFCouponExchangeToFriends *vc = [[UCFCouponExchangeToFriends alloc]initWithNibName:@"UCFCouponExchangeToFriends" bundle:nil];
    vc.quanData = _dataArr[indexPath.row];
    vc.couponType = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)fetchCouponCenter:(UIButton *)sender {
    
    UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
    web.url = COUPON_CENTER;
    web.isHidenNavigationbar = YES;
    [self.navigationController pushViewController:web animated:YES];
    
}
#pragma mark - 请求网络及回调
//下拉刷新
- (void)refreshingData{
    _currentPage = 1;
    [self getCouponDataList];
}
// 上拉加载更多
- (void)getCouponDataList{
    
    UCFNewCouponList *api = [[UCFNewCouponList alloc] initWithCouponType:@"2" CurrentPage:_currentPage PageSize:20 Statue:_status];
    @PGWeakObj(self);
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        UCFCouponListModel *model = request.responseJSONModel;
        if (model.ret) {
            BOOL hasNextPage = model.data.pageData.pagination.hasNextPage;
            selfWeak.presentFriendExist = [model.data.presentFriendExist boolValue];
            NSArray *dataArr = model.data.pageData.result;
            NSMutableArray *temp1 = [NSMutableArray array];
            for (UCFCouponListResult *couponModel in dataArr) {
                couponModel.couponType = 1;
                [temp1 addObject:couponModel];
            }
            id unUserFxCount = model.data.unUserFxCount;
            selfWeak.unUserFxCount.text = [NSString stringWithFormat:@"%@张",unUserFxCount?unUserFxCount:@"0"];
            [selfWeak.unUserFxCount setFont:[UIFont systemFontOfSize:12] string:@"张"];
            if (_currentPage == 1) {
                selfWeak.dataArr = [NSMutableArray arrayWithArray:temp1];
                if (dataArr.count == 0) {
                    [selfWeak.tableView.footer noticeNoMoreData];
                    [selfWeak.noDataView showInView:selfWeak.tableView];
                } else {
                    [selfWeak.noDataView hide];
                    selfWeak.tableView.footer.hidden = NO;
                    if (!hasNextPage) {
                        [selfWeak.tableView.footer noticeNoMoreData];
                    } else {
                        selfWeak.currentPage ++;
                        [selfWeak.tableView.footer resetNoMoreData];
                    }
                }
            }else{
                [selfWeak.tableView.footer endRefreshing];
                [selfWeak.dataArr addObjectsFromArray:temp1];
                if (!hasNextPage) {
                    [selfWeak.tableView.footer noticeNoMoreData];
                }
                else {
                    selfWeak.currentPage ++;
                    [selfWeak.tableView.footer resetNoMoreData];
                }
            }
            [selfWeak.tableView reloadData];
        } else {
            [AuxiliaryFunc showToastMessage:model.message withView:self.view];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    [api start];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

////请求成功及结果
//- (void)endPost:(id)result tag:(NSNumber *)tag{
//    [_tableView.header endRefreshing];
//    [_tableView.footer endRefreshing];
////    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    NSMutableDictionary *dic = [result objectFromJSONString];
//    DDLogDebug(@"返息券列表：%@",dic);
//
//    if (tag.intValue == kSXTagReturnCouponList2) {
//        if ([dic[@"ret"] boolValue]) {
//            BOOL hasNextPage = [dic[@"data"][@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
//            _presentFriendExist = [dic[@"data"][@"presentFriendExist"] boolValue];
//            NSArray *dataArr = dic[@"data"][@"pageData"][@"result"];
//            NSMutableArray *temp1 = [NSMutableArray array];
//            for (NSDictionary *dict in dataArr) {
//                UCFCouponModel *couponModel = [UCFCouponModel couponWithDict:dict];
////                couponModel.state = [_status integerValue];//1：未使用 2：已使用 3：已过期 4：已赠送
//                couponModel.couponType = @"1";
//                [temp1 addObject:couponModel];
//            }
//            id unUserFxCount = dic[@"data"][@"unUserFxCount"];
//            _unUserFxCount.text = [NSString stringWithFormat:@"%@张",unUserFxCount?unUserFxCount:@"0"];
//            [_unUserFxCount setFont:[UIFont systemFontOfSize:12] string:@"张"];
//
//            if (_currentPage == 1) {
//                [_tableView.header endRefreshing];
//                _dataArr = [NSMutableArray arrayWithArray:temp1];
//                if (dataArr.count == 0) {
//                    [self.tableView.footer noticeNoMoreData];
//                    [_noDataView showInView:_tableView];
//                }else{
//                    [self.noDataView hide];
//                    _tableView.footer.hidden = NO;
//                    if (!hasNextPage) {
//                        [_tableView.footer noticeNoMoreData];
//                    }
//                    else {
//                        _currentPage ++;
//                        [_tableView.footer resetNoMoreData];
//                    }
//                };
//            }else{
//                [_tableView.footer endRefreshing];
//                [_dataArr addObjectsFromArray:temp1];
//                if (!hasNextPage) {
//                    [_tableView.footer noticeNoMoreData];
//                }
//                else {
//                    _currentPage ++;
//                    [_tableView.footer resetNoMoreData];
//                }
//            }
//            [_tableView reloadData];
//        }else {
//            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
//        }
//    }
////    [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"6"];
//}
//
////请求失败
//- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
//{
//    [_tableView.header endRefreshing];
//    [_tableView.footer endRefreshing];
//    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
////    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}

@end
