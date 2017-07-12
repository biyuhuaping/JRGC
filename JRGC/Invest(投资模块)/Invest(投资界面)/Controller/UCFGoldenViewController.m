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

@interface UCFGoldenViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UCFGoldenHeaderView *goldenHeader;
@property (strong, nonatomic) NSMutableArray *dataArray;
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
}

#pragma mark - tableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    }
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
    if (self.dataArray.count>0) {
        return 32;
    }
    else
        return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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

@end
