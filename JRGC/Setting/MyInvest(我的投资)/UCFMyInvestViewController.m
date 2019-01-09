//
//  UCFMyInvestViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFMyInvestViewController.h"
#import "UCFMyInvestViewCell.h"
#import "UCFInvestmentDetailViewController.h"
#import "NZLabel.h"
#import "NetworkModule.h"
#import "YcMutableArray.h"
#import "UCFToolsMehod.h"
#import "UCFBackMoneyDetailViewController.h"
#import "UCFNoDataView.h"

@interface UCFMyInvestViewController ()<UITableViewDataSource, UITableViewDelegate, NetworkModuleDelegate>

@property (strong, nonatomic) IBOutlet UIView *itemChangeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineCenterX;//下划线左边的距离

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

@property (strong, nonatomic) IBOutlet NZLabel *listCountLab;//投资笔数
@property (strong, nonatomic) NSMutableArray *listCountArr;//投资笔数

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (strong, nonatomic) UCFNoDataView *noDataView2;
@property (strong, nonatomic) UCFNoDataView *noDataView3;

@end

@implementation UCFMyInvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = (UIButton *)[self.itemChangeView viewWithTag:100];
    btn.selected = YES;
    
    _dataArr1 = [NSMutableArray new];
    _dataArr2 = [NSMutableArray new];
    _dataArr3 = [NSMutableArray new];
    
    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;
    
    _statusArr = @[@"未审核", @"待确认", @"招标中", @"流标", @"满标", @"回款中", @"已回款"];
    _index = 0;
    _didClickBtns = [NSMutableArray arrayWithObject:@(0)];
    _listCountArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];
    
    [self initTableView];
    
    _noDataView = [[UCFNoDataView alloc] initWithFrame:_tableView1.bounds errorTitle:@"暂无数据"];
    _noDataView2 = [[UCFNoDataView alloc] initWithFrame:_tableView2.bounds errorTitle:@"暂无数据"];
    _noDataView3 = [[UCFNoDataView alloc] initWithFrame:_tableView3.bounds errorTitle:@"暂无数据"];
}

