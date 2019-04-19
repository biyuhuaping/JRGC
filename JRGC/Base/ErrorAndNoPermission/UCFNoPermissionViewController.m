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
#import "UIImage+Compression.h"
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
    UIImageView *logoImageVW = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 246)/2, 0, 246, 157)];
    logoImageVW.image = [UIImage imageNamed:@"invisible_bg.png"];
    [bkView addSubview:logoImageVW];
    
    UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageVW.frame) + 33, ScreenWidth, 15) text:_infoStr textColor:[Color color:PGColorOptionTitleGray] font:[UIFont systemFontOfSize:13]];
    [bkView addSubview:infoLabel];
    
    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookBtn.frame = CGRectMake((ScreenWidth - 246) / 2,CGRectGetMaxY(infoLabel.frame) + 30, 246, 37);
    [lookBtn addTarget:self action:@selector(lookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [lookBtn setTitle:@"再去转转" forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    lookBtn.layer.cornerRadius = 37/2.0f;
    lookBtn.clipsToBounds = YES;
    lookBtn.titleLabel.textColor = [UIColor whiteColor];
    [lookBtn setBackgroundImage:[UIImage gc_styleImageSize:CGSizeMake(288, 37)] forState:UIControlStateNormal];
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
