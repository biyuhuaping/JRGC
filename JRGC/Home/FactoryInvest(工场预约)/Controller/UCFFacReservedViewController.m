//
//  UCFFacReservedViewController.m
//  JRGC
//
//  Created by njw on 2017/8/1.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFFacReservedViewController.h"

@interface UCFFacReservedViewController ()

@end

@implementation UCFFacReservedViewController

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
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight-TabBarHeight)];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    [self addRefresh];
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
