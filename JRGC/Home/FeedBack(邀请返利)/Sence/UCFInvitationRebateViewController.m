//
//  UCFInvitationRebateViewController.m
//  JRGC
//
//  Created by njw on 2017/5/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvitationRebateViewController.h"
#import "UCFFeedBackViewController.h"
#import "UCFInvitationRewardViewController.h"

@interface UCFInvitationRebateViewController ()
@property (nonatomic, weak) UISegmentedControl *segmentedCtrl;
//邀请返利
@property (nonatomic, strong) UCFFeedBackViewController *invitaionRebateVC;
//邀请奖励
@property (nonatomic, strong) UCFInvitationRewardViewController *invitationRewardVC;

@property (nonatomic, weak) UCFBaseViewController *currentViewController;
@end

@implementation UCFInvitationRebateViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    
    [self createUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.currentViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
}

#pragma mark - 初始化界面
- (void)createUI {
    
    UISegmentedControl *segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"邀请返利",@"邀请奖励"]];;
    segmentContrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    [segmentContrl setTintColor:UIColorWithRGB(0x5b6993)];
    segmentContrl.selectedSegmentIndex = 0;
    [segmentContrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedCtrl = segmentContrl;
    self.navigationItem.titleView = segmentContrl;
    
    self.invitaionRebateVC = [[UCFFeedBackViewController alloc]initWithNibName:@"UCFFeedBackViewController" bundle:nil];
//    self.invitaionRebateVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.invitaionRebateVC.accoutType = self.accoutType;
    [self addChildViewController:self.invitaionRebateVC];
    
    self.invitationRewardVC = [[UCFInvitationRewardViewController alloc]initWithNibName:@"UCFInvitationRewardViewController" bundle:nil];
//    self.invitationRewardVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.invitationRewardVC.accoutType = self.accoutType;
    [self addChildViewController:self.invitationRewardVC];
    
    self.currentViewController = self.invitaionRebateVC;
    [self.view addSubview:self.invitaionRebateVC.view];
}

#pragma mark - segment代理方法
- (void)segmentedValueChanged:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            if ([self.currentViewController isEqual:self.invitaionRebateVC]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.invitaionRebateVC duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.invitaionRebateVC;
            }];
        }
            break;
            
        case 1: {
            if ([self.currentViewController isEqual:self.invitationRewardVC]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.invitationRewardVC duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = self.invitationRewardVC;
            }];
        }
            break;
    }
}

@end
