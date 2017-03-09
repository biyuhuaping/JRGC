//
//  UCFBackMoneyDetailViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBackMoneyDetailViewController.h"
#import "UCFBackMoneyCell.h"
#import "UCFBackMoneyCell1.h"
#import "UCFNoDataView.h"

@interface UCFBackMoneyDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *itemChangeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerX;//下划线的
@property (strong, nonatomic) IBOutlet UILabel *totalCountLab;//记录总数
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineVIewHeight;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;

@property (strong, nonatomic) NSMutableArray *dataArr1;
@property (strong, nonatomic) NSMutableArray *dataArr2;
@property (strong, nonatomic) NSArray *titleArr1;
@property (strong, nonatomic) NSArray *titleArr2;

@property (assign, nonatomic) NSInteger pageNum1;
@property (assign, nonatomic) NSInteger pageNum2;

@property (assign, nonatomic) NSInteger index;//选择了第几个
@property (strong, nonatomic) NSMutableArray *didClickBtns;
@property (strong, nonatomic) NSMutableArray *totalCountArr;//回款记录

// 无数据界面
@property (nonatomic, strong) UCFNoDataView *noDataView;

@end

@implementation UCFBackMoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButton];
    baseTitleLabel.text = @"回款明细";
    UIButton *btn = (UIButton *)[self.itemChangeView viewWithTag:100];
    btn.selected = YES;
    
    _dataArr1 = [NSMutableArray new];
    _dataArr2 = [NSMutableArray new];
    
    _titleArr1 = @[@"投标日期",@"回款日期",@"本金",@"利息",@"总计金额"];
    _titleArr2 = @[@"投标日期",@"回款日期",@"利息",@"总计金额"];
    
    _pageNum1 = 1;
    _pageNum2 = 1;
    
    _index = 0;
    _didClickBtns = [NSMutableArray arrayWithObject:@(0)];
    _totalCountArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];
    
    [self initTableView];
    _lineVIewHeight.constant = 0.5;
    _noDataView = [[UCFNoDataView alloc] initWithFrame:_tableView1.bounds errorTitle:@"暂无数据"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    CGFloat height = ScreenHeight - 140;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*2, height);
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, height) style:UITableViewStylePlain];
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, height) style:UITableViewStylePlain];
    
    [_scrollView addSubview:_tableView1];
    [_scrollView addSubview:_tableView2];
    
    _tableView1.delegate = self;
    _tableView2.delegate = self;
    
    _tableView1.dataSource = self;
    _tableView2.dataSource = self;
    
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView1.backgroundColor = UIColorWithRGB(0xebebee);
    _tableView2.backgroundColor = UIColorWithRGB(0xebebee);
    
    // 是否支持点击状态栏回到最顶端
    _tableView1.scrollsToTop = YES;
    _tableView2.scrollsToTop = NO;
    
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
    [_tableView1 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyInvestDataList)];
    [_tableView2 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyInvestDataList)];
    
    // 马上进入刷新状态
    [_tableView1.header beginRefreshing];

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
    _tableView1.footer.hidden = YES;
    _tableView2.footer.hidden = YES;
}

// 选项按钮的点击事件
- (IBAction)switchBtn:(UIButton *)sender {
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
    DBLOG(@"%ld",(long)_index);
    
    switch (_index) {
        case 0:{
            _tableView1.scrollsToTop = YES;
            _tableView2.scrollsToTop = NO;
        }
            break;
            
        case 1:{
            _tableView1.scrollsToTop = NO;
            _tableView2.scrollsToTop = YES;
        }
            break;
    }
    //滑动下划线
    [UIView animateWithDuration:0.25 animations:^{
        _centerX.constant = _index*ScreenWidth/2;
        [self.view layoutIfNeeded];  //没有此句可能没有动画效果
    }];
    
    //设置按钮颜色
    for (UIButton *btn in self.itemChangeView.subviews) {
        if (btn.tag == 100 + _index) {
            btn.selected = YES;
        }else if ([btn respondsToSelector:@selector(setSelected:)]){
            btn.selected = NO;
        }
    }
    if (![_didClickBtns containsObject:@(_index)]) {
        [_didClickBtns addObject:@(_index)];
        [_tableView2.header beginRefreshing];
    }else{
        [self setNoDataView];
    }
    _totalCountLab.text = [NSString stringWithFormat:@"共%@笔记录",_totalCountArr[_index]];
}

