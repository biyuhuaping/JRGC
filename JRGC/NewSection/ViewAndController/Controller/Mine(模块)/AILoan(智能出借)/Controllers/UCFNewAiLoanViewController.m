//
//  UCFNewAiLoanViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewAiLoanViewController.h"
#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
#import "UCFNewBatchBidListViewController.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
@interface UCFNewAiLoanViewController ()
@property(nonatomic, strong)UCFPageControlTool *pageController;
@property(nonatomic, strong)UCFPageHeadView    *pageHeadView;
@property(nonatomic, strong)UCFNewBatchBidListViewController    *batchBidListController;
@property(nonatomic, strong)UCFWebViewJavascriptBridgeBanner               *aiBidistController;
@property(nonatomic, strong)UCFWebViewJavascriptBridgeBanner               *reservationBidistController;
@end

@implementation UCFNewAiLoanViewController
- (void)loadView
{
    [super loadView];
    [self.rootLayout addSubview:self.pageController];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark ViewInIt 返现券


- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight1) WithTitleArray:@[@"批量出借",@"智存宝",@"预约宝"]];
        _pageHeadView.leftSpace = 50;
        _pageHeadView.rightSpace = 50;
        _pageHeadView.leftBackImage = @"icon_back";
        [_pageHeadView reloaShowView];
        [_pageHeadView.leftBarBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageHeadView;
}
- (void)leftBtnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UCFPageControlTool *)pageController
{
    if (nil == _pageController) {
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) WithChildControllers:@[self.batchBidListController,self.aiBidistController,self.reservationBidistController] WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}
- (UCFNewBatchBidListViewController *)batchBidListController
{
    if (!_batchBidListController) {
        _batchBidListController = [[UCFNewBatchBidListViewController alloc] init];
    }
    return _batchBidListController;
}
- (UCFWebViewJavascriptBridgeBanner *)aiBidistController
{
    if (!_aiBidistController) {

        _aiBidistController =[[UCFWebViewJavascriptBridgeBanner alloc] initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        _aiBidistController.isHideNativeNav = YES;
    }
    return _aiBidistController;
}
- (UCFWebViewJavascriptBridgeBanner *)reservationBidistController
{
    if (!_reservationBidistController) {
        _reservationBidistController =[[UCFWebViewJavascriptBridgeBanner alloc] initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        _reservationBidistController.isHideNativeNav = YES;
    }
    return _reservationBidistController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