- (void)initTableView{
    CGFloat height = ScreenHeight - 240;
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
    // 添加上拉加载更多
    [_tableView1 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyInvestDataList];
    }];
    [_tableView2 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyInvestDataList];
    }];
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
    CGFloat offset = ScreenWidth*(sender.tag-100);
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
    //滑动下划线
    [UIView animateWithDuration:0.25 animations:^{
        _lineCenterX.constant = _index*ScreenWidth/3;
        [self.view layoutIfNeeded];  //没有此句可能没有动画效果
    }];
    
    // 是否支持点击状态栏回到最顶端
    switch (_index) {
        case 0:{
            _tableView1.scrollsToTop = YES;
            _tableView2.scrollsToTop = NO;
            _tableView3.scrollsToTop = NO;
        }
            break;
        case 1:{
            _tableView1.scrollsToTop = NO;
            _tableView2.scrollsToTop = YES;
            _tableView3.scrollsToTop = NO;
        }
            break;
        case 2:{
            _tableView1.scrollsToTop = NO;
            _tableView2.scrollsToTop = NO;
            _tableView3.scrollsToTop = YES;
        }
            break;
    }
    
    //设置按钮颜色
    for (UIButton *btn in self.itemChangeView.subviews) {
        if (btn.tag == 100 + _index) {
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

//to回款明细页面
- (IBAction)toBackMoneyDetailView:(id)sender {
    UCFBackMoneyDetailViewController *vc = [[UCFBackMoneyDetailViewController alloc]initWithNibName:@"UCFBackMoneyDetailViewController" bundle:nil];
    vc.accoutType = self.accoutType;
    vc.title = @"回款明细";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return _dataArr1.count;
    }
    else if (tableView == _tableView2){
        return _dataArr2.count;
    }
    else if (tableView == _tableView3){
        return _dataArr3.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr = nil;
    if (tableView == _tableView1) {
        tempArr = _dataArr1;
    }else if (tableView == _tableView2){
        tempArr = _dataArr2;
    }
    else if (tableView == _tableView3){
        tempArr = _dataArr3;
    }
    NSString *annualAwardRateStr = [tempArr[indexPath.row] objectSafeForKey:@"gradeIncreases"];
    if ([annualAwardRateStr floatValue] > 0) {//年化加息奖励
        return 210;
    }else{
        return 210 - 27;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *indentifier = @"MyInvestViewCell";
    
    UCFMyInvestViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFMyInvestViewCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *tempArr = nil;
    if (tableView == _tableView1) {
        tempArr = _dataArr1;
    }else if (tableView == _tableView2){
        tempArr = _dataArr2;
    }
    else if (tableView == _tableView3){
        tempArr = _dataArr3;
        cell.repayDateLabText.text = @"实际回款日";//在 我的投资 已回款列表中 repayPerDate 是 实际回款日
    }
  
    int status = [tempArr[indexPath.row][@"status"]intValue];
    
    int batchInvestStatus = [[tempArr[indexPath.row] objectSafeForKey:@"batchInvestStatus"] intValue];
    if (batchInvestStatus) {
        cell.prdName.text = [NSString stringWithFormat:@"%@(批量出借)", tempArr[indexPath.row][@"prdName"]];//标的名称
        [cell.prdName setFont:[UIFont systemFontOfSize:11] string:@"(批量出借)"];
        [cell.prdName setFontColor:UIColorWithRGB(0x999999) string:@"(批量出借)"];
    }
    else {
        cell.prdName.text = tempArr[indexPath.row][@"prdName"];//标的名称
    }
    cell.labText.text = self.accoutType == SelectAccoutTypeP2P ? @"出借金额":@"投资金额";
    cell.status.text = _statusArr[status];//标状态
    cell.annualRate.text = [[tempArr[indexPath.row] objectSafeForKey:@"annualRate"] stringByAppendingString:@"%"];//年化收益率
    
    NSString *annualAwardRateStr = [NSString stringWithFormat:@"%@",[tempArr[indexPath.row] objectSafeForKey:@"gradeIncreases"]];//年化加息奖励
    if ([annualAwardRateStr isEqualToString:@""] || [annualAwardRateStr floatValue] > 0 ) {//年化加息奖励
        cell.gradeIncreases.text = [annualAwardRateStr stringByAppendingString:@"%"];
        cell.annualInterestRateViewHight.constant = 27;
    }else{
        cell.annualInterestRateViewHight.constant = 0;
    }
    NSString *effactiveDate = tempArr[indexPath.row][@"effactiveDate"];//起息日
    NSString *repayPerDate = tempArr[indexPath.row][@"repayPerDate"];//回款时间
    cell.effactiveDate.text = effactiveDate.length > 0?effactiveDate:@"--";
    cell.repayPerDate.text = repayPerDate.length > 0?repayPerDate:@"--";
    
    double investAmt = [tempArr[indexPath.row][@"investAmt"] doubleValue];
    cell.investAmt.text = [NSString stringWithFormat:@"¥%0.2f",investAmt];//投资金额
    cell.applyDate.text = tempArr[indexPath.row][@"applyDate"];//交易时间
    
    if (status == 2 || status == 4) {//招标中或者满标中
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
    NSMutableArray *temp = nil;
    if (_tableView1 == tableView){
        temp = _dataArr1;
    }
    else if (_tableView2 == tableView){
        temp = _dataArr2;
    }
    else if (_tableView3 == tableView){
        temp = _dataArr3;
    }
    DDLogDebug(@"%@", temp);
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = [temp objectAtIndex:indexPath.row];
    UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
    controller.billId = dict[@"id"];
    controller.accoutType = self.accoutType;
    controller.detailType = @"1";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 请求网络及回调
//获取我的投资列表
- (void)getMyInvestDataList{
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
    NSArray *tempArr = @[@"100",@"3",@"4"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *strParameters = [NSString stringWithFormat:@"page=%ld&rows=20&userId=%@&flag=%@&typeFlag=", (long)pageNum,userId,tempArr[_index]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdOrderUinvest owner:self Type:self.accoutType];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
    
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
    NSString *data = (NSString *)result;
    //DDLogDebug(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    DDLogDebug(@"我的投资请求结果：%@",dic);
    
    
    //headerView
//    id interests = dic[@"data"][@"interests"];
//    _interestsLab.text = [NSString stringWithFormat:@"￥%0.2f",[interests floatValue]];//累计收益
//    
//    float principal = [dic[@"data"][@"noPrincipal"] floatValue];
//    _noPrincipalLab.text = [NSString stringWithFormat:@"￥%0.2f",principal];//待收本金
//    
//    id noInterests = dic[@"data"][@"noInterests"];//待收利息
//    _noInterestsLab.text = [NSString stringWithFormat:@"￥%0.2f",[noInterests floatValue]];
    
    BOOL hasNextPage = [dic[@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
    NSArray *dataArr = dic[@"pageData"][@"result"];

    if (tag.intValue == kSXTagPrdOrderUinvest) {
        if ([rstcode intValue] == 1) {
//            if (_setHeaderInfoBlock) {
//                _setHeaderInfoBlock(dic[@"data"]);
//            }
            
            NSString *listCount = [NSString stringWithFormat:@"%@",dic[@"data"][@"listCount"]];//投资笔数
            [_listCountArr setObject:listCount atIndexedSubscript:_index];
            _listCountLab.text = [NSString stringWithFormat:@"共%@笔记录",_listCountArr[_index]];
            [_listCountLab setFont:[UIFont boldSystemFontOfSize:12] string:listCount];
            
        switch (_index) {
                case 0:{
                    if (_pageNum1 == 1) {
                        [_dataArr1 removeAllObjects];
                        _dataArr1 = [NSMutableArray arrayWithArray:dataArr];
                        if (_dataArr1.count == 0) {
                            [_tableView1.footer noticeNoMoreData];
                            [_noDataView showInView:_tableView1];
                        }else if(_dataArr1.count <= 20 && !hasNextPage){ //每页数据20条
                            [self.noDataView hide];
                            _tableView1.footer.hidden = NO;
                            [_tableView1.footer noticeNoMoreData];
                        }else{
                            [self.noDataView hide];
                            _tableView1.footer.hidden = NO;
                            if (!hasNextPage) {
                                [_tableView1.footer noticeNoMoreData];
                            }
                            else {
//                                _pageNum1 ++;
                                [_tableView1.footer resetNoMoreData];
                            }
                        };
                    }else{
                        [_dataArr1 addObjectsFromArray:dataArr];
                        if (!hasNextPage) {
                            [_tableView1.footer noticeNoMoreData];
                        }
                        else {
//                            _pageNum1 ++;
                            [_tableView1.footer resetNoMoreData];
                        }
                    }

                    [_tableView1 reloadData];
                }
                    break;
                case 1:{
                    if (_pageNum2 == 1) {
                        [_dataArr2 removeAllObjects];
                        _dataArr2 = [NSMutableArray arrayWithArray:dataArr];
                        if (_dataArr2.count == 0) {
                            [_tableView2.footer noticeNoMoreData];
                            [_noDataView2 showInView:_tableView2];
                        }else if(_dataArr2.count <= 20 && !hasNextPage){ //每页数据20条
                            [self.noDataView2 hide];
                            _tableView2.footer.hidden = NO;
                            [_tableView2.footer noticeNoMoreData];
                        }else{
                            [self.noDataView2 hide];
                            _tableView2.footer.hidden = NO;
                            if (!hasNextPage) {
                                [_tableView2.footer noticeNoMoreData];
                            }
                            else {
//                                _pageNum2 ++;
                                [_tableView2.footer resetNoMoreData];
                            }
                        };
                    }else{
                        [_dataArr2 addObjectsFromArray:dataArr];
                        if (!hasNextPage) {
                            [_tableView2.footer noticeNoMoreData];
                        }
                        else {
//                            _pageNum2 ++;
                            [_tableView2.footer resetNoMoreData];
                        }
                    }
                    
                    [_tableView2 reloadData];
                }
                    break;
                case 2:{
                    if (_pageNum3 == 1) {
                        [_dataArr3 removeAllObjects];
                        _dataArr3 = [NSMutableArray arrayWithArray:dataArr];
                        if (_dataArr3.count == 0) {
                            [_tableView3.footer noticeNoMoreData];
                            [_noDataView3 showInView:_tableView3];
                        }else if(_dataArr3.count <= 20 && !hasNextPage){ //每页数据20条
                            [self.noDataView3 hide];
                            _tableView3.footer.hidden = NO;
                            [_tableView3.footer noticeNoMoreData];
                        }else{
                            [self.noDataView hide];
                            _tableView3.footer.hidden = NO;
                            if (!hasNextPage) {
                                [_tableView3.footer noticeNoMoreData];
                            }
                            else {
//                                _pageNum3 ++;
                                [_tableView3.footer resetNoMoreData];
                            }
                        };
                    }else{
                        [_dataArr3 addObjectsFromArray:dataArr];
                        if (!hasNextPage) {
                            [_tableView3.footer noticeNoMoreData];
                        }
                        else {
//                            _pageNum3 ++;
                            [_tableView3.footer resetNoMoreData];
                        }
                    }
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

@end
