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
@interface UCFNewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property(nonatomic, strong)HomeHeadCycleView *homeHeadView;
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
    self.homeHeadView = homeHeadView;

    self.showTableView.myVertMargin = 0;
    self.showTableView.myHorzMargin = 0;
    [self.rootLayout addSubview:self.showTableView];
    self.showTableView.backgroundColor = [UIColor clearColor];
    self.showTableView.tableHeaderView = self.homeHeadView;

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
}
- (void)fetchData
{
    self.dataArray = [NSMutableArray arrayWithCapacity:10];
    CellConfig *data1 = [CellConfig cellConfigWithClassName:@"UCFNewUserGuideTableViewCell" title:@"新手入门" showInfoMethod:nil heightOfCell:185];
    NSMutableArray *section1 = [NSMutableArray arrayWithCapacity:1];
    [section1 addObject:data1];
    [self.dataArray addObject:section1];

    
    CellConfig *data2_0 = [CellConfig cellConfigWithClassName:@"UCFNewUserBidCell" title:@"新手专享" showInfoMethod:nil heightOfCell:150];
    CellConfig *data2_1 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"新手专享" showInfoMethod:@selector(reflectDataModel:) heightOfCell:((Screen_Width - 30) * 6 /23 + 15)];
    NSMutableArray *section2 = [NSMutableArray arrayWithCapacity:1];
    [section2 addObject:data2_0];
    [section2 addObject:data2_1];
    [self.dataArray addObject:section2];
    
//    CellConfig *data3_0 = [CellConfig cellConfigWithClassName:@"UCFPromotionCell" title:@"商城特惠" showInfoMethod:@selector(reflectDataModel:) heightOfCell:(Screen_Width - 30) * 6 /23];
//    NSMutableArray *section3 = [NSMutableArray arrayWithCapacity:1];
//    [section3 addObject:data3_0];
//    [self.dataArray addObject:section3];

    
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
    if (self.dataArray.count - 1 == section) {
        return 50;
    }
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
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}
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
    return [config cellOfCellConfigWithTableView:tableView dataModel:config];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
