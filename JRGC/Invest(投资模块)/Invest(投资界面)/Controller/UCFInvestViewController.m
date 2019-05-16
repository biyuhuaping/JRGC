//
//  UCFInvestViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvestViewController.h"
#import "UCFHonorInvestViewController.h"
#import "UCFMicroMoneyViewController.h"
#import "UCFInvestTransferViewController.h"
#import "PagerView.h"
#import "UCFSelectedView.h"
#import "UCFOrdinaryBidController.h"
#import "UCFHomeListPresenter.h"
#import "AppDelegate.h"
#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
@interface UCFInvestViewController () 
{
    PagerView *_pagerView;

}
@property (weak, nonatomic) UCFSelectedView *itemSelectedView;
@property (strong, nonatomic) UCFOrdinaryBidController *honorInvest;

@property (strong, nonatomic) UCFMicroMoneyViewController *microMoney;
@property (strong, nonatomic) UCFInvestTransferViewController *investTransfer;

@property (strong, nonatomic) UCFBaseViewController *currentViewController;


@property (strong, nonatomic)UCFPageHeadView * pageHeadView;
@property (strong, nonatomic)UCFPageControlTool *pageController;
@end

@implementation UCFInvestViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pageController];
}
- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        NSString *title1 = @"优质债权";
        NSString *title2 = @"智能出借";
        NSString *title3 = @"债权转让";
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44 + StatusBarHeight1) WithTitleArray:@[title1,title2,title3]];
        _pageHeadView.isNavBar = YES;
        _pageHeadView.leftSpace = _pageHeadView.rightSpace = 30;
        _pageHeadView.isSacle = YES;

        [_pageHeadView reloaShowView];
        
        if ([self.selectedType isEqualToString:@"IntelligentLoan"]) {
            [_pageHeadView setSelectIndex:1];
        }
        
    }
    return _pageHeadView;
}
- (UCFPageControlTool *)pageController
{
    if (nil == _pageController) {
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TabBarHeight) WithChildControllers:@[self.honorInvest,self.microMoney,self.investTransfer] WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}

- (void)refresh {
//    [self currentControllerUpdate];
}

//- (void)currentControllerUpdate
//{
//    if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
//        if (self.childViewControllers.count >= 1) {
//            UCFBaseViewController *baseVc = [self.childViewControllers firstObject];
//            [self updateViewControllerTableWithC:baseVc];
//        }
//    }
//    else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
//        if (self.childViewControllers.count >= 2) {
//            UCFBaseViewController *baseVc = [self.childViewControllers objectAtIndex:1];
//            [self updateViewControllerTableWithC:baseVc];
//        }
//    }
//    else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
//        if (self.childViewControllers.count >= 3) {
//            UCFBaseViewController *baseVc = [self.childViewControllers objectAtIndex:2];
//            [self updateViewControllerTableWithC:baseVc];
//        }
//    }
//    else if ([_pagerView.selectIndexStr isEqualToString:@"3"]) {
//        if (self.childViewControllers.count >= 4) {
//            UCFBaseViewController *baseVc = [self.childViewControllers lastObject];
//            [self updateViewControllerTableWithC:baseVc];
//        }
//    }
//}

//- (void)updateViewControllerTableWithC:(UCFBaseViewController *)baseVc
//{
//    if ([baseVc isEqual:self.microMoney]) {
//        if (![self.microMoney.tableview.header isRefreshing]) {
//            [self.microMoney.tableview.header beginRefreshing];
//        }
//    }
//    else if ([baseVc isEqual:self.honorInvest]) {
//        if (![self.honorInvest.tableview.header isRefreshing]) {
//            [self.honorInvest.tableview.header beginRefreshing];
//        }
//    }
//    else if ([baseVc isEqual:self.investTransfer]) {
//        if (![self.investTransfer.tableview.header isRefreshing]) {
//            [self.investTransfer.tableview.header beginRefreshing];
//        }
//    }
//}


- (UCFMicroMoneyViewController *)microMoney
{
    if (nil == _microMoney) {
        _microMoney = [[UCFMicroMoneyViewController alloc]initWithNibName:@"UCFMicroMoneyViewController" bundle:nil];
    }
    return _microMoney;
}
-(UCFOrdinaryBidController *)honorInvest
{
    if (nil == _honorInvest) {
        _honorInvest = [[UCFOrdinaryBidController alloc]initWithNibName:@"UCFOrdinaryBidController" bundle:nil];
    }
    return _honorInvest;
    
}
- (UCFInvestTransferViewController *)investTransfer
{
    if (nil == _investTransfer) {
        _investTransfer = [[UCFInvestTransferViewController alloc]initWithNibName:@"UCFInvestTransferViewController" bundle:nil];
    }
    return _investTransfer;
}

- (void)changeView {
    if ([self.selectedType isEqualToString:@"IntelligentLoan"]) {//智能出借
      
        [_pageHeadView setSelectIndex:1];
    }
    else if ([self.selectedType isEqualToString:@"QualityClaims"]) {//优质债权
        [_pageHeadView setSelectIndex:0];
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        [_pageHeadView setSelectIndex:2];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
