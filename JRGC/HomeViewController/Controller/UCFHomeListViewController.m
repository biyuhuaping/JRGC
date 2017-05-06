//
//  UCFHomeListViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListViewController.h"

#import "UCFHomeListPresenter.h"
#import "UCFHomeListHeaderSectionView.h"

#import "UCFHomeListCell.h"

@interface UCFHomeListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UCFHomeListPresenter *presenter;
@end

@implementation UCFHomeListViewController
+ (instancetype)instanceWithPresenter:(UCFHomeListPresenter *)presenter {
    return [[UCFHomeListViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFHomeListPresenter *)presenter {
    if (self = [super init]) {
        
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.backgroundColor = UIColorWithRGB(0xebebee);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        self.presenter = presenter;
//        self.presenter.view = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.tableView.tableFooterView = footerView;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 20)];
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.text = @"市场有风险  投资需谨慎";
        tipLabel.textColor = UIColorWithRGB(0x999999);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:tipLabel];
    }
    return self;
}

#pragma mark - tableDataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 3;
    }
    else {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeListCell";
    
    UCFHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFHomeListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListCell" owner:self options:nil] lastObject];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UCFHomeListHeaderSectionView *view = [[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
    view.frame = CGRectMake(0, 0, ScreenWidth, 30);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0.001;
    }
    return 10;
}

#pragma mark - tableView delegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(homeList:tableView:didScrollWithYOffSet:)]) {
        [self.delegate homeList:self tableView:self.tableView didScrollWithYOffSet:scrollView.contentOffset.y];
    }
}

#pragma mark - 提示标签

@end
