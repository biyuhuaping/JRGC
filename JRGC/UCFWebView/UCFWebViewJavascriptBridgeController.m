

//  UCFWebViewJavascriptBridgeController.m
//  JRGC
//
//  Created by 狂战之巅 on 16/7/18.
//  Copyright © 2016年 qinwei. All rights reserved.、
//

#import "AppDelegate.h"
#import "Common.h"
#import "NSString+URL.h"
#import "UCFContributionValueViewController.h"//工分详情
#import "UCFCouponViewController.h"
#import "UCFFacCodeViewController.h"
#import "UCFInvestmentDetailViewController.h"
#import "UCFLoginViewController.h"
#import "UCFMyFacBeanViewController.h"
#import "UCFRedEnvelopeViewController.h"
#import "UCFRegisterStepOneViewController.h"
#import "UCFToolsMehod.h"
#import "UCFTopUpViewController.h"
#import "UCFWebViewJavascriptBridgeController.h"
#import "UCFWorkPointsViewController.h"
//#import "UMSocial.h"
#import "UMSocialUIManager.h"
//#import "UMSocialManager.h"

#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "UCFFeedBackViewController.h"//邀请返利
#import "TradePasswordVC.h"
#define MALLTIME  12.0
#define SIGNATURETIME 30.0



@interface UCFWebViewJavascriptBridgeController ()<UMSocialPlatformProvider,UIScrollViewDelegate,NSURLConnectionDataDelegate>


//@property (nonatomic, assign) JavascriptBridgeWebType webType;

@property (strong, nonatomic) UIImage *shareImage;

@property (strong, nonatomic) NSString *shareTitle;

@property (strong, nonatomic) NSString *shareContent;

@property (strong, nonatomic) NSString *shareUrl;

@property (strong, nonatomic) UIProgressView *progressView; //webView的进度条

//@property(nonatomic,strong)NSMutableData *dataM; //存储data数据
@end

@implementation UCFWebViewJavascriptBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setController];    //初始化当前控制器的一些属性
//    [self addRefresh];       //添加下拉刷新
    [self tableViewAddTouch];//去掉长按手势
    [self setWebView];       //初始化webView 并加入js
    [self subErrorView];     //添加404页

}
/*- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self endRefresh];
}*/

- (void)setController
{
    
    [self addLeftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewReload) name:BACK_TO_BANNER object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewLoginBack) name:BACK_TO_LOGIN object:nil];
   
    
    if (!(nil == self.navTitle) || ![self.navTitle isEqualToString:@""])
    {
        baseTitleLabel.text = self.navTitle;
    }
}

- (void)subShar
{
    [self addRightButtonWithName:@"分享"];
    [self addRightButtonWithImage:[UIImage imageNamed:@"btn_share"]];
}


/**
 移除下拉刷新
 */
- (void)removeRefresh
{
     [self.webView.scrollView removeHeader]; //移除下拉刷新
}

- (void)subErrorView
{
    //[self endRefresh];//***qyy
    //添加404页面
    self.errorView = [[UCF404ErrorView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) errorTitle:@"网络不给力呀\n点击屏幕重新加载"];
    self.errorView.hidden = YES;
    self.errorView.delegate = self;
    [self.webView addSubview:self.errorView];
}
- (void)addErrorViewButton
{
    //豆哥商城2级页面才会有在404页面上的返回按钮
    [self.errorView addBackBtnView];

}
- (void)setErrorViewFrame:(CGRect)newFrame
{
    self.errorView.frame = newFrame;
}

#pragma mark - 添加返回按钮
- (void)getToBack {

    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark webView去掉长按手势
- (void)tableViewAddTouch
{
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:nil];
    longPressReger.minimumPressDuration = 0.4;
    [self.webView addGestureRecognizer:longPressReger];
}

#pragma mark - 下拉刷新部分

- (void)addRefresh
{
    // 下拉刷新
    [self.webView.scrollView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(webViewReload)];
}

- (void)beginRefresh
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endRefresh
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//点击屏幕重新刷新
- (void)refreshBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    [self webViewReload];
}

