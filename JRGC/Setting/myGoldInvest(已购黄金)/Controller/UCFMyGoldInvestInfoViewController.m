//
//  UCFMyGoldInvestInfoViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMyGoldInvestInfoViewController.h"
#import "HMSegmentedControl.h"
#import "NZLabel.h"
#import "UCFNoDataView.h"
#import "UCFMyGoldInvestInfoCell.h"
#import "UCFGoldInvestmentDetailViewController.h"
#import "UIDic+Safe.h"
#import "UILabel+Misc.h"
@interface UCFMyGoldInvestInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(strong,nonatomic)HMSegmentedControl *topSegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *segmentedControlBgView ;
@property (assign, nonatomic)  NSInteger selectIndex ;

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
@property (strong, nonatomic) IBOutlet UILabel *allGiveGoldAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *collectGiveGoldAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *collectGoldAmountLabel;

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView;
@property (strong, nonatomic) UCFNoDataView *noDataView2;
@property (strong, nonatomic) UCFNoDataView *noDataView3;
@end

@implementation UCFMyGoldInvestInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *btn = (UIButton *)[self.itemChangeView viewWithTag:100];
//    btn.selected = YES;
    
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"已购黄金";
    [self addTopSegment];
    
    _dataArr1 = [NSMutableArray new];
    _dataArr2 = [NSMutableArray new];
    _dataArr3 = [NSMutableArray new];
    
    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;
    
    _statusArr = @[@"未审核", @"待确认", @"招标中", @"流标", @"满标", @"回款中", @"已回款"];
    _didClickBtns = [NSMutableArray arrayWithObject:@(0)];
    _listCountArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];
    
    [self initTableView];

    _noDataView = [[UCFNoDataView alloc] initGoldWithFrame:_tableView1.bounds errorTitle:@"暂无数据"  buttonTitle:@""];
    _noDataView2 = [[UCFNoDataView alloc] initGoldWithFrame:_tableView2.bounds errorTitle:@"暂无数据"buttonTitle:@""];
    _noDataView3 = [[UCFNoDataView alloc] initGoldWithFrame:_tableView3.bounds errorTitle:@"暂无数据"buttonTitle:@""];
}

- (void)initTableView{
    CGFloat height = ScreenHeight - 240;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*3, height);
    _scrollView.delegate  =  self;
    _scrollView.pagingEnabled = YES;
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
        [weakSelf getMyGoldInvestDataList];
    }];
    [_tableView2 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyGoldInvestDataList];
    }];
    [_tableView3 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyGoldInvestDataList];
    }];
    [_tableView1 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyGoldInvestDataList)];
    [_tableView2 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyGoldInvestDataList)];
    [_tableView3 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyGoldInvestDataList)];
    
    // 马上进入刷新状态
    [_tableView1.header beginRefreshing];
    _tableView1.footer.hidden = YES;
    _tableView2.footer.hidden = YES;
    _tableView3.footer.hidden = YES;
}
- (void)addTopSegment
{
    NSArray *titleArray = @[@"全部",@"持有中",@"已到期"];
    _topSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titleArray];
    [_topSegmentedControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _topSegmentedControl.selectionIndicatorHeight = 2.0f;
    _topSegmentedControl.backgroundColor = [UIColor whiteColor];
    _topSegmentedControl.font = [UIFont systemFontOfSize:14];
    _topSegmentedControl.textColor = UIColorWithRGB(0x555555);
    _topSegmentedControl.selectedTextColor = UIColorWithRGB(0xfc8f0e);
    _topSegmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfc8f0e);
    _topSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _topSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _topSegmentedControl.shouldAnimateUserSelection = YES;
    _topSegmentedControl.tag = 10001;
    [_topSegmentedControl addTarget:self action:@selector(topSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControlBgView addSubview:_topSegmentedControl];
    //    self.twoTableview.tableHeaderView = _topSegmentedControl;
    //    [self.view viewAddLine:_topSegmentedControl Up:YES];
    //[self viewAddLine:_topSegmentedControl Up:NO];
    for (int i = 0 ; i < titleArray.count - 1 ; i++) {
        UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
        linebk.frame = CGRectMake(ScreenWidth/titleArray.count * (i + 1), 16, 1, 12);
        [_topSegmentedControl addSubview:linebk];
    }
    //    [_topSegmentedControl setHidden:YES];
    if (_selectIndex != 0) {
        _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    }
}
-(void)topSegmentedControlChangedValue:(HMSegmentedControl *)segmentedControl{
    // 是否支持点击状态栏回到最顶端
    _selectIndex = segmentedControl.selectedSegmentIndex;
    [self selectTableView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView)
    {
        _selectIndex  = scrollView.contentOffset.x / ScreenWidth;
        [self selectTableView];
    }
}
-(void)selectTableView

