//
//  UCFExtractGoldDetailController.m
//  JRGC
//
//  Created by njw on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFExtractGoldDetailController.h"
#import "MjAlertView.h"
@interface UCFExtractGoldDetailController ()<MjAlertViewDelegate>

@end

@implementation UCFExtractGoldDetailController

//需要加上这个 要不初始化不了webView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self refreshWebContent];
    [self.webView reload];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight-TabBarHeight)];
    //    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    [self addRefresh];
    
}
#pragma mark - 添加返回按钮
- (void)getToBack
{
    
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }
    else {
        if ([baseTitleLabel.text isEqualToString:@"提交订单"]) {
            MjAlertView *alertView = [[MjAlertView alloc]initDrawGoldRechangeAlertType:MjAlertViewTypeDrawGoldSubmitOrderCancel withMessage:@"订单信息尚未填写完成，是否放弃提交？未提交的订单将在30分钟之后自动取消。如需继续填写，请前往我的黄金-提交订单。" delegate:self];
            [alertView show];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index;
{
    if (index== 100 )//返回上一页
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //继续填写
    else if (index== 101 || index== 102)
    {
       
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    baseTitleLabel.text = titleHtmlInfo;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    if ([requestString isEqualToString:@"firstp2p://api?type=closeallpage"]) {
        UCFBaseViewController *baseVc = self.rootVc;
        if ([NSStringFromClass([baseVc class])isEqualToString:@"UCFDrawGoldViewController"]) {
            [self.navigationController popToViewController:baseVc.rootVc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_GOLD_ACCOUNT object:nil];
        }
        else {
            [self.navigationController popToViewController:baseVc.rootVc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_EXTRACTGOLD_LIST object:nil];
        }
        return NO;
    }
    else if ([requestString isEqualToString:@"firstp2p://api?method=updatebacktype&param=3"]) {
        [self hideLeftButton];
        return NO;
    }
    return YES;
}


@end
