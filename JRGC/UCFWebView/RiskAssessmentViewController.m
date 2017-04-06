//
//  RiskAssessmentViewController.m
//  JRGC
//
//  Created by 金融工场 on 2017/1/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "RiskAssessmentViewController.h"

@interface RiskAssessmentViewController ()

@end

@implementation RiskAssessmentViewController
//需要加上这个 要不初始化不了webView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.sourceVC isEqualToString:@"ProjectDetailVC"]) {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.sourceVC isEqualToString:@"ProjectDetailVC"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = self.title;
    [self addErrorViewButton];
    [self gotoURL:self.url];
    // Do any additional setup after loading the view from its nib.
}
//只要是豆哥商城的都去掉导航栏
//- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//}
-(void)getToBack{
    [self jsClose];
}
- (void)jsClose
{
//    if ([_sourceVC isEqualToString:@"P2POrHonerAccoutVC"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:RELOADP2PORHONERACCOTDATA object:nil];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
//    if ([_sourceVC isEqualToString:@"P2POrHonerAccoutVC"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:RELOADP2PORHONERACCOTDATA object:nil];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
