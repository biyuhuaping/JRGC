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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"天王盖地虎";
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

@end
