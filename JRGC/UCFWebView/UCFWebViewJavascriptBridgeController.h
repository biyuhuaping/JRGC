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
@interface UCFWebViewJavascriptBridgeController : UCFBaseViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (copy, nonatomic)   NSString *url;

@property (nonatomic,strong)  WebViewJavascriptBridge* bridge;

@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic,strong) UCFCycleModel *dicForShare;//***返回的banner图数据modle

@property (strong, nonatomic) NSURLConnection *theConnection;



////------------------------------------------------------------------------------------qyy
@property (strong, nonatomic) NSDictionary *webDataDic;//***由于输入交易密码和设置交易密码页面需要验签，通过该变量传入相关数据--qyy
//@property(nonatomic,strong) NSString *sourceVCStr;//从哪个页面进来的，可以传类名的字符串--qyy
//
//@property  BOOL flagInvestSuc;//***判断投资是否成功-成功：要改变返回按钮的返回到nav的标列表-失败：要改变返回按钮的返回到nav的投标页（输入金额页面）
////------------------------------------------------------------------------------------qyy

- (void)subShar;
- (void)gotoURL:(NSString *)url; //加载URL无需验签
- (void)gotoURLWithSignature:(NSString *)requestUrl;//加载URL需验签
- (void)setErrorViewFrame:(CGRect)newFrame;//设置错误页面frame
- (void)removeRefresh;//移除下拉刷新
- (void)addErrorViewButton;
@end
