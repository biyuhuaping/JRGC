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
//#import "UCFGoldenViewController.h"
#import "PagerView.h"
#import "UCFSelectedView.h"
#import "UCFOrdinaryBidController.h"
#import "UCFHomeListPresenter.h"
@interface UCFInvestViewController () <UCFSelectedViewDelegate>
{
    PagerView *_pagerView;

}
@property (weak, nonatomic) UCFSelectedView *itemSelectedView;
//@property (strong, nonatomic) UCFHonorInvestViewController *honorInvest;
@property (strong, nonatomic) UCFOrdinaryBidController *honorInvest;

@property (strong, nonatomic) UCFMicroMoneyViewController *microMoney;
//@property (strong, nonatomic) UCFGoldenViewController *golden;
@property (strong, nonatomic) UCFInvestTransferViewController *investTransfer;

@property (strong, nonatomic) UCFBaseViewController *currentViewController;
@end

@implementation UCFInvestViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"getPersonalCenterNetData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultView) name:@"setDefaultViewData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:@"refreshSuperviseView" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentControllerUpdate) name:@"reloadHonerPlanData" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentControllerUpdate) name:@"reloadP2PTransferData" object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewControllers];
    //设置UI
    [self newCreateUI];
}
    
- (void)refreshUI:(NSNotification *)noti
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self isViewLoaded]) {
            for (UIViewController *vc in self.childViewControllers) {
                [vc removeFromParentViewController];
            }
            [self addChildViewControllers];
            if (_pagerView) {
                [_pagerView removeFromSuperview];
                _pagerView = nil;
            }
            [self newCreateUI];
        }
    });
}
    
- (void)setDefaultView {
    [UserInfoSingle sharedManager].level = 1;
    [UserInfoSingle sharedManager].goldIsNew = YES;
    [UserInfoSingle sharedManager].zxIsNew = YES;
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    [self addChildViewControllers];
    [self newCreateUI];
}

- (void)refresh {
    [self currentControllerUpdate];
}

- (void)currentControllerUpdate
{
    if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
        if (self.childViewControllers.count >= 1) {
            UCFBaseViewController *baseVc = [self.childViewControllers firstObject];
            [self updateViewControllerTableWithC:baseVc];
        }
    }
    else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
        if (self.childViewControllers.count >= 2) {
            UCFBaseViewController *baseVc = [self.childViewControllers objectAtIndex:1];
            [self updateViewControllerTableWithC:baseVc];
        }
    }
    else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
        if (self.childViewControllers.count >= 3) {
            UCFBaseViewController *baseVc = [self.childViewControllers objectAtIndex:2];
            [self updateViewControllerTableWithC:baseVc];
        }
    }
    else if ([_pagerView.selectIndexStr isEqualToString:@"3"]) {
        if (self.childViewControllers.count >= 4) {
            UCFBaseViewController *baseVc = [self.childViewControllers lastObject];
            [self updateViewControllerTableWithC:baseVc];
        }
    }
}

