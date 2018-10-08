//
//  UCFZIZhiWebViewViewController.m
//  JRGC
//
//  Created by zrc on 2018/9/10.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFZIZhiWebViewViewController.h"

@interface UCFZIZhiWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *showWebView;

@end

@implementation UCFZIZhiWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    if (_url) {
        baseTitleLabel.text = @"信息披露";
        NSURL *url = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //加载网页
        [_showWebView loadRequest:request];
    } else {
        baseTitleLabel.text = [[_fileName componentsSeparatedByString:@"."] firstObject];
        [self loadDocument:_fileName];
    }
}
- (void) loadDocument:(NSString *)docName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:docName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_showWebView loadRequest:request];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
