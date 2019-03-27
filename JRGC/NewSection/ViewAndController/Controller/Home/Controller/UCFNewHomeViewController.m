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
#import "BaseTableViewCell.h"
#import "UCFHomeViewModel.h"
#import "UCFBidDetailRequest.h"
#import "UCFBidDetailAndInvestPageLogic.h"
#import "UCFNewNoticeViewController.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFHighQualityContainerViewController.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
@interface UCFNewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,YTKRequestDelegate,HomeHeadCycleViewDelegate,BaseTableViewCellDelegate>
@property(nonatomic, strong)HomeHeadCycleView *homeHeadView;
@property(nonatomic, strong)UCFHomeViewModel  *homeListViewModel;
//@property(nonatomic, strong)UCFBannerViewModel*bannerViewModel;

@property(nonatomic, strong)BaseTableView     *showTableView;
@property(nonatomic, strong)NSMutableArray    *dataArray;
@end

@implementation UCFNewHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.showTableView reloadData];
}

- (void)loadView
{
    [super loadView];
    
    [self addLeftButtonTitle:@"首页"];
    [self addRightbuttonImageName:@"home_icon_news"];
    
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
    self.showTableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.showTableView.tableHeaderView = self.homeHeadView;
    
    HomeFootView *homefootView = [HomeFootView new];
    homefootView.myHeight = 181;
    homefootView.myHorzMargin = 0;
    [homefootView createSubviews];
    self.showTableView.tableFooterView = homefootView;

}
- (void)rightBarClicked:(UIButton *)button
{
    
    UCFNewNoticeViewController *vc = [[UCFNewNoticeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self blindVM];
    [self fetchData];
    [self blindUserStatue];
}
- (void)blindUserStatue
{
    @PGWeakObj(self);
    [self.KVOController observe:[UserInfoSingle sharedManager] keyPaths:@[@"loginData"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"loginData"]) {
           UCFLoginData *oldUserData = [change objectSafeForKey:NSKeyValueChangeOldKey];
           UCFLoginData *newUserData = [change objectSafeForKey:NSKeyValueChangeNewKey];
            //登录或者注册
            if (!oldUserData.userInfo && newUserData.userInfo) {
                [selfWeak fetchData];
                return ;
            }
            //退出登录，或者切换账户
            if (oldUserData.userInfo && !newUserData.userInfo) {
                [selfWeak fetchData];
                return ;
            }
            //用户在登录的情况下，更改用户状态的时候，请求数据
            if (oldUserData.userInfo.isRisk != newUserData.userInfo.isRisk || [oldUserData.userInfo.openStatus intValue] != [newUserData.userInfo.openStatus intValue]) {
                [selfWeak fetchData];
            }
        }
    }];
    
//    @PGWeakObj(self);

    
}
- (void)blindVM
{
    self.homeListViewModel = [UCFHomeViewModel new];
    self.homeListViewModel.loaingSuperView = self.view;
    [self.homeHeadView showView:self.homeListViewModel];
    self.homeListViewModel.rootViewController = self;
    [self showView:_homeListViewModel];
}
- (void)showView:(UCFHomeViewModel *)viewModel
{
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"modelListArray",] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"modelListArray"]) {
            NSArray *modelListArray = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (modelListArray.count > 0) {
                [selfWeak.showTableView endRefresh];
                selfWeak.dataArray = [NSMutableArray arrayWithArray:modelListArray];
                [selfWeak.showTableView reloadData];
            }
        }
    }];
}
- (void)fetchData
{
    [self.homeListViewModel fetchNetData];
}
#pragma BaseTableViewDelegate
- (void)refreshTableViewHeader
{
    [self fetchData];
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
    NSArray *sectionArr = self.dataArray[section];
    CellConfig *data = sectionArr[0];
    if (data.title.length > 0) {
        return 54;
    } else {
        return 0.001;

    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArr = self.dataArray[section];
    CellConfig *data = sectionArr[0];
    if (data.title.length > 0) {
        UCFNewHomeSectionView *sectionView = [[UCFNewHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
        NSArray *sectionArr = self.dataArray[section];
        CellConfig *data = sectionArr[0];
        if (data) {
            sectionView.titleLab.text = data.title;
        }
        return sectionView;
    } else {
        return nil;
    }

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
    BaseTableViewCell *cell = (BaseTableViewCell *)[config cellOfCellConfigWithTableView:tableView dataModel:config.dataModel];
    cell.bc = self;
    cell.deleage = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.dataArray[indexPath.section];
    CellConfig *config = sectionArr[indexPath.row];
    if (config.dataModel) {
        [UCFBidDetailAndInvestPageLogic bidDetailAndInvestPageLogicUseDataModel:config.dataModel detail:YES rootViewController:self];
    }
}
#pragma mark BaseTableViewCellDelegate
- (void)baseTableViewCell:(BaseTableViewCell *)cell buttonClick:(UIButton *)button withModel:(id)model
{
    if (model) {
        [UCFBidDetailAndInvestPageLogic bidDetailAndInvestPageLogicUseDataModel:model detail:NO rootViewController:self];
    }
}
- (void)homeViewDataBidClickModel:(UCFNewHomeListModel *)model type:(UCFNewHomeListType)type
{
    
}
#pragma mark HomeHeadCycleViewDelegate
- (void)homeHeadCycleView:(HomeHeadCycleView *)cycleView didSelectIndex:(NSInteger)index
{
    
}
- (void)userGuideCellClickButton:(UIButton *)button
{
    if (SingleUserInfo.loginData.userInfo.userId.length > 0) {
        UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        webView.rootVc = self;
        webView.baseTitleType = @"lunbotuhtml";
        webView.url = @"https://www.9888keji.com/static/wap/invest/index.html#/new-guide/guide";
        webView.navTitle = @"新手入门引导";
        [self.rt_navigationController pushViewController:webView animated:YES];
    } else {
        [SingleUserInfo loadLoginViewController];
    }
    
    NSString *title = [button titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"注册领券"]) {
        
    } else if ([title isEqualToString:@"存管开户"]) {
        
    } else if ([title isEqualToString:@"风险评测"]) {
        
    } else if ([title isEqualToString:@"新人专享"]) {
        
    } else {
        
    }
    

}


@end
