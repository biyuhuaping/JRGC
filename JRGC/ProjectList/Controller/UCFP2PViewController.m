//
//  UCFP2PViewController.m
//  JRGC
//
//  Created by NJW on 2016/11/17.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFP2PViewController.h"
#import "UCFOrdinaryBidController.h"
#import "UCFBatchBidController.h"
#import "UCFSelectedView.h"
#import "UCFP2PTransferViewController.h"

@interface UCFP2PViewController () <UCFSelectedViewDelegate>
@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSeletedView;

@property (weak, nonatomic) UCFBaseViewController *currentViewController;
@property (nonatomic, strong) UCFOrdinaryBidController *ordinaryBid;
@property (nonatomic, strong) UCFBatchBidController *batchBid;
@property (nonatomic, strong) UCFP2PTransferViewController *p2PTransferVC;
@end

@implementation UCFP2PViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - create UI
    [self addLeftButton];
    // add SegmentControl
    [self addSegmentControl];
    // add child controllers
    [self addChildControllers];
    // setting current controller
    self.currentViewController = self.ordinaryBid;
    baseTitleLabel.text = @"即将跳转";
    [self performSelector:@selector(updateNavLabelTitle) withObject:nil afterDelay:LoadingSecond];
}
-(void)updateNavLabelTitle{
    baseTitleLabel.text  = @"工场微金";
}
- (void)setCurrentViewForBatchBid
{
    NSString *viewType = self.viewType;
    switch ([viewType intValue]) {
        case 1:
        {
            self.itemSeletedView.segmentedControl.selectedSegmentIndex = 0;
            self.currentViewController = self.ordinaryBid;
            [self.view addSubview:self.ordinaryBid.view];
            _currentViewController = self.ordinaryBid;
        }
            break;
        case 2:
        {
            self.itemSeletedView.segmentedControl.selectedSegmentIndex = 1;
            self.currentViewController = self.batchBid;
            [self.view addSubview:self.batchBid.view];
            _currentViewController = self.batchBid;
            
        }
            break;
        case 3:
        {
            self.itemSeletedView.segmentedControl.selectedSegmentIndex = 2;
            self.currentViewController = self.p2PTransferVC;
            [self.view addSubview:self.p2PTransferVC.view];
            _currentViewController = self.p2PTransferVC;
        }
            break;
            
        default:
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.view.subviews containsObject:self.currentViewController.view]) {
        [self.view addSubview:self.currentViewController.view];
        self.itemSeletedView.segmentedControl.selectedSegmentIndex = 0;
        [self.currentViewController didMoveToParentViewController:self];//确定关系建立
        [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
        [self.currentViewController.view setFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-49 - 44)];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - add child controllers
- (void)addChildControllers
{
    self.ordinaryBid = [[UCFOrdinaryBidController alloc]initWithNibName:@"UCFOrdinaryBidController" bundle:nil];
    self.ordinaryBid.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 -44);
    [self addChildViewController:self.ordinaryBid];
    self.batchBid = [[UCFBatchBidController alloc]initWithNibName:@"UCFBatchBidController" bundle:nil];
    self.batchBid.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 -44);
    [self addChildViewController:self.batchBid];
    self.p2PTransferVC = [[UCFP2PTransferViewController alloc]initWithNibName:@"UCFP2PTransferViewController" bundle:nil];
    self.p2PTransferVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 -44);
    [self addChildViewController:self.p2PTransferVC];
}

#pragma mark - add segmentcontrol and segmentcontrol clicked method

- (void)addSegmentControl
{
    self.itemSeletedView.sectionTitles = @[@"普通标", @"批量出借标",@"债权转让"];
    self.itemSeletedView.delegate = self;
}

- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.ordinaryBid]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.ordinaryBid duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.ordinaryBid;
            }];
        }
            break;
            
        case 1: {
            if ([self.currentViewController isEqual:self.batchBid]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.batchBid duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.batchBid;
            }];
        }
            break;
        case 2: {
            if ([self.currentViewController isEqual:self.p2PTransferVC]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.p2PTransferVC duration:0.25 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionCurveEaseIn  animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.p2PTransferVC;
            }];
        }
            break;

            
    }
}

@end
