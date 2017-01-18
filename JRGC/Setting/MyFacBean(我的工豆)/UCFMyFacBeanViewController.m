//
//  UCFMyFacBeanViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFMyFacBeanViewController.h"
#import "UCFOverDueListViewController.h"
#import "UCFSelectedView.h"
#import "HMSegmentedControl.h"
#import "BeanTableViewCell.h"
#import "UCFFacBeanModel.h"
#import "NSString+FormatForThousand.h"
#import "UCFToolsMehod.h"
#import "UCF404ErrorView.h"
#import "UCFNoDataView.h"

@interface UCFMyFacBeanViewController () <UITableViewDataSource, UITableViewDelegate, UCFSelectedViewDelegate, FourOFourViewDelegate>
@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSelectedView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

// 剩余资金
@property (weak, nonatomic) IBOutlet UILabel *cashBalanceLabel;
// 剩余资金所抵工豆
@property (weak, nonatomic) IBOutlet UILabel *beanBalanceLabel;
// 即将过期的工豆所抵现金
@property (weak, nonatomic) IBOutlet UILabel *moneyForOverduingBeanLabel;
// 工豆帮助
- (IBAction)help:(UIButton *)sender;

// 未使用的工豆
@property (strong, nonatomic) NSMutableArray *unusedBeanArray;
// 未使用工豆的页码
@property (nonatomic, assign) NSUInteger currentPageForUnusedBean;
// 已使用的工豆
@property (strong, nonatomic) NSMutableArray *usedBeanArray;
// 已使用工豆的页码
@property (nonatomic, assign) NSUInteger currentPageForUsedBean;
// 即将过期的工豆
@property (strong, nonatomic) NSMutableArray *overduingBeanArray;
// 即将过期工豆的页码
@property (nonatomic, assign) NSUInteger currentPageForOverduingBean;
// 当前的选种状态
@property (nonatomic, assign) MyFacBeanCurrentState currentState;
// 可用工豆
@property (nonatomic, weak) IBOutlet UITableView *tableViewForAvailable;
// 已用工豆
@property (nonatomic, weak) IBOutlet UITableView *tableViewForHadUsed;
// 即将过期
@property (nonatomic, weak) IBOutlet UITableView *tableViewForOverduing;
// 已选中状态存储数组
@property (nonatomic, strong) NSMutableArray *selectedStateArray;

// 无数据界面
@property (nonatomic, strong) UCFNoDataView *noDataViewOne;
@property (nonatomic, strong) UCFNoDataView *noDataViewTwo;
@property (nonatomic, strong) UCFNoDataView *noDataViewThree;
@end

@implementation UCFMyFacBeanViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

// 已选中状态存储数组
- (NSMutableArray *)selectedStateArray
{
    if (_selectedStateArray == nil) {
        _selectedStateArray = [[NSMutableArray alloc] init];
    }
    return _selectedStateArray;
}

- (NSMutableArray *)unusedBeanArray
{
    if (nil == _unusedBeanArray) {
        _unusedBeanArray = [[NSMutableArray alloc] init];
    }
    return _unusedBeanArray;
}

- (NSMutableArray *)usedBeanArray
{
    if (nil == _usedBeanArray) {
        _usedBeanArray = [[NSMutableArray alloc] init];
    }
    return _usedBeanArray;
}

