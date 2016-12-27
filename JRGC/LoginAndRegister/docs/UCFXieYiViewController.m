//
//  UCFXieYiViewController.m
//  JRGC
//
//  Created by MAC on 14-10-23.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFXieYiViewController.h"

@interface UCFXieYiViewController ()

@end

@implementation UCFXieYiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftButton];
    [baseTitleLabel setText:_titleName];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarHeight)];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:self.filePath];
    [webView loadRequest:req];
    [webView sizeToFit];
    webView.scrollView.bounces = NO;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xebebee);
    [self.view addSubview:lineView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getToBack
{
    if (kIS_IOS7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
