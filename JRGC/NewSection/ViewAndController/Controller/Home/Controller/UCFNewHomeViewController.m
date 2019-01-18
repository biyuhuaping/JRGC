//
//  UCFNewHomeViewController.m
//  JRGC
//
//  Created by zrc on 2019/1/10.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewHomeViewController.h"
#import "HomeHeadCycleView.h"
#import "UCFNewHomeSectionView.h"
#import "CellConfig.h"
#import "HomeFootView.h"
#import "UCFHomeListRequest.h"
#import "UCFBannerViewModel.h"
#import "BaseTableViewCell.h"
#import "UCFOldUserNoticeCell.h"
@interface UCFNewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,YTKRequestDelegate,HomeHeadCycleViewDelegate>
@property(nonatomic, strong)HomeHeadCycleView *homeHeadView;
@property(nonatomic, strong)UCFBannerViewModel*bannerViewModel;

@property(nonatomic, strong)BaseTableView     *showTableView;
@property(nonatomic, strong)NSMutableArray    *dataArray;
@end

@implementation UCFNewHomeViewController
- (void)loadView
{
    [super loadView];

    HomeHeadCycleView *homeHeadView = [HomeHeadCycleView new];
    homeHeadView.myTop = 0;
    homeHeadView.myHeight = ((([[UIScreen mainScreen] bounds].size.width - 54) * 9)/16);
    homeHeadView.myHorzMargin = 0;
    [homeHeadView createSubviews];
    homeHeadView.delegate = self;
    self.homeHeadView = homeHeadView;
    
    
    
    self.showTableView.myVertMargin = 0;
    self.showTableView.myHorzMargin = 0;
    [self.rootLayout addSubview:self.showTableView];
    self.showTableView.backgroundColor = [UIColor clearColor];
    self.showTableView.tableHeaderView = self.homeHeadView;
    
    HomeFootView *homefootView = [HomeFootView new];
    homefootView.myHeight = 181;
    homefootView.myHorzMargin = 0;
    [homefootView createSubviews];
    self.showTableView.tableFooterView = homefootView;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    [self blindVM];
    UCFHomeListRequest *request = [[UCFHomeListRequest alloc] init];
    request.delegate = self;
    [request start];
    
}
- (void)blindVM
{
    self.bannerViewModel = [UCFBannerViewModel new];
    self.bannerViewModel.rootViewController = self;
    [self.homeHeadView showView:_bannerViewModel];
    [self.bannerViewModel fetchNetData];
}
- (void)requestFinished:(YTKBaseRequest *)request {
    NSLog(@"succeed");
}

- (void)requestFailed:(YTKBaseRequest *)request {
    NSLog(@"failed");
}
- (void)fetchData
{
    self.dataArray = [NSMutableArray arrayWithCapacity:10];
    CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFOldUserNoticeCell" title:@"新手入门" showInfoMethod:nil heightOfCell:140];
    NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
    [section1 addObject:data1];
    [self.dataArray addObject:section1];
    
    if ([UserInfoSingle sharedManager].openStatus == 4 && [UserInfoSingle sharedManager].isRisk) {
       
    } else {
//        CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFNewUserGuideTableViewCell" title:@"新手入门" showInfoMethod:nil heightOfCell:185];
//        NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
//        [section1 addObject:data1];
//        [self.dataArray addObject:section1];
    }
    


    
    CellConfig *data2_0 = [CellConfig cellConfigWithClassName:@"UCFNewUserBidCell" title:@"新手专享" showInfoMethod:nil heightOfCell:150];
    CellConfig *data2_1 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"新手专享" showInfoMethod:@selector(reflectDataModel:) heightOfCell:((Screen_Width - 30) * 6 /23 + 15)];
    NSMutableArray *section2 = [NSMutableArray arrayWithCapacity:1];
    [section2 addObject:data2_0];
    [section2 addObject:data2_1];
    [self.dataArray addObject:section2];
    
    CellConfig *data3_0 = [CellConfig cellConfigWithClassName:@"UCFShopPromotionCell" title:@"商城特惠" showInfoMethod:nil heightOfCell:(Screen_Width - 30) * 6 /23 + 160];
    NSMutableArray *section3 = [NSMutableArray arrayWithCapacity:1];
    [section3 addObject:data3_0];
    [self.dataArray addObject:section3];

    CellConfig *data4_0 = [CellConfig cellConfigWithClassName:@"UCFBoutiqueCell" title:@"商城精选" showInfoMethod:nil heightOfCell:150];
    NSMutableArray *section4 = [NSMutableArray arrayWithCapacity:1];
    [section4 addObject:data4_0];
    [self.dataArray addObject:section4];
    
    CellConfig *data5_0 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"推荐内容" showInfoMethod:@selector(reflectDataModel:) heightOfCell:((Screen_Width - 30) * 6 /23)];
    NSMutableArray *section5 = [NSMutableArray arrayWithCapacity:1];
    [section5 addObject:data5_0];
    [self.dataArray addObject:section5];
    
    [self.showTableView reloadData];
}
#pragma BaseTableViewDelegate
- (void)refreshTableViewHeader
{
    [_showTableView endRefresh];
}

- (BaseTableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.tableRefreshDelegate = self;
        _showTableView.enableRefreshFooter = NO;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _showTableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UCFNewHomeSectionView *sectionView = [[UCFNewHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
    NSArray *sectionArr = self.dataArray[section];
    CellConfig *data = sectionArr[0];
    if (data) {
        sectionView.titleLab.text = data.title;
    }
    return sectionView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArr = self.dataArray[section];
    return sectionArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.dataArray[indexPath.section];
    CellConfig *data = sectionArr[indexPath.row];
    return data.heightOfCell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.dataArray[indexPath.section];
    CellConfig *config = sectionArr[indexPath.row];
    BaseTableViewCell *cell = (BaseTableViewCell *)[config cellOfCellConfigWithTableView:tableView dataModel:config];
    cell.bc = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark HomeHeadCycleViewDelegate
- (void)homeHeadCycleView:(HomeHeadCycleView *)cycleView didSelectIndex:(NSInteger)index
{
    
}
- (void)userGuideCellClickButton:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"注册领券"]) {
        
    } else if ([title isEqualToString:@"存管开户"]) {
        
    } else if ([title isEqualToString:@"风险评测"]) {
        
    } else if ([title isEqualToString:@"新人专享"]) {
        
    } else {
        
    }
}
@end
