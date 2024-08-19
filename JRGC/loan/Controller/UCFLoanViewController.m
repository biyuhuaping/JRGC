//
//  UCFLoanViewController.m
//  JRGC
//
//  Created by njw on 2017/3/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFLoanViewController.h"

@interface UCFLoanViewController ()

@end

@implementation UCFLoanViewController
//需要加上这个 要不初始化不了webView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)refreshWebContent
{
    [self gotoURL:self.url];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshWebContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebContent) name:IS_RELOADE_URL object:nil];
    // Do any additional setup after loading the view from its nib.
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight-TabBarHeight)];
//    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
//    self.webView.scrollView.bounces = NO;
    [self addRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////只要是豆哥商城的都去掉导航栏
//- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//}
//
//
//#pragma mark - webViewDelegite
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    self.loadCount ++;
//    DDLogDebug(@"webViewDidStartLoad");
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    self.loadCount --;
//    DDLogDebug(@"webViewDidFinishLoad");
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    // Disable callout
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//    [self.webView.scrollView.header endRefreshing];
//    
//    self.requestLastUrl = [NSString stringWithFormat:@"%@",self.webView.request.URL.absoluteString];
//    
//    DDLogDebug(@"%@",self.requestLastUrl);
//    
//    if (!self.errorView.hidden) {
//        self.errorView.hidden = YES;
//    }
//    
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    self.loadCount --;
//    DDLogDebug(@"webViewdidFailLoadWithError");
//    [self.webView.scrollView.header endRefreshing];
//    if([error code] == NSURLErrorCancelled)
//    {
//        DDLogDebug(@"Canceled request: %@", [webView.request.URL absoluteString]);
//        return;
//    }
//    self.errorView.hidden = NO;
//    
//}
//- (void)refreshBackBtnClicked:(id)sender fatherView:(UIView *)fhView
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        //        if(self.isTabbarfrom){
//        //            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        //            [app.tabBarController  setSelectedViewController:self.rootVc];
//        //        }
//    }];
//    
//}

@end
