//
//  UCFAccountDetailViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFAccountDetailViewController.h"
#import "UCFHuiShangBankViewController.h"
#import "UCFOldUserGuideViewController.h"

#import "FundAccountGroup.h"
#import "FundAccountItem.h"
#import "UCFHeadrView.h"
#import "UCFFundsDetailHeader.h"
#import "UCFNoDataView.h"

#import "UCFSelectedView.h"
#import "UCFFundDetialTableViewCell.h"
#import "FundsDetailGroup.h"
#import "FundsDetailModel.h"
#import "FundsDetailFrame.h"
#import "UCFToolsMehod.h"
#import "UCFAccountCell.h"
// 每页条数
#define NUMOFPAGE @"10"

@interface UCFAccountDetailViewController () <UITableViewDataSource, UITableViewDelegate, UCFHeadrViewDelegate,UCFSelectedViewDelegate,UIAlertViewDelegate>

// 选项view
@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSelectedView;

// 承载tableview的背景scrollview
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollview;
// 款项总览的tableview
@property (weak, nonatomic) UITableView *accumulateTableview;
// 资金流水的tableview
@property (weak, nonatomic) UITableView *fundsTableView;

@property (nonatomic, strong) NSArray *dataArray;                   // 资金总览的数据源
@property (nonatomic, strong) NSMutableArray *fundsDetailArray;     // 资金明细
@property (nonatomic, strong) NSMutableArray *selectedStateArray;   // 已选中状态存储
@property (nonatomic, assign) NSUInteger page;                      // 当前页数

// 无数据界面
@property (nonatomic, strong) UCFNoDataView *noDataViewOne;
@property (nonatomic, strong) UCFNoDataView *noDataViewTwo;

@end

@implementation UCFAccountDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedStateArray = [[NSMutableArray alloc] init];
        _fundsDetailArray = [[NSMutableArray alloc] init];
    }
    return self;
}
// 设置资金总览的数据源
- (void)setDataArray:(NSArray *)dataArray
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        FundAccountGroup *group = [FundAccountGroup groupWithDict:dict];
        [temp addObject:group];
    }
    _dataArray = temp;
}

// 资金明细分组
- (void)regroupWithArray:(NSArray *)array
{
    NSMutableArray *temp = [NSMutableArray array];
    for (id obj in array) {
        if ([obj isKindOfClass:[FundsDetailGroup class]]) {
            FundsDetailGroup *group = (FundsDetailGroup *)obj;
            [temp addObjectsFromArray:group.content];
        }
        else if ([obj isKindOfClass:[FundsDetailFrame class]]) {
            FundsDetailFrame *detailFrame = (FundsDetailFrame *)obj;
            [temp addObject:detailFrame];
        }
    }
    NSMutableArray *tempSection = [NSMutableArray array];
    for (id obj in temp) {
        FundsDetailFrame *detailFrame = (FundsDetailFrame *)obj;
        if (![tempSection containsObject:detailFrame.fundsDetailModel.yearMonth]) {
            [tempSection addObject:detailFrame.fundsDetailModel.yearMonth];
        }
    }
    NSMutableArray *tempDataSource = [NSMutableArray array];
    for (NSString *time in tempSection) {
        FundsDetailGroup *group = [[FundsDetailGroup alloc] init];
        NSMutableArray *tempRowData = [NSMutableArray array];
        for (id obj in temp) {
            FundsDetailFrame *detailFrame = (FundsDetailFrame *)obj;
            if ([detailFrame.fundsDetailModel.yearMonth isEqualToString:time]) {
                [tempRowData addObject:detailFrame];
            }
        }
        group.time = time;
        group.content = tempRowData;
        [tempDataSource addObject:group];
    }
    self.fundsDetailArray = tempDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    [self.fundsTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getFundsDetailNetData)];
    
    [self.accumulateTableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getAccountOverallNetData)];
    
    // 添加上拉加载更多
    [self.fundsTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getFundsDetailNetData];
    }];
    
    // 马上进入刷新状态
    [self.accumulateTableview.header beginRefreshing];
    [_selectedStateArray addObject:@(0)];
}