- (void)refreshBackBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewReload
{
   /* NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage cookies];*/
    
    
    if(self.webView.isLoading)
    {
        [self.webView stopLoading];
    }
    
    if (self.requestLastUrl.length > 1)
    {
        [self.webView reload]; //已经请求过一次，获得了 url
    }
    else
    {
        //一直没有请求成功，就重新添加 NSURLRequest
        [self gotoURL:self.url];
    }
    self.requestLastUrl = @"";//清空临时的记录
}
- (void)webViewLoginBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化webView 并加入js

- (void)setWebView
{
    if (_bridge) { return; }
    
    _webView.backgroundColor=[UIColor clearColor];
    _webView.scalesPageToFit = YES;
    self.webView.delegate = self;
//    self.webView.scrollView.delegate  = self; //在类中去实现该代理
    for (UIView *subView in [_webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
//            ((UIScrollView *)subView).bounces = YES; //去掉UIWebView的底图
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:NO]; //底下的滚动条
            for (UIView *scrollview in subView.subviews)
            {
                if ([scrollview isKindOfClass:[UIImageView class]])
                {
                    scrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"nativeCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        DBLOG(@"testObjcCallback called: %@", data);
        
        NSDictionary *nativeData = data;
        if (nil == nativeData || [nativeData isKindOfClass:[NSNull class]] || nativeData.count == 0 || !nativeData[@"action"])
        {
            return ;
        }
        
        if ([nativeData[@"action"] isEqualToString:@"login"] )
        {
            //登录后跳转到商城页面
            //{
            //action: "login",
            //value: "url"
            //}
            
            //带跳转链接直接跳转
            [weakSelf jsLogin:nativeData];
        }
        else if ([nativeData[@"action"] isEqualToString:@"goto"])
        {
            //跳转到指定页面页面
            //{
            //action: "goto",
            //value: "url"
            //}
            
            if (nativeData[@"value"])
            {
                [weakSelf jsGoto:nativeData];
            }
        }
        else if ([nativeData[@"action"] isEqualToString:@"close"])
        {
            //关闭当前页面
            //{
            //action: "close"
            //}
            [weakSelf jsClose];
        }
        else if ([nativeData[@"action"] isEqualToString:@"show_back_button"])
        {
            //显示后退按钮
            //{
            //action: "show_back_button"
            //}
            //[self addLeftButton];
            [weakSelf jsShowBackButton];
        }
        else if ([nativeData[@"action"] isEqualToString:@"hide_back_button"])
        {
            //隐藏后退按钮
            //{
            //action: "hide_back_button"
            //}
            [weakSelf jsHideBackButton];
        }
        else if ([nativeData[@"action"] isEqualToString:@"show_close_button"])
        {
            //显示关闭按钮
            //{
            //action: "show_close_button"
            //}
            [weakSelf jsShowCloseButton];
        }
        else if ([nativeData[@"action"] isEqualToString:@"hide_close_button"])
        {
            //隐藏关闭按钮
            //{
            //action: "hide_close_button"
            //}
            [weakSelf jsHideCloseButton];
        }
        else if ([nativeData[@"action"] isEqualToString:@"ajax_start"])
        {
            //ajax开始
            //{
            //action: "ajax_start"
            //}
            //[weakSelf beginRefresh];
        }
        else if ([nativeData[@"action"] isEqualToString:@"ajax_complete"])
        {
            //ajax完成
            //{
            //action: "ajax_complete"
            //}
            //[weakSelf endRefresh];
        }
        else if ([nativeData[@"action"] isEqualToString:@"set_title"])
        {
            //设置标题
            //{
            //action: "set_title",
            //value: "xxx"
            //}
            [weakSelf jsSetTitle:nativeData[@"value"]];
        }
        else if ([nativeData[@"action"] isEqualToString:@"redirectMall"])
        {
            //另外约定下工分说明页面豆哥商城的a标签事件：
            //function bridgeApp(){
            //NativeBridge.bridge.callHandler('nativeCallback', {
            //action: 'redirectMall',
            //value:'http://mmall.9888.cn'
            //);
            //}
            [weakSelf jsRedirectMall];
        }
        else if ([nativeData[@"action"] isEqualToString:@"toNative"])
        {
            
            [weakSelf jsToNative:nativeData[@"value"]];
        }
        //----------------------------------------------------------------------------------------------------qyy
        else if ([nativeData[@"action"] isEqualToString:@"app_invest_detail"]) //投标成功 跳转到 投资详情
        {
            // 投资详情
            [weakSelf jsToInvestDetail:nativeData];//***跳入订单详情页面qyy
        }
        else if ([nativeData[@"action"] isEqualToString:@"app_invest_tran_detail"]) //债转投标成功 跳转到 投资详情
        {
            // 债转详情
            [weakSelf jsToInvestTranDetail:nativeData];//***跳入订单详情页面qyy
        }
        else if ([nativeData[@"action"] isEqualToString:@"app_open_hs_account"])
        {
            //跳转到徽商开户流程
            UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        //----------------------------------------------------------------------------------------------------qyy
        
       /* else if ([nativeData[@"action"] isEqualToString:@"app_invest_error"]) //投标成功 跳转到 投资详情
        {
            [weakSelf jsToNativeHomeWithDic:nativeData];//跳入订单详情页面qyy
        }*/
    }];
}

#pragma mark - 加载地址

- (void)gotoURL:(NSString *)url
{
    [self createUrlRequest:nil withNSURL:[NSURL URLWithString:url]];
}
- (void)gotoURLWithSignature:(NSString *)requestUrl
{
    NSURL *url = [NSURL URLWithString: requestUrl];
    
    NSString * requestStr = [Common getParameterByDictionary:self.webDataDic];
    [self createUrlRequest:requestStr withNSURL:url];
}
//创建请求

- (void)createUrlRequest:(NSString *)isSignature withNSURL:(NSURL *)url
{
    
    NSMutableURLRequest *request;
    NSTimeInterval time = SIGNATURETIME;
    if (isSignature)
    {
        request = [NSMutableURLRequest requestWithURL:url
                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                      timeoutInterval:time];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [isSignature dataUsingEncoding: NSUTF8StringEncoding]];
    }
    else
    {
        if ([self isKindOfClass:[UCFWebViewJavascriptBridgeMall class]] || [self isKindOfClass:[UCFWebViewJavascriptBridgeMallDetails class]])
        {
            time = MALLTIME;
        }
        request = [NSMutableURLRequest requestWithURL:url
                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                      timeoutInterval:time];
        [request setHTTPMethod: @"GET"];
    }
    
    [self monitoringRequest:request];
    
}

/**
 监听该请求是否超时
 
 @param request 是否需要验签都进行监听
 */
- (void)monitoringRequest:(NSMutableURLRequest *)request
{
    if (self.webView.isLoading)
    {
        [self.webView stopLoading];
    }
    [self.webView loadRequest:request];
    
    if (self.theConnection)
    {
        [self.theConnection cancel];
        //        SAFE_RELEASE(theConnection);
        DBLOG(@"safe release connection");
    }
    if ([request.HTTPMethod isEqualToString:@"GET"])
    {
        self.theConnection= [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.theConnection) {
        //        SAFE_RELEASE(theConnection);
        NSLog(@"safe release connection");
    }
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]){
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if ((([httpResponse statusCode]/100) == 2)){
            NSLog(@"connection ok");
            if (!self.errorView.hidden )
            {
                self.errorView.hidden = YES;
            }
        }
        else
        {
            
            [self.webView stopLoading];
            [self.webView.scrollView.header endRefreshing];
            self.errorView.hidden = NO;
            //NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:nil];
            //if ([error code] / 100 == 4 || [error code] / 100 == 5){
                //NSLog(@"404");
                ////                [self openNextLink];
            //}
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if (self.theConnection) {
        //        SAFE_RELEASE(theConnection);
        DBLOG(@"safe release connection");
    }
    //    if (loadNotFinishCode == NSURLErrorCancelled)  {
    //        return;
    //    }
    [self.webView stopLoading];
    [self.webView.scrollView.header endRefreshing];
    [self endRefresh];
    self.errorView.hidden = NO;
    //if (!self.errorView.hidden ) {
        //self.errorView.hidden = NO;
    //}
    //if (error.code == 22) //The operation couldn’t be completed. Invalid argument
        ////        [self openNextLink];
        //NSLog(@"22");
    //else if (error.code == -1001) //The request timed out.  webview code -999的时候会收到－1001，这里可以做一些超时时候所需要做的事情，一些提示什么的
        ////        [self openNextLink];
        //NSLog(@"-1001");
    //else if (error.code == -1005) //The network connection was lost.
        ////        [self openNextLink];
        //NSLog(@"-1005");
    //else if (error.code == -1009){ //The Internet connection appears to be offline
        ////do nothing
        //NSLog(@"-1009");
    //}
}
-(void)addProgressView{
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 2)];
    //progressView.tintColor = WebViewNav_TintColor;
    progressView.tintColor = UIColorWithRGB(0xfd4d4c);
    progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:progressView];
    [self.view insertSubview:self.webView belowSubview:progressView];
    self.progressView = progressView;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}
// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    DBLOG(@"loadCount----->>>>>%d",loadCount);
    if (_loadCount == 0) {
       
        [self.progressView setProgress:1 animated:YES];
        [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:0.25];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (_loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        DBLOG(@"newP----->>>>>%f",newP);
        [self.progressView setProgress:newP animated:YES];
        
    }
}
-(void)hideProgressView{
    [self.progressView setProgress:0 animated:NO];
    self.progressView.hidden = YES;
}

#pragma mark - webViewDelegite
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loadCount ++;
    DBLOG(@"webViewDidStartLoad");
//    [self beginRefresh];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    DBLOG(@"webViewDidFinishLoad");
//    [self endRefresh];
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
//    [self endRefresh];
    DBLOG(@"webViewdidFailLoadWithError");
    [self.webView.scrollView.header endRefreshing];
    if([error code] == NSURLErrorCancelled)
    {
        DBLOG(@"Canceled request: %@", [webView.request.URL absoluteString]);
        return;
    }
    self.errorView.hidden = NO;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    if ([requestString newRangeOfString:@"jrgc://9888.cn/?key=sjgl"])
    {
        DBLOG(@"这个字符串中有\n");
       // [self pushWebView:LEVELURLSHENGJI withTitle:@"升级攻略"];
        UCFWebViewJavascriptBridgeLevel*vc = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        // vc.title = @"会员等级";
        vc.url = LEVELURLSHENGJI;
        vc.navTitle = @"升级攻略";
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    else if ([requestString newRangeOfString:@"jrgc://9888.cn/?key=gfxq"])
    {
        DBLOG(@"这个字符串中有\n");
        UCFWebViewJavascriptBridgeLevel*vc = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        // vc.title = @"会员等级";
        vc.url = LEVELURLXIANGQING;
        vc.navTitle = @"玩转工分";
        [self.navigationController pushViewController:vc animated:YES];
        //[self pushWebView:LEVELURLXIANGQING withTitle:@"玩转工分"];
        return NO;
    }
    else if ([requestString newRangeOfString:@"http://m.9888.cn/static/wap/reset-deal-password/index.html"])
    {
        DBLOG(@"这个字符串中有\n");
        TradePasswordVC * tradePasswordVC = [[TradePasswordVC alloc]initWithNibName:@"TradePasswordVC" bundle:nil];
        tradePasswordVC.title = @"修改交易密码";
        tradePasswordVC.isCompanyAgent = [UserInfoSingle sharedManager].companyAgent;
        [self.navigationController pushViewController:tradePasswordVC  animated:YES];
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - 跳转到登录

- (void)jsLogin:(NSDictionary *)dic
{
    [self jumpLogin];
}
- (void)jsClose
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)jumpLogin
{
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    loginViewController.sourceVC = @"webViewLongin";
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNaviController animated:YES completion:nil];
}
//跳转到App 原生界面 规则从哪来回哪去
-(void)jsGotoAppBackNative{
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.isTabbarfrom){
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [app.tabBarController  setSelectedViewController:self.rootVc];
        }
    }];
}

