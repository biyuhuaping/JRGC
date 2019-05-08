//
//  RiskAssessmentViewController.m
//  JRGC
//
//  Created by 金融工场 on 2017/1/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "RiskAssessmentViewController.h"
#import "UCFMicroBankDepositoryAccountHomeViewController.h"
#import "UCFNewHomeViewController.h"
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
    
    if (self.accoutType == SelectAccoutTypeHoner)
    {
        [self.navigationController setNavigationBarHidden:NO];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES];
    }
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
    if (self.accoutType == SelectAccoutTypeHoner) {
        self.url = GRADELURL;
        baseTitleLabel.text = @"尊享风险承担能力";
    }else{
        self.url = USEREVALUATEP2P;
        baseTitleLabel.text = @"微金风险承担能力";
    }
    [self addErrorViewButton];
    [self gotoURL:self.url];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    return [super webViewDidFinishLoad:webView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    return [super webView:webView didFailLoadWithError:error];
}
-(void)getToBack{
    [self jsClose];
}
- (void)jsClose
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[UCFMicroBankDepositoryAccountHomeViewController class]]) {
            [(UCFMicroBankDepositoryAccountHomeViewController *)vc refresh];
        }
//        if ([vc isKindOfClass:[UCFNewHomeViewController class]]) {
//            [(UCFNewHomeViewController *)vc monitorRiskStatueChange];
            
//        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    SingleUserInfo.webCloseUpdatePrePage = YES;

}


@end
