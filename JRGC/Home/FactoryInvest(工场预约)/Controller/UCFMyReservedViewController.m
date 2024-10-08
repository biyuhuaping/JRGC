//
//  UCFMyReservedViewController.m
//  JRGC
//
//  Created by njw on 2017/8/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMyReservedViewController.h"

@interface UCFMyReservedViewController ()

@end

@implementation UCFMyReservedViewController

//需要加上这个 要不初始化不了webView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)refreshWebContent
{
    [self gotoURL:self.url];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshWebContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebContent) name:IS_RELOADE_URL object:nil];
    // Do any additional setup after loading the view from its nib.
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight-TabBarHeight)];
    //    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    [self addRefresh];
}

@end
