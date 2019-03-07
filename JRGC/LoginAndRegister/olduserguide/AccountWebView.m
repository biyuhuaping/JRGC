//
//  AccountWebView.m
//  JRGC
//
//  Created by biyuhuaping on 16/8/16.
//  Copyright © 2016年 qinwei. All rights reserved.
//  开户成功web页

#import "AccountWebView.h"
#import "AppDelegate.h"
#import "NSString+Misc.h"
#import "UCFMicroBankOpenAccountViewController.h"
@interface AccountWebView ()

@end

@implementation AccountWebView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    baseTitleLabel.text = @"设置交易密码";
    [self removeRefresh];
    [self gotoURLWithSignature:self.url];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    DDLogDebug(@"webViewDidFinishLoad");
    //    [self endRefresh];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self.webView.scrollView.header endRefreshing];
    
    self.requestLastUrl = [NSString stringWithFormat:@"%@",self.webView.request.URL.absoluteString];
//    if (baseTitleLabel.text.length == 0)
//    {
        baseTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    }
    DDLogDebug(@"%@",self.requestLastUrl);
    if (!self.errorView.hidden) {
        self.errorView.hidden = YES;
    }
}
//***无验签跳转页面走该方法
- (void)jsToNative:(NSString *)controllerName
{
    if ([controllerName isEqualToString:@"app_open_account"]) //开户失败 跳转到 开户页面
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([controllerName isEqualToString:@"app_setHSPwd"]) //开户成功 跳转到 设置交易密码页面
    {
        if (self.accoutType == SelectAccoutTypeP2P)
        {
            SingleUserInfo.loginData.userInfo.openStatus = @"3";
            [SingleUserInfo setUserData:SingleUserInfo.loginData];
        }
        NSDictionary *encryptParamDic = @{
                                          @"userId": SingleUserInfo.loginData.userInfo.userId                 //用户id
                                          };
        [[NetworkModule sharedNetworkModule] newPostReq:encryptParamDic tag:kSXTagAccountSetHsPwdIntoBank owner:self signature:YES Type:self.accoutType];
    }
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
    if (tag.intValue == kSXTagAccountSetHsPwdIntoBank)
    {
        if ([ret boolValue])
        {
            NSDictionary *dataDic = [dic objectSafeDictionaryForKey:@"data"];
            self.url =  [dataDic objectSafeForKey:@"url"];
            self.webDataDic = [dataDic objectSafeForKey:@"tradeReq"];
            [self gotoURLWithSignature:self.url];
        }else{
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)getToBack {
    [self closeWebView];
}

- (void)jsClose {
    [self closeWebView];
}

- (void)closeWebView
{
    if ([baseTitleLabel.text hasSuffix:@"账户开立"])
    {
        for (UCFMicroBankOpenAccountViewController *vc in self.rt_navigationController.rt_viewControllers) {
            if ([vc isKindOfClass:[UCFMicroBankOpenAccountViewController class]]) {
                vc.openAccountSucceed = YES;
            }
        }
    }
    else
    {
        //([baseTitleLabel.text hasSuffix:@"开户失败"])
//        [self.rt_navigationController popViewControllerAnimated:YES];
    }
    [self.rt_navigationController popViewControllerAnimated:YES];
}

@end
