//
//  UCFHomeListViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListViewController.h"

#import "UCFHomeListPresenter.h"
#import "UCFHomeListGroupPresenter.h"
#import "MJRefresh.h"

#import "UCFHomeListCell.h"
#import "UCFHomeListNo2Cell.h"
#import "UCFHomeInvestCell.h"
#import "UCFGoldFlexibleCell.h"
#import "UCFHomeListHeaderSectionView.h"
#import "UCFLoginViewController.h"
#import "AppDelegate.h"

@interface UCFHomeListViewController () <UITableViewDelegate, UITableViewDataSource, HomeListViewPresenterCallBack, UCFHomeListHeaderSectionViewDelegate, UCFHomeListCellDelegate, UCFHomeInvestCellDelegate, UCFGoldFlexibleCellDelegate>
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
        self.tableView.showsVerticalScrollIndicator = NO;
        
        self.presenter = presenter;
        self.presenter.view = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        self.tableView.tableFooterView = footerView;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 20)];
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.text = @"市场有风险  投资需谨慎";
        tipLabel.textColor = UIColorWithRGB(0x999999);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:tipLabel];
        
        [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    }
    return self;
}

#pragma mark - tableDataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.presenter.allDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
    UCFHomeListGroup *group = groupPresenter.group;
    return group.prdlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
    UCFHomeListCellPresenter *cellPresenter = [groupPresenter.group.prdlist objectAtIndex:indexPath.row];
    if (cellPresenter.modelType == UCFHomeListCellModelTypeDefault) {
        static NSString *cellId = @"homeListCell";
        UCFHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFHomeListCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListCell" owner:self options:nil] lastObject];
        }
        cell.tableView = tableView;
        cell.delegate = self;
        cell.presenter = cellPresenter;
        cell.indexPath = indexPath;
        return cell;
    }
    else if (cellPresenter.modelType == UCFHomeListCellModelTypeOneImageTransfer || cellPresenter.modelType == UCFHomeListCellModelTypeOneImageBatchCycle || cellPresenter.modelType == UCFHomeListCellModelTypeOneImageBatchLending) {
        static NSString *cellId = @"homeListCell2";
        UCFHomeListNo2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFHomeListNo2Cell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListNo2Cell" owner:self options:nil] lastObject];
        }
        cell.presenter = cellPresenter;
        return cell;
    }
    else if (cellPresenter.modelType == UCFHomeListCellModelTypeReserved) {
        static NSString *cellId = @"homeListInvestCell";
        UCFHomeInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFHomeInvestCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeInvestCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        cell.indexPath = indexPath;
        cell.presenter = cellPresenter;
        return cell;
    }
    else if (cellPresenter.modelType == UCFHomeListCellModelTypeGoldFixed) {
        static NSString *cellId = @"goldflexible";
        UCFGoldFlexibleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldFlexibleCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldFlexibleCell" owner:self options:nil] lastObject];
        }
        cell.indexPath = indexPath;
        cell.presenter = cellPresenter;
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* viewId = @"homeListHeader";
    UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
    }
    view.delegate = self;
    view.frame = CGRectMake(0, 0, ScreenWidth, 30);
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
    UCFHomeListGroup *group = groupPresenter.group;
    if (!group.prdlist) {
        return nil;
    }
    view.presenter = groupPresenter;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString* viewId = @"homeListFooter";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    }
    view.contentView.backgroundColor = UIColorWithRGB(0xebebee);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
    UCFHomeListCellPresenter *presenter = [groupPresenter.group.prdlist objectAtIndex:indexPath.row];
    return presenter.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
    UCFHomeListGroup *group = groupPresenter.group;
    if (!group.prdlist) {
        return 0.001;
    }
    else if ([group.type isEqualToString:@""]) {
        return 100;
    }
    else
        return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
    UCFHomeListGroup *group = groupPresenter.group;
    if (!group.prdlist) {
        return 0.001;
    }
    else {
        if (section == 5) {
            return 0.001;
        }
        return 8;
    }
}

#pragma mark - tableView delegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(homeList:tableView:didScrollWithYOffSet:)]) {
        [self.delegate homeList:self tableView:self.tableView didScrollWithYOffSet:scrollView.contentOffset.y];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.presenter.canReservedClicked) {
        return;
    }
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
    UCFHomeListCellPresenter *presenter = [groupPresenter.group.prdlist objectAtIndex:indexPath.row];
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (nil == userId && presenter.item.moedelType != UCFHomeListCellModelTypeOneImageTransfer) {
        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
        return;
    }
    if ([presenter.type intValue] == 6) {
        if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedGoldIncreaseWithModel:)]) {
            [self.delegate homeList:self tableView:self.tableView didClickedGoldIncreaseWithModel:presenter.item];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedWithModel:withType:)]) {
            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:presenter.item withType:UCFHomeListTypeDetail];
        }
    }
}

#pragma mark - presenter的代理方法
- (void)homeListViewPresenter:(UCFHomeListPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error
{
    [self.tableView.header endRefreshing];
    
    if (!error) {
        [self.tableView reloadData];
        //        [self.tableView.footer resetNoMoreData];
    } else if (self.presenter.allDatas.count == 0) {
        //        show error view
    }
}

#pragma mark - cell的代理方法
- (void)homelistCell:(UCFHomeListCell *)homelistCell didClickedProgressViewWithPresenter:(UCFHomeListCellModel *)model
{
    if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedWithModel:withType:)]) {
        [self.delegate homeList:self tableView:self.tableView didClickedWithModel:model withType:UCFHomeListTypeInvest];
    }
}

#pragma mark - UCFHomeListHeaderSectionView的代理方法
- (void)homeListHeader:(UCFHomeListHeaderSectionView *)homeListHeader didClickedMoreWithType:(NSString *)type
{
    if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedWithModel:withType:)]) {
        if ([type isEqualToString:@"11"]) {
            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:nil withType:UCFHomeListTypeP2PMore];
        }
        else if ([type isEqualToString:@"12"]) {
            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:nil withType:UCFHomeListTypeZXMore];
        }
        else if ([type isEqualToString:@"15"]) {
            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:nil withType:UCFHomeListTypeGlodMore];
        }
    }
}

#pragma mark - 工厂邀请cell的代理方法
- (void)homeInvestCell:(UCFHomeInvestCell *)homeInvestCell didClickedInvestButtonAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.presenter.canReservedClicked) {
        return;
    }
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (nil == userId) {
        UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
        return;
    }
    
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
    UCFHomeListCellPresenter *cellPresenter =  [groupPresenter.group.prdlist objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(homeList:didClickReservedWithModel:)]) {
        [self.delegate homeList:self didClickReservedWithModel:cellPresenter.item];
    }
}

#pragma mark -  黄金活期购买
- (void)homelistCell:(UCFGoldFlexibleCell *)homelistCell didClickedBuyButtonWithModel:(UCFHomeListCellModel *)model
{
    if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedBuyGoldWithModel:)]) {
        [self.delegate homeList:self tableView:self.tableView didClickedBuyGoldWithModel:model];
    }
}

#pragma mark - 刷新数据
- (void)refreshData
{
    if ([self.delegate respondsToSelector:@selector(homeListRefreshDataWithHomelist:)]) {
        [self.delegate homeListRefreshDataWithHomelist:self];
    }
}

@end
