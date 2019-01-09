//
//  UCFWebViewJavascriptBridgeMall.m
//  JRGC
//
//  Created by 狂战之巅 on 16/9/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface UCFWebViewJavascriptBridgeMall ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIPanGestureRecognizer *panGesture;
@end

@implementation UCFWebViewJavascriptBridgeMall

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_interactivePopDisabled = YES;
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    if (self.isFromBarMall) {
//        [self addLeftPan];
    }
//    [[UIApplication sharedApplication]  addObserver:self forKeyPath:@"statusBarStyle" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)addLeftPan
{
    self.fd_interactivePopDisabled = YES;
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
     // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(move:)];

    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    self.panGesture = panGesture;
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
//- (void)move:(UIPanGestureRecognizer *)pan {
//    CGPoint point = [pan locationInView:self.view];
//    CGPoint transPoint = [pan translationInView:self.view];
//    NSLog(@"%f++++%f\n --- \n%f+++++%f",point.x,point.y,transPoint.x,transPoint.y);

//}
- (CATransition *)popAnimation{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    /*
     cube                   立方体效果
     pageCurl               向上翻一页
     pageUnCurl             向下翻一页
     rippleEffect           水滴波动效果
     suckEffect             变成小布块飞走的感觉
     oglFlip                上下翻转
     cameraIrisHollowClose  相机镜头关闭效果
     cameraIrisHollowOpen   相机镜头打开效果
     */
    
    //    transition.type = @"pageUnCurl";
    transition.type = kCATransitionPush;
    
    //下面四个是系统列举出来的常见的类型
    //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    transition.subtype = kCATransitionFromLeft;
    //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    return transition;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.panGesture) {
        CGPoint locationPoint = [gestureRecognizer locationInView:self.webView];
        if (locationPoint.x < 0.2 * ScreenWidth) {
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            } else {
                [self.view.window.layer addAnimation:[self popAnimation] forKey:nil];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
        return NO;
    }
    return YES;
}
/*
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)panBack:(UIPanGestureRecognizer *)gestureRecognizer {
    //是滑动返回距左边的有效长度
    int location_X = 0.15 * ScreenWidth;
    if (gestureRecognizer == self.panGesture) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self.webView.scrollView];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self.webView.scrollView];
            //这是允许每张图片都可实现滑动返回
            int temp1 = location.x;
            int temp2 = ScreenWidth;
            NSInteger XX = temp1 % temp2;
            if (point.x >0 && XX < location_X) {
                return YES;
            }
        }
    }
    return NO;
}

*/
//只要是豆哥商城的都去掉导航栏
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.view.frame = CGRectMake(0,StatusBarHeight1 == 20 ? 0 : StatusBarHeight1, ScreenWidth, CGRectGetHeight(self.view.frame));
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}
#pragma mark - webViewDelegite
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loadCount ++;
    DDLogDebug(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    DDLogDebug(@"webViewDidFinishLoad");
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    // Disable callout
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self.webView.scrollView.header endRefreshing];
    
    self.requestLastUrl = [NSString stringWithFormat:@"%@",self.webView.request.URL.absoluteString];
    
    DDLogDebug(@"%@",self.requestLastUrl);
    
    if (!self.errorView.hidden) {
        self.errorView.hidden = YES;
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadCount --;
    DDLogDebug(@"webViewdidFailLoadWithError");
    [self.webView.scrollView.header endRefreshing];
    if([error code] == NSURLErrorCancelled)
    {
        DDLogDebug(@"Canceled request: %@", [webView.request.URL absoluteString]);
        return;
    }
    self.errorView.hidden = NO;
    
}
- (void)refreshBackBtnClicked:(id)sender fatherView:(UIView *)fhView
{
    [self dismissViewControllerAnimated:YES completion:^{
//        if(self.isTabbarfrom){
//            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            [app.tabBarController  setSelectedViewController:self.rootVc];
//        }
    }];

}
@end
