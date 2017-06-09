//
//  UCFInvestTransferViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvestTransferViewController.h"
#import "UCFTransferHeaderView.h"
#import "UCFTransfeTableViewCell.h"
#import "UCFTransferModel.h"
@interface UCFInvestTransferViewController () <UITableViewDelegate, UITableViewDataSource, UCFTransferHeaderViewDelegate,UCFTransfeTableViewCellDelegate>
{
    NSInteger currentPage;
}
@property (strong, nonatomic) UCFTransferHeaderView *transferHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray    *dataArray;
@property (copy, nonatomic) NSString *sortType;
@end

@implementation UCFInvestTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
}

#pragma mark - 设置界面
- (void)createUI {
    UCFTransferHeaderView *transferHeaderView = (UCFTransferHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFTransferHeaderView" owner:self options:nil] lastObject];
    transferHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 230);
    self.tableview.tableHeaderView = transferHeaderView;
    transferHeaderView.delegate = self;
    self.transferHeaderView = transferHeaderView;
    
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    __weak typeof(self) weakSelf = self;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadNetData];
    }];

    [self.tableview setSeparatorColor:[UIColor clearColor]];
}
- (void)initData
{
    self.sortType = @"12";
    currentPage = 1;
    self.dataArray = [NSMutableArray array];
}
#pragma mark - tableview 数据源
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeListCell";
    UCFTransfeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFTransfeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFTransfeTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
//判断从哪个过来的model
- (void)transferCellDidSelectModel:(UCFTransferModel *)model
{
    
}
#pragma mark - tableview 代理

#pragma mark - header 代理
- (void)transferHeaderView:(UCFTransferHeaderView *)transferHeader didClickOrderButton:(UIButton *)orderBtn andIsIncrease:(BOOL)isUp
{
    switch (orderBtn.tag - 100) {
            // 利率 YES 升序 NO 降序
        case 0: {
            if (isUp) {
                DBLOG(@"利率  升序");
                self.sortType = @"12";
            }
            else {
                DBLOG(@"利率  降序");
                self.sortType = @"11";
            }
        }
            break;
            // 期限 YES 升序 NO 降序
        case 1: {
            if (isUp) {
                DBLOG(@"期限  升序");
                self.sortType = @"22";
            }
            else {
                DBLOG(@"期限  降序");
                self.sortType = @"21";
            }
        }
            break;
            // 金额 NO 升序 YES 降序
        case 2: {
            if (isUp) {
                DBLOG(@"金额  降序");
                self.sortType = @"31";
            }
            else {
                DBLOG(@"金额  升序");
                self.sortType = @"32";
            }
        }
            break;
    }
    [self refreshData];
}

#pragma mark NetWorkDelegate
- (void)refreshData
{
    currentPage = 1;
    [self loadNetData];
}
- (void)loadNetData
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSMutableDictionary *strParameters = [NSMutableDictionary dictionary];
    if (!uuid) {
        [strParameters setValue:@"" forKey:@"userId"];
    }
    else {
        [strParameters setValue:uuid forKey:@"userId"];
    }
    [strParameters setValue:self.sortType forKey:@"sortType"];
    [strParameters setValue:@"20" forKey:@"rows"];
    [strParameters setValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"page"];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagPrdTransferList owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagPrdTransferList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                NSString *oepnState =  [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"openStatus"];
                NSString *enjoyOpenStatus =  [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"enjoyOpenStatus"];
                [UserInfoSingle sharedManager].openStatus = [oepnState integerValue];
                [UserInfoSingle sharedManager].enjoyOpenStatus = [enjoyOpenStatus integerValue];
            }
            if (currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in list_result) {
                UCFTransferModel *model = [UCFTransferModel transferWithDict:dict];
                [self.dataArray addObject:model];
            }
            
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            
            if (self.dataArray.count > 0) {
                self.tableview.footer.hidden = NO;
                if (!hasNext) {
                    [self.tableview.footer noticeNoMoreData];
                } else {
                    currentPage++;
                }
            }
            else {
            }

            [self.tableview reloadData];
        }
    
    }
    if ([self.tableview.header isRefreshing]) {
        [self.tableview.header endRefreshing];
    }
    if ([self.tableview.footer isRefreshing]) {
        [self.tableview.footer endRefreshing];
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}
@end