#pragma mark 获取网络数据
// 获取资金总览的网络数据
- (void)getAccountOverallNetData
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagMoneyOverview owner:self Type:self.accoutType];
}

- (void)getFundsDetailNetData
{
    if (self.fundsTableView.header.isRefreshing) {
        self.page = 1;
        self.fundsTableView.footer.hidden = YES;
    }else if (self.fundsTableView.footer.isRefreshing){
        self.page ++;
    }
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%@&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID], [NSString stringWithFormat:@"%lu", (unsigned long)self.page], NUMOFPAGE];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFundsDetail owner:self Type:self.accoutType];
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
    if (tag.intValue == kSXTagMoneyOverview) {
        if (self.noDataViewOne) {
            [self.noDataViewOne hide];
        }
        NSMutableDictionary *dic = [data objectFromJSONString];
        int isSucess = [dic[@"status"] intValue];
        if (isSucess == 1) {
            NSDictionary *result = dic[@"data"];
            NSDictionary *dict0 = @{@"name": @"累计收益", @"opened": @(YES),
                                    @"content":result[@"interests"],
                                    @"fundlist":
        @[
            @{@"ItemName": @"已收利息",@"ItemData":[result[@"interestsDetail"] isKindOfClass:[NSNull class]] ? @"0.00" :result[@"interestsDetail"][@"interestReceived"]},
            @{@"ItemName": @"待收利息", @"ItemData": [result[@"interestsDetail"] isKindOfClass:[NSNull class]] ? @"0.00" :result[@"interestsDetail"][@"writReceived"] },
            @{@"ItemName": @"已用返现券", @"ItemData":[result[@"interestsDetail"] isKindOfClass:[NSNull class]] ? @"0.00" :result[@"interestsDetail"][@"beanRecord"]},
            @{@"ItemName": @"已用工豆", @"ItemData": [result[@"interestsDetail"] isKindOfClass:[NSNull class]] ? @"0.00" :result[@"interestsDetail"][@"bean"]},
            @{@"ItemName": @"余额利息", @"ItemData": [result[@"interestsDetail"] isKindOfClass:[NSNull class]] ? @"0.00" :result[@"interestsDetail"][@"balanceIncome"]}
        ]};
            NSDictionary *dict1 = @{@"name": @"总计资产", @"opened": @(NO), @"content": result[@"total"], @"fundlist": @[@{@"ItemName": @"待收本息", @"ItemData": result[@"principalAndInterest"]},@{@"ItemName": @"账户余额", @"ItemData": result[@"cashBalance"]}]};
            NSDictionary *dict2 = @{@"name": @"待收本息", @"opened": @(NO), @"content": result[@"principalAndInterest"], @"fundlist": @[@{@"ItemName": @"待收本金", @"ItemData": result[@"principal"]}, @{@"ItemName": @"待收利息", @"ItemData": result[@"Interest"]}]};
            NSDictionary *dict3 = @{@"name": @"账户余额", @"opened": @(NO), @"content": result[@"cashBalance"], @"fundlist": @[@{@"ItemName": @"我的余额", @"ItemData": result[@"availableBalance"]}, @{@"ItemName": @"冻结资金", @"ItemData": result[@"tradeFrozenAmt"]}]};
            self.dataArray = @[dict0, dict1, dict2, dict3];
            [self.accumulateTableview reloadData];
        }
        else {
            [AuxiliaryFunc showToastMessage:dic[@"statusdes"] withView:self.view];
        }
        [self.accumulateTableview.header endRefreshing];
    }
    if (tag.integerValue == kSXTagFundsDetail) {
        
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSInteger isSucess = [dic[@"status"] integerValue];
        BOOL hasNextPage = [[[dic[@"pageData"] objectForKey:@"pagination"] valueForKey:@"hasNextPage"] boolValue];
        if (isSucess == 1) {
            if ([self.fundsTableView.header isRefreshing]) {
                [self.fundsDetailArray removeAllObjects];
            }
            NSDictionary *result = dic[@"pageData"];
            NSArray *datalist = [result objectForKey:@"result"];
        // 解析资金流水
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in datalist) {
                FundsDetailModel *model = [FundsDetailModel fundDetailModelWithDict:dict];
                FundsDetailFrame *frame = [[FundsDetailFrame alloc] init];
                frame.fundsDetailModel = model;
                [temp addObject:frame];
            }
            [self.fundsDetailArray addObjectsFromArray:temp];
            [self regroupWithArray:self.fundsDetailArray];
            [self.fundsTableView reloadData];
            if ([self.fundsTableView.header isRefreshing]) {
                if (self.fundsDetailArray.count > 0) {
                    [self.noDataViewTwo hide];
                    if (!hasNextPage) {
                        [self.fundsTableView.footer noticeNoMoreData];
                    }
                    else
                        [self.fundsTableView.footer resetNoMoreData];
                }
                else {
                    [self.noDataViewTwo showInView:self.fundsTableView];
                    [self.fundsTableView.footer noticeNoMoreData];
                }
            }
            else if ([self.fundsTableView.footer isRefreshing])
            {
                if (temp.count==0) {
                    [self.fundsTableView.footer noticeNoMoreData];
                }
            }
        }
        else {
            [AuxiliaryFunc showToastMessage:dic[@"statusdes"] withView:self.view];
        }
        if ([self.fundsTableView.header isRefreshing]) {
            [self.fundsTableView.header endRefreshing];
            self.fundsTableView.footer.hidden = NO;
        }
        if ([self.fundsTableView.footer isRefreshing]) {
            [self.fundsTableView.footer endRefreshing];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    if (tag.intValue == kSXTagMoneyOverview) {
        [self.noDataViewOne showInView:self.accumulateTableview];
    }
    else if (tag.intValue == kSXTagFundsDetail) {
        if (self.fundsDetailArray.count == 0) {
            [self.noDataViewTwo showInView:self.fundsTableView];
            [self.fundsTableView.footer noticeNoMoreData];
        }
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.accumulateTableview.header isRefreshing]) {
        [self.accumulateTableview.header endRefreshing];
    }
    if ([self.fundsTableView.header isRefreshing]) {
        self.fundsTableView.footer.hidden = NO;
        [self.fundsTableView.header endRefreshing];
    }
    if ([self.fundsTableView.footer isRefreshing]) {
        [self.fundsTableView.footer endRefreshing];
    }
}

