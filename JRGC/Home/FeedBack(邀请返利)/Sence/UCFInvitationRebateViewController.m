//
//  UCFInvitationRebateViewController.m
//  JRGC
//
//  Created by njw on 2017/5/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvitationRebateViewController.h"

@interface UCFInvitationRebateViewController ()
@property (nonatomic, weak) UISegmentedControl *segmentedCtrl;
@end

@implementation UCFInvitationRebateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    
    [self createUI];
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
}

#pragma mark - segment代理方法
- (void)segmentedValueChanged:(UISegmentedControl *)segment
{
    
}

@end
