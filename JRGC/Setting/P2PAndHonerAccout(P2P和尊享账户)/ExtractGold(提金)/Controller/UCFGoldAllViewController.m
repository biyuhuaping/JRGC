//
//  UCFGoldAllViewController.m
//  JRGC
//
//  Created by njw on 2017/11/8.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFGoldAllViewController.h"
#import "UCFNoDataView.h"

@interface UCFGoldAllViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UCFNoDataView *noDataView;
@end

@implementation UCFGoldAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) errorTitle:@"敬请期待..."];
    self.noDataView = noDataView;
    
    self.currentPage = 1;
    
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getExtractGoldListAllFromNet)];
    // 添加上拉加载更多
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf getExtractGoldListAllFromNet];
    }];
    
    self.tableview.footer.hidden = YES;
    [self.tableview.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)getExtractGoldListAllFromNet
{
    NSString *pageNo = [NSString stringWithFormat:@"%ld", (long)self.currentPage];
    NSString *userId = [UserInfoSingle sharedManager].userId;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId, @"userId", pageNo, @"pageNo", @"1", @"status", @"20", @"pageSize", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagExtractGoldList owner:self signature:YES Type:SelectAccoutTypeGold];
}

- (void)beginPost:(kSXTag)tag
{
    UCFBaseViewController *vc = self.rootVc;
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    UCFBaseViewController *vc = self.rootVc;
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
    if (tag.integerValue == kSXTagExtractGoldList) {
        
    }
    [self.tableview.header endRefreshing];
    [self.tableview.footer endRefreshing];
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    UCFBaseViewController *vc = self.rootVc;
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
    [self.tableview.header endRefreshing];
    [self.tableview.footer endRefreshing];
}

@end
