//
//  UCFCashRecordListViewController.m
//  JRGC
//
//  Created by hanqiyuan on 16/8/30.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFCashRecordListViewController.h"
#import "RechargeListCell.h"
#import "UCFNoDataView.h"
#import "UCFSettingGroup.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "UCFCashRecordCell.h"
@interface UCFCashRecordListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageNum;
    int totalPage;
    UCFNoDataView *_noDataView;
}
@property (nonatomic, strong) IBOutlet UITableView       *cashRecordTable;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) NSMutableArray    *sectionItemArray;
@end

@implementation UCFCashRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.accoutType == SelectAccoutTypeHoner) {
        baseTitleLabel.text = @"尊享提现记录";
    }else{
        baseTitleLabel.text = @"微金提现记录";
    }
    [self addLeftButton];
    self.dataArray = [NSMutableArray array];
    self.sectionItemArray = [NSMutableArray array];
    self.cashRecordTable.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight);
    _cashRecordTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    pageNum = 1;
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    
    [weakSelf.cashRecordTable addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getCashRecordListHttpRequset)];
    
    // 添加上拉加载更多
    [weakSelf.cashRecordTable addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCashRecordListHttpRequset];
    }];
    weakSelf.cashRecordTable.footer.hidden = YES;
    [weakSelf.cashRecordTable.footer setTitle:@"无更多数据了" forState:MJRefreshFooterStateNoMoreData];
    [weakSelf.cashRecordTable.header beginRefreshing];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _noDataView = [[UCFNoDataView alloc] initWithFrame:self.cashRecordTable.bounds errorTitle:@"暂无数据"];
}
- (void)getCashRecordListHttpRequset
{
    if (self.cashRecordTable.header.isRefreshing) {
        pageNum = 1;
    }
    NSString *pageStr = [NSString stringWithFormat:@"%d",pageNum];
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:@"20",@"pageSize",SingleUserInfo.loginData.userInfo.userId,@"userId",pageStr, @"page",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagCashRecordList owner:self signature:YES Type:self.accoutType];
}
-(void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.cashRecordTable.header endRefreshing];
    [self.cashRecordTable.footer endRefreshing];
    NSDictionary *dataDic = [(NSString *)result objectFromJSONString];
    NSDictionary *dic =[dataDic objectSafeDictionaryForKey:@"data"];
    NSDictionary *pageDataDic = [dic objectSafeDictionaryForKey:@"pageData"];
    if ([dataDic[@"ret"] integerValue] == 1) {
        totalPage = [[pageDataDic[@"pagination"] objectForKey:@"totalPage"] intValue];
        _cashRecordTable.footer.hidden = NO;
        if(pageNum == 1)
        {
            [self.dataArray removeAllObjects];
            [self.sectionItemArray removeAllObjects];
        }
        if(pageNum <= totalPage)
        {
            pageNum++;
        }
        else
        {
            [_cashRecordTable.footer noticeNoMoreData];
        }
        NSArray *tmpDataArr = [pageDataDic objectSafeArrayForKey:@"result"];
        if (tmpDataArr.count > 0) {
            [self.dataArray addObjectsFromArray:tmpDataArr];
        }
        if (self.dataArray.count >0) {
            [self updateSectionItemArray:self.dataArray];
            
        }
        if (self.dataArray.count == 0) {
            [_noDataView showInView:_cashRecordTable];
        }
        [_cashRecordTable reloadData];
    } else {
        [MBProgressHUD displayHudError:dic[@"messages"]];
    }
    
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.cashRecordTable.header endRefreshing];
    [self.cashRecordTable.footer endRefreshing];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionItemArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFSettingGroup *group = self.sectionItemArray[section];
    return group.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFSettingGroup *group = self.sectionItemArray[indexPath.section];
    NSDictionary *dataDict = [group.items objectAtIndex:indexPath.row];
    NSString *withdrawModeStr = [dataDict objectSafeForKey:@"withdrawMode"];
    if ([withdrawModeStr isEqualToString:@""]) {
        return 129-27;
    }else{
        return 129;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 1.创建头部控件
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = UIColorWithRGB(0xebebee) ;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = UIColorWithRGB(0xf9f9f9);
    UILabel *headTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 100, 15)];
    headTitleLab.font = [UIFont systemFontOfSize:13];
    headTitleLab.textColor = UIColorWithRGB(0x333333);
    [view addSubview:headTitleLab];
    [headerView addSubview:view];
    
    if (section == 0) {
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 30);
        
    }else{
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
        view.frame = CGRectMake(0, 10, ScreenWidth, 30);
    }
    UCFSettingGroup *group = self.sectionItemArray[section];
    headTitleLab.text = [[group.headTitle stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"UCFCashRecordCell";
    UCFCashRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFCashRecordCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UCFSettingGroup *group = self.sectionItemArray[indexPath.section];
    cell.dataDict = [group.items objectAtIndex:indexPath.row];
    return cell;
}
//更新分组
-(void)updateSectionItemArray:(NSMutableArray *)array{
    if (array.count  == 0) {
        return;
    }
    [self.sectionItemArray removeAllObjects];
     NSDictionary * dataDic = [array firstObject];
     UCFSettingGroup *group = [[UCFSettingGroup alloc]init];
     group.headTitle = [[dataDic objectSafeForKey:@"happenTime"] substringToIndex:7];
     group.items = [NSMutableArray new];
     [group.items addObject:dataDic];
     for (int i = 1 ;i< array.count;i++) {
         NSDictionary * data = [array objectAtIndex:i];
         NSString * yearMonthStr = [[data objectSafeForKey:@"happenTime"] substringToIndex:7];
         if ([group.headTitle isEqualToString:yearMonthStr]) {
             [group.items addObject:data];
         }else{
             [self.sectionItemArray addObject:group];
             group = [[UCFSettingGroup alloc]init];
             group.headTitle = yearMonthStr;
             group.items = [NSMutableArray new];
             [group.items addObject:data];
         }
     }
     [self.sectionItemArray addObject:group];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
