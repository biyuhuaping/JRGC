//
//  UCFWebViewJavascriptBridgeMallDetails.m
//  JRGC
//
//  Created by 狂战之巅 on 16/9/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UCFWebViewJavascriptBridgeMall.h"
@interface UCFWebViewJavascriptBridgeMallDetails ()<UIScrollViewDelegate>

@end

@implementation UCFWebViewJavascriptBridgeMallDetails


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
     [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.delegate = self;
//     self.webView.scrollView.bounces = YES;
}

//只要是豆哥商城的都去掉导航栏
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)jsClose
{
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[UCFWebViewJavascriptBridgeMall class]])
    {
        [self.navigationController.navigationBar setHidden:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[UCFWebViewJavascriptBridgeMall class]])
//    {
//        [self.navigationController.navigationBar setHidden:NO];
//    }
//}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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
#pragma mark - scrollView代理
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
    if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }else if (scrollView.contentOffset.y > scrollView.contentSize.height - ScreenHeight){
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - ScreenHeight);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }else if (scrollView.contentOffset.y > scrollView.contentSize.height - ScreenHeight){
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - ScreenHeight);
    }
}

@end
