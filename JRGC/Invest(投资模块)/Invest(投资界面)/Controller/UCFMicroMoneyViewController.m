//
//  UCFMicroMoneyViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMicroMoneyViewController.h"
#import "UCFMicroMoneyHeaderView.h"

#import "UCFHomeListHeaderSectionView.h"
#import "UCFHomeListCell.h"

@interface UCFMicroMoneyViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UCFMicroMoneyHeaderView *microMoneyHeaderView;
@end

@implementation UCFMicroMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - 设置界面
- (void)createUI {
    UCFMicroMoneyHeaderView *microMoneyHeaderView = (UCFMicroMoneyHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFMicroMoneyHeaderView" owner:self options:nil] lastObject];
    microMoneyHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 120);
    self.tableview.tableHeaderView = microMoneyHeaderView;
    self.microMoneyHeaderView = microMoneyHeaderView;
    
}

#pragma mark - tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0.001;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* viewId = @"homeListHeader";
    UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
    }
    [view.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
    [view.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
    [view.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    view.frame = CGRectMake(0, 0, ScreenWidth, 30);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeListCell";
    UCFHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFHomeListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListCell" owner:self options:nil] lastObject];
        cell.tableView = tableView;
    }
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark - tableview 代理

@end
