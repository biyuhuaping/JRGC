//
//  UCFExtractGoldDetailController.m
//  JRGC
//
//  Created by njw on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFExtractGoldDetailController.h"

@interface UCFExtractGoldDetailController ()

@end

@implementation UCFExtractGoldDetailController

//需要加上这个 要不初始化不了webView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self refreshWebContent];
    [self.webView reload];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight-TabBarHeight)];
    //    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    [self addRefresh];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    baseTitleLabel.text = titleHtmlInfo;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    if ([requestString isEqualToString:@"firstp2p://api?type=closeallpage"]) {
        UCFBaseViewController *baseVc = self.rootVc;
        UCFBaseViewController *desVc = baseVc.rootVc;
        [self.navigationController popToViewController:desVc animated:YES];
        return NO;
    }
    else if ([requestString isEqualToString:@"firstp2p://api?method=updatebacktype&param=3"]) {
        [self hideLeftButton];
        return NO;
    }
    return YES;
}

- (void)getToBack
{
    if ([baseTitleLabel.text isEqualToString:@"提金订单"]) {
        
    }
}

@end
