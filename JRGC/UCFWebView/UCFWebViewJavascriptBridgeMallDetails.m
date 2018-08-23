//
//  UCFWebViewJavascriptBridgeMallDetails.m
//  JRGC
//
//  Created by 狂战之巅 on 16/9/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UIDic+Safe.h"
#import "UCFLoginViewController.h"
#import "NSString+Misc.h"
@interface UCFWebViewJavascriptBridgeMallDetails ()

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
     self.webView.scrollView.bounces = NO;
}

//只要是豆哥商城的都去掉导航栏
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:!_isHidenNavigationbar animated:animated];
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
#pragma mark - 返回豆哥商城
- (void)jsRedirectMall{
    [self jsClose]; //这里是返回豆哥商城
}
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
    if (baseTitleLabel.text.length == 0) {
        baseTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
- (void)jumpLogin
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    loginViewController.sourceVC = @"webViewLongin";
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}

-(void)webViewReload
{
   
        NSDictionary *encryptParamDic = @{
                                          @"userId": [[NSUserDefaults standardUserDefaults] valueForKey:UUID]                 //用户id
                                          };
        [[NetworkModule sharedNetworkModule] newPostReq:encryptParamDic tag:kSXTagIntoCoinPage owner:self signature:YES Type:SelectAccoutTypeP2P];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    id ret = dic[@"ret"];
    NSString *messageStr = [dic objectSafeForKey:@"message"];
    if (tag.intValue == kSXTagIntoCoinPage)
    {
        if ([ret boolValue])
        {
            NSDictionary *coinRequestDicData = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"coinRequest"];
            NSDictionary *paramDict = [coinRequestDicData objectSafeDictionaryForKey:@"param"];
            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
            [data setValue:[NSString urlEncodeStr:[paramDict objectSafeForKey:@"encryptParam"]] forKey:@"encryptParam"];
            [data setObject:[paramDict objectSafeForKey:@"fromApp"] forKey:@"fromApp"];
            [data setObject:[paramDict objectSafeForKey:@"userId"] forKey:@"userId"];
            NSString * requestStr = [Common getParameterByDictionary:data];
            NSString *webUrl  = [NSString stringWithFormat:@"%@/#/?%@",[coinRequestDicData objectSafeForKey:@"urlPath"],requestStr];
            [self gotoURL:webUrl];
        }else{
            [AuxiliaryFunc showToastMessage:messageStr withView:self.view];
        }
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
