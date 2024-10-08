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
#import "UCFBatchProjectController.h"       //批量项目

@interface MyViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentedCtrl;
@property (strong, nonatomic) UCFMyInvestViewController *myInvest;//我的债权
@property (strong, nonatomic) UCFMyClaimCtrl *myClaimCtrl;//我的债权
@property (strong, nonatomic) UCFBatchProjectController *batchProject;//批量项目
@property (weak, nonatomic)   UIViewController *currentController;//当前控制器

@property (strong, nonatomic) IBOutlet UILabel *interestsLab;//累计收益
@property (strong, nonatomic) IBOutlet UILabel *noPrincipalLab;//待收本金
@property (strong, nonatomic) IBOutlet NZLabel *noInterestsLab;//待收利息
@property (weak, nonatomic) IBOutlet UILabel *titleDescribeLabel;

@end

@implementation MyViewController

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [self.currentController.view setFrame:CGRectMake(0, 100, SCREEN_WIDTH, ScreenHeight - 164)];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addLeftButton];
    //尊享开关
    BOOL isShowHornor =  [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowHornor"];
    isShowHornor = YES;
    
    NSString *titleStr = isShowHornor ? @"转入项目":@"我的债权" ;
    if (self.accoutType == SelectAccoutTypeP2P) {
        _segmentedCtrl = [[UISegmentedControl alloc]initWithItems:@[@"我的项目",@"批量项目",titleStr]];
        self.titleDescribeLabel.text = @"累计利息";
    }
    else if (self.accoutType == SelectAccoutTypeHoner) {
        _segmentedCtrl = [[UISegmentedControl alloc]initWithItems:@[@"我的项目", titleStr]];
        self.titleDescribeLabel.text = @"累计收益";
    }
//    _segmentedCtrl = [[UISegmentedControl alloc]initWithItems:@[@"我的项目",@"批量项目",titleStr]];
    DDLogDebug(@"%@",NSStringFromCGRect(self.view.frame));
    _segmentedCtrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    [_segmentedCtrl setTintColor:UIColorWithRGB(0x5b6993)];
//    [_segmentedCtrl setTitleTextAttributes:@{[UIFont systemFontOfSize:15]:NSFontAttributeName} forState:UIControlStateNormal];
    _segmentedCtrl.selectedSegmentIndex = _selectedSegmentIndex;
    [_segmentedCtrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedCtrl;

    self.myInvest = [[UCFMyInvestViewController alloc]initWithNibName:@"UCFMyInvestViewController" bundle:nil];
    self.myInvest.accoutType = self.accoutType;
    self.myInvest.view.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 164);
    [self addChildViewController:self.myInvest];
    
    self.batchProject = [[UCFBatchProjectController alloc]initWithNibName:@"UCFBatchProjectController" bundle:nil];
    self.batchProject.accoutType = self.accoutType;
    self.batchProject.view.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 164);
    [self addChildViewController:self.batchProject];

    self.myClaimCtrl = [[UCFMyClaimCtrl alloc]initWithNibName:@"UCFMyClaimCtrl" bundle:nil];
    self.myClaimCtrl.view.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 164);
    self.myClaimCtrl.accoutType = self.accoutType;
    [self addChildViewController:self.myClaimCtrl];
    
    self.segmentedCtrl.selectedSegmentIndex = self.selectedSegmentIndex;
    switch (self.selectedSegmentIndex) {
        case 0: {
            [_myInvest didMoveToParentViewController:self];//确定关系建立
            self.currentController = self.myInvest;
            [self.view addSubview:_myInvest.view];
        }
            break;
        
        case 1: {
            if (self.accoutType == SelectAccoutTypeP2P) {
                [_batchProject didMoveToParentViewController:self];//确定关系建立
                
                self.currentController = self.batchProject;
                [self.view addSubview:_batchProject.view];
            }
            else if (self.accoutType == SelectAccoutTypeHoner) {
                [_myClaimCtrl didMoveToParentViewController:self];//确定关系建立
                self.currentController = self.myClaimCtrl;
                [self.view addSubview:_myClaimCtrl.view];
            }
        }
            break;
        
        case 2: {
            [_myClaimCtrl didMoveToParentViewController:self];//确定关系建立
            self.currentController = self.myClaimCtrl;
            [self.view addSubview:_myClaimCtrl.view];
        }
            break;
    }
    
    [self getHeaderInfoRequest];
    
//    __weak typeof(self) weakSelf = self;
//    _setHeaderInfoBlock = ^(NSDictionary *data){
//        
//        
//    };
}

- (void)viewWillLayoutSubviews
{
    [self.currentController.view setFrame:CGRectMake(0, 100, SCREEN_WIDTH, ScreenHeight - 164)];
}

- (void)segmentedValueChanged:(UISegmentedControl *)sender{
    DDLogDebug(@"%ld",(long)sender.selectedSegmentIndex);
//    __weak typeof(self)weakSelf = self;
    switch (sender.selectedSegmentIndex) {
        case 0: {
            [self transitionFromViewController:self.currentController toViewController:self.myInvest duration:0.25 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
                if (finished) {
                    [self.myInvest didMoveToParentViewController:self];//确认关系
                    self.currentController = self.myInvest;
                }
            }];
        }
            break;
         
        case 1: {
            if (self.accoutType == SelectAccoutTypeP2P) {
                [self transitionFromViewController:self.currentController toViewController:self.batchProject duration:0.25 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
                    if (finished) {
                        [self.batchProject didMoveToParentViewController:self];//确认关系
                        self.currentController = self.batchProject;
                    }
                }];
            }
            else if (self.accoutType == SelectAccoutTypeHoner) {
                [self transitionFromViewController:self.currentController toViewController:self.myClaimCtrl duration:0.25 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
                    if (finished) {
                        [self.myClaimCtrl didMoveToParentViewController:self];//确认关系
                        self.currentController = self.myClaimCtrl;
                    }
                }];
            }
        }
            break;
        
        case 2: {
            [self transitionFromViewController:self.currentController toViewController:self.myClaimCtrl duration:0.25 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:^(BOOL finished) {
                if (finished) {
                    [self.myClaimCtrl didMoveToParentViewController:self];//确认关系
                    self.currentController = self.myClaimCtrl;
                }
            }];
        }
            break;
    }
    
}
//to回款明细页面
- (IBAction)toBackMoneyDetailView:(id)sender {
    UCFBackMoneyDetailViewController *vc = [[UCFBackMoneyDetailViewController alloc]initWithNibName:@"UCFBackMoneyDetailViewController" bundle:nil];
    vc.title = @"回款明细";
    vc.accoutType = self.accoutType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getHeaderInfoRequest
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",SingleUserInfo.loginData.userInfo.userId];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagMyInvestHeaderInfo owner:self Type:self.accoutType];
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber*)tag
{
    if (tag.integerValue == kSXTagMyInvestHeaderInfo) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] intValue] == 1)
        {
            NSDictionary *data = [dic objectSafeDictionaryForKey:@"data"];
            id interests = data[@"interests"];
            self.interestsLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:interests]];//累计收益
            
            id principal = data[@"noPrincipal"];
            self.noPrincipalLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:principal]];//待收本金
            
            id noInterests = data[@"noInterests"];
            self.noInterestsLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:noInterests]];//待收利息
        }
    }
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:@"网络连接异常"];
}
@end
