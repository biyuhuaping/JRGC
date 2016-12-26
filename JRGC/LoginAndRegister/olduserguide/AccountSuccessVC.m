//
//  AccountSuccessVC.m
//  JRGC
//
//  Created by biyuhuaping on 16/8/10.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "AccountSuccessVC.h"

@interface AccountSuccessVC ()

@property (strong, nonatomic) IBOutlet UIButton *submitDataButton;

@end

@implementation AccountSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitDataButton:(id)sender {
    DBLOG(@"设置交易密码");
    //请求成功后，发通知到 UCFOldUserGuideHeadViewController.m  设置 isFirstComingPassWord 为yes
    [self.db changeTitleViewController:showPassWord];
}


@end