- (void)jsGoto:(NSDictionary *)dic
{
    BOOL islogin = [dic[@"need_login"] boolValue];
    //判断首页是否需要登录,只有需要登录并且未登录才调登录
    if (islogin && (![[NSUserDefaults standardUserDefaults] valueForKey:UUID]))
    {
        //没有登录去调登录
        [self jumpLogin];
    
    }
    else
    {
        UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
        web.url = [dic objectSafeForKey:@"value"];
        [self.navigationController pushViewController:web animated:YES];
        
    }
    
//    UCFWebViewJavascriptBridgeMallDetails *web = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
//    web.url = [dic objectSafeForKey:@"value"];
//    [self.navigationController pushViewController:web animated:YES];

}

- (void)jsShowBackButton
{
    [self addLeftButton];
}
- (void)jsHideBackButton
{
    self.navigationItem.leftBarButtonItem= nil;
}
- (void)jsShowCloseButton
{
    
}
- (void)jsHideCloseButton
{
    
}
- (void)jsAjaxStart
{
    
}
- (void)jsAjaxComplet
{
    
}
//----------------------------------------------------------------------------------------------------qyy
//***投资成功页面走该方法（新增在子类中使用）
- (void)jsToInvestDetail:(NSDictionary *)_dic
{
    
}
//***投资成功页面走该方法（新增在子类中使用）
- (void)jsToInvestTranDetail:(NSDictionary *)_dic
{
    
}
/*- (void)jsToNativeHomeWithDic:(NSDictionary *)_dic
{
    //投资异常进入的页面
}*/
//----------------------------------------------------------------------------------------------------qyy
//***无验签跳转页面走该方法
- (void)jsToNative:(NSString *)controllerName
{
    
    ///** 跳转到我的贡献值 */
    //app_contribute_detail
    ///** 跳转到立即投资 */
    //public final static String JS_TO_INVEST_IMMEDIATELY = "app_invest_immediately";
    ///** 跳转到优惠券 */
    //public final static String JS_TO_COUPON = "app_coupon";
    ///** 跳转到工豆 */
    //public final static String JS_TO_BEAN = "app_bean";
    ///** 跳转到红包 */
    //public final static String JS_TO_RED_PACKAGE = "app_red_package";
    ///** 跳转到会员等级 */
    //public final static String JS_TO_VIP_LEVEL = "app_vip_level";
    ///** 跳转到充值 */
    //public final static String JS_TO_RECHARGE = "app_recharge";
    ///** 跳转到工场码 */
    //public final static String JS_TO_FACTORY_BARCODE = "app_factory_barcode";
    /** 跳转到工分 */
    //public final static String JS_TO_SCORES = "app_scores";
    ///** 跳转到升级攻略 */
    //public final static String JS_TO_UPGRADE_STRATEGY = "app_upgrade_strategy";
    ///** 跳转到我的商城 */
    //public final static String JS_TO_MY_MAIL = "app_my_mail";
    ///** 跳转到邀请返利 */
    //public final static String JS_TO_MY_MAIL = "app_invite_interest";
    
    if (!(![controllerName isEqualToString:@"app_upgrade_strategy"] ||![controllerName isEqualToString:@"app_register"] ||![controllerName isEqualToString:@"app_invest_immediately"] || ![controllerName isEqualToString:@"app_invite_interest"]|| ![controllerName isEqualToString:@"app_contribute_detail"])) //这个页面不需要登录所以需要判断，如果是进这个页面，直接去加载，不再调登录
    {
        if (! [[NSUserDefaults standardUserDefaults] valueForKey:UUID])
        {
            //直接调登录
            [self jumpLogin];
            return;
        }
    }
    
    if ([controllerName isEqualToString:@"app_invest_immediately"])
    {
        //跳转到立即投资
        //?????????????
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([controllerName isEqualToString:@"app_contribute_detail"]) //这个页面不需要登录所以需要判断，如果是进这个页面，直接去加载，不再调登录
    {
        UCFContributionValueViewController *a = [[UCFContributionValueViewController alloc] initWithNibName:@"UCFContributionValueViewController" bundle:nil];
        a.title = @"我的贡献值";

        [self.navigationController pushViewController:a animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_coupon"]) 
    {
        //跳转到优惠券
        UCFCouponViewController *subVC = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
//        subVC.isGoBackShowNavBar = YES;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_bean"])
    {
        //跳转到工豆
        UCFMyFacBeanViewController *subVC = [[UCFMyFacBeanViewController alloc] initWithNibName:@"UCFMyFacBeanViewController" bundle:nil];
        subVC.title = @"我的工豆";
//        subVC.isGoBackShowNavBar = YES;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_red_package"])
    {
        //跳转到红包
        UCFRedEnvelopeViewController *subVC = [[UCFRedEnvelopeViewController alloc] initWithNibName:@"UCFRedEnvelopeViewController" bundle:nil];
        subVC.title = @"我的红包";
//        subVC.isGoBackShowNavBar = YES;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_vip_level"])
    {
        //跳转到会员等级
        UCFWebViewJavascriptBridgeLevel*vc = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
       // vc.title = @"会员等级";
        vc.url = LEVELURL;
        vc.navTitle = @"会员等级";
        [self.navigationController pushViewController:vc animated:YES];
        
        //[self pushWebView:LEVELURL withTitle:@"会员等级"];
    }
    else if ([controllerName isEqualToString:@"app_recharge"])
    {
        //跳转到充值
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
        UCFTopUpViewController * vc1 = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
        vc1.title = @"充值";
        vc1.uperViewController = self;
        //            vc1.dataDict = dic;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_factory_barcode"])
    {
        //跳转到工场码
        //#import "UCFFacCodeViewController.h"
        UCFFacCodeViewController *code = [[UCFFacCodeViewController alloc] initWithNibName:@"UCFFacCodeViewController" bundle:nil];
        code.urlStr = [NSString stringWithFormat:@"http://m.9888.cn/mpwap/mycode.jsp?pcode=%@&sex=%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserMsg"]valueForKey:@"promotioncode"],[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserMsg"]valueForKey:@"sex"]];
//        code.isGoBackShowNavBar = YES;
        [self.navigationController pushViewController:code animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_scores"])
    {
        //跳转到工分
        UCFWorkPointsViewController *subVC = [[UCFWorkPointsViewController alloc]initWithNibName:@"UCFWorkPointsViewController" bundle:nil];
        subVC.title = @"我的工分";
//        subVC.isGoBackShowNavBar = YES;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_upgrade_strategy"])
    {
        //跳转到升级攻略
        UCFWebViewJavascriptBridgeLevel *vc = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        vc.url = LEVELURLSHENGJI;
        vc.navTitle = @"升级攻略";
        [self.navigationController pushViewController:vc animated:YES];
       // [self pushWebView:LEVELURLSHENGJI withTitle:@"升级攻略"];
        
    }
    else if ([controllerName isEqualToString:@"app_invite_interest"])
    {
        //邀请返利
        UCFFeedBackViewController *vc = [[UCFFeedBackViewController alloc] initWithNibName:@"UCFFeedBackViewController" bundle:nil];
        vc.title = @"邀请返利";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([controllerName isEqualToString:@"app_my_mall"])
    {
        //跳转到我的商城
        //[self pushWebView:[NSString stringWithFormat:@"%@/user",MALLURL] withTitle:@"我的商城"];
        
        
        UCFWebViewJavascriptBridgeMallDetails *mall = [[UCFWebViewJavascriptBridgeMallDetails alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMallDetails" bundle:nil];
        ////mall.url = [dic objectSafeForKey:@"value"];
        mall.url = [NSString stringWithFormat:@"%@/user",MALLURL];
        [self.navigationController pushViewController:mall animated:YES];
        
    }
    else if ([controllerName isEqualToString:@"app_register"])
    {
        //跳转到注册页
        UCFRegisterStepOneViewController *registerControler = [[UCFRegisterStepOneViewController alloc] init];
        registerControler.sourceVC = @"webView";
        UINavigationController *regNaviController = [[UINavigationController alloc] initWithRootViewController:registerControler];
        [self presentViewController:regNaviController animated:YES completion:nil];
    }
    //----------因nativeData[@"action"]值等于@"toNative"，需要重新写sToNative:方法。需要等鸿龙处理，故暂且放在此处------------------qyy
    else if ([controllerName isEqualToString:@"app_fanxiCoupon"]) //跳到反息劵界面
    {
        UCFCouponViewController *coupVC = [[UCFCouponViewController alloc]initWithNibName:@"UCFCouponViewController" bundle:nil];
        coupVC.segmentIndex = 1;
        [self.navigationController pushViewController:coupVC animated:YES];
    }else if ([controllerName isEqualToString:@"app_withdraw"])//提现成功页面红色按妞
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];  
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([controllerName  isEqualToString:@"app_withdraw_recharge"])//提现失败页面
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([controllerName  isEqualToString:@"app_invest_suc"])//成功标识，投标、提现
    {
        //[self.navigationController popViewControllerAnimated:YES];
        [self jsInvestSuc:YES];
    }
    else if ([controllerName  isEqualToString:@"app_back_native"])//回到
    {
        //[self.navigationController popViewControllerAnimated:YES];
        [self jsGotoAppBackNative];
    }
    
    //----------------------------------------------------------------------------------------------------qyy
    else
    {
        DBLOG(@"没有符合的要求");
    }
    
    
}
- (void)jsSetTitle:(NSString *)title
{
    baseTitleLabel.text = title;
}

- (void)jsInvestSuc:(BOOL)isSuc
{
}

/*- (void)pushWebView:(NSString *)url withTitle:(NSString *)title
{
    UCFWebViewJavascriptBridgeController *vc = [[UCFWebViewJavascriptBridgeController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeController" bundle:nil];
    vc.url = url;
    vc.navTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}*/

#pragma mark - 跳转到商城
- (void)jsRedirectMall
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    [del.tabBarController setSelectedIndex:2];
    UCFWebViewJavascriptBridgeMall *mallWeb = [[UCFWebViewJavascriptBridgeMall alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
    mallWeb.url = MALLURL;
    mallWeb.rootVc = self;
    mallWeb.isHideNavigationBar = YES;
    [self useragent:mallWeb.webView];
//    mallWeb.navTitle = @"豆哥商城";
    mallWeb.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *mallWebNaviController = [[UINavigationController alloc] initWithRootViewController:mallWeb];
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:mallWebNaviController animated:YES completion:nil];
}
- (void)useragent:(UIWebView *)webView
{
    //我的需求是不光要能更改user-agent，而且要保留WebView 原来的user-agent 信息，也就是说我需要在其上追加信息。在stackOverflow上搜集了多方答案，最终汇总的解决方案如下：
    
    //在启动时，比如在AppDelegate 中添加如下代码：
    
    //get the original user-agent of webview
    //UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:@"FinancialWorkshop"];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    //这样，WebView在请求时的user-agent 就是我们设置的这个了，如果需要在WebView 使用过程中再次变更user-agent，则需要再通过这种方式修改user-agent， 然后再重新实例化一个WebView。
}

- (void)dealloc
{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACK_TO_BANNER object:nil];
    [self endRefresh];
}


#pragma mark - 友盟的分享
-(void)clickRightBtn{
    
    if(self.dicForShare == nil)
    {
        return;
    }
    _shareUrl = self.dicForShare.url;
    
    _shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dicForShare.thumb]]];
    _shareTitle = self.dicForShare.title;
    _shareContent = self.dicForShare.desc;
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_Qzone];
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_QQ];
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_WechatFavorite];
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_WechatFavorite];
    __weak typeof(self) weakSelf = self;
    //显示分享面板 （自定义UI可以忽略）
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView,UMSocialPlatformType platformType) {
        [weakSelf shareDataWithPlatform:platformType withObject:messageObject];
    }];
}
//直接分享
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType withObject:(UMSocialMessageObject *)object
{
    UMSocialMessageObject *messageObject = object;
    if (platformType == UMSocialPlatformType_Sina) {
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:_shareTitle descr:_shareContent thumImage:[UIImage imageNamed:@"AppIcon"]];
        [shareObject setShareImage:self.dicForShare.thumb];
        messageObject.shareObject = shareObject;
        messageObject.text = [NSString stringWithFormat:@"%@%@",_shareContent,_shareUrl];
    } else {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:_shareContent thumImage:_shareImage];
        [shareObject setWebpageUrl:_shareUrl];
        messageObject.shareObject = shareObject;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
            if (platformType == UMSocialPlatformType_Sina) {
                if ([messageObject.text newRangeOfString:@"appmercyparameter"]) {
                    [self post:_shareUrl];
                }
            } else {
                UMShareWebpageObject *obj = messageObject.shareObject;
                if ([obj.webpageUrl newRangeOfString:@"appmercyparameter"]) {
                    [self post:_shareUrl];
                }
            }
        }
        else{
            if (error) {
                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            }
            else{
                message = [NSString stringWithFormat:@"分享失败"];
            }
        }
    }];
}


