//
//  UCFFlutterContainerViewController.m
//  JRGC
//
//  Created by 金融工场 on 2019/5/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFFlutterContainerViewController.h"
#import <Flutter/Flutter.h>
//#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "Encryption.h"
#import "UCFWebViewJavascriptBridgeController.h"
#import "UCFGetUserPhoneNumRequest.h"
#import "UCFRequestSucceedDetection.h"
@interface UCFFlutterContainerViewController ()

@end

@implementation UCFFlutterContainerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    self.fd_interactivePopDisabled = YES;
//    self.rt_disableInteractivePop = YES;
//    self.rt_navigationController.rt_disableInteractivePop = YES;
//    ((RTContainerController *) (self)).fd_interactivePopDisabled = YES;
    [self setSetNavgationPopDisabled:YES];

    
}
- (void)skipToJY:(NSString *)phoneNo
{
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    FlutterMethodChannel *presentChannel = [FlutterMethodChannel methodChannelWithName:@"com.eten.jingyuan/crayfish" binaryMessenger:flutterViewController];
    flutterViewController.view.frame = CGRectMake( 0, 0,ScreenWidth,ScreenHeight);
    [self addChildViewController:flutterViewController];
    [self.view addSubview:flutterViewController.view];
    [flutterViewController didMoveToParentViewController:self];
//    return;
    __weak typeof(self) weakSelf = self;
    // 注册方法等待flutter页面调用
    [presentChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"%@", call.method);
        NSLog(@"%@", result);
        NSDictionary *dic = call.arguments;
        if ([call.method isEqualToString:@"getTokenInfo"])
        {
            NSString *name = [weakSelf getDeiveName];
            if (name == nil) {
                FlutterError *error = [FlutterError errorWithCode:@"UNAVAILABLE" message:@"Device info unavailable" details:nil];
                result(error);
            } else {
                // 通过result返回给Flutter回调结果
                NSDictionary *parameterDic;
                if (SingleUserInfo.loginData.userInfo.userId == nil)
                {
                    parameterDic = @{@"imei": [Encryption getKeychain],@"version": [Encryption getIOSVersion]};
                }
                else
                {
                    parameterDic = @{@"imei": [Encryption getKeychain],@"version": [Encryption getIOSVersion],@"userId": SingleUserInfo.loginData.userInfo.userId,@"token": SingleUserInfo.signatureStr,@"phone": phoneNo};
                }
                NSString *str = [Encryption dictionaryToJson:parameterDic];
                result(str);
            }
        }
        else if ([call.method isEqualToString:@"showPDFView"])
        {
            NSString *title =  [dic objectSafeForKey:@"title"];
            NSString * downloadUrl = [dic objectSafeForKey:@"downloadUrl"];
            NSLog(@"%@", dic);
        }
        else if ([call.method isEqualToString:@"showWebView"])
        {
            UCFWebViewJavascriptBridgeController *web = [[UCFWebViewJavascriptBridgeController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeController" bundle:nil];
            web.title = [dic objectSafeForKey:@"title"];
            web.url = [dic objectSafeForKey:@"url"];
            [weakSelf.rt_navigationController pushViewController:web animated:YES];
        }
        else if ([call.method isEqualToString:@"showBankApp"])
        {
            NSString *code = [dic objectSafeForKey:@"bankid"];
            
            NSString *filePath = [[NSBundle mainBundle]pathForResource:@"BankSchemeList.plist" ofType:nil];
            NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
            NSArray *bankArr = [infoDic objectForKey:@"bankList"];
            for (NSDictionary *bankDict in bankArr) {
                if ([[bankDict objectForKey:@"code"] isEqualToString:code]) {
                    
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",bankDict[@"scheme"]]];
                    
                    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                    // 调起app
                    if (canOpen) {
//                        NSLog(@"可以调起");
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }else {
                        ShowMessage(@"请安装银行最新版APP或自行启动");
//                        NSLog(@"未安装手机银行");
                    }
                    break;
                }
            }
        }
        else if ([call.method isEqualToString:@"logout"])
        {
            UCFRequestSucceedDetection *re = [[UCFRequestSucceedDetection alloc] init];
            [re requestSucceedDetection:dic];
        }
        else if ([call.method isEqualToString:@"closeNative"])
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    @PGWeakObj(self);
    UCFGetUserPhoneNumRequest *api = [[UCFGetUserPhoneNumRequest alloc] init];
    api.animatingView = self.view;
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *phoneNo = [[request.responseObject objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"phoneNo"];

        [selfWeak skipToJY:phoneNo];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
    [api start];
}
- (NSString *)getDeiveName {
    UIDevice *device = UIDevice.currentDevice;
    return device.name;
}
- (void)dealloc
{
    
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
