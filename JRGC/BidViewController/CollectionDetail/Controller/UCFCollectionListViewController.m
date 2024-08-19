//
//  UCFCollectionListViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionListViewController.h"
#import "UCFCollectionListCell.h"
#import "UCFNoDataView.h"
#import "UCFInvestmentDetailViewController.h"
static NSString * const ListCellID = @"UCFCollectionListCell";

@interface UCFCollectionListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_listCountLabel;//子标个数
}
@property (assign,nonatomic) int currentPage;
@property (strong,nonatomic)NSMutableArray *investmentDetailDataArray;//投资详情数组
@property (strong,nonatomic)UCFNoDataView *noDataView;
@end

@implementation UCFCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawCollectionListView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark 项目详情
-(void)drawCollectionListView{
    
    self.investmentDetailDataArray  = [NSMutableArray arrayWithCapacity:0];
    _listHeaderView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    _listHeaderView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    [self.view addSubview:_listHeaderView];
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    headerTitleLabel.text = [UserInfoSingle sharedManager].isSubmitTime ? @"购买详情": @"出借详情";
    headerTitleLabel.textColor = UIColorWithRGB(0x333333);
    headerTitleLabel.font = [UIFont systemFontOfSize:13];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_listHeaderView  addSubview:headerTitleLabel];
    
    _listCountLabel= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 15 - 100 , 5, 100, 20)];
    _listCountLabel.text = @"0个子标";
    _listCountLabel.textColor = UIColorWithRGB(0x555555);
    _listCountLabel.font = [UIFont systemFontOfSize:13];
    _listCountLabel.textAlignment = NSTextAlignmentRight;
    [_listHeaderView  addSubview:_listCountLabel];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30 , ScreenWidth, ScreenHeight - 64 - 30 - 57) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _listTableView.tag = 1020;
    _listTableView.backgroundColor = UIColorWithRGB(0xebebee);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerNib:[UINib nibWithNibName:@"UCFCollectionListCell" bundle:nil] forCellReuseIdentifier:ListCellID];
    [self.view addSubview:_listTableView];
    
    
    __weak typeof(self)  weakSelf = self;
    [self.listTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getCollectionListHttpRequest)];
    
    // 添加上拉加载更多
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCollectionListHttpRequest];
    }];
    [self.listTableView.header beginRefreshing];
    [self addNoDataView];
}
#pragma mark - 添加无数据页面
- (void)addNoDataView {
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 207 - 57 ) errorTitle:@"暂无数据"];
}
#pragma mark -scrollViewScroll代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    
    return self.investmentDetailDataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *data =[self.investmentDetailDataArray objectAtIndex:indexPath.row];
    NSString *addRateStr = [data objectSafeForKey:@"addRate"];
    if (indexPath.row < self.investmentDetailDataArray.count) {
        if ([addRateStr floatValue] == 0.0) {
            return 209 - 27;
        }else{
            return 209;
        }
    }
    return 202;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCFCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *data =[self.investmentDetailDataArray objectAtIndex:indexPath.row];
    if (indexPath.row < self.investmentDetailDataArray.count) {
         cell.dataDict =data;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDict = self.investmentDetailDataArray[indexPath.row];
    UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
    controller.billId = dataDict[@"id"];
    controller.detailType = @"1";
    controller.accoutType = SelectAccoutTypeP2P;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)getCollectionListHttpRequest{
     NSString *uuid = SingleUserInfo.loginData.userInfo.userId;
    if ([self.listTableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.listTableView.footer resetNoMoreData];
    }
    else if ([self.listTableView.footer isRefreshing]) {
        self.currentPage ++;
    }
    NSString *currentPageStr = [NSString stringWithFormat:@"%d",_currentPage];
    NSDictionary* dataDict  = @{@"userId":uuid,@"colPrdClaimsId":_colPrdClaimId, @"batchOrderId":_batchOrderIdStr,@"page":currentPageStr,@"pageSize":@"20"};//我的投资页面 订单id};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagMyBatchInvestDetail owner:self signature:YES Type:self.accoutType];
}
-(void)beginPost:(kSXTag)tag{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)endPost:(id)result tag:(NSNumber *)tag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DDDLogDebugDebug(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagMyBatchInvestDetail){
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"]  objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"hasNextPage"] boolValue];
            int totalCount = [[[[[dic objectSafeDictionaryForKey:@"data"]  objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"totalCount"] intValue];
            _listCountLabel.text = [NSString stringWithFormat:@"%d个子标",totalCount];
            if (self.currentPage == 1) {
                [self.investmentDetailDataArray removeAllObjects];
            }
            for (NSDictionary *dict in list_result)
            {
               [self.investmentDetailDataArray addObject:dict];
            }
            [self.listTableView reloadData];
        
            if (self.investmentDetailDataArray.count > 0) {
                 [self.noDataView hide];
                if (!hasNext) {
                    [self.listTableView.footer noticeNoMoreData];
                }
            }else{
                 [self.noDataView showInView:self.listTableView];
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    
    if ([self.listTableView.header isRefreshing]) {
        [self.listTableView.header endRefreshing];
    }
    if ([self.listTableView.footer isRefreshing]) {
        [self.listTableView.footer endRefreshing];
    }
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.listTableView.header isRefreshing]) {
        [self.listTableView.header endRefreshing];
    }
    if ([self.listTableView.footer isRefreshing]) {
        [self.listTableView.footer endRefreshing];
    }

}

@end