- (NSMutableArray *)overduingBeanArray
{
    if (!_overduingBeanArray) {
        _overduingBeanArray = [[NSMutableArray alloc] init];
    }
    return _overduingBeanArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"过期记录" forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 60, 40);
    [right.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [right setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    //    right.backgroundColor = [UIColor greenColor];
    [right addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self addLeftButton];
    
    baseTitleLabel.text = @"我的工豆";
    
    self.itemSelectedView.sectionTitles = @[@"按过期时间", @"工豆收入", @"工豆支出"];
    self.itemSelectedView.delegate = self;
        
    
    self.tableViewForAvailable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewForHadUsed.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewForOverduing.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableViewForAvailable.backgroundColor = UIColorWithRGB(0xebebee);
    self.tableViewForHadUsed.backgroundColor = UIColorWithRGB(0xebebee);
    self.tableViewForOverduing.backgroundColor = UIColorWithRGB(0xebebee);


    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    [self.tableViewForAvailable addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getFirstPageBeanForAvailableFromNet)];
    
    // 添加上拉加载更多
    [_tableViewForAvailable addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPageForUnusedBean++;
        [weakSelf getBeanInComeFromNetworkWithCurrentPage:self.currentPageForUnusedBean];
    }];
    
    [self.tableViewForHadUsed addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getFirstPageBeanForHadUsedFromNet)];
    
    // 添加上拉加载更多
    [self.tableViewForHadUsed addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPageForUsedBean++;
        [weakSelf getBeanExpendFromNetworkWithCurrentPage:self.currentPageForUsedBean];
    }];
    
    [self.tableViewForOverduing addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getFirstPageBeanForOverduing)];
    
    // 添加上拉加载更多
    [_tableViewForOverduing addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPageForOverduingBean++;
        [weakSelf getOverduingBeanFromNetworkWithCurrentPage:self.currentPageForOverduingBean];
    }];
    
    // 马上进入刷新状态
    [self.tableViewForOverduing.header beginRefreshing];
    [self.selectedStateArray addObject:@(UCFMyFacBeanStateOverduing)];
    
    // 是否支持点击状态栏回到最顶端
    _tableViewForAvailable.scrollsToTop = NO;
    _tableViewForHadUsed.scrollsToTop = NO;
    _tableViewForOverduing.scrollsToTop = YES;
    
    self.currentPageForUnusedBean = 1;
    self.currentPageForUsedBean = 1;
    self.currentPageForOverduingBean = 1;
    self.currentState = UCFMyFacBeanStateOverduing;
    
    if (!self.noDataViewThree) {
        self.noDataViewThree = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-140) errorTitle:@"暂无数据"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    _bgViewWidth.constant = 3*ScreenWidth;
    self.bgScrollView.frame = CGRectMake(0, 140, ScreenWidth, ScreenHeight);
}

// 刷新可使用的工豆
- (void)getFirstPageBeanForAvailableFromNet
{
    self.tableViewForAvailable.footer.hidden= YES;
    self.currentPageForUnusedBean = 1;
    [self getBeanInComeFromNetworkWithCurrentPage:1];
}

// 刷新已使用的工豆
- (void)getFirstPageBeanForHadUsedFromNet
{
    self.tableViewForHadUsed.footer.hidden= YES;
    self.currentPageForUsedBean = 1;
    [self getBeanExpendFromNetworkWithCurrentPage:1];
}

// 刷新即将过期的工豆
- (void)getFirstPageBeanForOverduing
{
    self.tableViewForOverduing.footer.hidden= YES;
    self.currentPageForOverduingBean = 1;
    [self getOverduingBeanFromNetworkWithCurrentPage:1];
}

// 404错误界面的代理方法
- (void)refreshBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    switch (fhView.tag) {
//        case 100:
//            [self.tableViewForOverduing.header beginRefreshing];
//            break;
//        case 101:
//            [self.tableViewForAvailable.header beginRefreshing];
//            break;
//        default: [self.tableViewForHadUsed.header beginRefreshing];
//            break;
    }
}

// 选项栏的点击方法
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender
{
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth*sender.selectedSegmentIndex, 0) animated:YES];

    switch (sender.selectedSegmentIndex) {
        case 0: {
            // 是否支持点击状态栏回到最顶端
            _tableViewForAvailable.scrollsToTop = NO;
            _tableViewForHadUsed.scrollsToTop = NO;
            _tableViewForOverduing.scrollsToTop = YES;
            
            self.currentState = UCFMyFacBeanStateOverduing;
            if (self.currentPageForOverduingBean == 1) {
                if (![self.selectedStateArray containsObject:@(UCFMyFacBeanStateOverduing)]) {
                    [_tableViewForAvailable.header beginRefreshing];
                    [self.selectedStateArray addObject:@(UCFMyFacBeanStateOverduing)];
                }
            }
        }
            break;
            
        case 1: {
            // 是否支持点击状态栏回到最顶端
            _tableViewForAvailable.scrollsToTop = YES;
            _tableViewForHadUsed.scrollsToTop = NO;
            _tableViewForOverduing.scrollsToTop = NO;
            
            self.currentState = UCFMyFacBeanStateUnused;
            if (self.currentPageForUnusedBean == 1) {
                if (![self.selectedStateArray containsObject:@(UCFMyFacBeanStateUnused)]) {
                    [_tableViewForAvailable.header beginRefreshing];
                    [self.selectedStateArray addObject:@(UCFMyFacBeanStateUnused)];
                }
            }
        }
            break;
            
        case 2:
        {
            // 是否支持点击状态栏回到最顶端
            _tableViewForAvailable.scrollsToTop = NO;
            _tableViewForHadUsed.scrollsToTop = YES;
            _tableViewForOverduing.scrollsToTop = NO;
            
            self.currentState = UCFMyFacBeanStateUsed;
            if (self.currentPageForUsedBean == 1) {
                if (![self.selectedStateArray containsObject:@(UCFMyFacBeanStateUsed)]) {
                    [_tableViewForHadUsed.header beginRefreshing];
                    [self.selectedStateArray addObject:@(UCFMyFacBeanStateUsed)];
                }
            }
        }
            break;
    }
}

