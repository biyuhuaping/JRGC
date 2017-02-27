//
//  UCFMyClaimCtrl.m
//  JRGC
//
//  Created by biyuhuaping on 15/6/9.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFMyClaimCtrl.h"
#import "MJRefresh.h"
#import "NZLabel.h"
#import "UIDic+Safe.h"
#import "NetworkModule.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "UCFMyInvestViewCell.h"
#import "UCFInvestmentDetailViewController.h"

// 错误界面
#import "UCFNoDataView.h"

@interface UCFMyClaimCtrl ()<UITableViewDataSource, UITableViewDelegate, NetworkModuleDelegate>

@property (strong, nonatomic) IBOutlet UIView *itemChangeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leading;//下划线的

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;
@property (strong, nonatomic) UITableView *tableView3;

@property (strong, nonatomic) NSMutableArray *dataArr1;
@property (strong, nonatomic) NSMutableArray *dataArr2;
@property (strong, nonatomic) NSMutableArray *dataArr3;

@property (assign, nonatomic) NSInteger pageNum1;
@property (assign, nonatomic) NSInteger pageNum2;
@property (assign, nonatomic) NSInteger pageNum3;

@property (strong, nonatomic) NSArray *statusArr;//标状态数组
@property (assign, nonatomic) NSInteger index;//选择了第几个
@property (strong, nonatomic) NSMutableArray *didClickBtns;
@property (strong, nonatomic) NSMutableArray *listCountArr;//投资笔数
@property (strong, nonatomic) IBOutlet NZLabel *listCountLab;//投资笔数

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (strong, nonatomic) UCFNoDataView *noDataView2;
@property (strong, nonatomic) UCFNoDataView *noDataView3;

@end

@implementation UCFMyClaimCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArr1 = [NSMutableArray new];
    _dataArr2 = [NSMutableArray new];
    _dataArr3 = [NSMutableArray new];

    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;
    
    _statusArr = @[@"未审核", @"待确认", @"招标中", @"流标", @"满标", @"回款中", @"已回款"];
    _index = 0;
    _didClickBtns = [NSMutableArray arrayWithObject:@(0)];
    _listCountArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    
    UIButton *btn = (UIButton *)[self.itemChangeView viewWithTag:110];
    btn.selected = YES;
    
    [self initTableView];
    _noDataView = [[UCFNoDataView alloc] initWithFrame:_tableView1.bounds errorTitle:@"暂无数据"];
    _noDataView2 = [[UCFNoDataView alloc] initWithFrame:_tableView1.bounds errorTitle:@"暂无数据"];
    _noDataView3 = [[UCFNoDataView alloc] initWithFrame:_tableView1.bounds errorTitle:@"暂无数据"];
}

- (void)initTableView{
    CGFloat height = ScreenHeight -240 ;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*3, height);
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, height) style:UITableViewStylePlain];
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, height) style:UITableViewStylePlain];
    _tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, height) style:UITableViewStylePlain];
    
    [_scrollView addSubview:_tableView1];
    [_scrollView addSubview:_tableView2];
    [_scrollView addSubview:_tableView3];
    
    _tableView1.delegate = self;
    _tableView2.delegate = self;
    _tableView3.delegate = self;
    
    _tableView1.dataSource = self;
    _tableView2.dataSource = self;
    _tableView3.dataSource = self;
    
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView1.backgroundColor = UIColorWithRGB(0xebebee);
    _tableView2.backgroundColor = UIColorWithRGB(0xebebee);
    _tableView3.backgroundColor = UIColorWithRGB(0xebebee);
    
    // 是否支持点击状态栏回到最顶端
    _tableView1.scrollsToTop = YES;
    _tableView2.scrollsToTop = NO;
    _tableView3.scrollsToTop = NO;
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
//    [_tableView1 addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [weakSelf getMyInvestDataList];
//    }];
    
    // 添加上拉加载更多
    [_tableView1 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyInvestDataList];
    }];
    
    //=========
    // 添加传统的下拉刷新
//    [_tableView2 addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [weakSelf getMyInvestDataList];
//    }];
    
    // 添加上拉加载更多
    [_tableView2 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyInvestDataList];
    }];
    
    //=========
    // 添加传统的下拉刷新
//    [_tableView3 addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [weakSelf getMyInvestDataList];
//    }];
    
    // 添加上拉加载更多
    [_tableView3 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyInvestDataList];
    }];
    
    [_tableView1 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyInvestDataList)];
    [_tableView2 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyInvestDataList)];
    [_tableView3 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyInvestDataList)];
    
    // 马上进入刷新状态
    [_tableView1.header beginRefreshing];
    _tableView1.footer.hidden = YES;
    _tableView2.footer.hidden = YES;
    _tableView3.footer.hidden = YES;
}

