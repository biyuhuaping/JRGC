//
//  UCFNewMallWebViewController.m
//  JRGC
//
//  Created by zrc on 2019/4/9.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewMallWebViewController.h"
#import "UCFNewSubMallWebViewController.h"
@interface UCFNewMallWebViewController ()
{
    BOOL showTabBar;
}
@end

@implementation UCFNewMallWebViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.view.backgroundColor = [Color color:PGColorOptionThemeWhite];
//    [self ddd];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSLog(@"%@",request.URL.absoluteString);
    NSString *requetRUL = request.URL.absoluteString;
    if ([requetRUL isEqualToString:@"https://m.dougemall.com/static/mall/home/index.html?fromAppBar=true"] || [requetRUL isEqualToString:@"https://m.dougemall.com/?fromAppBar=true"]) {
        showTabBar = YES;
    } else {
        showTabBar = NO;
    }
    [self.view setNeedsLayout];
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (showTabBar) {
        [SingGlobalView.tabBarController.tabBar setHidden:NO];
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - SingGlobalView.tabBarController.tabBar.frame.size.height);
        self.webView.frame = CGRectMake(0, StatusBarHeight1, ScreenWidth, CGRectGetHeight(self.view.frame));
    } else {
        [SingGlobalView.tabBarController.tabBar setHidden:YES];
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.webView.frame = CGRectMake(0, StatusBarHeight1, ScreenWidth, CGRectGetHeight(self.view.frame) - StatusBarHeight1);
    }
    [super webViewDidFinishLoad:webView];
}
//- (void)ddd
//{
//    [self.KVOController observe:SingGlobalView.tabBarController.tabBar keyPaths:@[@"hidden"] options:NSKeyValueObservingOptionNew  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
//        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
//        if ([keyPath isEqualToString:@"hidden"]) {
//            BOOL hide = [[change valueForKey:@"new"] boolValue];
//            if (hide) {
//                NSLog(@"隐藏");
//            } else {
//                NSLog(@"显示");
//            }
//        }
//    }];
//}
-(void)monitorUserGetOut
{
    [self.webView reload];
}
- (void)monitorUserLogin
{
    [self.webView reload];
}
@end
