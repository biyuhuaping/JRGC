//
//  UCFNoticeViewController.m
//  JRGC
//
//  Created by njw on 2017/10/11.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFNoticeViewController.h"

@interface UCFNoticeViewController ()

@end

@implementation UCFNoticeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, 0.5, CGRectGetWidth(self.webView.frame), CGRectGetHeight(self.webView.frame));
    self.view.backgroundColor = UIColorWithRGB(0xeeeeee);
    [self.webView reload];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_COUPON_CENTER object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    //    self.webView.scrollView.bounces = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    DDLogDebug(@"webViewDidFinishLoad");
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self.webView.scrollView.header endRefreshing];
    
    self.requestLastUrl = [NSString stringWithFormat:@"%@",self.webView.request.URL.absoluteString];
    
    DDLogDebug(@"%@",self.requestLastUrl);
    
    if (!self.errorView.hidden) {
        self.errorView.hidden = YES;
    }
    if (baseTitleLabel.text.length == 0) {
        baseTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
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
