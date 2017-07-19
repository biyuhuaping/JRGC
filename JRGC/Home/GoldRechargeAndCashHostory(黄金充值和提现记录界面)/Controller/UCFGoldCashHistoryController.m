//
//  UCFGoldCashHistoryController.m
//  JRGC
//
//  Created by njw on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashHistoryController.h"
#import "UCFGoldReCashHisCell.h"

@interface UCFGoldCashHistoryController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic) NSUInteger currentPage;
@end

@implementation UCFGoldCashHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    self.currentPage = 1;
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataFromNet)];
    __weak typeof(self) weakSelf = self;
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataFromNet];
    }];
    self.tableview.footer.hidden = YES;
    [self.tableview.header beginRefreshing];
}

#pragma mark - tableview 的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldRechargeAndCash";
    UCFGoldReCashHisCell *hisCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == hisCell) {
        hisCell = (UCFGoldReCashHisCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldReCashHisCell" owner:self options:nil] lastObject];
        hisCell.tableview = tableView;
    }
    hisCell.indexPath = indexPath;
    return hisCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)getDataFromNet
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    if (!userId) {
        return;
    }
    if ([self.tableview.header isRefreshing]) {
        self.currentPage = 1;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentPage], @"pageNo", @"20", @"pageSize", userId, @"userId", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldCashHistory owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    
}

-(void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}

@end
