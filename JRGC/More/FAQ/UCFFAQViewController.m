//
//  UCFFAQViewController.m
//  JRGC
//
//  Created by NJW on 15/4/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFFAQViewController.h"

@interface UCFFAQViewController ()<UIWebViewDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UCFFAQViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = self.title;
    self.baseTitleType = @"moreViewController";
    [self gotoURL:HELPCENTERURL];
}
- (void)addRefresh //去掉页面刷新
{
}
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    if ([[request.URL absoluteString] rangeOfString:@"goMore.html"].location !=NSNotFound) {
//        self.navigationController.navigationBarHidden = NO;
//        [self.navigationController popViewControllerAnimated:YES];
//        return NO;
//    }
//    return YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