// 初始化界面
- (void)createUI
{
    
    [self addLeftButton];
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 65, 35);
    [rightbutton setTitle:@"徽商账户" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    if (self.accoutType == SelectAccoutTypeHoner) {
       baseTitleLabel.text = @"尊享资金帐户";
    }else if (self.accoutType == SelectAccoutTypeP2P){
        baseTitleLabel.text = @"P2P资金帐户";
    }
    self.bgScrollview.contentSize = CGSizeMake(self.view.frame.size.width *2, 0);
    self.bgScrollview.scrollEnabled = NO;
    
    UITableView *tableview1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-40) style:UITableViewStyleGrouped];
    tableview1.dataSource = self;
    tableview1.delegate = self;
    tableview1.backgroundColor = UIColorWithRGB(0xebebee);
    [self.bgScrollview addSubview:tableview1];
    tableview1.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.accumulateTableview = tableview1;
    
    UCFNoDataView *noDataViewOne = [[UCFNoDataView alloc] initWithFrame:tableview1.bounds errorTitle:@"暂无款项总览信息"];
    self.noDataViewOne = noDataViewOne;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = UIColorWithRGB(0xebebee);
    tableview1.tableHeaderView = view;
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, ScreenWidth, 44)];
//    headerView.backgroundColor = [UIColor whiteColor];
////    [view addSubview:headerView];
//    
//    UIView *linetop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    linetop.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    [headerView addSubview:linetop];
//    
//    UIView *linebottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame)-0.5, ScreenWidth, 0.5)];
//    linebottom.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    [headerView addSubview:linebottom];
//    
//    UILabel *accumulatedProfitNameLabel = [[UILabel alloc] init];
//    accumulatedProfitNameLabel.text = @"累计收益";
//    accumulatedProfitNameLabel.font = [UIFont boldSystemFontOfSize:14];
//    [accumulatedProfitNameLabel setTextColor:UIColorWithRGB(0x555555)];
//    accumulatedProfitNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [headerView addSubview:accumulatedProfitNameLabel];
//    
//    UILabel *accumulatedProfitLabel = [[UILabel alloc] init];
//    accumulatedProfitLabel.text = @"¥0.00";
//    accumulatedProfitLabel.font = [UIFont boldSystemFontOfSize:14];
//    [accumulatedProfitLabel setTextColor:UIColorWithRGB(0x555555)];
//    accumulatedProfitLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [headerView addSubview:accumulatedProfitLabel];
//    self.accumulatedProfitLabel = accumulatedProfitLabel;
    