- (void)updateViewControllerTableWithC:(UCFBaseViewController *)baseVc
{
    if ([baseVc isEqual:self.microMoney]) {
        if (![self.microMoney.tableview.header isRefreshing]) {
            [self.microMoney.tableview.header beginRefreshing];
        }
    }
    else if ([baseVc isEqual:self.honorInvest]) {
        if (![self.honorInvest.tableview.header isRefreshing]) {
            [self.honorInvest.tableview.header beginRefreshing];
        }
    }
//    else if ([baseVc isEqual:self.golden]) {
//        if (![self.golden.tableview.header isRefreshing]) {
//            [self.golden.tableview.header beginRefreshing];
//        }
//    }
    else if ([baseVc isEqual:self.investTransfer]) {
        if (![self.investTransfer.tableview.header isRefreshing]) {
            [self.investTransfer.tableview.header beginRefreshing];
        }
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - 设置界面
- (void)addChildViewControllers
{
        UCFHomeListPresenter *homeList = [[UCFHomeListPresenter alloc]init];
        [homeList getUserStateData];
        [self addHonor];//添加优质债权
        [self addMicroMoney];//添加智能出借
        [self addTransfer];//添加债权转让
    
}

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

- (void)addMicroMoney {
    self.microMoney.rootVc = self;
    [self addChildViewController:self.microMoney];
}

- (void)addHonor {
    self.honorInvest.rootVc = self;
    [self addChildViewController:self.honorInvest];
}

//- (void)addGolden {
//    self.golden.rootVc = self;
//    [self addChildViewController:self.golden];
//}

- (void)addTransfer {
    self.investTransfer.rootVc = self;
    [self addChildViewController:self.investTransfer];
}

- (void)newCreateUI
{
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
//    if ([UserInfoSingle sharedManager].wjIsShow) {
//        [titleArray addObject:@"微金"];
//    }
//    if ([UserInfoSingle sharedManager].zxIsShow) {
//        [titleArray addObject:@"尊享"];
//    }
//    if ([UserInfoSingle sharedManager].goldIsShow) {
//        [titleArray addObject:@"黄金"];
//    }
//    if ([UserInfoSingle sharedManager].transferIsShow) {
//        [titleArray addObject:@"债转"];
//    }
     [titleArray addObject:@"优质债权"];
     [titleArray addObject:@"智能出借"];
     [titleArray addObject:@"债权转让"];
    
    _pagerView = [[PagerView alloc] initWithFrame:CGRectMake(0,20,ScreenWidth,ScreenHeight - 20 - 49)
                                SegmentViewHeight:44
                                       titleArray:titleArray
                                       Controller:self
                                        lineWidth:70
                                       lineHeight:3];
    
    [self.view addSubview:_pagerView];
    
//    if ([self.selectedType isEqualToString:@"P2P"]) {
//        self.currentViewController = self.microMoney;
//        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
//    }
//    else if ([self.selectedType isEqualToString:@"ZX"]) {
//        self.currentViewController = self.honorInvest;
//        if ([self.childViewControllers containsObject:self.honorInvest]) {
//            [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
//        }
//        else {
//            [_pagerView setSelectIndex:0];
//        }
//
//    }
//    else if ([self.selectedType isEqualToString:@"Trans"]) {
//        self.currentViewController = self.investTransfer;
//        if ([self.childViewControllers containsObject:self.investTransfer]) {
//            [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
//        }
//        else {
//            [_pagerView setSelectIndex:0];
//        }
//    }
//    else if ([self.selectedType isEqualToString:@"Gold"]) {
//        self.currentViewController = self.golden;
//        if ([self.childViewControllers containsObject:self.golden]) {
//            [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
//        }
//        else {
//            [_pagerView setSelectIndex:0];
//        }
//    }
//    else {
//        self.currentViewController = self.microMoney;
//        [_pagerView setSelectIndex:0];
//    }
}
- (void)changeView {
    if ([self.selectedType isEqualToString:@"IntelligentLoan"]) {//智能出借
        self.currentViewController = self.microMoney;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
    else if ([self.selectedType isEqualToString:@"QualityClaims"]) {//优质债权
        self.currentViewController = self.honorInvest;
        if ([self.childViewControllers containsObject:self.honorInvest]) {
            [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
        } else {
            [_pagerView setSelectIndex:0];
        }
       
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        self.currentViewController = self.investTransfer;
        if ([self.childViewControllers containsObject:self.investTransfer]) {
            [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
        }
        else {
            [_pagerView setSelectIndex:0];
        }
    }
//    else if ([self.selectedType isEqualToString:@"Gold"]) {
//        self.currentViewController = self.golden;
//        if ([self.childViewControllers containsObject:self.golden]) {
//            [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
//        }
//        else {
//            [_pagerView setSelectIndex:0];
//        }
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
