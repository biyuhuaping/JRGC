//
//  UCFNewCashParentViewController.m
//  JRGC
//  选择返现券的父控制器
//  Created by zrc on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCashParentViewController.h"
#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
@interface UCFNewCashParentViewController ()
@property(nonatomic, strong)UCFPageControlTool *pageController;
@property(nonatomic, strong)UCFPageHeadView    *pageHeadView;
@property(nonatomic, strong)UCFInvestmentCouponCashTicketController *canUseVC;
@property(nonatomic, strong)UCFInvestmentCouponCashTicketController *unCanUseVC;

@end

@implementation UCFNewCashParentViewController
- (void)loadView
{
    [super loadView];
    [self.rootLayout addSubview:self.pageController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlueLeftButton];
    [self setTitleViewText:@"使用返现券"];
}
#pragma mark ViewInIt 返现券
- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        NSString *title1 = [NSString stringWithFormat:@"可用返现券(%ld)",self.canUseCashArray.count];
        NSString *title2 = [NSString stringWithFormat:@"不可用返现券(%ld)",self.unCanUseCashArray.count];
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) WithTitleArray:@[title1,title2] WithType:1];
    }
    return _pageHeadView;
}
- (UCFPageControlTool *)pageController
{
    if (nil == _pageController) {
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1) WithChildControllers:@[self.canUseVC,self.unCanUseVC] WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}
- (UCFInvestmentCouponCashTicketController *)canUseVC
{
    if (nil == _canUseVC) {
        _canUseVC = [[UCFInvestmentCouponCashTicketController alloc] init];
    }
    _canUseVC.cashArray = _canUseCashArray;
    return _canUseVC;
}
- (UCFInvestmentCouponCashTicketController *)unCanUseVC
{
    if (nil == _unCanUseVC) {
        _unCanUseVC = [[UCFInvestmentCouponCashTicketController alloc] init];
    }
    _unCanUseVC.cashArray = _unCanUseCashArray;
    return _unCanUseVC;
}
#pragma mark ViewInIt 返息券



- (void)backToTheInvestmentPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)confirmTheCouponOfYourChoice
{
    [self.canUseVC couponOfChoice];//返现券
    [self backToTheInvestmentPage];
    
}
@end
