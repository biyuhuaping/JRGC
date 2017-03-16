//
//  UCFNoPermissionViewController.m
//  JRGC
//
//  Created by HeJing on 15/5/18.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFNoPermissionViewController.h"
#import "UILabel+Misc.h"
#import "UIImage+Misc.h"

@interface UCFNoPermissionViewController ()
{
    NSString *_title;
    NSString *_infoStr;
}

@end

@implementation UCFNoPermissionViewController

- (id)initWithTitle:(NSString*)title noPermissionTitle:(NSString *)infoStr
{
    self = [super init];
    if (self) {
        _title = title;
        _infoStr = infoStr;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_souceVC isEqualToString:@"CollectionDetailVC"]) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if([_souceVC isEqualToString:@"CollectionDetailVC"]){//集合标详情里
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    // Do any additional setup after loading the view.
    [self addLeftButton];
    self.baseTitleType = @"nopromition";
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
    
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - 64 - 296) / 2 , ScreenWidth, 296)];

    baseTitleLabel.text = _title;
    UIImageView *logoImageVW = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 234)/2, 0, 234, 178)];
    logoImageVW.image = [UIImage imageNamed:@"invisible_bg.png"];
    [bkView addSubview:logoImageVW];
    
    UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageVW.frame) + 33, ScreenWidth, 18) text:_infoStr textColor:UIColorWithRGB(0x8591b3) font:[UIFont systemFontOfSize:18]];
    [bkView addSubview:infoLabel];
    
    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookBtn.frame = CGRectMake((ScreenWidth - 137) / 2,CGRectGetMaxY(infoLabel.frame) + 30, 137, 37);
    [lookBtn addTarget:self action:@selector(lookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [lookBtn setTitle:@"再去转转" forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    lookBtn.layer.cornerRadius = 4.0f;
    lookBtn.titleLabel.textColor = [UIColor whiteColor];
    
    UIImage *normalImageForTopUp = [[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
    UIImage *highlightImageForTopUp = [[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
    [lookBtn setBackgroundImage:normalImageForTopUp forState:UIControlStateNormal];
    [lookBtn setBackgroundImage:highlightImageForTopUp forState:UIControlStateHighlighted];
    [bkView addSubview:lookBtn];
    
    [self.view addSubview:bkView];
}

- (void)lookBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