// 选项按钮的点击事件
- (IBAction)sender:(UIButton *)sender {
    CGFloat offset = ScreenWidth*(sender.tag-110);
    [self setBtnAndLine:offset];
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        [self setBtnAndLine:offset];
    }
}

//设置按钮颜色和下划线
- (void)setBtnAndLine:(NSInteger)offset{
    _index = (NSInteger)offset/ScreenWidth;
    DBLOG(@"%ld",(long)_index);
    
    //滑动下划线
    [UIView animateWithDuration:0.25 animations:^{
        _leading.constant = offset/3;
        [self.view layoutIfNeeded];  //没有此句可能没有动画效果
    }];
    
    // 是否支持点击状态栏回到最顶端
    _tableView1.scrollsToTop = NO;
    _tableView2.scrollsToTop = NO;
    _tableView3.scrollsToTop = NO;
    
    // 是否支持点击状态栏回到最顶端
    switch (_index) {
        case 0:{
            _tableView1.scrollsToTop = YES;
        }
            break;
        case 1:{
            _tableView2.scrollsToTop = YES;
        }
            break;
        case 2:{
            _tableView3.scrollsToTop = YES;
        }
            break;
    }
    
    //设置按钮颜色
    for (UIButton *btn in self.itemChangeView.subviews) {
        if (btn.tag == 110 + _index) {
            btn.selected = YES;
        }else if ([btn respondsToSelector:@selector(setSelected:)])
            btn.selected = NO;
    }
    if (![_didClickBtns containsObject:@(_index)]) {
        [_didClickBtns addObject:@(_index)];
        switch (_index) {
            case 0:{
                [_tableView1.header beginRefreshing];
            }
                break;
            case 1:{
                [_tableView2.header beginRefreshing];
            }
                break;
            case 2:{
                [_tableView3.header beginRefreshing];
            }
                break;
        }
    }
    _listCountLab.text = [NSString stringWithFormat:@"共%@笔记录",_listCountArr[_index]];
    [_listCountLab setFont:[UIFont boldSystemFontOfSize:12] string:_listCountArr[_index]];
}

