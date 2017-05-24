//
//  UCFHomeInviteViewController.m
//  JRGC
//
//  Created by njw on 2017/5/24.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeInviteViewController.h"

@interface UCFHomeInviteViewController ()

@end

@implementation UCFHomeInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = CGRectMake(0, 0.5, CGRectGetWidth(self.webView.frame), CGRectGetHeight(self.webView.frame));
    self.view.backgroundColor = UIColorWithRGB(0xeeeeee);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    //    self.webView.scrollView.bounces = NO;
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
