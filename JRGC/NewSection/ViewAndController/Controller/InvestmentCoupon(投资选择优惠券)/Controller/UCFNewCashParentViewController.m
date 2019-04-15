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
    [self addRightButtonWithImage:[UIImage imageNamed:@"icon_question.png"]];

}
- (void)leftBar1Clicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ViewInIt 返现券
- (void)addRightButtonWithImage:(UIImage *)rightButtonimage;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 25, 25);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setImage:rightButtonimage forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)clickRightBtn
{
    NSString *isP2PTipStr =  self.accoutType == SelectAccoutTypeP2P  ? @"出借":@"投资";
    NSString *messageStr = [NSString stringWithFormat:@"1.返现券和返息券可在一笔%@中共用\n2.返现券可叠加使用\n3.返息券只能使用一张,不可叠加",isP2PTipStr];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr  delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}

- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        NSString *title1 = [NSString stringWithFormat:@"可用返现券(%ld)",self.canUseCashArray.count];
        NSString *title2 = [NSString stringWithFormat:@"不可用返现券(%ld)",self.unCanUseCashArray.count];
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) WithTitleArray:@[title1,title2]];
        [_pageHeadView reloaShowView];
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
