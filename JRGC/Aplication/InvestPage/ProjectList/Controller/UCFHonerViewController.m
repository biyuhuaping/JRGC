//
//  UCFHonerViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHonerViewController.h"
#import "UCFSelectedView.h"
#import "UCFHonerPlanViewController.h"
#import "UCFHornerTransferViewController.h"
@interface UCFHonerViewController ()<UCFSelectedViewDelegate>
@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSeletedView;

@property (weak, nonatomic) UCFBaseViewController *currentViewController;
@property (nonatomic, strong) UCFHonerPlanViewController *honerPlanVC;
@property (nonatomic, strong) UCFHornerTransferViewController *hornerTransferVC;
@end

@implementation UCFHonerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - create UI
    [self addLeftButton];
    // add SegmentControl
    [self addSegmentControl];
    // add child controllers
    [self addChildControllers];
    // setting current controller
    self.currentViewController = self.honerPlanVC;
     baseTitleLabel.text = @"即将跳转";
    [self performSelector:@selector(updateNavLabelTitle) withObject:nil afterDelay:LoadingSecond];
   
}
-(void)updateNavLabelTitle{
     baseTitleLabel.text = @"工场尊享";
}
- (void)setCurrentViewForHornerTransferVC
{
    NSString *viewType = self.viewType;
    if ([viewType isEqualToString:@"2"]) {
        self.itemSeletedView.segmentedControl.selectedSegmentIndex = 1;
        self.currentViewController = self.hornerTransferVC;
        [self.view addSubview:self.hornerTransferVC.view];
        _currentViewController = self.hornerTransferVC;
    }
    else {
        self.itemSeletedView.segmentedControl.selectedSegmentIndex = 0;
        self.currentViewController = self.honerPlanVC;
        [self.view addSubview:self.honerPlanVC.view];
        _currentViewController = self.honerPlanVC;
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
        [self.currentViewController.view setFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 - 44 - 49)];
    }
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - add child controllers
- (void)addChildControllers
{
    self.honerPlanVC = [[UCFHonerPlanViewController alloc]initWithNibName:@"UCFHonerPlanViewController" bundle:nil];
    self.honerPlanVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 - 44);
    self.honerPlanVC.rootVc = self;
    [self addChildViewController:self.honerPlanVC];
    self.hornerTransferVC = [[UCFHornerTransferViewController alloc]initWithNibName:@"UCFHornerTransferViewController" bundle:nil];
    self.hornerTransferVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 - 44);
    self.hornerTransferVC.rootVc = self;
    [self addChildViewController:self.hornerTransferVC];
    
}

#pragma mark - add segmentcontrol and segmentcontrol clicked method

- (void)addSegmentControl
{
    self.itemSeletedView.sectionTitles = @[@"尊享计划", @"尊享转让"];
    self.itemSeletedView.delegate = self;
}

- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.honerPlanVC]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.honerPlanVC duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.honerPlanVC;
            }];
        }
            break;
        case 1: {
            if ([self.currentViewController isEqual:self.hornerTransferVC]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.hornerTransferVC duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.hornerTransferVC;
            }];
        }
            break;
    }
}
@end
