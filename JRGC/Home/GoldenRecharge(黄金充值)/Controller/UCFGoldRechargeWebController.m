//
//  UCFGoldRechargeWebController.m
//  JRGC
//
//  Created by njw on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeWebController.h"

#define SIGNATURETIME 30.0

@interface UCFGoldRechargeWebController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation UCFGoldRechargeWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    
    [self gotoURLWithSignature:self.url];
}

- (void)gotoURLWithSignature:(NSString *)requestUrl
{
    NSURL *url = [NSURL URLWithString: requestUrl];
    
    NSString * requestStr = [Common getParameterByDictionary:self.paramDictory];
    [self createUrlRequest:requestStr withNSURL:url];
}

- (void)createUrlRequest:(NSString *)isSignature withNSURL:(NSURL *)url
{
    
    NSMutableURLRequest *request;
    NSTimeInterval time = SIGNATURETIME;
    request = [NSMutableURLRequest requestWithURL:url
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:time];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [isSignature dataUsingEncoding: NSUTF8StringEncoding]];
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
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    if (self.theConnection) {
//        //        SAFE_RELEASE(theConnection);
//        NSLog(@"safe release connection");
//    }
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]){
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if ((([httpResponse statusCode]/100) == 2)){
            NSLog(@"connection ok");
//            if (!self.errorView.hidden )
//            {
//                self.errorView.hidden = YES;
//            }
        }
        else
        {
            
            [self.webView stopLoading];
            [self.webView.scrollView.header endRefreshing];
//            self.errorView.hidden = NO;
            //NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:nil];
            //if ([error code] / 100 == 4 || [error code] / 100 == 5){
            //NSLog(@"404");
            ////                [self openNextLink];
            //}
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange range = [requestString rangeOfString:self.backUrl];
    if (range.location != NSNotFound) {
        [self.navigationController popToViewController:self.rootVc animated:YES];
        return NO;
    }
    
    return YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    
//    if (self.theConnection) {
//        //        SAFE_RELEASE(theConnection);
//        DBLOG(@"safe release connection");
//    }
    //    if (loadNotFinishCode == NSURLErrorCancelled)  {
    //        return;
    //    }
    [self.webView stopLoading];
    [self.webView.scrollView.header endRefreshing];
//    [self endRefresh];
//    self.errorView.hidden = NO;
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_GOLD_ACCOUNT object:nil];
}
@end
