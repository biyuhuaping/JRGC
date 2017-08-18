//
//  UCFGoldRaiseViewController.m
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRaiseViewController.h"
#import "UCFGoldRaiseView.h"
#import "UCFGoldRaiseSectionHeaderView.h"
#import "UCFGoldRaiseTransDetailController.h"
#import "UCFGoldIncreaseAccountInfoModel.h"

@interface UCFGoldRaiseViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UCFGoldRaiseView *raiseHeaderView;
@end

@implementation UCFGoldRaiseViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat height = [UCFGoldRaiseView viewHeight];
    self.raiseHeaderView.frame = CGRectMake(0, 0, ScreenWidth, height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self createUI];
    [self getGoldIncreaseAccount];
}

- (void)createUI {
    UCFGoldRaiseView *view = (UCFGoldRaiseView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRaiseView" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = view;
    self.raiseHeaderView = view;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 88, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:@"交易详情" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clickRightBtn {
    UCFGoldRaiseTransDetailController *transDetail = [[UCFGoldRaiseTransDetailController alloc] initWithNibName:@"UCFGoldRaiseTransDetailController" bundle:nil];
    transDetail.baseTitleText = @"交易详情";
    [self.navigationController pushViewController:transDetail animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerId = @"goldraisesectionheader";
    UCFGoldRaiseSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (nil == header) {
        header = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRaiseSectionHeaderView" owner:self options:nil] lastObject];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)getGoldIncreaseAccount {
    NSString *userId = [UserInfoSingle sharedManager].userId;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", @"20", @"pageSize", @"1", @"pageNo", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldIncrease owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.integerValue == kSXTagGoldIncrease) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            UCFGoldIncreaseAccountInfoModel *goldAccount = [[UCFGoldIncreaseAccountInfoModel alloc] init];
            goldAccount.allGiveMoney = [dict objectSafeForKey:@"allGiveMoney"];
            goldAccount.dealPrice = [dict objectSafeForKey:@"dealPrice"];
            goldAccount.floatingPL = [dict objectSafeForKey:@"floatingPL"];
            goldAccount.goldAmount = [dict objectSafeForKey:@"goldAmount"];
//            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
//            if ([self.tableview.header isRefreshing]) {
//                [self.dataArray removeAllObjects];
//            }
//            for (NSDictionary *temp in resut) {
//                UCFGoldRechargeHistoryModel *goldhistory = [UCFGoldRechargeHistoryModel goldRechargeHistoryModelWithDict:temp];
//                [self.dataArray addObject:goldhistory];
//            }
//            BOOL hasNextPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
//            if (hasNextPage) {
//                self.currentPage ++;
//                self.tableview.footer.hidden = YES;
//                [self.tableview.footer resetNoMoreData];
//                self.dataArray = [self arrayGroupWithArray:self.dataArray];
//            }
//            else {
//                if (self.dataArray.count > 0) {
//                    [self.tableview.footer noticeNoMoreData];
//                }
//                else
//                    self.tableview.footer.hidden = YES;
//                self.dataArray = [self arrayGroupWithArray:self.dataArray];
//            }
//            if (!self.dataArray.count) {
//                [self.noDataView showInView:self.tableview];
//            }
//            else {
//                [self.noDataView hide];
//            }
            [self.tableview reloadData];
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
        }
        if ([self.tableview.header isRefreshing]) {
            [self.tableview.header endRefreshing];
        }
        if ([self.tableview.footer isRefreshing]) {
            [self.tableview.footer endRefreshing];
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}

@end
