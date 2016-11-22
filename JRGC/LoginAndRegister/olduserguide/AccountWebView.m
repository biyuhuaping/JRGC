//
//  AccountWebView.m
//  JRGC
//
//  Created by biyuhuaping on 16/8/16.
//  Copyright © 2016年 qinwei. All rights reserved.
//  开户成功web页

#import "AccountWebView.h"

@interface AccountWebView ()

@end

@implementation AccountWebView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    baseTitleLabel.text = @"设置交易密码";
    [self removeRefresh];
    [self gotoURLWithSignature:self.url];
}

- (void)getToBack {
    [self closeWebView];
}

- (void)jsClose {
    [self closeWebView];
}

- (void)closeWebView
{
    if (self.isPresentViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //刷新首页、债券转让、个人中心数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignmentUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MODIBANKZONE_SUCCESSED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACK_TO_HS object:nil];
}

@end
