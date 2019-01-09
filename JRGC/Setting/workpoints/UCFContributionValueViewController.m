//
//  UCFContributionValueViewController.m
//  JRGC
//  贡献值
//  Created by 秦 on 16/6/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFContributionValueViewController.h"
#import "UCFSelectedView.h"
#import "MJRefresh.h"
#import "NetworkModule.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"

#import "UCFContributionValueCell.h"//***投资贡献值的cell
#import "UCFContributionValueTypeTowCell.h"//***邀友贡献值Cell
#import "UCFToolsMehod.h"
// 错误界面
#import "UCFNoDataView.h"
@interface UCFContributionValueViewController ()<UITableViewDelegate,UITableViewDataSource,UCFSelectedViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) IBOutlet UITableView *tableView3;

@property (strong, nonatomic) NSMutableArray *dataArr1;
@property (strong, nonatomic) NSMutableArray *dataArr2;
@property (strong, nonatomic) NSMutableArray *dataArr3;

@property (assign, nonatomic) NSInteger pageNum1;
@property (assign, nonatomic) NSInteger pageNum2;
@property (assign, nonatomic) NSInteger pageNum3;

@property (strong, nonatomic) NSMutableArray *selectedStateArray;   // 已选中状态存储数组
@property (assign, nonatomic) NSInteger currentSelectedState;//选择了第几个

// 无数据界面
@property (strong, nonatomic) UCFNoDataView *noDataView1;
@property (strong, nonatomic) UCFNoDataView *noDataView2;
@property (strong, nonatomic) UCFNoDataView *noDataView3;

@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSelectView;   // 选项条


@property (weak, nonatomic) IBOutlet UILabel *lable_totalContributionValue;//***总贡献值显示

@property (weak, nonatomic) IBOutlet UILabel *lable_invotValue;//***投资贡献值显示+数字值

@property (weak, nonatomic) IBOutlet UILabel *lable_investValue;//***邀友贡献值显示+数字值

@property (weak, nonatomic) IBOutlet UIImageView *img_numberlever;//***会员等级图片
@property (weak, nonatomic) IBOutlet UILabel *lable_add;//***加号
@property (weak, nonatomic) IBOutlet UILabel *lable_numbershiptext;//***文字：会员等级

@end

@implementation UCFContributionValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    baseTitleLabel.text = @"我的贡献值";
    self.itemSelectView.sectionTitles = @[@"投资贡献值", @"邀友贡献值"];
    self.itemSelectView.delegate = self;
    [self addLeftButton];
    _selectedStateArray = [[NSMutableArray alloc] init];// 已选中状态存储数组
    _dataArr1 = [NSMutableArray new];
    _dataArr2 = [NSMutableArray new];
    
    _pageNum1 = 1;
    _pageNum2 = 1;
//    _pageNum3 = 1;
    
    [self initTableView];
    _noDataView1 = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-176) errorTitle:@"暂无投资贡献值"];
    _noDataView2 = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-176) errorTitle:@"暂无邀友贡献值"];

    [self didClickSelectedItemWithSeg:0];//***进入本页面后刷新“投资贡献值”


}
- (void)updateViewConstraints{
    _bgViewWidth.constant = 2*ScreenWidth;
    [super updateViewConstraints];
}

- (void)initTableView{
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView1.backgroundColor = UIColorWithRGB(0xebebee);
    _tableView2.backgroundColor = UIColorWithRGB(0xebebee);
//    _tableView3.backgroundColor = UIColorWithRGB(0xebebee);
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    // 添加上拉加载更多
    [_tableView1 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyInvestDataList];
    }];
    
    // 添加上拉加载更多
    [_tableView2 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMyInvestDataList];
    }];
    
    
    [_tableView1 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyInvestDataList)];
    [_tableView2 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyInvestDataList)];
    
    _tableView1.footer.hidden = YES;
    _tableView2.footer.hidden = YES;

}
// 选项的点击事件
- (void)didClickSelectedItemWithSeg:(NSInteger)sender{
    _currentSelectedState = sender;
    switch (sender) {
        case 0: {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0, 0)];
            }];
            
            if (_pageNum1 == 1) {
                if (![_selectedStateArray containsObject:@(sender)]) {
                    [_tableView1.header beginRefreshing];
                    [self.selectedStateArray addObject:@(sender)];
                }
            }
        }
            break;
            
        case 1:
        {
            [UIView animateWithDuration:0.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
            }];
            
            if (_pageNum2 == 1) {
                if (![_selectedStateArray containsObject:@(sender)]) {
                    [_tableView2.header beginRefreshing];
                    [_selectedStateArray addObject:@(sender)];
                }
            }
        }
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DBCellConfig *cellConfig = [self.cellConfigArray objectAtSafeIndex:indexPath.row];
    if (tableView == _tableView1) {
        //        return _dataArr1.count;
        return 96;
    }else if (tableView == _tableView2){
        //        return _dataArr2.count;
        return 77;
    }
    return 0;

    
}

// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return _dataArr1.count;
        
    }else if (tableView == _tableView2){
        return _dataArr2.count;
      
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr;
    UITableViewCell *cell=nil;
    if (tableView == _tableView1) {
        tempArr = _dataArr1;
        UCFContributionValueCell *cellTemp = [UCFContributionValueCell cellWithTableView:tableView];
     
        
        NSDictionary *dictemp = [_dataArr1 objectSafeAtIndex:indexPath.row];
        cellTemp.name_biao.text = [dictemp objectSafeForKey:@"name"];//***标名
        cellTemp.lable_contributValue.text =[dictemp objectSafeForKey:@"contributionValue"];//***贡献值
        cellTemp.lable_stateMoney.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[dictemp objectSafeForKey:@"thePrincipal"]]];//***自有本金
        cellTemp.lable_yearbenfit.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[dictemp objectSafeForKey:@"annualInvestmentQuota"]]];//***年化投资额度
        cellTemp.lable_takebakeDate.text = [NSString stringWithFormat:@"计划回款日期 %@",[dictemp objectSafeForKey:@"collectionDate"]];//***投资日期
        cellTemp.lable_investDate.text = [NSString stringWithFormat:@"投资日期 %@",[dictemp objectSafeForKey:@"dateOfInvestment"]];//***回款日期
             cell = cellTemp;
    }else if (tableView == _tableView2){
        tempArr = _dataArr2;
        UCFContributionValueTypeTowCell *cellTemp = [UCFContributionValueTypeTowCell cellWithTableView:tableView];
        
        NSDictionary *dictemp = [_dataArr2 objectSafeAtIndex:indexPath.row];
        cellTemp.lable_biaoname.text = [dictemp objectSafeForKey:@"name"];//***标名
        cellTemp.lable_contributionValue.text = [dictemp objectSafeForKey:@"contributionValue"];//***贡献值
        cellTemp.lable_investdate.text = [NSString stringWithFormat:@"投资日期 %@",[dictemp objectSafeForKey:@"dateOfInvestment"]];//***回款日期
        cellTemp.lable_takebackdate.text = [NSString stringWithFormat:@"过期时间 %@",[dictemp objectSafeForKey:@"collectionDate"]];//***投资日期

        
        cell = cellTemp;

        
    }
 
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - 请求网络及回调
// 刷新贡献值页面
- (void)getMyInvestDataList{
    NSInteger pageNum = 1;
    switch (_currentSelectedState) {
        case 0:{
            if (_tableView1.header.isRefreshing) {
                _pageNum1 = 1;
            }else if (_tableView1.footer.isRefreshing){
                _pageNum1 ++;
            }
            pageNum = _pageNum1;

        }
            break;
        case 1:{
            if (_tableView2.header.isRefreshing) {
                _pageNum2 = 1;
            }else if (_tableView2.footer.isRefreshing){
                _pageNum2 ++;
            }
            pageNum = _pageNum2;

        }
            break;
    }
    
//    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&type=%lu&page=%lu&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID],(long)_currentSelectedState,(long)pageNum,@"20"];
    
    NSString *typeStr = [NSString stringWithFormat:@"%ld",_currentSelectedState];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",pageNum];
    
    NSDictionary *paramerDict = @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"type":typeStr,@"page":pageStr,@"rows":@"20"};
    [[NetworkModule sharedNetworkModule] newPostReq:paramerDict tag:kSXTagContributionValueInvot owner:self signature:YES Type:SelectAccoutDefault];
    
   
    
}