#pragma mark - UITableViewDelegate
//每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return _dataArr1.count;
    }else if (tableView == _tableView2){
        return _dataArr2.count;
    }
    return 0;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        return 187;
    }else if (tableView == _tableView2){
        return 243;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView1) {
        static  NSString *indentifier = @"BackMoneyDetailViewCell";
        
        UCFBackMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UCFBackMoneyCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *str = @"";
        id total = _dataArr1[indexPath.row][@"totalPerNo"];
        if ([total intValue] > 1) {
            str = [NSString stringWithFormat:@"(第%@期/共%@期)",_dataArr1[indexPath.row][@"repayPerNo"],total];
        }
        int batchInvestStatus = [[_dataArr1[indexPath.row] objectSafeForKey:@"batchInvestStatus"] intValue];
        if (batchInvestStatus) {
            cell.prdName.text = [NSString stringWithFormat:@"%@%@(批量投资)",_dataArr1[indexPath.row][@"prdName"],str];//标的名称
            [cell.prdName setFont:[UIFont systemFontOfSize:11] string:@"(批量投资)"];
            [cell.prdName setFontColor:UIColorWithRGB(0x999999) string:@"(批量投资)"];
        }
        else {
            cell.prdName.text = [NSString stringWithFormat:@"%@%@",_dataArr1[indexPath.row][@"prdName"],str];        //投标名称
        }
        [cell.prdName setFontColor:UIColorWithRGB(0x999999) string:str];
        
        cell.orderTime.text = _dataArr1[indexPath.row][@"orderTime"];      //投标时间
        cell.repayPerDate.text = _dataArr1[indexPath.row][@"repayPerDate"];//回款日期
        cell.principal.text = [NSString stringWithFormat:@"¥%@",_dataArr1[indexPath.row][@"principal"]];      //回款本金
        cell.interest.text = [NSString stringWithFormat:@"¥%@",_dataArr1[indexPath.row][@"interest"]];       //回款利息
        cell.princAndIntest.text = [NSString stringWithFormat:@"¥%@",_dataArr1[indexPath.row][@"princAndIntest"]]; //总计金额
        
        id comingFlag = _dataArr1[indexPath.row][@"comingFlag"];
        if ([comingFlag intValue] == 1) {
            cell.angleView.angleString = @"即将回款";
            cell.angleView.hidden = NO;
            cell.angleView.angleStatus = @"2";
        }else{
            cell.angleView.hidden = YES;
        }
        return cell;
    }else if (tableView == _tableView2){
        static  NSString *indentifier1 = @"BackMoneyDetailViewCell1";
        
        UCFBackMoneyCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if (!cell1) {
            cell1 = [[NSBundle mainBundle]loadNibNamed:@"UCFBackMoneyCell1" owner:self options:nil][0];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *str = @"";
        id total = _dataArr2[indexPath.row][@"totalPerNo"];
        if ([total intValue] > 1) {
            str = [NSString stringWithFormat:@"(第%@期/共%@期)",_dataArr2[indexPath.row][@"repayPerNo"],total];
        }
        int batchInvestStatus = [[_dataArr2[indexPath.row] objectSafeForKey:@"batchInvestStatus"] intValue];
        if (batchInvestStatus) {
            cell1.prdName.text = [NSString stringWithFormat:@"%@%@(批量投资)",_dataArr2[indexPath.row][@"prdName"],str];//标的名称
            [cell1.prdName setFont:[UIFont systemFontOfSize:11] string:@"(批量投资)"];
            [cell1.prdName setFontColor:UIColorWithRGB(0x999999) string:@"(批量投资)"];
        }
        else {
            cell1.prdName.text = [NSString stringWithFormat:@"%@%@",_dataArr2[indexPath.row][@"prdName"],str];        //投标名称
        }
        
        [cell1.prdName setFontColor:UIColorWithRGB(0x999999) string:str];
        
        cell1.orderTime.text = _dataArr2[indexPath.row][@"orderTime"];      //投标时间
        cell1.repayPerDate.text = _dataArr2[indexPath.row][@"repayPerDate"];//计划回款日期
        cell1.paidTime.text = _dataArr2[indexPath.row][@"paidTime"];        //实际回款日
        cell1.principal.text = [NSString stringWithFormat:@"¥%@",_dataArr2[indexPath.row][@"principal"]];      //回款本金
        cell1.interest.text = [NSString stringWithFormat:@"¥%@",_dataArr2[indexPath.row][@"interest"]];       //回款利息
        cell1.penalty.text = [NSString stringWithFormat:@"¥%@",_dataArr2[indexPath.row][@"prepaymentPenalty"]];     //违约金
        cell1.princAndIntest.text = [NSString stringWithFormat:@"¥%@",_dataArr2[indexPath.row][@"princAndIntest"]]; //总计金额
        
        id comingFlag = _dataArr2[indexPath.row][@"comingFlag"];
        if ([comingFlag intValue] == 1) {
            cell1.angleView.angleString = @"  最新  ";
            cell1.angleView.hidden = YES;
            cell1.angleView.angleStatus = @"2";
        }else{
            cell1.angleView.hidden = YES;
        }
        return cell1;
    }
    return nil;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&status=%ld&page=%ld&rows=20",userId, (long)_index, (long)pageNum];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdOrderRefundLsit owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
    DBLOG(@"回款明细页：%@",dic);
    NSArray *tempArr = dic[@"pageData"][@"result"];
    if (tag.intValue == kSXTagPrdOrderRefundLsit) {
        if ([rstcode intValue] == 1) {
            NSString *totalCount = dic[@"pageData"][@"pagination"][@"totalCount"];
            _totalCountLab.text = [NSString stringWithFormat:@"共%@笔记录",totalCount];
            [_totalCountArr setObject:totalCount atIndexedSubscript:_index];
            
            if (_index == 0) {
                _tableView1.footer.hidden = NO;
                if (_pageNum1 == 1) {
                    _dataArr1 = [NSMutableArray arrayWithArray:tempArr];
                    [_tableView1.header endRefreshing];
                    [_tableView1.footer endRefreshing];
                }else{
                    if (tempArr.count == 0) {
                        [_tableView1.footer noticeNoMoreData];
                    }else{
                        [_dataArr1 addObjectsFromArray:tempArr];
                        [_tableView1.footer endRefreshing];
                    }
                }
                [_tableView1 reloadData];
            }else if (_index == 1){
                _tableView2.footer.hidden = NO;
                if (_pageNum2 == 1) {
                    _dataArr2 = [NSMutableArray arrayWithArray:tempArr];
                    [_tableView2.header endRefreshing];
                    [_tableView2.footer endRefreshing];
                }else{
                    if (tempArr.count == 0) {
                        [_tableView2.footer noticeNoMoreData];
                    }else{
                        [_dataArr2 addObjectsFromArray:tempArr];
                        [_tableView2.footer endRefreshing];
                    }
                }
                [_tableView2 reloadData];
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        //更改回款状态状态符
        _superViewController.checkedFeedBack = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"4"];
    }
    [self setNoDataView];
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagPrdOrderRefundLsit) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self setNoDataView];
}

- (void)setNoDataView{
    switch (_index) {
        case 0:{
            if (_dataArr1.count == 0) {
                [_noDataView showInView:_tableView1];
                [_tableView1.footer noticeNoMoreData];
            }
            else {
                [self.noDataView hide];
            }
        }
            break;
        case 1:{
            if (_dataArr2.count == 0) {
                [_noDataView showInView:_tableView2];
                [_tableView2.footer noticeNoMoreData];
            }
            else {
                [self.noDataView hide];
            }
        }
    }
    if ([_tableView1.header isRefreshing]) {
        [_tableView1.header endRefreshing];
    }else if ([_tableView1.footer isRefreshing]) {
        [_tableView1.footer endRefreshing];
    }
    if ([_tableView2.header isRefreshing]) {
        [_tableView2.header endRefreshing];
    }else if ([_tableView2.footer isRefreshing]) {
        [_tableView2.footer endRefreshing];
    }
}


@end
