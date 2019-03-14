//
//  UCFNewCollectionDetailViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCollectionDetailViewController.h"
#import "UCFBidDetailNavView.h"
#import "UVFBidDetailViewModel.h"
#import "UCFNewBidDetaiInfoView.h"
#import "UCFRemindFlowView.h"
#import "UCFNewInvestBtnView.h"
#import "UCFCollectionSortBaseView.h"
#import "UCFPageControlTool.h"
#import "UCFPageHeadView.h"
#import "UCFCollectionBidListViewController.h"
#import "MjAlertView.h"
@interface UCFNewCollectionDetailViewController ()<UCFBidDetailNavViewDelegate,MjAlertViewDelegate>
{
    NSInteger _currentSelectSortTag;//当前选择排序tag

}
@property(nonatomic, strong)UCFNewBidDetaiInfoView *bidinfoView;
@property(nonatomic, strong)UCFBidDetailNavView *navView;
@property(nonatomic, strong)MyRelativeLayout *contentLayout;
@property(nonatomic, strong)UCFRemindFlowView *remind;
@property(nonatomic, strong)UCFNewInvestBtnView *investView;
@property(nonatomic, strong)UCFCollectionDetailVM   *VM;
@property(nonatomic, strong)UCFPageControlTool *pageController;
@property(nonatomic, strong)UCFPageHeadView    *pageHeadView;
@property(nonatomic, strong)UCFCollectionBidListViewController *canInvestVC;
@property(nonatomic, strong)UCFCollectionBidListViewController *unCanInvestVC;

@property(nonatomic, copy) NSString *currentOrderStr;

@end

@implementation UCFNewCollectionDetailViewController
- (void)loadView
{
    [super loadView];
    
    _currentSelectSortTag = 0;
    self.currentOrderStr = @"00";
    
    UCFBidDetailNavView *navView = [[UCFBidDetailNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight1)];
    self.navView = navView;
    navView.delegate = self;
    [self.rootLayout addSubview:navView];
    
    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.topPos.equalTo(self.navView.bottomPos);
    contentLayout.backgroundColor = [UIColor clearColor];
    contentLayout.myHorzMargin = 0; //同时指定左右边距为0表示宽度和父视图一样宽
    self.contentLayout = contentLayout;
    [self.rootLayout addSubview:self.contentLayout];
    
    UCFNewBidDetaiInfoView *bidinfoView = [[UCFNewBidDetaiInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 155)];
    self.bidinfoView = bidinfoView;
    [self.contentLayout addSubview:bidinfoView];
    
    UCFRemindFlowView *remind = [UCFRemindFlowView new];
    remind.topPos.equalTo(bidinfoView.bottomPos);
    remind.myHorzMargin = 0;
    remind.heightSize.equalTo(@40);
    remind.backgroundColor = [UIColor clearColor];
    remind.subviewVSpace = 5;
    remind.subviewHSpace = 5;
    self.remind = remind;
    [self.contentLayout addSubview:remind];
    
    
    UCFCollectionSortBaseView *sortBaseView =  [UCFCollectionSortBaseView new];
    sortBaseView.topPos.equalTo(self.remind.bottomPos);
    sortBaseView.heightSize.equalTo(@45);
    sortBaseView.leftPos.equalTo(@0);
    sortBaseView.rightPos.equalTo(@0);
    [sortBaseView.sortButton addTarget:self action:@selector(showSortView:) forControlEvents:UIControlEventTouchUpInside];
    contentLayout.heightSize.equalTo(@(155 + 40 + 45));
    [self.contentLayout addSubview:sortBaseView];

    self.pageController.topPos.equalTo(self.contentLayout.bottomPos);
    self.pageController.leftPos.equalTo(@0);
    self.pageController.rightPos.equalTo(@0);
    self.pageController.bottomPos.equalTo(@50);
    [self.rootLayout addSubview:self.pageController];

    
    UCFNewInvestBtnView *investView = [[UCFNewInvestBtnView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 57)];
    investView.myHorzMargin = 0;
    investView.bottomPos.equalTo(@0);
    
    [self.rootLayout addSubview:investView];
    self.investView = investView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)topLeftButtonClick:(UIButton *)button
{
    [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self blindVM];
    [self.navView blindCollectionVM:self.VM];
    
    [self.bidinfoView blindCollectionVM:self.VM];
    
    [self.remind blindCollectionVM:self.VM];
}
- (void)blindVM
{
    self.VM.model = self.model;
}
- (UCFCollectionDetailVM *)VM
{
    if (!_VM) {
        _VM = [UCFCollectionDetailVM new];
    }
    return _VM;
}

- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        NSString *title1 = @"可投项目";
        NSString *title2 = @"已满项目";
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) WithTitleArray:@[title1,title2]];
        [_pageHeadView reloaShowView];
    }
    return _pageHeadView;
}
- (UCFPageControlTool *)pageController
{
    if (nil == _pageController) {
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1 - 155 - 40 - 45 - 50) WithChildControllers:@[self.canInvestVC,self.unCanInvestVC] WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}
- (UCFCollectionBidListViewController *)canInvestVC
{
    if (!_canInvestVC) {
        _canInvestVC = [[UCFCollectionBidListViewController alloc] init];
    }
    _canInvestVC.colPrdClaimId = [NSString stringWithFormat:@"%ld",self.model.data.colPrdClaimId];
    _canInvestVC.prdClaimsOrderStr = self.currentOrderStr;
    _canInvestVC.listType = @"0";
    return _canInvestVC;
}
- (UCFCollectionBidListViewController *)unCanInvestVC
{
    if (!_unCanInvestVC) {
        _unCanInvestVC = [[UCFCollectionBidListViewController alloc] init];
    }
    _unCanInvestVC.colPrdClaimId = [NSString stringWithFormat:@"%ld",self.model.data.colPrdClaimId];
    _unCanInvestVC.prdClaimsOrderStr = self.currentOrderStr;
    _unCanInvestVC.listType = @"1";
    return _unCanInvestVC;
}

#pragma mark 点击排序button响应事件
- (void)showSortView:(UIButton *)button
{
    MjAlertView *sortAlertView = [[MjAlertView alloc]initCollectionViewWithTitle:@"项目排序" sortArray:@[@"综合排序",@"可投额递减",@"可投额递增"]  selectedSortButtonTag:_currentSelectSortTag delegate:self cancelButtonTitle:@"" withOtherButtonTitle:@"确定"];
    [sortAlertView show];
}
-(void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    if (_currentSelectSortTag != index) {
        _currentSelectSortTag = index;
        if (_currentSelectSortTag == 0) {//@"综合排序"
            self.currentOrderStr = @"00";
        } else if (_currentSelectSortTag == 1) {
            self.currentOrderStr = @"31";//@"金额递减"
        } else if (_currentSelectSortTag == 2) {
            self.currentOrderStr = @"32";//@"金额递增"
        }
        [_canInvestVC refreshDataWithOrderStr:self.currentOrderStr andListType:@"0"];
//        [_unCanInvestVC refreshDataWithOrderStr:self.currentOrderStr andListType:@"1"];
    }
}
@end
