//
//  MyViewController.m
//  JRGC
//
//  Created by biyuhuaping on 16/4/6.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "MyViewController.h"
#import "NZLabel.h"
#import "UCFToolsMehod.h"

#import "UCFMyInvestViewController.h"       //我的项目
#import "UCFMyClaimCtrl.h"                  //我的债转
#import "UCFBackMoneyDetailViewController.h"//项目详情

@interface MyViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentedCtrl;
@property (strong, nonatomic) UCFMyInvestViewController *myInvest;//我的债权
@property (strong, nonatomic) UCFMyClaimCtrl *myClaimCtrl;//我的债权

@property (strong, nonatomic) IBOutlet UILabel *interestsLab;//累计收益
@property (strong, nonatomic) IBOutlet UILabel *noPrincipalLab;//待收本金
@property (strong, nonatomic) IBOutlet NZLabel *noInterestsLab;//待收利息

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addLeftButton];
    
    _segmentedCtrl = [[UISegmentedControl alloc]initWithItems:@[@"我的项目",@"转入项目"]];
    DBLOG(@"%@",NSStringFromCGRect(self.view.frame));
    _segmentedCtrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    [_segmentedCtrl setTintColor:UIColorWithRGB(0x5b6993)];
    [_segmentedCtrl setTitleTextAttributes:@{[UIFont systemFontOfSize:15]:NSFontAttributeName} forState:UIControlStateNormal];
    _segmentedCtrl.selectedSegmentIndex = 0;
    [_segmentedCtrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedCtrl;

    _myInvest = [[UCFMyInvestViewController alloc]initWithNibName:@"UCFMyInvestViewController" bundle:nil];
    _myInvest.view.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 164);
    [self addChildViewController:_myInvest];

    _myClaimCtrl = [[UCFMyClaimCtrl alloc]initWithNibName:@"UCFMyClaimCtrl" bundle:nil];
    _myClaimCtrl.view.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 164);
    [self addChildViewController:_myClaimCtrl];

    [self.view addSubview:_myInvest.view];
    [_myInvest didMoveToParentViewController:self];//确定关系建立
    
    __weak typeof(self) weakSelf = self;
    _myInvest.setHeaderInfoBlock = ^(NSDictionary *data){
        id interests = data[@"interests"];
        weakSelf.interestsLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:interests]];//累计收益

        id principal = data[@"noPrincipal"];
        weakSelf.noPrincipalLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:principal]];//待收本金

        id noInterests = data[@"noInterests"];
        weakSelf.noInterestsLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:noInterests]];//待收利息
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedValueChanged:(UISegmentedControl *)sender{
    DBLOG(@"%ld",(long)sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex) {
        [self transitionFromViewController:_myInvest toViewController:_myClaimCtrl duration:0 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
            if (finished) {
                [_myClaimCtrl didMoveToParentViewController:self];//确认关系
            }
        }];
    }else{
        [self transitionFromViewController:_myClaimCtrl toViewController:_myInvest duration:0 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
            if (finished) {
                [_myInvest didMoveToParentViewController:self];//确认关系
            }
        }];
    }
}
//to回款明细页面
- (IBAction)toBackMoneyDetailView:(id)sender {
    UCFBackMoneyDetailViewController *vc = [[UCFBackMoneyDetailViewController alloc]initWithNibName:@"UCFBackMoneyDetailViewController" bundle:nil];
    vc.title = @"回款明细";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