//    NSArray *constraints1H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[accumulatedProfitNameLabel(==80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(accumulatedProfitNameLabel)];
//    NSArray *constraints1V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[accumulatedProfitNameLabel(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(accumulatedProfitNameLabel)];
//    [headerView addConstraints:constraints1H];
//    [headerView addConstraints:constraints1V];
//    
//    NSDictionary *views = NSDictionaryOfVariableBindings(accumulatedProfitNameLabel, accumulatedProfitLabel);
//    NSArray *constraints2H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:[accumulatedProfitNameLabel][accumulatedProfitLabel]-|" options:0 metrics:nil views:views];
//    NSArray *constraints2V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[accumulatedProfitLabel(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(accumulatedProfitLabel)];
//    [headerView addConstraints:constraints2H];
//    [headerView addConstraints:constraints2V];
    
    UITableView *tableview2 = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-64-40) style:UITableViewStylePlain];
    tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview2.backgroundColor = UIColorWithRGB(0xebebee);
    tableview2.dataSource = self;
    tableview2.delegate = self;
    [self.bgScrollview addSubview:tableview2];
    self.fundsTableView = tableview2;
    
    UCFNoDataView *noDataViewTwo = [[UCFNoDataView alloc] initWithFrame:tableview2.bounds errorTitle:@"暂无资金流水信息"];
    self.noDataViewTwo = noDataViewTwo;
    
    self.itemSelectedView.sectionTitles = @[@"款项总览", @"资金流水"];
    self.itemSelectedView.delegate = self;
}

// 404错误界面的代理方法
- (void)refreshBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    if ([fhView.superview isEqual:self.accumulateTableview]) {
        [self.accumulateTableview.header beginRefreshing];
    }
    else if ([fhView.superview isEqual:self.fundsTableView]) {
        [self.fundsTableView.header beginRefreshing];
    }
}

- (void)rightClicked:(UIButton *)button
{
    if ([UserInfoSingle sharedManager].openStatus <= 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先开通徽商存管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1009;
        [alert show];
        return;
    }
    
    UCFHuiShangBankViewController *huiShangBank = [[UCFHuiShangBankViewController alloc] initWithNibName:@"UCFHuiShangBankViewController" bundle:nil];
    huiShangBank.accoutType = self.accoutType;
    [self.navigationController pushViewController:huiShangBank animated:YES];
}

