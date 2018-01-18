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
#import "UCFGoldenViewController.h"
#import "PagerView.h"
#import "UCFSelectedView.h"

@interface UCFInvestViewController () <UCFSelectedViewDelegate>
{
    PagerView *_pagerView;

}
@property (weak, nonatomic) UCFSelectedView *itemSelectedView;
@property (strong, nonatomic) UCFHonorInvestViewController *honorInvest;
@property (strong, nonatomic) UCFMicroMoneyViewController *microMoney;
@property (strong, nonatomic) UCFGoldenViewController *golden;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentControllerUpdate) name:@"reloadHonerPlanData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentControllerUpdate) name:@"reloadP2PTransferData" object:nil];
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
    [self createUI];
}
    
- (void)refreshUI:(NSNotification *)noti
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self isViewLoaded]) {
            for (UIViewController *vc in self.childViewControllers) {
                [vc removeFromParentViewController];
            }
            [self addChildViewControllers];
            [self createUI];
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
    [self createUI];
}

- (void)refresh {
    [self currentControllerUpdate];
}

- (void)currentControllerUpdate
{
    if ([UserInfoSingle sharedManager].userId) {
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            if ([UserInfoSingle sharedManager].level < 2) {
                if ([UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                    if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                        [self.microMoney.tableview.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                        [self.investTransfer.tableview.header beginRefreshing];
                    }
                }
                else if ([UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                    if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                        [self.microMoney.tableview.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                        [self.honorInvest.tableView.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
                        [self.investTransfer.tableview.header beginRefreshing];
                    }
                }
                else if (![UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                    if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                        [self.microMoney.tableview.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                        [self.golden.tableview.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
                        [self.investTransfer.tableview.header beginRefreshing];
                    }
                }
                else if (![UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                    if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                        [self.microMoney.tableview.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                        [self.honorInvest.tableView.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"3"]) {
                        [self.investTransfer.tableview.header beginRefreshing];
                    }
                    else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
                        [self.golden.tableview.header beginRefreshing];
                    }
                }
            }
            else {
                if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                    [self.microMoney.tableview.header beginRefreshing];
                }
                else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                    [self.honorInvest.tableView.header beginRefreshing];
                }
                else if ([_pagerView.selectIndexStr isEqualToString:@"3"]) {
                    [self.investTransfer.tableview.header beginRefreshing];
                }
                else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
                    [self.golden.tableview.header beginRefreshing];
                }
            }
        }
        else {
            if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                [self.microMoney.tableview.header beginRefreshing];
            }
            else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                [self.honorInvest.tableView.header beginRefreshing];
            }
            else if ([_pagerView.selectIndexStr isEqualToString:@"3"]) {
                [self.investTransfer.tableview.header beginRefreshing];
            }
            else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
                [self.golden.tableview.header beginRefreshing];
            }
        }
    }
    else {
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                [self.microMoney.tableview.header beginRefreshing];
            }
            else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                [self.investTransfer.tableview.header beginRefreshing];
            }
        }
        else {
            if ([_pagerView.selectIndexStr isEqualToString:@"0"]) {
                [self.microMoney.tableview.header beginRefreshing];
            }
            else if ([_pagerView.selectIndexStr isEqualToString:@"1"]) {
                [self.honorInvest.tableView.header beginRefreshing];
            }
            else if ([_pagerView.selectIndexStr isEqualToString:@"3"]) {
                [self.investTransfer.tableview.header beginRefreshing];
            }
            else if ([_pagerView.selectIndexStr isEqualToString:@"2"]) {
                [self.golden.tableview.header beginRefreshing];
            }
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
    if ([UserInfoSingle sharedManager].userId) {
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            if ([UserInfoSingle sharedManager].level < 2) {
                if ([UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                    [self addMicroMoney];
                    [self addTransfer];
                }
                else if ([UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                    [self addMicroMoney];
                    [self addHonor];
                    [self addTransfer];
                }
                else if (![UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                    [self addMicroMoney];
                    [self addGolden];
                    [self addTransfer];
                }
                else if (![UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                    [self addMicroMoney];
                    [self addHonor];
                    [self addGolden];
                    [self addTransfer];
                }
            }
            else {
                [self addMicroMoney];
                [self addHonor];
                [self addGolden];
                [self addTransfer];
            }
        }
        else {
            [self addMicroMoney];
            [self addHonor];
            [self addGolden];
            [self addTransfer];
        }
    }
    else {
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            [self addMicroMoney];
            [self addTransfer];
        }
        else {
            [self addMicroMoney];
            [self addHonor];
            [self addGolden];
            [self addTransfer];
        }
    }
}

- (void)addMicroMoney {
    self.microMoney = [[UCFMicroMoneyViewController alloc]initWithNibName:@"UCFMicroMoneyViewController" bundle:nil];
    self.microMoney.rootVc = self;
    [self addChildViewController:self.microMoney];
}

- (void)addHonor {
    self.honorInvest = [[UCFHonorInvestViewController alloc]initWithNibName:@"UCFHonorInvestViewController" bundle:nil];
    self.honorInvest.rootVc = self;
    [self addChildViewController:self.honorInvest];
}

- (void)addGolden {
    self.golden = [[UCFGoldenViewController alloc] initWithNibName:@"UCFGoldenViewController" bundle:nil];
    self.golden.rootVc = self;
    [self addChildViewController:self.golden];
}

- (void)addTransfer {
    self.investTransfer = [[UCFInvestTransferViewController alloc]initWithNibName:@"UCFInvestTransferViewController" bundle:nil];
    self.investTransfer.rootVc = self;
    [self addChildViewController:self.investTransfer];
}


- (void)createUI {
    NSArray *titleArray = nil;
    if ([UserInfoSingle sharedManager].userId) {
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            if ([UserInfoSingle sharedManager].level < 2) {
                if ([UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                    titleArray = @[@"微金", @"债转"];
                }
                else if ([UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                    titleArray = @[@"微金", @"尊享", @"债转"];
                }
                else if (![UserInfoSingle sharedManager].goldIsNew && [UserInfoSingle sharedManager].zxIsNew) {
                    titleArray = @[@"微金", @"黄金", @"债转"];
                }
                else if (![UserInfoSingle sharedManager].goldIsNew && ![UserInfoSingle sharedManager].zxIsNew) {
                    titleArray = @[@"微金", @"尊享", @"黄金", @"债转"];
                }
            }
            else {
                titleArray = @[@"微金", @"尊享", @"黄金", @"债转"];
            }
        }
        else {
            titleArray = @[@"微金", @"尊享", @"黄金", @"债转"];
        }
    }
    else {
        if ([UserInfoSingle sharedManager].superviseSwitch) {
            titleArray = @[@"微金", @"债转"];
        }
        else {
            titleArray = @[@"微金", @"尊享", @"黄金", @"债转"];
        }
    }
    _pagerView = [[PagerView alloc] initWithFrame:CGRectMake(0,20,ScreenWidth,ScreenHeight - 20 - 49)
                               SegmentViewHeight:44
                                      titleArray:titleArray
                                      Controller:self
                                       lineWidth:44
                                      lineHeight:3];
    
    [self.view addSubview:_pagerView];
    
    if ([self.selectedType isEqualToString:@"P2P"]) {
        self.currentViewController = self.microMoney;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
    else if ([self.selectedType isEqualToString:@"ZX"]) {
        self.currentViewController = self.honorInvest;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
        
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        self.currentViewController = self.investTransfer;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
    else if ([self.selectedType isEqualToString:@"Gold"]) {
        self.currentViewController = self.golden;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
    else {
        self.currentViewController = self.microMoney;
        [_pagerView setSelectIndex:0];
    }
}

- (void)changeView {
    if ([self.selectedType isEqualToString:@"P2P"]) {
        self.currentViewController = self.microMoney;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
    else if ([self.selectedType isEqualToString:@"ZX"]) {
        self.currentViewController = self.honorInvest;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
    else if ([self.selectedType isEqualToString:@"Trans"]) {
        self.currentViewController = self.investTransfer;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
    else if ([self.selectedType isEqualToString:@"Gold"]) {
        self.currentViewController = self.golden;
        [_pagerView setSelectIndex:[self.childViewControllers indexOfObject:self.currentViewController]];
    }
}

@end