//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    ///分享成功后调用
//    if ([_shareUrl newRangeOfString:@"appmercyparameter"])
//    {
//        //如果是php的才调这个接口
//        [self post:_shareUrl];
//    }
//}
//
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//    if (platformName == UMShareToSina || platformName == UMShareToTencent) {
//        socialData.shareText = [NSString stringWithFormat:@"%@%@",_shareContent,_shareUrl];
//    }
//    
//}


-(void)post:(NSString *)parameUrl
{
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://wx.9888.cn/weixin/share/index"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //5.设置请求体
    NSDictionary *dic =  [NSDictionary dictionaryWithObjectsAndKeys:parameUrl,@"appmercyparameter",@"ios",@"type", nil];
    
    //设置请求体
    NSString *param=[NSString stringWithFormat:@"%@",[self dictionaryToJson:dic]];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     26      第一个参数：请求对象
     27      第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     28                 data：响应体信息（期望的数据）
     29                 response：响应头信息，主要是对服务器端的描述
     30                 error：错误信息，如果请求失败，则error有值
     31      */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        DBLOG (@"%@",dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



#pragma mark - 投标、设置交易密码、输入交易密码 - 验签方法
//----------------------------------------------------------------------------------------------------qyy
//- (NSString *)signatureString
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.webDataDic];
//    [dict setValue:@"1" forKey:@"sourceType"];
//    [dict setValue:[Common getKeychain] forKey:@"imei"];
//    [dict setValue:[Common getIOSVersion] forKey:@"version"];
    
    //是否需要验签
//    NSString *signature = [self getSinatureWithPar:[self newGetParStr:dict]];
//    [dict setValue:signature forKey:@"signature"];
    //对整体参数加密
//    NSString * encryptParam  = [Common AESWithKey2:AES_TESTKEY WithDic:dict];
//    NSString *  dataStr = [NSString stringWithFormat:@"encryptParam=%@",encryptParam];
//    
//    return [Common getParameterByDictionary:self.webDataDic];
//}
//***新版通过字典获取值拼成的字符串 新增函数-qyy-002
- (NSString *)newGetParStr:(NSDictionary *)dataDict
{
    NSArray *valuesArr = [dataDict allValues];
    NSString *lastStr = @"";
    if (!valuesArr || valuesArr.count > 0) {
        for (int i = 0; i< valuesArr.count; i++) {
            lastStr = [lastStr stringByAppendingString:[valuesArr objectAtIndex:i]];
        }
    }
    return lastStr;
}
//***新增函数-qyy-003
-(NSString *) getSinatureWithPar:(NSString *) par
{
    NSString *lastStr = [NSString stringWithFormat:@"%@%@",par,[[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP]];
    //    NSString *stttt  = [[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP];
    //遍历字符串中的每一个字符
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[lastStr length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [lastStr substringWithRange:NSMakeRange(i, 1)];
        [array addObject:[NSString stringWithFormat:@"%@",s]];
    }
    NSArray *lastArray =[array sortedArrayUsingSelector:@selector(compare:)];
    NSString * str55 = [lastArray componentsJoinedByString:@","];
    NSString *str66 = @"[";
    NSString *str77 = @"]";
    NSString *str88 = [[str66 stringByAppendingString:str55] stringByAppendingString:str77];
    return [UCFToolsMehod md5:str88];
}
//----------------------------------------------------------------------------------------------------qyy
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NSURLSessionDataDelegate代理方法
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
//{
//    NSLog(@"challenge = %@",challenge.protectionSpace.serverTrust);
//    //判断是否是信任服务器证书
//    if (challenge.protectionSpace.authenticationMethod ==NSURLAuthenticationMethodServerTrust)
//    {
//        //创建一个凭据对象
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        //告诉服务器客户端信任证书
//        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//        
//    }
//}
/**
*  接收到服务器返回的数据时调用
*/
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    NSLog(@"接收到的数据%zd",data.length);
//    [self.dataM appendData:data];
//}
/**
 *  请求完毕
 */
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSString *html = [[NSString alloc]initWithData:self.dataM encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"请求完毕");
////    [self.webView loadHTMLString:html baseURL:self.url];
//}
//- (NSMutableData *)dataM
//{
//    if (_dataM == nil)
//    {
//        _dataM = [[NSMutableData alloc]init];
//    }
//    return _dataM;
//}
@end