// 请求工豆收入
- (void)getBeanInComeFromNetworkWithCurrentPage:(NSInteger)currentPageNo
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%lu&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID], (unsigned long)currentPageNo, PAGESIZE];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSxTagGongDouInCome owner:self];
}

// 请求工豆收入
- (void)getBeanExpendFromNetworkWithCurrentPage:(NSInteger)currentPageNo
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%lu&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID], (unsigned long)currentPageNo, PAGESIZE];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSxTagGongDouExpend owner:self];
}

// 请求工豆收入
- (void)getOverduingBeanFromNetworkWithCurrentPage:(NSInteger)currentPageNo
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%lu&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID], (unsigned long)currentPageNo, PAGESIZE];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGongDouOverDuing owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
//    if (self.settingBaseBgView.hidden) {
//        self.settingBaseBgView.hidden = NO;
//    }
//    [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    BOOL hasNextPage = [[[dic[@"pageData"] objectForKey:@"pagination"] valueForKey:@"hasNextPage"] boolValue];
//    self.bgView.hidden = YES;
    if (tag.integerValue == kSXTagGongDouOverDuing) {
        NSInteger sign = [rstcode integerValue];
        if (sign == 1) {
            if ([self.tableViewForOverduing.header isRefreshing]) {
                [self.overduingBeanArray removeAllObjects];
            }
            NSInteger cashBalance = [dic[@"cashBalance"] integerValue];
            self.beanBalanceLabel.text = [NSString stringWithFormat:@"(总共%ld工豆，100工豆＝1元)", (long)cashBalance];
            if (cashBalance < 0) {
                cashBalance = labs(cashBalance);
            }
            NSString *cashBalanceStr = [NSString stringWithFormat:@"%.2f", (double)cashBalance/100.0];
            self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            if ([dic[@"cashBalance"] integerValue] < 0) {
                self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥-%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            }
            else {
                self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            }
            NSUInteger overduingBean = [dic[@"overbeancount"] integerValue];
            NSString *overduingMoney = [NSString stringWithFormat:@"%.2f", (double)overduingBean/100.0];
            self.moneyForOverduingBeanLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:overduingMoney]];
            NSArray *result = [dic[@"pageData"] objectForKey:@"result"];
            NSMutableArray *tempForOverduing = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                UCFFacBeanModel *model = [UCFFacBeanModel facBeanWithDict:dict];
                model.state = UCFMyFacBeanStateOverduing;
                [tempForOverduing addObject:model];
            }
            [self.overduingBeanArray addObjectsFromArray:tempForOverduing];
            if ([self.tableViewForOverduing.header isRefreshing]) {
                if (self.overduingBeanArray.count > 0) {
                    [self.noDataViewThree hide];
                    if (!hasNextPage) {
                        [self.tableViewForOverduing.footer noticeNoMoreData];
                    }
                    else
                        [self.tableViewForOverduing.footer resetNoMoreData];
                }
                else {
                    if (!self.noDataViewThree) {
                        self.noDataViewThree = [[UCFNoDataView alloc] initWithFrame:self.tableViewForAvailable.bounds errorTitle:@"暂无数据"];
                    }
                    [self.noDataViewThree showInView:self.tableViewForOverduing];
                    [self.tableViewForOverduing.footer noticeNoMoreData];
                }
            }
            else if ([self.tableViewForOverduing.footer isRefreshing])
            {
                if (tempForOverduing.count==0) {
                    [self.tableViewForOverduing.footer noticeNoMoreData];
                }
            }
        }
        else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        [self.tableViewForOverduing reloadData];
        if ([self.tableViewForOverduing.header isRefreshing]) {
            [self.tableViewForOverduing.header endRefreshing];
            self.tableViewForOverduing.footer.hidden= NO;
        }
        if ([self.tableViewForOverduing.footer isRefreshing]) {
            [self.tableViewForOverduing.footer endRefreshing];
        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"1"];
    }
    else if (tag.intValue == kSxTagGongDouInCome) {
        NSInteger sign = [rstcode integerValue];
        if (sign == 1) {
            if ([self.tableViewForAvailable.header isRefreshing]) {
                [self.unusedBeanArray removeAllObjects];
            }
            NSInteger cashBalance = [dic[@"cashBalance"] integerValue];
            self.beanBalanceLabel.text = [NSString stringWithFormat:@"(总共%ld工豆，100工豆＝1元)", (long)cashBalance];
            if (cashBalance < 0) {
                cashBalance = labs(cashBalance);
            }
            NSString *cashBalanceStr = [NSString stringWithFormat:@"%.2f", (double)cashBalance/100.0];
            self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            if ([dic[@"cashBalance"] integerValue] < 0) {
                self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥-%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            }
            else {
                self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            }
            NSUInteger overduingBean = [dic[@"overbeancount"] integerValue];
            NSString *overduingMoney = [NSString stringWithFormat:@"%.2f", (double)overduingBean/100.0];
            self.moneyForOverduingBeanLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:overduingMoney]];
            NSArray *result = [dic[@"pageData"] objectForKey:@"result"];
            NSMutableArray *tempForUnused = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                UCFFacBeanModel *model = [UCFFacBeanModel facBeanWithDict:dict];
                model.state = UCFMyFacBeanStateUnused;
                [tempForUnused addObject:model];
            }
            [self.unusedBeanArray addObjectsFromArray:tempForUnused];
            if ([self.tableViewForAvailable.header isRefreshing]) {
                if (self.unusedBeanArray.count > 0) {
                    [self.noDataViewOne hide];
                    if (!hasNextPage) {
                        [self.tableViewForAvailable.footer noticeNoMoreData];
                    }
                    else
                        [self.tableViewForAvailable.footer resetNoMoreData];
                }
                else {
                    if (!self.noDataViewOne) {
                        self.noDataViewOne = [[UCFNoDataView alloc] initWithFrame:self.tableViewForAvailable.bounds errorTitle:@"暂无数据"];
                    }
                    [self.noDataViewOne showInView:self.tableViewForAvailable];
                    [self.tableViewForAvailable.footer noticeNoMoreData];
                }
                
            }
            else if ([self.tableViewForAvailable.footer isRefreshing])
            {
                if (tempForUnused.count==0) {
                    [self.tableViewForAvailable.footer noticeNoMoreData];
                }
            }
        }
        else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        [self.tableViewForAvailable reloadData];
        if ([self.tableViewForAvailable.header isRefreshing]) {
            [self.tableViewForAvailable.header endRefreshing];
            self.tableViewForAvailable.footer.hidden = NO;
        }
        if ([self.tableViewForAvailable.footer isRefreshing]) {
            [self.tableViewForAvailable.footer endRefreshing];
        }
    }
    else if (tag.integerValue == kSxTagGongDouExpend) {
        NSInteger sign = [rstcode integerValue];
        if (sign == 1) {
            if ([self.tableViewForHadUsed.header isRefreshing]) {
                [self.usedBeanArray removeAllObjects];
            }
            NSInteger cashBalance = [dic[@"cashBalance"] integerValue];
            self.beanBalanceLabel.text = [NSString stringWithFormat:@"(总共%ld工豆，100工豆＝1元)", (long)cashBalance];
            if (cashBalance < 0) {
                cashBalance = labs(cashBalance);
            }
            NSString *cashBalanceStr = [NSString stringWithFormat:@"%.2f", (double)cashBalance/100.0];
            self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            if ([dic[@"cashBalance"] integerValue] < 0) {
                self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥-%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            }
            else {
                self.cashBalanceLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:cashBalanceStr]];
            }
            NSUInteger overduingBean = [dic[@"overbeancount"] integerValue];
            NSString *overduingMoney = [NSString stringWithFormat:@"%.2f", (double)overduingBean/100.0];
            self.moneyForOverduingBeanLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:overduingMoney]];
            NSArray *result = [dic[@"pageData"] objectForKey:@"result"];
            NSMutableArray *tempForUnused = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                UCFFacBeanModel *model = [UCFFacBeanModel facBeanWithDict:dict];
                model.state = UCFMyFacBeanStateUsed;
                [tempForUnused addObject:model];
            }
            [self.usedBeanArray addObjectsFromArray:tempForUnused];
            if ([self.tableViewForHadUsed.header isRefreshing]) {
                if (self.usedBeanArray.count > 0) {
                    [self.noDataViewTwo hide];
                    if (!hasNextPage) {
                        [self.tableViewForHadUsed.footer noticeNoMoreData];
                    }
                    else
                        [self.tableViewForHadUsed.footer resetNoMoreData];
                }
                else {
                    if (!self.noDataViewTwo) {
                        self.noDataViewTwo = [[UCFNoDataView alloc] initWithFrame:self.tableViewForAvailable.bounds errorTitle:@"暂无数据"];
                    }
                    [self.noDataViewTwo showInView:self.tableViewForHadUsed];
                    [self.tableViewForHadUsed.footer noticeNoMoreData];
                }
                
            }
            else if ([self.tableViewForHadUsed.footer isRefreshing])
            {
                if (tempForUnused.count==0) {
                    [self.tableViewForHadUsed.footer noticeNoMoreData];
                }
            }
        }
        else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        [self.tableViewForHadUsed reloadData];
        if ([self.tableViewForHadUsed.header isRefreshing]) {
            [self.tableViewForHadUsed.header endRefreshing];
            self.tableViewForHadUsed.footer.hidden = NO;
        }
        if ([self.tableViewForHadUsed.footer isRefreshing]) {
            [self.tableViewForHadUsed.footer endRefreshing];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (tag.intValue == kSxTagGongDouInCome || tag.integerValue == kSxTagGongDouExpend || tag.integerValue == kSXTagGongDouOverDuing) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    if (tag.intValue == kSxTagGongDouInCome) {
        [self.tableViewForAvailable.header endRefreshing];
        self.tableViewForAvailable.footer.hidden = NO;
        [self.tableViewForAvailable.footer endRefreshing];
        if (self.unusedBeanArray.count == 0) {
            [self.noDataViewOne showInView:self.tableViewForAvailable];
            [self.tableViewForAvailable.footer noticeNoMoreData];
        }
    }
    else if (tag.intValue == kSxTagGongDouExpend) {
        [self.tableViewForHadUsed.header endRefreshing];
        self.tableViewForHadUsed.footer.hidden = NO;
        [self.tableViewForHadUsed.footer endRefreshing];
        if (self.usedBeanArray.count == 0) {
            [self.noDataViewTwo showInView:self.tableViewForHadUsed];
            [self.tableViewForHadUsed.footer noticeNoMoreData];
        }
    }
    else if (tag.intValue == kSXTagGongDouOverDuing) {
        [self.tableViewForOverduing.header endRefreshing];
        self.tableViewForOverduing.footer.hidden = NO;
        [self.tableViewForOverduing.footer endRefreshing];
        if (self.overduingBeanArray.count == 0) {
            [self.noDataViewThree showInView:self.tableViewForOverduing];
            [self.tableViewForOverduing.footer noticeNoMoreData];
        }
    }
}

