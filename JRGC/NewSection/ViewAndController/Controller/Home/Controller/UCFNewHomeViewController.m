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
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFInvitationRebateViewController.h"
#import "UCFMineIntoCoinPageApi.h"
#import "UCFMineIntoCoinPageModel.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "NSString+Misc.h"
@interface UCFNewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,YTKRequestDelegate,HomeHeadCycleViewDelegate,BaseTableViewCellDelegate,UCFNewHomeSectionViewDelegate>
@property(nonatomic, strong)HomeHeadCycleView *homeHeadView;
@property(nonatomic, strong)UCFHomeViewModel  *homeListViewModel;
//@property(nonatomic, strong)UCFBannerViewModel*bannerViewModel;

@property(nonatomic, strong)BaseTableView     *showTableView;
@property(nonatomic, strong)NSMutableArray    *dataArray;

/**
 商城推荐查看更多URL
 */
@property(nonatomic, copy)NSString      *remcommendUrl;

/**
 商城精选查看更多URL
 */
@property(nonatomic, copy)NSString      *boutiqueUrl;
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
- (void)monitorUserLogin
{
    [self fetchData];
}
- (void)monitorUserGetOut
{
    [self fetchData];
}
- (void)monitorOpenStatueChange
{
    [self fetchData];
}
- (void)monitorRiskStatueChange
{
    [self fetchData];
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
    [self.KVOController observe:viewModel keyPaths:@[@"modelListArray",@"remcommendUrl",@"boutiqueUrl"] options:NSKeyValueObservingOptionNew  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"modelListArray"]) {
            NSArray *modelListArray = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (modelListArray.count > 0) {
                [selfWeak.showTableView endRefresh];
                selfWeak.dataArray = [NSMutableArray arrayWithArray:modelListArray];
                [selfWeak.showTableView reloadData];
            }
        }   else if ([keyPath isEqualToString:@"remcommendUrl"]) {
            NSString *remcommendUrl = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            selfWeak.remcommendUrl = remcommendUrl;
        } else if ([keyPath isEqualToString:@"boutiqueUrl"]) {
            NSString *boutiqueUrl = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            selfWeak.boutiqueUrl = boutiqueUrl;
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
        sectionView.section = section;
        sectionView.delegate = self;
        NSArray *sectionArr = self.dataArray[section];
        CellConfig *data = sectionArr[0];
        if (data) {
            sectionView.titleLab.text = data.title;
        }
        if ([data.title isEqualToString:@"商城精选"] || [data.title isEqualToString:@"商城特惠"]) {
            [sectionView showMore];
        }
        return sectionView;
    } else {
        return nil;
    }

}

- (void)showMoreViewSection:(NSInteger)section andTitle:(NSString *)title
{
    if ([title isEqualToString:@"商城精选"]) {
        [self pushWebViewWithUrl:self.boutiqueUrl Title:@"商城精选"];
    } else if([title isEqualToString:@"商城特惠"]){
        [self pushWebViewWithUrl:self.remcommendUrl Title:@"商城特惠"];
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
    if ([model isKindOfClass:[UCFNewHomeListPrdlist class]]) {
        [UCFBidDetailAndInvestPageLogic bidDetailAndInvestPageLogicUseDataModel:model detail:NO rootViewController:self];
    } else if ([model isKindOfClass:[NSString class]]) {
        NSString *userId = SingleUserInfo.loginData.userInfo.userId;
        if(nil == userId) {
            [SingleUserInfo loadLoginViewController];
        } else {
            NSString *title = model;

            if ([title isEqualToString:@"豆哥商城"]) {
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                NSURLCache * cache = [NSURLCache sharedURLCache];
                [cache removeAllCachedResponses];
                [cache setDiskCapacity:0];
                [cache setMemoryCapacity:0];
                
                UCFWebViewJavascriptBridgeMall *mallController = [[UCFWebViewJavascriptBridgeMall alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
                mallController.url      = @"https://m.dougemall.com";//请求地址;
                mallController.navTitle = @"商城";
                mallController.isFromBarMall = NO;
                [self.navigationController pushViewController:mallController animated:YES];
            } else if ([title isEqualToString:@"领券中心"]) {
                UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
                web.url = COUPON_CENTER;
                web.isHidenNavigationbar = YES;
                [self.navigationController pushViewController:web animated:YES];
            } else if ([title isEqualToString:@"邀请返利"]) {
                UCFInvitationRebateViewController *feedBackVC = [[UCFInvitationRebateViewController alloc] initWithNibName:@"UCFInvitationRebateViewController" bundle:nil];
                feedBackVC.title = @"邀请获利";
                feedBackVC.accoutType = SelectAccoutTypeP2P;
                [self.navigationController pushViewController:feedBackVC animated:YES];
            } else if ([title isEqualToString:@"工力工贝"]) {
                if(SingleUserInfo.loginData.userInfo.isCompanyAgent)//如果是机构用户
                {//吐司：此活动暂时未对企业用户开放
                    ShowMessage(@"此活动暂时未对企业用户开放");
                } else {
                    UCFMineIntoCoinPageApi * request = [[UCFMineIntoCoinPageApi alloc] initWithPageType:@""];
                    
                    //    request.animatingView = self.view;
                    //    request.tag =tag;
                    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        // 你可以直接在这里使用 self
                        UCFMineIntoCoinPageModel *model = [request.responseJSONModel copy];
                        //        DDLogDebug(@"---------%@",model);
                        if (model.ret == YES) {
                            
                            //            NSDictionary *coinRequestDicData = [dataDict objectSafeDictionaryForKey:@"coinRequest"];
                            UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
                            //            NSDictionary *paramDict = [coinRequestDicData objectSafeDictionaryForKey:@"param"];
                            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
                            [data setValue:[NSString urlEncodeStr:model.data.coinRequest.param.encryptParam ] forKey:@"encryptParam"];
                            [data setObject:[NSString stringWithFormat:@"%zd",model.data.coinRequest.param.fromApp] forKey:@"fromApp"];
                            [data setObject:model.data.coinRequest.param.userId forKey:@"userId"];
                            NSString * requestStr = [Common getParameterByDictionary:data];
                            web.url  = [NSString stringWithFormat:@"%@/#/?%@",model.data.coinRequest.urlPath,requestStr];
                            web.isHidenNavigationbar = YES;
                            [self.navigationController pushViewController:web animated:YES];
                        }
                        else{
                            ShowMessage(model.message);
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        // 你可以直接在这里使用 self
                        
                    }];
                }
            }
        }
    } else if ([model isKindOfClass:[UCFHomeMallrecommends class]]) {
        UCFHomeMallrecommends *mallModel = model;
        [self pushWebViewWithUrl:mallModel.bizUrl Title:mallModel.title];
    } else if ([model isKindOfClass:[UCFhomeMallbannerlist class]]) {
         UCFhomeMallbannerlist *mallModel = model;
        [self pushWebViewWithUrl:mallModel.url Title:mallModel.title];
    } else if ([model isKindOfClass:[UCFHomeMallsale class]]) {
        UCFHomeMallsale *mallModel = model;
        [self pushWebViewWithUrl:mallModel.bizUrl Title:mallModel.title];
    }
}
- (void)pushWebViewWithUrl:(NSString *)url Title:(NSString *)title
{
    UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
    web.url = [NSString stringWithFormat:@"%@?closeView=true",url];
    web.title = title;
    web.isHidenNavigationbar = YES;
    [self.navigationController pushViewController:web animated:YES];
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
