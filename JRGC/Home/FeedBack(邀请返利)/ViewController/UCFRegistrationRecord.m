//
//  UCFRegistrationRecord.m
//  JRGC
//
//  Created by biyuhuaping on 15/7/23.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRegistrationRecord.h"
#import "UCFRebateCell1.h"
#import "UCFNoDataView.h"
#include "UIDic+Safe.h"
@interface UCFRegistrationRecord ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *monthDataArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *dataArr_1;//用来储存未便利前的原始格式数据

@property (assign, nonatomic) NSInteger pageNum;
@property (strong, nonatomic) NSArray *titleArr;

@property (strong, nonatomic) IBOutlet UILabel *sumCommLab;//人数
@property (strong, nonatomic) IBOutlet UILabel *friendCountLab;//邀请投资人数

// 无数据界面
@property (nonatomic, strong) UCFNoDataView *noDataView;

@end

@implementation UCFRegistrationRecord

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButton];
    baseTitleLabel.text = @"邀请记录";
    
    _dataArr = [NSMutableArray new];
    _monthDataArr = [NSMutableArray array];
    _pageNum = 1;
    _titleArr = @[@"已认证", @"未认证"];
    
    _tableView.backgroundColor = UIColorWithRGBA(230, 230, 234, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加上拉加载更多
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
    [_tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataList)];
    
    // 马上进入刷新状态
    [_tableView.header beginRefreshing];
    _tableView.footer.hidden = YES;
    
    _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 120) errorTitle:@"暂无数据"];
}

#pragma mark - UITableViewDelegate
// tableview的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 1.创建头部控件
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    left.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:left];
    
//    if (tableView == _tableView1) {
//        UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 15 - 150, 0, 150, 30)];
//        right.font = [UIFont systemFontOfSize:12];
//        right.textAlignment = NSTextAlignmentRight;
//        [headerView addSubview:right];
//        
//        left.text = [[_monthDataArr1[section][@"transactionTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
//        right.text = [@"本月收益￥" stringByAppendingString:_monthDataArr1[section][@"commission"]];
//    }else if (tableView == _tableView2){
        left.text = [[_monthDataArr[section] stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
//    }
    return headerView;
}

//每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_dataArr[indexPath.section] count] - 1) {
        return 142;
    }
    return 132;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *indentifier1 = @"UCFRebateCell1";
    UCFRebateCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:indentifier1];
    if (!cell1) {
        cell1 = [[NSBundle mainBundle]loadNibNamed:@"UCFRebateCell1" owner:self options:nil][0];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell1.title1.text = _dataArr[indexPath.section][indexPath.row][@"loginName"];//登录名
    cell1.title_1.text = _dataArr[indexPath.section][indexPath.row][@"state"];//认证状态
    cell1.title2.text = _dataArr[indexPath.section][indexPath.row][@"realName"];//真实姓名
    cell1.title3.text = _dataArr[indexPath.section][indexPath.row][@"mobile"];//手机号
    cell1.title4.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.section][indexPath.row][@"createTime"]];//注册时间
    if ([cell1.title_1.text isEqualToString:@"已认证"]) {
        cell1.title_1.textColor = UIColorWithRGB(0x4aa1f9);
    }else if ([cell1.title_1.text isEqualToString:@"未认证"]){
        cell1.title_1.textColor = UIColorWithRGB(0x999999);
    }
    return cell1;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 请求网络及回调
//（邀请返利-邀请注册记录）
- (void)getDataList
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    if (_tableView.header.isRefreshing) {
        _pageNum = 1;
    }else if (_tableView.footer.isRefreshing){
        _pageNum ++;
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)_pageNum];//5644
    NSDictionary *parameterDic = @{@"userId":userId,@"page":pageStr,@"rows":@"20"};
    
    [[NetworkModule sharedNetworkModule] newPostReq:parameterDic tag:kSXTagRecFriendList owner:self signature:YES Type:SelectAccoutDefault];
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
    BOOL rstcode = [dic[@"ret"]  boolValue];
    NSString *rsttext = dic[@"message"];
    
    DBLOG(@"我的返利页：%@",dic);
    
    NSDictionary *dataDic = [dic objectSafeDictionaryForKey:@"data"];
    
    _sumCommLab.text = [NSString stringWithFormat:@"%@人",[dataDic objectSafeForKey:@"userRemmendCount"]];//人数
    if (self.accoutType == SelectAccoutTypeGold) {
        _friendCountLab.text = [NSString stringWithFormat:@"邀请购买人数:%@人",[dataDic objectSafeForKey:@"friendsCount"]];//邀请投资人数
    } else if (self.accoutType == SelectAccoutTypeP2P) {
        _friendCountLab.text = [NSString stringWithFormat:@"邀请出借人数:%@人",[dataDic objectSafeForKey:@"friendsCount"]];//邀请投资人数
    }
    else {
        _friendCountLab.text = [NSString stringWithFormat:@"邀请投资人数:%@人",[dataDic objectSafeForKey:@"friendsCount"]];//邀请投资人数
    }

    NSArray *tempArr =  [[dataDic objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey: @"result"];
//
    //（邀请返利-邀请注册记录）
    if (tag.intValue == kSXTagRecFriendList) {
        _tableView.footer.hidden = NO;
        if (rstcode) {
            if (_pageNum == 1) {
                _dataArr_1 = [NSMutableArray arrayWithArray:tempArr];
                [_tableView.header endRefreshing];
                [_tableView.footer endRefreshing];
            }else{
                if (tempArr.count == 0) {
                    [_tableView.footer noticeNoMoreData];
                }else{
                    [_dataArr_1 addObjectsFromArray:tempArr];
                    [_tableView.footer endRefreshing];
                }
            }
            DBLOG(@"_dataArr:%@",_dataArr);
            [self getFormatData];
            [_tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [self endRefreshing];
        }
    }
    
    if (_dataArr.count == 0) {
        [_noDataView showInView:_tableView];
        [_tableView.footer noticeNoMoreData];
    }
    else {
        [self.noDataView hide];
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagRecFriendList) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self endRefreshing];
    if (_dataArr.count == 0) {
        [_noDataView showInView:_tableView];
        [_tableView.footer noticeNoMoreData];
    }
    else {
        [self.noDataView hide];
    }
}

- (void)endRefreshing{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

#pragma mark - 其他
- (void)getFormatData{
    if (_dataArr_1.count == 0) {
        return;
    }
    
    if (_pageNum == 1) {
        [_monthDataArr removeAllObjects];
    }
    
    //取出分组个数/分组关键字
    for (int i = 0; i < _dataArr_1.count; i++) {
        NSString *dateStr = [_dataArr_1[i][@"createTime"]substringToIndex:7];
        if (![_monthDataArr containsObject:dateStr]) {
            [_monthDataArr addObject:dateStr];
        }
    }
    
    //把同年月的归到一组
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _monthDataArr.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < _dataArr_1.count; j++) {
            NSString *dateStr = [_dataArr_1[j][@"createTime"]substringToIndex:7];
            if ([_monthDataArr[i] isEqualToString:dateStr]) {
                [arr addObject:_dataArr_1[j]];
            }
        }
        [dataArray addObject:arr];
    }
    _dataArr = [NSMutableArray arrayWithArray:dataArray];
}

@end