{    _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    
    switch (_selectIndex) {
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
    switch (_selectIndex) {
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
    _listCountLab.text = [NSString stringWithFormat:@"共%@笔记录",_listCountArr[_selectIndex]];
    [_listCountLab setFont:[UIFont boldSystemFontOfSize:12] string:_listCountArr[_selectIndex]];
    [_scrollView setContentOffset:CGPointMake(ScreenWidth *_selectIndex, 0) animated:YES];
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
    return 209;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *indentifier = @"UCFMyGoldInvestInfoCell";
    
    UCFMyGoldInvestInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UCFMyGoldInvestInfoCell" owner:self options:nil][0];
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
    }

    if (indexPath.row < tempArr.count) {
        NSDictionary *dataDict = [tempArr objectAtIndex:indexPath.row];
        cell.dataDict = dataDict;
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
    UCFGoldInvestmentDetailViewController *controller = [[UCFGoldInvestmentDetailViewController alloc] initWithNibName:@"UCFGoldInvestmentDetailViewController" bundle:nil];
    controller.orderId =  [NSString stringWithFormat:@"%@",[dict objectSafeForKey:@"orderId"]];
    controller.accoutType = SelectAccoutTypeGold;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 请求网络及回调
//获取我的投资列表
- (void)getMyGoldInvestDataList{
    NSInteger pageNum = 1;
    switch (_selectIndex) {
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
    
    /*
     orderStatusCode	购买订单状态编码	string	0：全部；1：持有中；2：已到期
     pageNo	页号	string
     pageSize	页面大小	string
     userId	用户ID	string
     */
    
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    NSString *pageNoStr = [NSString stringWithFormat:@"%d",pageNum];
    NSString *orderStatusCodeStr = [NSString stringWithFormat:@"%d",_selectIndex];
    NSDictionary *strParameters  = @{@"userId":userId,@"pageNo":pageNoStr,@"pageSize":@"20",@"orderStatusCode":orderStatusCodeStr};
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldTradeRecordList owner:self signature:YES Type:SelectAccoutTypeGold];
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
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    DDLogDebug(@"我的投资请求结果：%@",dic);
    
    
    //headerView
    NSDictionary * userDataInfoDict = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"userDataInfo"];

    self.allGiveGoldAmountLabel.text = [NSString stringWithFormat:@"%.3f克",[[userDataInfoDict objectSafeForKey:@"allGiveGoldAmount"] floatValue]];//累计收益
    [self.allGiveGoldAmountLabel setFont:[UIFont boldSystemFontOfSize:14] string:@"克"];
    
    
    float  collectGiveGoldAmount = [userDataInfoDict[@"collectGiveGoldAmount"] floatValue];;//待收利息
    self.collectGoldAmountLabel.text = [NSString stringWithFormat:@"待收收益:%.3f克",collectGiveGoldAmount];
      float principal = [userDataInfoDict[@"collectGoldAmount"] floatValue];////总待收黄金
    self.collectGiveGoldAmountLabel.text = [NSString stringWithFormat:@"总待收黄金:%.3f克",principal];
    
    BOOL hasNextPage = [[dic objectSafeDictionaryForKey:@"data"][@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
    NSArray *dataArr = [dic objectSafeDictionaryForKey:@"data"][@"pageData"][@"result"];
    
    if (tag.intValue == kSXTagGetGoldTradeRecordList) {
        if ([rstcode boolValue]) {
            //            if (_setHeaderInfoBlock) {
            //                _setHeaderInfoBlock(dic[@"data"]);
            //            }
            
            NSString *listCount = [NSString stringWithFormat:@"%@",[dic objectSafeDictionaryForKey:@"data"][@"pageData"][@"pagination"][@"totalCount"]];//投资笔数
            [_listCountArr setObject:listCount atIndexedSubscript:_selectIndex];
            _listCountLab.text = [NSString stringWithFormat:@"共%@笔记录",_listCountArr[_selectIndex]];
            [_listCountLab setFont:[UIFont boldSystemFontOfSize:12] string:listCount];
            
            switch (_selectIndex) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
