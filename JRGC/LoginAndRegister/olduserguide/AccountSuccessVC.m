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
@property (strong, nonatomic) IBOutlet UILabel  *showLabel; //显示徽商或者微金的文案
@property (weak, nonatomic) IBOutlet UIImageView *successTipView;
@end

@implementation AccountSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_submitDataButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    _showLabel.text = [_site isEqualToString:@"1"] ? @"微金徽商存管账户":@"尊享徽商存管账户";
    NSString *imageStr = [_site isEqualToString:@"1"] ? @"account_successful_img":@"account_successful_zunxiang";
    _successTipView.image = [UIImage imageNamed:imageStr];
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