//开始请求
- (void)beginPost:(kSXTag)tag{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag{
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;

    NSMutableDictionary *dic = [data objectFromJSONString];
    BOOL rstcode = [dic[@"ret"] boolValue];
    NSString *rsttext = dic[@"message"];
  
    
    DDLogDebug(@"UCFContributionValueViewController贡献值列表：%@",dic);
    
    if (tag.intValue == kSXTagContributionValueInvot) {
        if (rstcode) {
            dic = [dic objectSafeDictionaryForKey:@"data"];
            self.lable_invotValue.text = [NSString stringWithFormat:@"投资贡献值%@",[dic objectSafeForKey:@"investmentContribution"]];//***投资贡献值
            self.lable_investValue.text = [NSString stringWithFormat:@"邀友贡献值%@",[dic objectSafeForKey:@"inviteFriendContribution"]];//***邀友贡献值
            self.lable_totalContributionValue.text = [dic objectSafeForKey:@"totalContribution"];//***总贡献值
            NSString *leverStr = dic[@"vipLevel"];//***会员等级
            if ([leverStr intValue] == 1) {
                self.img_numberlever.image =[UIImage imageNamed:@"no_vip_icon.png"];
            }else{
                self.img_numberlever.image =[UIImage imageNamed:[NSString stringWithFormat:@"vip%d_icon.png",[leverStr intValue]-1]];
            }

//            if([self.lable_totalContributionValue.text intValue]!=0)//***当总贡献值为0时，投资贡献值+邀友贡献值都不显示
//            {
            self.lable_investValue.hidden=NO;
            self.lable_invotValue.hidden=NO;
            self.lable_add.hidden=NO;
//            }
            self.lable_numbershiptext.hidden=NO;
            
            
            NSArray *dataArr = dic[@"pageData"][@"result"];
            NSMutableArray *temp1 = [NSMutableArray array];
            NSMutableArray *temp2 = [NSMutableArray array];

            
        
          
            for (NSDictionary *dict in dataArr) {
                switch (_currentSelectedState) {
                    case 0:{
                        [temp1 addObject:dict];
                    }
                        break;
                    case 1:{

                        [temp2 addObject:dict];
                    }
                        break;
                }
            }
            
            switch (_currentSelectedState) {
                case 0:{
                    _tableView1.footer.hidden = NO;
                    if (_pageNum1 == 1) {
                        [_tableView1.header endRefreshing];
//                        [_tableView1.footer endRefreshing];
                        _dataArr1 = [NSMutableArray arrayWithArray:temp1];
                    }else{
                        if (dataArr.count == 0) {
//                            [self.tableView1.footer noticeNoMoreData];
                        }else{
//                            [_tableView1.footer endRefreshing];
                            [_dataArr1 addObjectsFromArray:temp1];
                        }
                    }
                    if(dataArr.count<19)
                    {
                        [self.tableView1.footer noticeNoMoreData];
                    }else
                    {
                        [self.tableView1.footer endRefreshing];
                    }

                    [_tableView1 reloadData];
                }
                    break;
                case 1:{
                    _tableView2.footer.hidden = NO;
                    if (_pageNum2 == 1) {
                        [_tableView2.header endRefreshing];
//                        [_tableView2.footer endRefreshing];
                        _dataArr2 = [NSMutableArray arrayWithArray:temp2];
                    }else{
                        if (dataArr.count == 0) {
//                            [self.tableView2.footer noticeNoMoreData];
                        }else{
//                            [_tableView2.footer endRefreshing];
                            [_dataArr2 addObjectsFromArray:temp2];
                        }
                    }
                    if(dataArr.count<19)
                    {
                      [self.tableView2.footer noticeNoMoreData];
                    }else
                    {
                      [self.tableView2.footer endRefreshing];
                    }
                       

                    [_tableView2 reloadData];
                }
                    break;
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    [self setNoDataView];
//    [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"7"];
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagContributionValueInvot) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self setNoDataView];
}

- (void)setNoDataView{
    switch (_currentSelectedState) {
        case 0:{
            if (_dataArr1.count == 0) {//无数据：显示“暂无数据”、隐藏“已无更多数据”
                [_noDataView1 showInView:_tableView1];
                [_tableView1.footer noticeNoMoreData];
            } else {//有数据：隐藏“暂无数据”
                [_noDataView1 hide];
            }
        }
            break;
        case 1:{
            if (_dataArr2.count == 0) {
                [_noDataView2 showInView:_tableView2];
                [_tableView2.footer noticeNoMoreData];
            } else {
                [_noDataView2 hide];
            }
        }
            break;
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
// 选项的点击事件
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender{
    _currentSelectedState = sender.selectedSegmentIndex;
    [self refreshDataAndClickSelectedItemWithSeg:_currentSelectedState];
}
- (void)refreshDataAndClickSelectedItemWithSeg:(NSInteger)sender{
    
            [self didClickSelectedItemWithSeg:_currentSelectedState];
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"fromeCouponExchange" object:nil];
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
