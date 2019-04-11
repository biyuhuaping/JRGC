//
//  UCFNewSubMallWebViewController.m
//  JRGC
//
//  Created by zrc on 2019/4/9.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewSubMallWebViewController.h"

@interface UCFNewSubMallWebViewController ()<UIWebViewDelegate>

@end

@implementation UCFNewSubMallWebViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSLog(@"%@",request.URL.absoluteString);
    NSString *requetRUL = request.URL.absoluteString;
    if ([requetRUL isEqualToString:@"https://m.dougemall.com/static/mall/home/index.html?fromAppBar=true"] || [requetRUL isEqualToString:@"https://m.dougemall.com/?fromAppBar=true"]) {
        UINavigationController *nav = SingGlobalView.tabBarController.selectedViewController;
        if ([nav.viewControllers indexOfObject:self] != 0) {
            [self.rt_navigationController popToRootViewControllerAnimated:YES complete:nil];
        }
    } 
    return result;
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
