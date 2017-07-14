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
@interface GoldTransactionRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSMutableArray    *timeIndexArr;
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
    UCFGoldTradeListModel *model = [UCFGoldTradeListModel new];
    model.frozenMoney = @"1000.0";
    model.purchaseAmount = @"100";
    model.purchasePrice = @"235.00";
    model.tradeMoney = @"11111.00";
    model.tradeRemark = @"都是对的撒";
    model.tradeTime = @"2017-07-13";
    model.tradeTypeCode = @"12";
    model.tradeTypeName = @"买金";
    
    UCFGoldTradeListModel *model1 = [UCFGoldTradeListModel new];
    model1.frozenMoney = @"1000.0";
    model1.purchaseAmount = @"100";
    model1.purchasePrice = @"235.00";
    model1.tradeMoney = @"11111.00";
    model1.tradeRemark = @"都是对的撒";
    model1.tradeTime = @"2017-08-13";
    model1.tradeTypeCode = @"11";
    model1.tradeTypeName = @"冻结";
    
    NSMutableArray *list_result = [NSMutableArray array];
    [list_result addObject:model];
    [list_result addObject:model];
    [list_result addObject:model1];
    
    for (int i = 0; i < list_result.count; i++) {
        UCFGoldTradeListModel *model =  [list_result objectAtIndex:i];;
        NSString *tradeTime = model.tradeTime;
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
    [self.baseTableView reloadData];
}

- (void)initUI
{
    baseTitleLabel.text = @"交易记录";
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    [self addLeftButton];
//    [self addRefreshingAndLoadMore];
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
    self.baseTableView.footer.hidden = YES;
}
- (void)getNetDataFromNet
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if ([self.baseTableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.baseTableView.footer resetNoMoreData];
    }
    if (uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", nil];
    }
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGoldTradeFlowList owner:self signature:YES Type:SelectAccoutDefault];
}
#pragma NetDelegat
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DBLOG(@"首页获取最新项目列表：%@",data);
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
//                [self.noDataView hide];
                if (!hasNext) {
                    [self.baseTableView.footer noticeNoMoreData];
                }
            }
            else {
//                [self.noDataView showInView:self.tableview];
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
    return 44;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