#pragma mark - UITableViewDelegate
// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return _dataArr1.count;
    }else if (tableView == _tableView2){
        return _dataArr2.count;
    }else if (tableView == _tableView3){
        return _dataArr3.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210 - 27;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *indentifier = @"MyInvestViewCell";
    
    UCFMyInvestViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFMyInvestViewCell" owner:self options:nil][0];
//        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
//        view.backgroundColor = [UIColor whiteColor];
//        cell.selectedBackgroundView = view;//选中后cell的背景颜色
        cell.labText.text = @"实付金额";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *tempArr;
    if (tableView == _tableView1) {
        tempArr = _dataArr1;
    }else if (tableView == _tableView2){
        tempArr = _dataArr2;
    }else if (tableView == _tableView3){
        tempArr = _dataArr3;
    }
   
    int status = [tempArr[indexPath.row][@"status"]intValue];
    cell.prdName.text = tempArr[indexPath.row][@"name"];//标的名称
    cell.status.text = _statusArr[status];//标状态
    
    NSString *annualRate = [tempArr[indexPath.row] objectSafeForKey:@"annualRate"];
    NSString *transfereeYearRate = [tempArr[indexPath.row] objectSafeForKey:@"transfereeYearRate"];
    
    cell.annualRate.text = [transfereeYearRate.length == 0?annualRate:transfereeYearRate stringByAppendingString:@"%"];//年化收益率
    cell.annualInterestRateViewHight.constant = 0;
    
    NSString *effactiveDate = tempArr[indexPath.row][@"startInervestTime"];//起息日
    NSString *repayPerDate = tempArr[indexPath.row][@"repayPerDate"];//回款时间
    cell.effactiveDate.text = effactiveDate.length > 0?effactiveDate:@"--";
    cell.repayPerDate.text = repayPerDate.length > 0?repayPerDate:@"--";
    
    float investAmt = [tempArr[indexPath.row][@"contributionAmt"] floatValue];
    cell.investAmt.text = [NSString stringWithFormat:@"¥%0.2f",investAmt];//投资金额
    cell.applyDate.text = tempArr[indexPath.row][@"createdTime"];//交易时间
    
    if (status == 2) {//招标中
        cell.status.textColor = UIColorWithRGB(0xfd4d4c);
    }
    else if (status == 5) {//回款中
        cell.status.textColor = UIColorWithRGB(0x4aa1f9);
    }else{
        cell.status.textColor = UIColorWithRGB(0x999999);
    }
    
    return cell;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSMutableArray *temp = nil;
    if (_tableView1 == tableView) {
        temp = _dataArr1;
    }
    else if (_tableView2 == tableView) {
        temp = _dataArr2;
    }
    else if (_tableView3 == tableView) {
        temp = _dataArr3;
    }
    NSDictionary *dict = temp[indexPath.row];
    UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
    controller.billId = dict[@"prdOrderId"];
    controller.detailType = @"2";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 请求网络及回调
//获取我的投资列表
- (void)getMyInvestDataList
{
    NSInteger pageNum = 1;
    switch (_index) {
        case 0:
        {
            if (_tableView1.header.isRefreshing) {
                _pageNum1 = 1;
            }else if (_tableView1.footer.isRefreshing){
                _pageNum1 ++;
            }
            pageNum = _pageNum1;
        }
            break;
        case 1:
        {
            if (_tableView2.header.isRefreshing) {
                _pageNum2 = 1;
            }else if (_tableView2.footer.isRefreshing){
                _pageNum2 ++;
            }
            pageNum = _pageNum2;
        }
            break;
        case 2:
        {
            if (_tableView3.header.isRefreshing) {
                _pageNum3 = 1;
            }else if (_tableView3.footer.isRefreshing){
                _pageNum3 ++;
            }
            pageNum = _pageNum3;
        }
            break;
    }
//    NSArray *tempArr = @[@"",@"0",@"1"];
    NSArray *tempArr1 = @[@"",@"5",@"6"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *strParameters = [NSString stringWithFormat:@"page=%ld&rows=20&userId=%@&orderUserId=%@&typeFlag=3&callStatus=%@", (long)pageNum,userId,userId,tempArr1[_index]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagTransfersOrder owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [_tableView1.header endRefreshing];
    [_tableView1.footer endRefreshing];
    
    [_tableView2.header endRefreshing];
    [_tableView2.footer endRefreshing];
    
    [_tableView3.header endRefreshing];
    [_tableView3.footer endRefreshing];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    //DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    DBLOG(@"我的债权列表请求结果：%@",dic);
    //zrc 修改 是否有下一页，取值错误
//    BOOL hasNextPage = [dic[@"data"][@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
    BOOL hasNextPage = [dic[@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
    NSArray *dataArr = dic[@"pageData"][@"result"];
    if (tag.intValue == kSXTagTransfersOrder) {
        if ([rstcode intValue] == 1) {
//            if (_setHeaderInfoBlock) {
//                _setHeaderInfoBlock(dic[@"data"]);
//            }
            NSString *listCount = [NSString stringWithFormat:@"%@",dic[@"pageData"][@"pagination"][@"totalCount"]];//投资笔数
            [_listCountArr setObject:listCount atIndexedSubscript:_index];
            _listCountLab.text = [NSString stringWithFormat:@"共%@笔记录",_listCountArr[_index]];
            [_listCountLab setFont:[UIFont boldSystemFontOfSize:12] string:listCount];
            
            switch (_index) {
                case 0:{
                    _dataArr1 = [self currentPage:_pageNum1 tableView:_tableView1 tempArr:dataArr :hasNextPage];
                    [_tableView1 reloadData];
                }
                    break;
                case 1:{
                    _dataArr2 = [self currentPage:_pageNum2 tableView:_tableView2 tempArr:dataArr :hasNextPage];
                    [_tableView2 reloadData];
                }
                    break;
                case 2:{
                    _dataArr3 = [self currentPage:_pageNum3 tableView:_tableView3 tempArr:dataArr :hasNextPage];
                    [_tableView3 reloadData];
                }
                    break;
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [_tableView1.header endRefreshing];
    [_tableView1.footer endRefreshing];
    
    [_tableView2.header endRefreshing];
    [_tableView2.footer endRefreshing];
    
    [_tableView3.header endRefreshing];
    [_tableView3.footer endRefreshing];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}

- (NSMutableArray *)currentPage:(NSInteger)currentPage tableView:(UITableView *)tableView tempArr:(NSArray *)tempArr :(BOOL)hasNextPage{
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    if (currentPage == 1) {
        dataArr = [NSMutableArray arrayWithArray:tempArr];
        if (dataArr.count == 0) {
            [tableView.footer noticeNoMoreData];
            switch (_index) {
                case 0:
                    [_noDataView showInView:tableView];
                    break;
                    
                case 1:
                    [_noDataView2 showInView:tableView];
                    break;
                    
                case 2:
                    [_noDataView3 showInView:tableView];
                    break;
            }
           
        }else{
            switch (_index) {
                case 0:
                    [self.noDataView hide];
                    break;
                    
                case 1:
                   [self.noDataView2 hide];
                    break;
                    
                case 2:
                    [self.noDataView3 hide];
                    break;
            }
            
            tableView.footer.hidden = NO;
            if (!hasNextPage) {
                [tableView.footer noticeNoMoreData];
            }
            else {
                currentPage ++;
                [tableView.footer resetNoMoreData];
            }
        };
    }else{
        [dataArr addObjectsFromArray:tempArr];
        if (!hasNextPage) {
            [tableView.footer noticeNoMoreData];
        }
        else {
            currentPage ++;
            [tableView.footer resetNoMoreData];
        }
    }
    return dataArr;
}

@end