// 有导航栏按钮的点击事件
- (void)rightClicked:(UIButton *)button
{
    UCFOverDueListViewController *overdue = [[UCFOverDueListViewController alloc] init];
    overdue.title = @"已过期工豆";
    [self.navigationController pushViewController:overdue animated:YES];
}

// tableview的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableViewForAvailable) {
        return self.unusedBeanArray.count;
    }
    else if (tableView == self.tableViewForHadUsed) {
        return self.usedBeanArray.count;
    }
    else if (tableView == self.tableViewForOverduing) {
        return self.overduingBeanArray.count;
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeanTableViewCell *cell = [BeanTableViewCell cellWithTableView:tableView];
    UCFFacBeanModel *model = nil;
    if (tableView == self.tableViewForAvailable) {
        model = self.unusedBeanArray[indexPath.row];
        cell.facBean = model;
    }
    else if (tableView == self.tableViewForHadUsed) {
        model = self.usedBeanArray[indexPath.row];
        cell.facBean = model;
    }
    else if (tableView == self.tableViewForOverduing) {
        model = self.overduingBeanArray[indexPath.row];
        cell.facBean = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (IBAction)help:(UIButton *)sender {
    NSString *message = @"即将过期的工豆，在投资时系统会默认优先使用，快去投资用掉吧，不要浪费哦亲";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
@end