#pragma mark - table
// tableview的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.fundsTableView) {
        return self.fundsDetailArray.count;
    }
    else if (tableView == self.accumulateTableview) {
        return self.dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.accumulateTableview) {
        return 44;
    }
    else if (tableView == self.fundsTableView){
//        if (section == 0) {
//            return 30;
//        }
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.accumulateTableview) {
        return 10;
    }
    else
        return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.fundsTableView) {
        FundsDetailGroup *group = self.fundsDetailArray[indexPath.section];
        FundsDetailFrame *frame = group.content[indexPath.row];
        if (indexPath.row == 0) {
            return frame.cellHeight + 10;
        }
        else return frame.cellHeight;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.accumulateTableview) {
        // 1.创建头部控件
        UCFHeadrView *header = [UCFHeadrView headerViewWithTableView:tableView];
        header.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        header.delegate = self;
        // 2.给header设置数据(给header传递模型)
        header.group = self.dataArray[section];
//        if (section == self.dataArray.count-1) {
//            header.button.hidden = NO;
//        }
//        else header.button.hidden = YES;
        return header;
    } else if (tableView == self.fundsTableView) {
        UCFFundsDetailHeader *headerView = [UCFFundsDetailHeader headerViewWithTableView:tableView];
        if (section == 0) {
            headerView.isFirst = YES;
        }
        else headerView.isFirst = NO;
        headerView.group = self.fundsDetailArray[section];
        return headerView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.fundsTableView) {
        FundsDetailGroup *group = self.fundsDetailArray[section];
        return group.content.count;
    }
    else if (tableView == self.accumulateTableview) {
        FundAccountGroup *group = self.dataArray[section];
        return (group.isOpened ? group.fundlist.count : 0);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.fundsTableView) {//资金流水 列表
        UCFFundDetialTableViewCell *cell = [UCFFundDetialTableViewCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.isFirst = YES;
        }
        else cell.isFirst = NO;
        FundsDetailGroup *group = self.fundsDetailArray[indexPath.section];
        FundsDetailFrame *frame = group.content[indexPath.row];
        cell.fundsFrame = frame;
        
//        if (indexPath.row == group.content.count-1) {
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame) - 1, ScreenWidth, 0.5)];
//            line.backgroundColor = UIColorWithRGB(0xd8d8d8);
//            [cell.contentView addSubview:line];
//        }
        return cell;
    }
    else if (tableView == self.accumulateTableview) {//款项总览 列表
        UCFAccountCell *cell = [UCFAccountCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        FundAccountGroup *group = self.dataArray[indexPath.section];
        cell.item = group.fundlist[indexPath.row];
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountdetail"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"accountdetail"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        [cell setBackgroundColor:UIColorWithRGB(0xf8f8f8)];
//
//        cell.textLabel.text = item.ItemName;
//        cell.textLabel.textColor = UIColorWithRGB(0x434343);
//        cell.textLabel.font = [UIFont systemFontOfSize:12];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",item.ItemData];//[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%@",item.ItemData]]];
//        cell.detailTextLabel.textColor = UIColorWithRGB(0x434343);
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        return cell;
    }
    return nil;
}

- (void)headerViewDidClickedNameView:(UCFHeadrView *)headerView
{
    [self.accumulateTableview reloadData];
}


// 选项栏的点击方法
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0: {
            if (![_selectedStateArray containsObject:@(sender.selectedSegmentIndex)]) {
                [self.accumulateTableview.header beginRefreshing];
                [_selectedStateArray addObject:@(sender.selectedSegmentIndex)];
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.bgScrollview setContentOffset:CGPointMake(0, 0)];
            }];
        }
            break;
            
        default:
        {
            if (![_selectedStateArray containsObject:@(sender.selectedSegmentIndex)]) {
                [self.fundsTableView.header beginRefreshing];
                [_selectedStateArray addObject:@(sender.selectedSegmentIndex)];
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.bgScrollview setContentOffset:CGPointMake(self.view.bounds.size.width, 0)];
            }];
        }
            break;
    }
}

#pragma mark - 警示框代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1009 && buttonIndex == 1) {
        UCFOldUserGuideViewController *vc = [[UCFOldUserGuideViewController alloc] initWithNibName:@"UCFOldUserGuideViewController" bundle:nil];
        vc.isStep = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
