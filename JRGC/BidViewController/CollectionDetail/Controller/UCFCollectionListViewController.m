//
//  UCFCollectionListViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionListViewController.h"
#import "UCFCollectionDetailCell.h"
#import "UCFCollectionListCell.h"
#import "HMSegmentedControl.h"
#import "MjAlertView.h"
static NSString * const DetailCellID = @"UCFCollectionDetailCell";
static NSString * const ListCellID = @"UCFCollectionListCell";
@interface UCFCollectionListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    HMSegmentedControl *_topSegmentedControl;
    NSInteger _selectIndex;//segmentselect
    
    NSInteger _currentSelectSortTag;//当前选择排序tag
    
}
@property (strong,nonatomic) UITableView *listTableView;
@property (strong,nonatomic) UIButton *sortButton;   //排序按钮
@property (assign,nonatomic) int currentPage;
@property (strong,nonatomic)NSMutableArray *investmentProjectDataArray;//可投项目数组
@property (strong,nonatomic)NSMutableArray *fullProjectDataArray;//已满项目数组
@property (strong,nonatomic)NSMutableArray *investmentDetailDataArray;//投资详情数组
@end

@implementation UCFCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBottomBgView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark 初始化底部--即项目列表
-(void)drawBottomBgView{
    //初始化数组
    self.investmentProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    self.fullProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    [self addTableHeaderView];
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 74, ScreenWidth, self.view.frame.size.height - 74) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.scrollEnabled = YES;
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _listTableView.tag = 1020;
    _listTableView.backgroundColor = UIColorWithRGB(0xebebee);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerNib:[UINib nibWithNibName:@"UCFCollectionDetailCell" bundle:nil] forCellReuseIdentifier:DetailCellID];
    [self.view addSubview:_listTableView];
    
    
    
    __weak typeof(self)  weakSelf = self;
    [self.listTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getCollectionDetailHttpRequest)];
    
    // 添加上拉加载更多
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCollectionDetailHttpRequest];
    }];
    [self.listTableView.header beginRefreshing];
}
- (void)addTableHeaderView
{
    UIView *tableHeaderView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 74)];
    tableHeaderView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], 5, 60, 20)];
    headerTitleLabel.text = @"项目列表";
    headerTitleLabel.textColor = UIColorWithRGB(0x333333);
    headerTitleLabel.font = [UIFont systemFontOfSize:13];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    [tableHeaderView  addSubview:headerTitleLabel];
    
    self.sortButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sortButton.frame = CGRectMake(ScreenWidth - 15 - 30 , 5, 30, 20);
    _sortButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _sortButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _sortButton.titleLabel.textColor = UIColorWithRGB(0x4aa1f9);
    [_sortButton setTitle:@"排序" forState:UIControlStateNormal];
    [_sortButton addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:_sortButton];
    NSArray *titleArray = @[@"可投项目",@"已满项目"];
    _topSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titleArray];
    [_topSegmentedControl setFrame:CGRectMake(0, 30, ScreenWidth, 44)];
    _topSegmentedControl.selectionIndicatorHeight = 2.0f;
    _topSegmentedControl.backgroundColor = [UIColor whiteColor];
    _topSegmentedControl.font = [UIFont systemFontOfSize:14];
    _topSegmentedControl.textColor = UIColorWithRGB(0x3c3c3c);
    _topSegmentedControl.selectedTextColor = UIColorWithRGB(0xfd4d4c);
    _topSegmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfd4d4c);
    _topSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _topSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _topSegmentedControl.shouldAnimateUserSelection = YES;
    _topSegmentedControl.tag = 10001;
    [_topSegmentedControl addTarget:self action:@selector(topSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:_topSegmentedControl isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_topSegmentedControl isTop:NO];
    [tableHeaderView addSubview:_topSegmentedControl];
    for (int i = 0 ; i < titleArray.count - 1 ; i++) {
        UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
        linebk.frame = CGRectMake(ScreenWidth/titleArray.count * (i + 1), 16, 1, 12);
        [_topSegmentedControl addSubview:linebk];
    }
    if (_selectIndex != 0) {
        _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    }
    [self.view addSubview:tableHeaderView];
    
}
-(void)topSegmentedControlChangedValue:(HMSegmentedControl *)control{
    _topSegmentedControl.selectedSegmentIndex = control.selectedSegmentIndex;
    _selectIndex = control.selectedSegmentIndex;
    if (_selectIndex == 0) {
        [_sortButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
        _sortButton.userInteractionEnabled = YES;
    }else{
        [_sortButton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
        _sortButton.userInteractionEnabled = NO;
    }
    [_listTableView setContentInset:UIEdgeInsetsZero];
    [_listTableView setContentOffset:CGPointZero];
    [_listTableView reloadData];
}
#pragma mark
#pragma mark 项目详情
-(void)drawCollectionListView{
    
    self.investmentDetailDataArray  = [NSMutableArray arrayWithCapacity:0];
    UIView *listHeaderView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    listHeaderView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    [self.view addSubview:listHeaderView];
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    headerTitleLabel.text = @"投资详情";
    headerTitleLabel.textColor = UIColorWithRGB(0x333333);
    headerTitleLabel.font = [UIFont systemFontOfSize:13];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
    [listHeaderView  addSubview:headerTitleLabel];
    
    UILabel *listCountLabel= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 15 - 100 , 5, 100, 20)];
    listCountLabel.text = @"10个标";
    listCountLabel.textColor = UIColorWithRGB(0x555555);
    listCountLabel.font = [UIFont systemFontOfSize:13];
    listCountLabel.textAlignment = NSTextAlignmentRight;
    [listHeaderView  addSubview:listCountLabel];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 + 30, ScreenWidth, ScreenHeight - 64 - 57 - 30 ) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _listTableView.tag = 1020;
    _listTableView.backgroundColor = UIColorWithRGB(0xebebee);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerNib:[UINib nibWithNibName:@"UCFCollectionListCell" bundle:nil] forCellReuseIdentifier:ListCellID];
    UIView *tableBackgroundView = [[UIView alloc]initWithFrame:_listTableView.frame];
    tableBackgroundView.backgroundColor = UIColorWithRGB(0xebebee);
    [tableBackgroundView addSubview:_listTableView];
    [self.view addSubview:tableBackgroundView];
    
    
    __weak typeof(self)  weakSelf = self;
    [self.listTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getCollectionListHttpRequest)];
    
    // 添加上拉加载更多
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCollectionListHttpRequest];
    }];
    [self.listTableView.header beginRefreshing];
    
    
    
}
#pragma mark 点击排序button响应事件
-(void)clickSortButton:(UIButton *)button{
    
    DLog(@"点击了排序button事件");
    
    MjAlertView *sortAlertView = [[MjAlertView alloc]initCollectionViewWithTitle:@"项目排序" sortArray:@[@"综合排序",@"金额递增",@"金额递减"]  selectedSortButtonTag:_currentSelectSortTag delegate:self cancelButtonTitle:@"" withOtherButtonTitle:@"确定"];
    [sortAlertView show];
}
-(void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    
    _currentSelectSortTag = index;
    
    
}

