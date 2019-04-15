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
#import "UCFDataStatisticsViewController.h"
#import "UCFPageHeadView.h"
@interface UCFInvitationRebateViewController ()<UCFPageHeadViewDelegate>
//@property (nonatomic, weak) UISegmentedControl *segmentedCtrl;
@property (nonatomic, strong) UCFPageHeadView  *pageHeadView;
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
    
    if (self.accoutType != SelectAccoutTypeGold) {
        NSString *gcm = [[NSUserDefaults standardUserDefaults] objectForKey:GCMCODE];
        if ([gcm hasPrefix:@"A"]) { //A码用户显示 饼图
            [self addRightButtonWithImage:[UIImage imageNamed:@"icon_data"]];
        }
    }
}
- (UCFPageHeadView *)pageHeadView
{
    if (!_pageHeadView) {
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) WithTitleArray:@[@"邀请返利",@"邀请奖励"]];
//        _pageHeadView.leftSpace = 80;
//        _pageHeadView.rightSpace = 80;
        [_pageHeadView reloaShowView];
        _pageHeadView.delegate = self;

    }
    return _pageHeadView;
}
- (void)pageHeadView:(UCFPageHeadView *)pageView selectIndex:(NSInteger)index
{
    switch (index) {
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
- (void)addRightButtonWithImage:(UIImage *)rightButtonimage;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 30,30);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setImage:rightButtonimage forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)clickRightBtn{
    
    UCFDataStatisticsViewController *dataStatistic = [[UCFDataStatisticsViewController alloc] initWithNibName:@"UCFDataStatisticsViewController" bundle:nil];
    [self.navigationController pushViewController:dataStatistic animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.currentViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
}

#pragma mark - 初始化界面
- (void)createUI {
    if (self.accoutType == SelectAccoutTypeGold) {
        baseTitleLabel.text = @"邀请返利";
    } else {
//        UISegmentedControl *segmentContrl = [[UISegmentedControl alloc]initWithItems:@[@"邀请返利",@"邀请奖励"]];;
//        segmentContrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
//        [segmentContrl setTintColor:[UIColor redColor]];
//        segmentContrl.selectedSegmentIndex = 0;
//        [segmentContrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
//        self.segmentedCtrl = segmentContrl;
        self.navigationItem.titleView = self.pageHeadView;
    }
    self.invitaionRebateVC = [[UCFFeedBackViewController alloc]initWithNibName:@"UCFFeedBackViewController" bundle:nil];
    self.invitaionRebateVC.accoutType = self.accoutType;
    [self addChildViewController:self.invitaionRebateVC];
    
    self.invitationRewardVC = [[UCFInvitationRewardViewController alloc]initWithNibName:@"UCFInvitationRewardViewController" bundle:nil];
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
