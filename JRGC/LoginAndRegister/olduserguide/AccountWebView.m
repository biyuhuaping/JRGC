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
            [UserInfoSingle sharedManager].openStatus = 3;
        }
        NSDictionary *encryptParamDic = @{
                                          @"userId": [[NSUserDefaults standardUserDefaults] valueForKey:UUID]                 //用户id
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
    if (self.isPresentViewController)
    {
//        [self dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
            NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
            UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
            [nav popToRootViewControllerAnimated:NO];
        }];
    }
    else
    {
        if ([baseTitleLabel.text hasSuffix:@"账户开立"] || [baseTitleLabel.text hasSuffix:@"开户失败"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([self.rootVc isEqualToString:@"UpgradeAccountVC"]){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getP2PAccountDataMessage" object:nil]; //刷新微金充值页面
    //刷新首页、债券转让、个人中心数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadP2PData" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserState" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADP2PORHONERACCOTDATA object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MODIBANKZONE_SUCCESSED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACK_TO_HS object:nil];
}

@end
