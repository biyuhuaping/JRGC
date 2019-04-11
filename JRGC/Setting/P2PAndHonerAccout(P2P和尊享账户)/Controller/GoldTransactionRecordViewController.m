//
//  GoldTransactionRecordViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "GoldTransactionRecordViewController.h"
#import "UCFGoldTransCell.h"
#import "UCFGoldTransactionHeadView.h"
#import "UCFGoldTransactionDetailViewController.h"
#import "UCFGoldTradeListModel.h"
#import "UCFNoDataView.h"
@interface GoldTransactionRecordViewController ()<UITableViewDelegate,UITableViewDataSource,NoDataViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSMutableArray    *timeIndexArr;
@property (strong, nonatomic)UCFNoDataView *noDataView;

@end

@implementation GoldTransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
}
- (void)initData
{
    self.dataDict = [NSMutableDictionary dictionary];
    self.timeIndexArr = [NSMutableArray array];
    [self addRefreshingAndLoadMore];
    
}

- (void)initUI
{
    baseTitleLabel.text = @"交易记录";
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.backgroundColor = UIColorWithRGB(0xebebee);
    [self addLeftButton];
    if (!self.noDataView) {
        self.noDataView = [[UCFNoDataView alloc] initGoldWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 100) errorTitle:@"你还没有交易记录" buttonTitle:@""];
        self.noDataView.delegate = self;
    }
}
- (void)addRefreshingAndLoadMore
{
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加上拉加载更多
    [self.baseTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getNetDataFromNet];
    }];
    self.currentPage = 1;
    // 添加传统的下拉刷新
    [self.baseTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNetDataFromNet)];
    [self.baseTableView.header beginRefreshing];
    self.baseTableView.footer.hidden = YES;
}
- (void)getNetDataFromNet
{
    NSString *uuid = SingleUserInfo.loginData.userInfo.userId;
    NSDictionary *strParameters;
    if ([self.baseTableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.baseTableView.footer resetNoMoreData];
    }
    if (uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"pageNo", @"20", @"pageSize", nil];
    }
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGoldTradeFlowList owner:self signature:YES Type:SelectAccoutDefault];
}
#pragma NetDelegat
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    if (tag.intValue == kSXTagGoldTradeFlowList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            
            if ([self.baseTableView.header isRefreshing]) {
                [self.dataDict removeAllObjects];
                [self.timeIndexArr removeAllObjects];
            }
            //讲数据分组
            for (int i = 0; i < list_result.count; i++) {
                NSDictionary *dic = [list_result objectAtIndex:i];
                UCFGoldTradeListModel *model = [[UCFGoldTradeListModel alloc] initWithDict:dic];
                NSString *tradeTime = model.tradeTime;
                tradeTime = [tradeTime substringToIndex:10];
                if ([[self.dataDict allKeys] containsObject:tradeTime]) {
                    NSMutableArray *tmpArr = [self.dataDict objectForKey:tradeTime];
                    [tmpArr addObject:model];
                } else {
                    //此处每次有新分组的时候会创建，因为字典是无序的，所以用数组存个有序序列（前提是服务端给的有顺序的）
                    NSMutableArray *tmpArr = [NSMutableArray array];
                    [tmpArr addObject:model];
                    [self.dataDict setValue:tmpArr forKey:tradeTime];
                    //这个实际上是个时间索引
                    [self.timeIndexArr addObject:tradeTime];
                }
            }
            self.currentPage ++;
            [self.baseTableView reloadData];
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            
            if (self.dataDict.allKeys.count > 0) {
                self.baseTableView.footer.hidden = NO;
                [self.noDataView hide];
                if (!hasNext) {
                    [self.baseTableView.footer noticeNoMoreData];
                }
            }
            else {
                [self.noDataView showInView:self.baseTableView];
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    if ([self.baseTableView.header isRefreshing]) {
        [self.baseTableView.header endRefreshing];
    }
    if ([self.baseTableView.footer isRefreshing]) {
        [self.baseTableView.footer endRefreshing];
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:@"网络异常"];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * identy = @"headFoot";
    UCFGoldTransactionHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    if (!view) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldTransactionHeadView" owner:self options:nil] lastObject];
    }
    view.timeLab.text =  self.timeIndexArr[section];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.timeIndexArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *tradeTimeKey = self.timeIndexArr[section];
    NSArray *arr  = [self.dataDict valueForKey:tradeTimeKey];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UCFGoldTransCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFGoldTransCell" owner:self options:nil][0];
    }
    NSString *tradeTimeKey = self.timeIndexArr[indexPath.section];
    cell.model = [[self.dataDict valueForKey:tradeTimeKey] objectAtIndex:indexPath.row];
    if (indexPath.section == self.timeIndexArr.count - 1 && indexPath.row == [[self.dataDict valueForKey:tradeTimeKey] count] - 1) {
        cell.sepLinePostion = 2;
    } else if (indexPath.row == [[self.dataDict valueForKey:tradeTimeKey] count] - 1) {
        cell.sepLinePostion = 1;
    } else {
        cell.sepLinePostion = 0;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tradeTimeKey = self.timeIndexArr[indexPath.section];
    UCFGoldTradeListModel *model = [[self.dataDict valueForKey:tradeTimeKey] objectAtIndex:indexPath.row];
    UCFGoldTransactionDetailViewController *vc1 = [[UCFGoldTransactionDetailViewController alloc] initWithNibName:@"UCFGoldTransactionDetailViewController" bundle:nil];
    vc1.model = model;
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)refreshBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
