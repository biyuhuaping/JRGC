//
//  UCFHighQualityContainerViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHighQualityContainerViewController.h"
#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
#import "UCFHighQualityViewController.h"
#import "UCFTransBidListViewController.h"
@interface UCFHighQualityContainerViewController ()
@property(nonatomic, strong)UCFPageControlTool *pageController;
@property(nonatomic, strong)UCFPageHeadView    *pageHeadView;
@property(nonatomic, strong)UCFHighQualityViewController *hightQualityController;
@property(nonatomic, strong)UCFTransBidListViewController *transBidListController;

@end

@implementation UCFHighQualityContainerViewController
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
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight1) WithTitleArray:@[@"优质债权",@"债权转让"]];
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
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) WithChildControllers:@[self.hightQualityController,self.transBidListController] WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}
- (UCFHighQualityViewController *)hightQualityController
{
    if (!_hightQualityController) {
        _hightQualityController = [[UCFHighQualityViewController alloc] init];
    }
    _hightQualityController.accoutType = self.accoutType;
    return _hightQualityController;
}
- (UCFTransBidListViewController *)transBidListController
{
    if (!_transBidListController) {
        _transBidListController = [[UCFTransBidListViewController alloc] init];
    }
    _transBidListController.accoutType = self.accoutType;
    return _transBidListController;
}
@end
