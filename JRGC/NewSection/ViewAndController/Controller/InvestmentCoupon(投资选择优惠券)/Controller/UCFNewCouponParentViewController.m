//
//  UCFNewCouponParentViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCouponParentViewController.h"
#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
#import "UCFInvestmentCouponInterestTicketController.h"
@interface UCFNewCouponParentViewController ()
@property(nonatomic, strong)UCFPageControlTool *pageController;
@property(nonatomic, strong)UCFPageHeadView    *pageHeadView;
@property(nonatomic, strong)UCFInvestmentCouponInterestTicketController *canUseVC;
@property(nonatomic, strong)UCFInvestmentCouponInterestTicketController *unCanUseVC;
@end

@implementation UCFNewCouponParentViewController
- (void)loadView
{
    [super loadView];
    [self.rootLayout addSubview:self.pageController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [Color color:PGColorOptionThemeWhite];
    [self addBlueLeftButton];
    [self setTitleViewText:@"使用返息券"];
    [self addRightButtonWithImage:[UIImage imageNamed:@"icon_question"]];

}
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
- (void)leftBar1Clicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ViewInIt 返息券
- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        NSString *title1 = [NSString stringWithFormat:@"可用返息券(%ld)",self.canUseCouponArray.count];
        NSString *title2 = [NSString stringWithFormat:@"不可用返息券(%ld)",self.unCanUseCouponArray.count];
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
- (UCFInvestmentCouponInterestTicketController *)canUseVC
{
    if (nil == _canUseVC) {
        _canUseVC = [[UCFInvestmentCouponInterestTicketController alloc] init];
    }
    _canUseVC.couponArray = _canUseCouponArray;
    return _canUseVC;
}
- (UCFInvestmentCouponInterestTicketController *)unCanUseVC
{
    if (nil == _unCanUseVC) {
        _unCanUseVC = [[UCFInvestmentCouponInterestTicketController alloc] init];
    }
    _unCanUseVC.couponArray = _unCanUseCouponArray;
    return _unCanUseVC;
}



- (void)backToTheInvestmentPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)confirmTheCouponOfYourChoice
{
    [self.canUseVC couponOfChoic];//返现券
    [self backToTheInvestmentPage];
    
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
