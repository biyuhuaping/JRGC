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
//    BOOL showTabBar;
    BOOL firstLoad;
}
@property(nonatomic, assign)BOOL showTabBar;
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!firstLoad) {
        [self monitorFrame];
    }
    firstLoad = YES;

}
- (void)updateFrame
{
    [self dealTabBar];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.view.backgroundColor = [Color color:PGColorOptionThemeWhite];
//    [self monitorFrame];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSLog(@"%@",request.URL.absoluteString);
    NSString *requetRUL = request.URL.absoluteString;
    if ([requetRUL isEqualToString:@"https://m.dougemall.com/static/mall/home/index.html?fromAppBar=true"] || [requetRUL isEqualToString:@"https://m.dougemall.com/?fromAppBar=true"]) {
        _showTabBar = YES;
    } else {
        _showTabBar = NO;
    }
    [self.view setNeedsLayout];
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dealTabBar];
    [super webViewDidFinishLoad:webView];
}
- (void)dealTabBar
{
    if (_showTabBar) {
        [SingGlobalView.tabBarController.tabBar setHidden:NO];
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - SingGlobalView.tabBarController.tabBar.frame.size.height);
        self.webView.frame = CGRectMake(0, StatusBarHeight1, ScreenWidth, CGRectGetHeight(self.view.frame));
    } else {
        [SingGlobalView.tabBarController.tabBar setHidden:YES];
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.webView.frame = CGRectMake(0, StatusBarHeight1, ScreenWidth, CGRectGetHeight(self.view.frame) - StatusBarHeight1);
    }
}
- (void)monitorFrame
{
    @PGWeakObj(self);
    [self.KVOController observe:self.view keyPaths:@[@"frame"] options:NSKeyValueObservingOptionNew  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"frame"]) {
            CGRect rect = [((NSValue *)[change objectForKey:@"new"]) CGRectValue];
            
            if (selfWeak.showTabBar) {
                if (rect.size.height != ScreenHeight - SingGlobalView.tabBarController.tabBar.frame.size.height) {
                    [selfWeak dealTabBar];
                } else {
                    return ;
                }
                
            } else {
                if (rect.size.height != ScreenHeight) {
                    [selfWeak dealTabBar];
                } else {
                    return ;
                }
            }
        }
    }];
}
//现在剩下的问题是换账号登录 页面导致这个没有调用引起不刷新，明天来看下
-(void)monitorUserGetOut
{
    [self reSetLoadURL];
}
- (void)monitorUserLogin
{
    [self reSetLoadURL];
}
- (void)reSetLoadURL
{
    [self gotoURL:@"https://m.dougemall.com?fromAppBar=true"];
}
@end
