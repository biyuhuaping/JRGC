//
//  UCFProfitBackViewController.m
//  JRGC
//
//  Created by njw on 2017/5/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFProfitBackViewController.h"
#import "UCFMyRebateViewCtrl.h"

@interface UCFProfitBackViewController ()
@property (nonatomic, weak) UISegmentedControl *segmentedCtrl;
@property (nonatomic, strong) UCFMyRebateViewCtrl *p2pRebate;
@property (nonatomic, strong) UCFMyRebateViewCtrl *zxRebate;
@property (nonatomic, weak) UCFBaseViewController *currentViewController;
@end

@implementation UCFProfitBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self configure];
}

- (void)createUI {
    
    [self addLeftButton];
    if([UserInfoSingle sharedManager].superviseSwitch && [UserInfoSingle sharedManager].level < 2   && ![UserInfoSingle sharedManager].zxAuthorization)
    {
        baseTitleLabel.text = @"微金返利";
    }
    else {
        UISegmentedControl *segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"微金返利",@"尊享返利"]];;
        segmentContrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
        [segmentContrl setTintColor:UIColorWithRGB(0x5b6993)];
        segmentContrl.selectedSegmentIndex = 0;
        [segmentContrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.segmentedCtrl = segmentContrl;
        self.navigationItem.titleView = segmentContrl;
    }
}

- (void)segmentedValueChanged:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.p2pRebate]) {
                return;
            }
            self.p2pRebate.accoutType = SelectAccoutTypeP2P;
            [self transitionFromViewController:self.currentViewController toViewController:self.p2pRebate duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.p2pRebate;
            }];
        }
            break;
            
        case 1: {
            if ([self.currentViewController isEqual:self.zxRebate]) {
                return;
            }
            self.zxRebate.accoutType = SelectAccoutTypeHoner;
            [self transitionFromViewController:self.currentViewController toViewController:self.zxRebate duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.zxRebate;
            }];
        }
            break;
    }
}

- (void)configure
{
    self.p2pRebate = [[UCFMyRebateViewCtrl alloc]initWithNibName:@"UCFMyRebateViewCtrl" bundle:nil];
//    self.p2pRebate.accoutType = self.accoutType;
    [self addChildViewController:self.p2pRebate];
    
    self.zxRebate = [[UCFMyRebateViewCtrl alloc]initWithNibName:@"UCFMyRebateViewCtrl" bundle:nil];
//    self.zxRebate.accoutType = self.accoutType;
    [self addChildViewController:self.zxRebate];
    
    
    if (self.index == 0) {
        [self.view addSubview:self.p2pRebate.view];
        self.p2pRebate.accoutType = SelectAccoutTypeP2P;
        self.currentViewController = self.p2pRebate;
    }
    else if (self.index == 1) {
        [self.view addSubview:self.zxRebate.view];
        self.currentViewController = self.zxRebate;
        self.zxRebate.accoutType = SelectAccoutTypeHoner;
    }
    self.segmentedCtrl.selectedSegmentIndex = self.index;
    [self segmentedValueChanged:self.segmentedCtrl];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.currentViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
}

@end
