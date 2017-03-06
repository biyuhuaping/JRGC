//
//  FullWebViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "FullWebViewController.h"
#import <UShareUI/UShareUI.h>


@interface FullWebViewController ()<UMSocialPlatformProvider>
{
    NSString *_webUrl;
    NSString *_title;
    NSString *_htmlStr;
    UIActivityIndicatorView *_activityIndicatorView;

}
@property (strong, nonatomic) UIImage  *shareImage;
@property (strong, nonatomic) NSString  *shareImageUrl;
@property (strong, nonatomic) NSString *shareTitle;
@property (strong, nonatomic) NSString *shareContent;
@property (strong, nonatomic) NSString *shareUrl;
@end

@implementation FullWebViewController

- (id)initWithWebUrl :(NSString*)url title:(NSString *)titleStr
{
    self = [super init];
    if (self) {
        _webUrl = url;
        _title = titleStr;
    }
    return self;
}

- (id)initWithHtmlStr:(NSString*)htmlStr title:(NSString *)titleStr
{
    self = [super init];
    if (self) {
        _title = titleStr;
        _htmlStr = htmlStr;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([_sourceVc isEqualToString:@"biddetail"]) {
        self.navigationController.navigationBarHidden = NO;
    }
    if([_sourceVc isEqualToString:@"topUpVC"] || [_sourceVc isEqualToString:@"huishangAccout"] || [_sourceVc isEqualToString:@"feedBackVC"] ||[_sourceVc isEqualToString:@"aboutUsVC"]){//充值页面
       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    
    //NSHTTPCookie *cookie;
    //NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //for (cookie in [storage cookies])
    //{
        //[storage deleteCookie:cookie];
    //}

//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    UIWebView *fullView = [[UIWebView alloc] init];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    if([_sourceVc isEqualToString:@"cashVC"]){//提现页面
     [self addheaderView];
     fullView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - NavigationBarHeight);
    }else{
      fullView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight);
    }
    
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
    [self.view addSubview:fullView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xebebee);
    [self.view addSubview:lineView];
    if (_webUrl) {
        [fullView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    } else {
        if (_htmlStr) {
            [fullView loadHTMLString:_htmlStr baseURL:nil];
        }
    }
    
    fullView.scalesPageToFit =YES;
    fullView.delegate =self;
    _activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [_activityIndicatorView setCenter: self.view.center] ;
    [_activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : _activityIndicatorView] ;

    if (!([self.baseTitleType isEqualToString:@"specialUser"] || [self.baseTitleType isEqualToString:@"detail_heTong"])) {
        [self addRightButtonWithName:@"分享"];
        [self addRightButtonWithImage:[UIImage imageNamed:@"btn_share"]];
    }
    
    if(self.dicForShare != nil)
    {
        _shareUrl = self.dicForShare.url;
        _shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dicForShare.thumb]]];
        _shareImageUrl = self.dicForShare.thumb;
        _shareTitle = self.dicForShare.title;
        _shareContent = self.dicForShare.desc;
    }
    if ([_sourceVc isEqualToString:@"UCFLatestProjectViewController"]) {//首页2017新手政策分享
        [self getAppSetting];//获取邀请链接的详细信息
    }
}
-(void)addheaderView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.bounds = CGRectMake(0, 0, 150, 30);
    titleLabel.center = CGPointMake(ScreenWidth/2,44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:UIColorWithRGB(0x333333)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = _title;
    [headerView addSubview:titleLabel];
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(ScreenWidth - 45, 30, 30, 24);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    [rightBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(dismissCashViewController) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:rightBtn];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame)-0.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [headerView addSubview:lineView];
    [self.view addSubview:headerView];
   
}
-(void)dismissCashViewController{
    [self dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}
-(void)clickRightBtn{
    
    
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];


    __weak typeof(self) weakSelf = self;
    //显示分享面板 （自定义UI可以忽略）
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareDataWithPlatform:platformType withObject:messageObject];
    }];
}
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType withObject:(UMSocialMessageObject *)object
{
    UMSocialMessageObject *messageObject = object;
    if (platformType == UMSocialPlatformType_Sina) {
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:_shareTitle descr:_shareContent thumImage:[UIImage imageNamed:@"AppIcon"]];
        [shareObject setShareImage:_shareImageUrl];
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
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//    if (platformName == UMShareToSina || platformName == UMShareToTencent) {
//        socialData.shareText = [NSString stringWithFormat:@"%@%@",_shareContent,_shareUrl];
//    }
//}

//获取分享各种信息
- (void)getAppSetting{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSDictionary *dataDict = @{};
    if (uuid != nil ) {
        dataDict = @{@"userId":uuid};
    }
    [[NetworkModule sharedNetworkModule]  newPostReq:dataDict tag:kSXTagGetShareMessage owner:self signature:YES];
}
//
//开始请求
- (void)beginPost:(kSXTag)tag{
    //    if (tag == kSXTagGetAppSetting)
    //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    
    /*
     data		object
     gcmDes	工场码描述	string
     gcmImg	工场码图片	string
     gcmTitle	工场码标题	string
     inviteUrl	邀请链接	string
     */
    BOOL rstcode = [dic[@"ret"] boolValue];
    if (tag.intValue == kSXTagGetShareMessage){
        if (rstcode) {
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            //1:红包URL   2：红包文字描述    3：工场码图片URL    4:工场码文字描述   5：红包标题  6：工场码标题
            
            _shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dataDict objectSafeForKey:@"gcmImg"]]]];//工场码图片URL
            _shareImageUrl = [dataDict objectSafeForKey:@"gcmImg"];//工场码图片URL
            _shareContent = [dataDict objectSafeForKey:@"gcmDes"];///工场码文字描述
            _shareTitle = [dataDict objectSafeForKey:@"gcmTitle"];//工场码标题
            _shareUrl = [dataDict objectSafeForKey:@"inviteUrl"];
        }
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagGetAppSetting) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!_title) {
        baseTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    }else
        baseTitleLabel.text = _title;

    [_activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alterview show];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]; ;
    if ([requestString rangeOfString:@"jrgc://9888.cn/?key=sjgl"].location != NSNotFound)
    {
        DBLOG(@"这个字符串中有\n");
        [self pushWebView:LEVELURLSHENGJI withTitle:@"升级攻略"];
        return NO;
    }
    else if ([requestString rangeOfString:@"jrgc://9888.cn/?key=gfxq"].location != NSNotFound)
    {
        DBLOG(@"这个字符串中有\n");
        [self pushWebView:LEVELURLXIANGQING withTitle:@"玩转工分"];
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)pushWebView:(NSString *)url withTitle:(NSString *)title
{
    //UCFWebViewJavascriptBridgeLevel *vc = [[UCFWebViewJavascriptBridgeLevel alloc] initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
    //vc.url = url;
    
    //vc.navTitle = title;
    
    //vc.isHideBar = YES;
    //vc.isToken = NO;
    //[self.navigationController pushViewController:vc animated:YES];
}
@end
