//
//  BeansFamilyViewController.m
//  JRGC
//
//  Created by 金融工场 on 15/11/16.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "BeansFamilyViewController.h"

@interface BeansFamilyViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activi;

@end

@implementation BeansFamilyViewController

- (void)viewDidLoad {
    self.baseTitleType = @"moreViewController";
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    baseTitleLabel.text = self.title;
    [self addLeftButton];
    
    NSURL *url = [NSURL URLWithString:_urlSting];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activi stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [_activi stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

@end
