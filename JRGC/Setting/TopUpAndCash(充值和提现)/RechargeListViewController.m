//
//  RechargeListViewController.m
//  JRGC
//
//  Created by 金融工场 on 15/5/20.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "RechargeListViewController.h"
#import "RechargeListCell.h"
#import "UCFNoDataView.h"
#import "UCFSettingGroup.h"
#import "Common.h"
#import "UCFNewRechargeListCell.h"

@interface RechargeListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageNum;
    int totalPage;
    UCFNoDataView *_noDataView;
}
@property (nonatomic, strong) UITableView       *rechargeTable;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) NSMutableArray    *sectionItemArray;
@end

@implementation RechargeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.accoutType == SelectAccoutTypeHoner) {
          baseTitleLabel.text = @"尊享充值记录";
    }else{
          baseTitleLabel.text = @"微金充值记录";
    }
    [self addLeftButton];
    self.dataArray = [NSMutableArray array];
    self.sectionItemArray = [NSMutableArray array];
    _rechargeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight) style:UITableViewStyleGrouped];
    _rechargeTable.delegate = self;
    _rechargeTable.dataSource = self;
    _rechargeTable.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];;
    _rechargeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rechargeTable];
    pageNum = 1;
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新

    [_rechargeTable addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewData)];

    // 添加上拉加载更多
    [_rechargeTable addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    _rechargeTable.footer.hidden = YES;
    [_rechargeTable.footer setTitle:@"无更多数据了" forState:MJRefreshFooterStateNoMoreData];
    [_rechargeTable.header beginRefreshing];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.baseTitleType = @"充值记录";
    _noDataView = [[UCFNoDataView alloc] initWithFrame:_rechargeTable.bounds errorTitle:@"暂无数据"];

    self.view.backgroundColor = UIColorWithRGBA(235, 235, 238, 1);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xe2e2e2);
    [self.view addSubview:lineView];
}
- (void)getNewData
{
    pageNum = 1;
    [self getNetData];
}
- (void)loadMoreData
{
    [self getNetData];
}
- (void)getNetData
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%d&&rows=10",SingleUserInfo.loginData.userInfo.userId,pageNum];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:ksxTagPayRecord owner:self Type:self.accoutType];
}
-(void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_rechargeTable.header endRefreshing];
    [_rechargeTable.footer endRefreshing];
    NSString *Data = (NSString *)result;
    NSDictionary * dic = [Data objectFromJSONString];
    if ([dic[@"status"] integerValue] == 1) {
        totalPage = [[[dic[@"pageData"] objectForKey:@"pagination"] objectForKey:@"totalPage"] intValue];
         _rechargeTable.footer.hidden = NO;
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
            [_rechargeTable.footer noticeNoMoreData];
        }
        NSArray *tmpDataArr = [dic[@"pageData"] objectForKey:@"result"];
        if (tmpDataArr.count > 0) {
            [self.dataArray addObjectsFromArray:tmpDataArr];
        }
        if (self.dataArray.count >0) {
            [self updateSectionItemArray:self.dataArray];

        }
        if (self.dataArray.count == 0) {
            [_noDataView showInView:_rechargeTable];
        }
        [_rechargeTable reloadData];
    } else {
        [MBProgressHUD displayHudError:dic[@"statusdes"]];
    }

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
    return 142.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 33;
//    }
//    return 43;
    return 33;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 1.创建头部控件
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 33)];
    headerView.backgroundColor = UIColorWithRGB(0xf5f5f5) ;
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
//    view.backgroundColor = UIColorWithRGB(0xf9f9f9);
    UILabel *headTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 33-15,ScreenWidth -30, 15)];
    headTitleLab.font = [UIFont systemFontOfSize:14];
    headTitleLab.textColor = UIColorWithRGB(0xB1B5C2);
    
//    [view addSubview:headTitleLab];
//    [headerView addSubview:view];
    
    [headerView addSubview:headTitleLab];
//    if (section == 0) {
//        headerView.frame = CGRectMake(0, 0, ScreenWidth, 30);
//    }else{
//        headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
//        view.frame = CGRectMake(0, 10, ScreenWidth, 30);
//    }
    UCFSettingGroup *group = self.sectionItemArray[section];
    headTitleLab.text = [[group.headTitle stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
//    [headTitleLab sizeToFit];
//    [self textAlignmentBottom:headTitleLab];
    return headerView;
}
- (void)textAlignmentBottom:(UILabel *)label {
    label.numberOfLines = 0;
    CGSize fontSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    double finalWidth = label.frame.size.width;
    CGSize maximumSize = CGSizeMake(finalWidth, CGFLOAT_MAX);
    CGRect stringSize = [label.text boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil];
    int lines = (label.frame.size.height - stringSize.size.height) / fontSize.height;
    for (int i = 0; i < lines; i++) {
        label.text = [NSString stringWithFormat:@" \n%@",label.text];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"UCFNewRechargeListCell";
//    RechargeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
//    if (cell == nil) {
//        cell = [[RechargeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    UCFSettingGroup *group = self.sectionItemArray[indexPath.section];
//    cell.dataDict = [group.items objectAtIndex:indexPath.row];
    
    UCFNewRechargeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        //        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFNewCashRecordCell" owner:nil options:nil]firstObject];
        cell = [[UCFNewRechargeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UCFSettingGroup *group = self.sectionItemArray[indexPath.section];
    [cell showInfo:[group.items objectAtIndex:indexPath.row]];
    return cell;
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
//更新分组
-(void)updateSectionItemArray:(NSMutableArray *)array{
    if (array.count  == 0) {
        return;
    }
    [self.sectionItemArray removeAllObjects];
    NSDictionary * dataDic = [array firstObject];
    UCFSettingGroup *group = [[UCFSettingGroup alloc]init];
    group.headTitle = [dataDic[@"createTime"] substringToIndex:7];
    group.items = [NSMutableArray new];
    [group.items addObject:dataDic];
    for (int i = 1 ;i< array.count;i++) {
         NSDictionary * data = [array objectAtIndex:i];
         NSString * yearMonthStr = [data[@"createTime"] substringToIndex:7];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
