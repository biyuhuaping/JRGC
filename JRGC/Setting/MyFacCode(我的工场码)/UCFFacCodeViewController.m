//
//  UCFFacCodeViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFFacCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "NZLabel.h"

@interface UCFFacCodeViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *haedPhoto;//头像
@property (strong, nonatomic) IBOutlet NZLabel *gcmLab;//工厂码
@property (strong, nonatomic) IBOutlet UIImageView *QrCodeImaView;//二维码

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *higt1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *higt2;
@property (weak, nonatomic) NSTimer *cycleTimer;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activi;

@end

@implementation UCFFacCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"我的工场码";
    [self addLeftButton];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //增加屏幕亮度
    [[NSNotificationCenter defaultCenter] postNotificationName:AddBrightness object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //降低屏幕亮度
    [[NSNotificationCenter defaultCenter] postNotificationName:ReduceBrightness object:nil];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];//清除web缓存
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activi stopAnimating];
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [_activi stopAnimating];
    [AuxiliaryFunc showToastMessage:@"网络连接异常" withView:self.view];
}

#pragma mark - 请求网络及回调
//获取数据
- (void)getData
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagWorkshopCode owner:self Type:SelectAccoutDefault];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
    
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
    DDLogDebug(@"我的工场码：%@",dic);
    if (tag.intValue == kSXTagWorkshopCode) {
        if ([rstcode intValue] == 1) {
            NSString *tempStr = dic[@"gcm"];
            _gcmLab.text = [NSString stringWithFormat:@"工场码：%@",tempStr];
            [_gcmLab setFontColor:UIColorWithRGB(0xfd4d4c) string:tempStr];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_IP,dic[@"twoCodeUrl"]];
            _QrCodeImaView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
//            [_QrCodeImaView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagWorkshopCode) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
}

#pragma mark - 把图片保存到相册
//#import <QuartzCore/QuartzCore.h>
- (void)writeToSavedPhotosAlbum:(UIView *)currentView{
    UIGraphicsBeginImageContext(currentView.bounds.size);
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [AuxiliaryFunc showToastMessage:@"保存成功" withView:self.view];
}

//- (void)dealloc{
////    页面退出之后 在本地中 删除该工场码标示符
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myFacCode"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

@end
