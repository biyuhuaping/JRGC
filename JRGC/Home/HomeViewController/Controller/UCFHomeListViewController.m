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
#import "UCFNewUserCell.h"
#import "UCFHomeListHeaderSectionView.h"
#import "UCFLoginViewController.h"
#import "UCFRegisterStepOneViewController.h"
#import "AppDelegate.h"
#import "UCFHomeListFooterView.h"

@interface UCFHomeListViewController () <UITableViewDelegate, UITableViewDataSource, HomeListViewPresenterCallBack, UCFHomeListHeaderSectionViewDelegate, UCFHomeListCellDelegate, UCFHomeInvestCellDelegate, UCFGoldFlexibleCellDelegate, UCFNewUserCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UCFHomeListPresenter *presenter;
@property (weak, nonatomic) UCFHomeListFooterView *footerView;
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
        
        UCFHomeListFooterView *footerView = (UCFHomeListFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListFooterView" owner:self options:nil] lastObject];
        footerView.homeListTipLabel.text  = [UserInfoSingle sharedManager].isSubmitTime ? @"市场有风险  购买需谨慎":@"市场有风险  出借需谨慎";
        self.tableView.tableFooterView = footerView;
        self.tableView.tableFooterView.clipsToBounds = YES;
        self.footerView = footerView;
        
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
    if (cellPresenter.modelType == UCFHomeListCellModelTypeDefault) { //普通类型
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
    else if (cellPresenter.modelType == UCFHomeListCellModelTypeDebtsTransfer) { //债转
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
    else if (cellPresenter.modelType == UCFHomeListCellModelTypeNewUser) { //新手标类型
        static NSString *cellId = @"newusercell";
        UCFNewUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFNewUserCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFNewUserCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.tableview = tableView;
        }
        cell.presenter = cellPresenter;
        cell.indexPath = indexPath;
        return cell;
    }
    else if (cellPresenter.modelType == UCFHomeListCellModelTypeReserved || cellPresenter.modelType == UCFHomeListCellModelTypeAI|| cellPresenter.modelType == UCFHomeListCellModelTypeBatch) { //预约宝
        static NSString *cellId = @"homeListInvestCell";
        UCFHomeInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFHomeInvestCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeInvestCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.tableview = tableView;
        }
        cell.presenter = cellPresenter;
        cell.indexPath = indexPath;
        return cell;
    }
    else if (cellPresenter.modelType == UCFHomeListCellModelTypeGoldFixed) { //黄金定期
        static NSString *cellId = @"goldflexible";
        UCFGoldFlexibleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldFlexibleCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldFlexibleCell" owner:self options:nil] lastObject];
        }
        cell.presenter = cellPresenter;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!kIS_IOS8) {
        UCFHomeListHeaderSectionView *view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
        view.frame = CGRectMake(0, 0, ScreenWidth, 39);
        view.section = section;
        view.delegate = self;
        UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
        UCFHomeListGroup *group = groupPresenter.group;
        if (!group.prdlist) {
            return nil;
        }
        view.presenter = groupPresenter;
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
        baseView.backgroundColor = [UIColor clearColor];
        [baseView addSubview:view];
        return baseView;
    } else {
        static NSString* viewId = @"homeListHeader";
        UCFHomeListHeaderSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
        if (nil == view) {
            view = (UCFHomeListHeaderSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeListHeaderSectionView" owner:self options:nil] lastObject];
        }
        view.frame = CGRectMake(0, 0, ScreenWidth, 39);
        view.section = section;
        view.delegate = self;
        UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
        UCFHomeListGroup *group = groupPresenter.group;
        if (group.attach.count  == 0 && [group.type intValue] == 0)
        {
             return nil;
        }else{
            if ([group.type intValue] >  0 && group.prdlist.count == 0) {
                return nil;
            }
        }
        view.presenter = groupPresenter;
        return view;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString* viewId = @"homeListFooter";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
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
    
    if ([group.type intValue] == 0)//新手专区
    {
        if (group.attach.count > 0) {
            return 140;
        }else{
            return 0.01f;
        }
    }else if (group.prdlist.count == 0)
    {
        return 0.01f;
    }else {
        return 39;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:section];
    UCFHomeListGroup *group = groupPresenter.group;
    if ([group.type intValue] == 0)//新手专区
    {
        if (group.attach.count > 0) {
            return 8;
        }else{
            return 0.01f;
        }
    }else if (group.prdlist.count == 0)
    {
        return 0.01f;
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
    if ([UserInfoSingle sharedManager].isSubmitTime) {
        UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectSafeAtIndex:indexPath.section];
        UCFHomeListCellPresenter *presenter = [groupPresenter.group.prdlist objectSafeAtIndex:indexPath.row];
//        NSString *userId = [UserInfoSingle sharedManager].userId;
        if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedWithModel:withType:)]) {
            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:presenter.item withType:UCFHomeListTypeDetail];
        }
    } else {
        UCFHomeListGroupPresenter *groupPresenter = [self.presenter.allDatas objectAtIndex:indexPath.section];
        UCFHomeListCellPresenter *presenter = [groupPresenter.group.prdlist objectAtIndex:indexPath.row];
        NSString *userId = [UserInfoSingle sharedManager].userId;
        if (nil == userId) {
            UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
            UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
            return;
        }
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
    if([self.delegate respondsToSelector:@selector(homeList:withType:)])
    {
        if ([type isEqualToString:@"1"]) {
            [self.delegate homeList:self  withType:UCFHomeListTypeIntelligentLoan];
        }
        else if ([type isEqualToString:@"2"])
        {
                [self.delegate homeList:self  withType:UCFHomeListTypeQualityClaims];
        }
    }
    
    
    
//    if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedWithModel:withType:)]) {
//        if ([type isEqualToString:@"18"] || [type isEqualToString:@"11"]) {
//            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:nil withType:UCFHomeListTypeP2PMore];
//        }
//        else if ([type isEqualToString:@"12"]) {
//            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:nil withType:UCFHomeListTypeZXMore];
//        }
//        else if ([type isEqualToString:@"15"]) {
//            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:nil withType:UCFHomeListTypeGlodMore];
//        }
//        else if ([type isEqualToString:@"19"]) {
//            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:nil withType:UCFHomeListTypeDebtsMore];
//        }
//        else if ([type isEqualToString:@"16"]) {
//            NSString *userId = [UserInfoSingle sharedManager].userId;
//            if (nil == userId) {
//                UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
//                UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];
//                return;
//            }
//            else {
//                UCFHomeListGroupPresenter *groupP = [self.presenter.allDatas objectAtIndex:homeListHeader.section];
//                UCFHomeListCellPresenter *cellP = [groupP.group.prdlist firstObject];
//                [self.delegate homeList:self tableView:self.tableView didClickedWithModel:cellP.item withType:UCFHomeListTypeDetail];
//            }
//        }
//    }
}

#pragma mark - 工厂邀请cell的代理方法
- (void)homeInvestCell:(UCFHomeInvestCell *)homeInvestCell didClickedInvestButtonAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.presenter.canReservedClicked) {
//        return;
//    }
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

- (void)newUserCell:(UCFNewUserCell *)newUserCell didClickedRegisterButton:(UIButton *)button withModel:(UCFHomeListCellModel *)model
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (nil == userId) {
        UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
        registerControler.sourceVC = @"fromHomeView";
        UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:registerControler] ;
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UINavigationController *nav = app.tabBarController.selectedViewController ;
        [nav presentViewController:loginNaviController animated:YES completion:nil];
        return;
    }
    else {
        if ([self.delegate respondsToSelector:@selector(homeList:tableView:didClickedWithModel:withType:)]) {
            [self.delegate homeList:self tableView:self.tableView didClickedWithModel:model withType:UCFHomeListTypeInvest];
        }
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
