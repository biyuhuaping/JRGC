//
//  UCFGoldenViewController.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldenViewController.h"
#import "UCFGoldenHeaderView.h"
#import "UCFHomeListCell.h"
#import "UCFHomeListHeaderSectionView.h"
#import "UCFGoldModel.h"

@interface UCFGoldenViewController () <UITableViewDelegate, UITableViewDataSource, UCFHomeListCellHonorDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UCFGoldenHeaderView *goldenHeader;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSUInteger currentPage;
@end

@implementation UCFGoldenViewController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [self.tableview.header beginRefreshing];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.goldenHeader.frame = CGRectMake(0, 0, ScreenWidth, 236);
}

#pragma mark - 初始化UI
- (void)createUI {
    CGFloat height = [UCFGoldenHeaderView viewHeight];
    UCFGoldenHeaderView *goldenHeader = (UCFGoldenHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldenHeaderView" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = goldenHeader;
    self.goldenHeader = goldenHeader;
    
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    __weak typeof(self) weakSelf = self;
    self.tableview.footer.hidden = YES;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadNetData];
    }];
}

#pragma mark - tableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeListCell";
    UCFHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFHomeListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListCell" owner:self options:nil] lastObject];
        cell.honorDelegate = self;
    }
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    cell.goldModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count>0) {
        return 32;
    }
    else
        return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.dataArray.count > 0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count > 0) {
        static NSString* viewId = @"homeListHeader";
        UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
        if (nil == view) {
            view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
        }
        view.headerTitleLabel.text = @"优享金";
        view.headerImageView.image = [UIImage imageNamed:@"mine_icon_gold"];
        view.honerLabel.text = @"实物黄金赚收益";
        view.honerLabel.hidden = NO;
        [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
        [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
        [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
        view.frame = CGRectMake(0, 0, ScreenWidth, 30);
        return view;
    }
    return nil;
}

- (void)homelistCell:(UCFHomeListCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)refreshData {
    self.currentPage = 1;
    [self getGoldProFromNetWithPage:[NSString stringWithFormat:@"%lu", self.currentPage]];
}

- (void)loadNetData {
    [self getGoldProFromNetWithPage:[NSString stringWithFormat:@"%lu", self.currentPage]];
}

- (void)getGoldProFromNetWithPage:(NSString *)page
{
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"20", @"pageSize", page, @"pageNo", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldList owner:self signature:NO Type:SelectAccoutDefault];
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
    if (tag.integerValue == kSXTagGoldList) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *pageData = [dict objectSafeDictionaryForKey:@"pageData"];
            BOOL hasNextPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            if (hasNextPage) {
                self.currentPage ++;
                self.tableview.footer.hidden = YES;
                [self.tableview.footer resetNoMoreData];
            }
            else {
                if (self.dataArray.count > 0) {
                    [self.tableview.footer noticeNoMoreData];
                }
                else
                    self.tableview.footer.hidden = YES;
            }
            NSArray *resut = [pageData objectSafeArrayForKey:@"result"];
            if ([self.tableview.header isRefreshing]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *temp in resut) {
                UCFGoldModel *gold = [UCFGoldModel goldModelWithDict:temp];
                [self.dataArray addObject:gold];
            }
            [self.tableview reloadData];
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
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
