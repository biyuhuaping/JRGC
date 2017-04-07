//
//  UCFWebViewJavascriptBridgeMall.m
//  JRGC
//
//  Created by 狂战之巅 on 16/9/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface UCFWebViewJavascriptBridgeMall ()
@end

@implementation UCFWebViewJavascriptBridgeMall

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_interactivePopDisabled = YES;
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    
//    [[UIApplication sharedApplication]  addObserver:self forKeyPath:@"statusBarStyle" options:NSKeyValueObservingOptionNew context:nil];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    DBLOG(@"-----");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//只要是豆哥商城的都去掉导航栏
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}
#pragma mark - webViewDelegite
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loadCount ++;
    DBLOG(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    DBLOG(@"webViewDidFinishLoad");
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    // Disable callout
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self.webView.scrollView.header endRefreshing];
    
    self.requestLastUrl = [NSString stringWithFormat:@"%@",self.webView.request.URL.absoluteString];
    
    DBLOG(@"%@",self.requestLastUrl);
    
    if (!self.errorView.hidden) {
        self.errorView.hidden = YES;
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadCount --;
    DBLOG(@"webViewdidFailLoadWithError");
    [self.webView.scrollView.header endRefreshing];
    if([error code] == NSURLErrorCancelled)
    {
        DBLOG(@"Canceled request: %@", [webView.request.URL absoluteString]);
        return;
    }
    self.errorView.hidden = NO;
    
}
- (void)refreshBackBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    [self dismissViewControllerAnimated:YES completion:^{
//        if(self.isTabbarfrom){
//            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            [app.tabBarController  setSelectedViewController:self.rootVc];
//        }
    }];

}
@end
