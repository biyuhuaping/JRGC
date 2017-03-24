//
//  UCFRetrievePasswordStepOneViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRetrievePasswordStepOneViewController.h"
#import "UCFRetrievePasswordStepTwoViewController.h"
#import "BaseAlertView.h"

@interface UCFRetrievePasswordStepOneViewController ()
{
    UCFRetrievePasswordStepOneView *_retPassView;
}

@end

@implementation UCFRetrievePasswordStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"找回密码";
    [self addLeftButton];
    _retPassView = [[UCFRetrievePasswordStepOneView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight)];
    _retPassView.delegate = self;
    [self.view addSubview:_retPassView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self.view addSubview:lineView];
}

- (void)didReceiveMemoryWarning {
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

- (void)nextStep:(id)sender
{
    NSDictionary *dataDic =@{@"phoneNum":[_retPassView getPhoneFieldText]};
    if (dataDic) {
        [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:KSXTAGVERFIUSERNAMEANDPHONE owner:self signature:NO Type:SelectAccoutDefault];
    }
}

- (void)concactUs:(id)sender
{
    
}

#pragma mark -RequsetDelegate

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode =  [dic objectSafeForKey: @"ret"];
    NSString *rsttext = [dic objectSafeForKey:@"message"];
    
    if (tag.intValue == KSXTAGVERFIUSERNAMEANDPHONE) {
        if([rstcode intValue] == 1)
        {
            UCFRetrievePasswordStepTwoViewController *controller = [[UCFRetrievePasswordStepTwoViewController alloc] initWithPhoneNumber:[_retPassView getPhoneFieldText] andUserName:[_retPassView getUserNameText]];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [AuxiliaryFunc showToastMessage:@"当前没有网络，请检查网络！" withView:self.view];
}

@end
