//
//  UCFCouponExchange.m
//  JRGC
//
//  Created by biyuhuaping on 16/4/18.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFCouponExchange.h"
#import "UCFExchangeCell.h"

//#import "MJRefresh.h"
//#import "NetworkModule.h"
//#import "MBProgressHUD.h"
//#import "JSONKit.h"
//#import "AuxiliaryFunc.h"
#import "NZLabel.h"
#import "UCFToolsMehod.h"

#import "UCFWebViewJavascriptBridgeMallDetails.h"

// 错误界面
#import "UCFNoDataView.h"

@interface UCFCouponExchange ()<NetworkModuleDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger currentPage;                   //当前页码
@property (strong, nonatomic) NSMutableArray *selectedStateArray;       // 已选中状态存储数组

@property (strong, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (strong, nonatomic) IBOutlet NZLabel *unUserFxCount;          // 总张数

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;

@end

@implementation UCFCouponExchange

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectedStateArray = [[NSMutableArray alloc] init];// 已选中状态存储数组
    _currentPage = 1;
    [_unUserFxCount setFont:[UIFont systemFontOfSize:12] string:@"张"];

    [self initTableView];
    _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-176) errorTitle:@"暂无数据"];
    
    switch ([_status intValue]) {
        case 1:{
            _couponNameLabel.text = @"可用兑换券";
        }
            break;
        case 2:{
            _couponNameLabel.text = @"已用兑换券";
        }
            break;
        case 3:{
            _couponNameLabel.text = @"过期兑换券";
        }
            break;
        case 4:{
            _couponNameLabel.text = @"已赠送兑换券";
        }
            break;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCouponDataList) name:@"fromeCouponExchange" object:nil];
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
}

#pragma mark - UITableViewDelegate
// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCFExchangeCell *cell = [UCFExchangeCell cellWithTableView:tableView];
    UCFExchangeModel *model = _dataArr[indexPath.row];
    cell.exchangeModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UCFExchangeCell *cell = [UCFExchangeCell cellWithTableView:tableView];
    cell.exchangeModel = _dataArr[indexPath.row];;
    
    UCFWebViewJavascriptBridgeMallDetails *subVC = [[UCFWebViewJavascriptBridgeMallDetails alloc]initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
    subVC.navTitle = @"豆哥商城";
    subVC.url      = cell.exchangeModel.couponUrl;
    [self.navigationController pushViewController:subVC animated:YES];
}

#pragma mark - 请求网络及回调
//下拉刷新
- (void)refreshingData{
    _currentPage = 1;
    [self getCouponDataList];
}
// 上拉加载更多
- (void)getCouponDataList{
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",_currentPage],
                          @"pageSize":@"20",
                          @"status":_status,   //status：1：未使用 2：已使用 3：已过期 4：已赠送
                          @"userId":userId};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagCouponCertificateList owner:self signature:YES];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    DBLOG(@"兑换券列表：%@",dic);
    
    if (tag.intValue == kSXTagCouponCertificateList) {
        if ([dic[@"ret"] boolValue]) {
            BOOL hasNextPage = [dic[@"data"][@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
            NSArray *dataArr = dic[@"data"][@"pageData"][@"result"];
            NSMutableArray *temp1 = [NSMutableArray array];
            for (NSDictionary *dict in dataArr) {
                UCFExchangeModel *exchangeModel = [UCFExchangeModel couponWithDict:dict];
                exchangeModel.state = [_status integerValue];//1：未使用 2：已使用 3：已过期 4：已赠送
                [temp1 addObject:exchangeModel];
            }
            id unUserFxCount = dic[@"data"][@"unUserFxCount"];
            _unUserFxCount.text = [NSString stringWithFormat:@"%@张",unUserFxCount?unUserFxCount:@"0"];
            [_unUserFxCount setFont:[UIFont systemFontOfSize:12] string:@"张"];
            
            if (_currentPage == 1) {
                _dataArr = [NSMutableArray arrayWithArray:temp1];
                if (dataArr.count == 0) {
                    [self.tableView.footer noticeNoMoreData];
                    [_noDataView showInView:_tableView];
                }else{
                    [self.noDataView hide];
                    _tableView.footer.hidden = NO;
                    if (!hasNextPage) {
                        [_tableView.footer noticeNoMoreData];
                    }
                    else {
                        _currentPage ++;
                        [_tableView.footer resetNoMoreData];
                    }
                };
            }else{
                [_dataArr addObjectsFromArray:temp1];
                if (!hasNextPage) {
                    [_tableView.footer noticeNoMoreData];
                }
                else {
                    _currentPage ++;
                    [_tableView.footer resetNoMoreData];
                }
            }
            [_tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"7"];
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"fromeCouponExchange" object:nil];
}

@end
