//
//  UCFOverDueListViewController.m
//  JRGC
//
//  Created by NJW on 15/4/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFOverDueListViewController.h"
#import "BeanTableViewCell.h"
#import "UCFFacBeanModel.h"
#import "UCFNoDataView.h"
#import "UCF404ErrorView.h"

@interface UCFOverDueListViewController () <UITableViewDataSource, UITableViewDelegate, FourOFourViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSource;
//
@property (nonatomic, assign) NSUInteger currentPage;
// 404错误界面
@property (nonatomic, strong) UCFNoDataView *noDataView;
@end

@implementation UCFOverDueListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
//        self = [storyboard instantiateViewControllerWithIdentifier:@"overdue"];
        self.currentPage = 1;
    }
    return self;
}
// 懒加载数据源
- (NSMutableArray *)dataSource
{
    if (nil == _dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    
    baseTitleLabel.text = @"已过期工豆";

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableview setBackgroundColor:UIColorWithRGB(0xebebee)];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect frame = self.tableview.bounds;
    frame.size.width = ScreenWidth;
    UCFNoDataView *noDataView = [[UCFNoDataView alloc] initWithFrame:frame errorTitle:@"暂无数据"];
    self.noDataView = noDataView;
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    [self.tableview addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getFirstPageBeanForOverDueFromNet)];
    
    // 添加上拉加载更多
    [self.tableview addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPage ++;
        [weakSelf getBeanNetworkDataWithPageNo:weakSelf.currentPage];
    }];
    
    // 马上进入刷新状态
    [self.tableview.header beginRefreshing];
}

// 404错误界面的代理方法
- (void)refreshBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    [self.tableview.header beginRefreshing];
}

// tableview 的数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeanTableViewCell *cell = [BeanTableViewCell cellWithTableView:tableView];
    UCFFacBeanModel *model = self.dataSource[indexPath.row];
    cell.facBean = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

// 刷新可使用的工豆
- (void)getFirstPageBeanForOverDueFromNet
{
    self.tableview.footer.hidden = YES;
    self.currentPage = 1;
    [self getBeanNetworkDataWithPageNo:1];
}

// 请求过期工豆网络数据
- (void)getBeanNetworkDataWithPageNo:(NSUInteger)currentPageNo
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%lu&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID], (unsigned long)currentPageNo, PAGESIZE];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSxTagGongDouOverDue owner:self Type:SelectAccoutDefault];
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
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    BOOL hasNextPage = [[[dic[@"pageData"] objectForKey:@"pagination"] valueForKey:@"hasNextPage"] boolValue];
    if (tag.intValue == kSxTagGongDouOverDue) {
        NSInteger sign = [rstcode integerValue];
        if (sign == 1) {
            if ([self.tableview.header isRefreshing]) {
                [self.dataSource removeAllObjects];
            }
            NSArray *result = [dic[@"pageData"] objectForKey:@"result"];
            NSMutableArray *tempForUnused = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                UCFFacBeanModel *model = [UCFFacBeanModel facBeanWithDict:dict];
                model.state = UCFMyFacBeanStateOverdue;
                [tempForUnused addObject:model];
            }
            [self.dataSource addObjectsFromArray:tempForUnused];
            if ([self.tableview.header isRefreshing]) {
                if (self.dataSource.count > 0) {
                    [self.noDataView hide];
                    if (!hasNextPage) {
                        [self.tableview.footer noticeNoMoreData];
                    }
                    else
                        [self.tableview.footer resetNoMoreData];
                }
                else {
                    [self.noDataView showInView:self.tableview];
                    [self.tableview.footer noticeNoMoreData];
                }
                
            }
            else if ([self.tableview.footer isRefreshing])
            {
                if (tempForUnused.count==0) {
                    [self.tableview.footer noticeNoMoreData];
                }
            }
        }
        else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        [self.tableview reloadData];
        if ([self.tableview.header isRefreshing]) {
            [self.tableview.header endRefreshing];
            self.tableview.footer.hidden = NO;
        }
        else if ([self.tableview.footer isRefreshing]) {
            [self.tableview.footer endRefreshing];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSxTagGongDouOverDue) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [self.tableview.header endRefreshing];
    self.tableview.footer.hidden = YES;
    [self.tableview.footer endRefreshing];
    if (self.dataSource.count == 0) {
        [self.noDataView showInView:self.tableview];
        [self.tableview.footer noticeNoMoreData];
    }
}
@end