#pragma mark -scrollViewScroll代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    return [self addTableHeaderView];
//
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 74.f;
//}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    if([_souceVC isEqualToString:@"P2PVC"]){
        if (_selectIndex == 0) {
            return _investmentProjectDataArray.count;
        }else{
            return _fullProjectDataArray.count ;
        }
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_souceVC isEqualToString:@"P2PVC"]){
        return 95;
    }else{
        return 202;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_souceVC isEqualToString:@"P2PVC"]){
        
        UCFCollectionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellID];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_selectIndex == 0) {
            NSDictionary *dataDict = [_investmentProjectDataArray objectAtIndex:indexPath.row];
            if (indexPath.row <_investmentProjectDataArray.count) {
                cell.dataDict = dataDict;
            }
        }else{
            NSDictionary *dataDict = [_fullProjectDataArray objectAtIndex:indexPath.row];
            if (indexPath.row <_fullProjectDataArray.count) {
                cell.dataDict = dataDict;
            }
        }
        return cell;
    }else{
        UCFCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"投资详情";
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark
#pragma mark 网络请求
-(void)getCollectionDetailHttpRequest{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *dataDict;
    if ([self.listTableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.listTableView.footer resetNoMoreData];
    }
    else if ([self.listTableView.footer isRefreshing]) {
        self.currentPage ++;
    }
    NSString *prdClaimsOrderStr = @"";
    switch (_currentSelectSortTag) {
        case 1:
            prdClaimsOrderStr = @"32";//
            break;
        case 2:
            prdClaimsOrderStr = @"31";
            break;
        default:
            prdClaimsOrderStr = @"00";
            break;
    }
    NSString *currentPageStr = [NSString stringWithFormat:@"%d",_currentPage];
    NSString *statusStr = [NSString stringWithFormat:@"%ld",_selectIndex];
    dataDict  = @{@"userId":uuid,@"colPrdClaimId":_colPrdClaimId,@"page":currentPageStr,@"pageSize":@"20",@"prdClaimsOrder":prdClaimsOrderStr,@"status":statusStr};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagChildPrdclaimsList owner:self signature:YES];
}
-(void)getCollectionListHttpRequest{
    
}
-(void)beginPost:(kSXTag)tag{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)endPost:(id)result tag:(NSNumber *)tag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagChildPrdclaimsList){
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            BOOL hasNext = [[[[dic objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"hasNextPage"] boolValue];
            
            if ([self.listTableView.header isRefreshing]) {
                if (_selectIndex == 0) {
                    [self.investmentProjectDataArray removeAllObjects];
                }else{
                    [self.fullProjectDataArray removeAllObjects];
                }
            }
            
            for (NSDictionary *dict in list_result)
            {
                if (_selectIndex == 0) {
                    [self.investmentProjectDataArray addObject:dict];
                }else{
                    [self.fullProjectDataArray addObject:dict];
                }
                
            }
            [self.listTableView reloadData];
            if (_selectIndex == 0) {
                if (self.investmentProjectDataArray.count > 0) {
                    //                [self.noDataView hide];
                    if (!hasNext) {
                        self.listTableView.footer.state = MJRefreshFooterStateNoMoreData;
                        [self.listTableView.footer noticeNoMoreData];
                    }else{
                        self.listTableView.footer.hidden = NO;
                    }
                }
                
            }else{
                if (self.fullProjectDataArray.count > 0) {
                    //                [self.noDataView hide];
                    if (!hasNext) {
                        self.listTableView.footer.state = MJRefreshFooterStateNoMoreData;
                        [self.listTableView.footer noticeNoMoreData];
                    }else{
                        self.listTableView.footer.hidden = NO;
                    }
                }
                
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    
    [self.listTableView.header endRefreshing];
    [self.listTableView.footer endRefreshing];
    
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag{
    
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
