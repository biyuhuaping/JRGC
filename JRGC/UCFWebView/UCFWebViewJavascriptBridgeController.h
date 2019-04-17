//
//  UCFWebViewJavascriptBridgeController.h
//  JRGC
//
//  Created by 狂战之巅 on 16/7/18.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MJRefresh.h"
#import "UCFCycleModel.h"
#import "UCF404ErrorView.h"
//typedef enum {
//    //以下是枚举成员
//    WebBBS = 0,
//    WebBanner,
//    WebMail,
//    WebMailDetails,
//    WebLevel,
//    WebBank,
//    WebCash //提现页面
//}JavascriptBridgeWebType;//枚举名称
@interface UCFWebViewJavascriptBridgeController : UCFBaseViewController<FourOFourViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (copy, nonatomic)   NSString *url;


@property (nonatomic,strong)  WebViewJavascriptBridge* bridge;

@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic,strong) UCFCycleModel *dicForShare;//***返回的banner图数据modle

@property (strong, nonatomic) NSURLConnection *theConnection;

@property (nonatomic, strong) UCF404ErrorView *errorView;

@property (nonatomic, copy) NSString *requestLastUrl;

@property (nonatomic,assign) BOOL isTabbarfrom; //是否是从tabarController进入的


@property (assign, nonatomic) NSUInteger loadCount;

////------------------------------------------------------------------------------------qyy
@property (strong, nonatomic) NSDictionary *webDataDic;//***由于输入交易密码和设置交易密码页面需要验签，通过该变量传入相关数据--qyy
//@property(nonatomic,strong) NSString *sourceVCStr;//从哪个页面进来的，可以传类名的字符串--qyy
//
//@property  BOOL flagInvestSuc;//***判断投资是否成功-成功：要改变返回按钮的返回到nav的标列表-失败：要改变返回按钮的返回到nav的投标页（输入金额页面）
////------------------------------------------------------------------------------------qyy
@property (assign, nonatomic) NSInteger preSelectIndex;
@property (assign, nonatomic) BOOL isHideNativeNav;

@property (assign, nonatomic) BOOL isFromBarMall; //是否从tabbr进入商城

- (void)subShar;
- (void)gotoURL:(NSString *)url; //加载URL无需验签
- (void)gotoURLWithSignature:(NSString *)requestUrl;//加载URL无验签
- (void)gotoURLWithSignature2:(NSString *)requestUrl;//加载URL需验签
- (void)setErrorViewFrame:(CGRect)newFrame;//设置错误页面frame
- (void)removeRefresh;//移除下拉刷新
- (void)addErrorViewButton;
-(void)addProgressView;
- (void)addRefresh;
- (void)jumpLogin;
-(void)gotoOpenAccout;
- (void)jsToNative:(NSString *)controllerName;
@end
