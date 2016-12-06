//
//  UCFTransferViewController.m
//  JRGC
//
//  Created by NJW on 2016/11/17.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFTransferViewController.h"
#import "UCFSelectedView.h"
#import "UCFHornerTransferViewController.h"
#import "UCFP2PTransferViewController.h"

@interface UCFTransferViewController () <UCFSelectedViewDelegate
>
@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSeletedView;

@property (weak, nonatomic) UCFBaseViewController *currentViewController;
@property (nonatomic, strong) UCFHornerTransferViewController *hornerTransfer;
@property (nonatomic, strong) UCFP2PTransferViewController *p2pTransfer;
    
@property (nonatomic, assign) BOOL isShowHornor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedHight;
@end

@implementation UCFTransferViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (![self.view.subviews containsObject:self.hornerTransfer.view]) {
//        [self.view addSubview:self.hornerTransfer.view];
//        self.itemSeletedView.segmentedControl.selectedSegmentIndex = 0;
//        [self.hornerTransfer didMoveToParentViewController:self];//确定关系建立
//    }
    if (![self.view.subviews containsObject:self.currentViewController.view]) {
        [self.view addSubview:self.currentViewController.view];
        self.itemSeletedView.segmentedControl.selectedSegmentIndex = 0;
        [self.currentViewController didMoveToParentViewController:self];//确定关系建立
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isShowHornor = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowHornor"];
    
    self.itemSeletedView.sectionTitles = @[@"尊享转让", @"P2P转让"];
    self.itemSeletedView.delegate = self;
    
    self.hornerTransfer = [[UCFHornerTransferViewController alloc]initWithNibName:@"UCFHornerTransferViewController" bundle:nil];
    self.hornerTransfer.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64-49 -44);
    [self addChildViewController:self.hornerTransfer];
    
    self.p2pTransfer = [[UCFP2PTransferViewController alloc]initWithNibName:@"UCFP2PTransferViewController" bundle:nil];
    self.p2pTransfer.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64-49 -44);
    [self addChildViewController:self.p2pTransfer];
    
    if (self.isShowHornor) {
        self.currentViewController = self.hornerTransfer;
        self.selectedHight.constant = 44;
    }
    else {
        self.currentViewController = self.p2pTransfer;
        self.selectedHight.constant = 0;
        self.p2pTransfer.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49);
    }
    
}

// 选项的点击事件
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.hornerTransfer]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.hornerTransfer duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.hornerTransfer;
            }];
        }
            break;
            
        case 1: {
            if ([self.currentViewController isEqual:self.p2pTransfer]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.p2pTransfer duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.p2pTransfer;
            }];
        }
            break;
            
    }
}

@end
