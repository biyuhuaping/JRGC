//
//  UCFRegisterStepOneViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRegisterStepOneViewController.h"
#import "UCFRegisterStepTwoViewController.h"
#import "FullWebViewController.h"
#import "UCFXieYiViewController.h"
#import "AuxiliaryFunc.h"
#import "AppDelegate.h"

@interface UCFRegisterStepOneViewController ()
{
    UCFRegisterOneView *_registerOneView;
    BOOL            isLimitFactoryCode;
}

@end

@implementation UCFRegisterStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"注册";
    [self addLeftButton];
    self.navigationController.navigationBar.translucent = NO;
    _registerOneView = [[UCFRegisterOneView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight)];
    _registerOneView.delegate = self;
    [self.view addSubview:_registerOneView];
    
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
    [self.view endEditing:YES];
    if ([_sourceVC isEqualToString:@"fromPersonCenter"]) {
        //个人中心跳到登录页
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate.tabBarController setSelectedIndex:3];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([_sourceVC isEqualToString:@"webView"])
    {
        [self closeViewController];
    }
    else {
        if (kIS_IOS7) {
            [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
            self.navigationController.navigationBar.translucent = NO;
        } else {
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeViewController
{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - viewDelegate

- (void)nextBtnClicked:(id)sender
{
    if([QDCODE isEqualToString:@""]){
        //点下一步前先验证手机号
        NSString *strParameters = [NSString stringWithFormat:@"vString=%@&type=%@",[_registerOneView phoneNumberText],@"1"];
        if (strParameters) {
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSxTagRegistMobileCheck owner:self];
        }
    } else {
        //点下一步前先验证手机号
        NSString *strParameters = [NSString stringWithFormat:@"qd=%@",QDCODE];
        if (strParameters) {
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagRegistCheckQUDAO owner:self];
        }
    }

}

- (void)readBtnClicked:(id)sender
{
    
}

- (void)but1Click:(id)sender
{
    //注册协议 加载本地文件
    UCFXieYiViewController *zhuCeXieYi = [[UCFXieYiViewController alloc] init];
    zhuCeXieYi.titleName = @"注册协议";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zhucexieyi" ofType:@"docx"];
    zhuCeXieYi.filePath = [NSURL fileURLWithPath:path];
    [self.navigationController pushViewController:zhuCeXieYi animated:YES];
}

- (void)but2Click:(id)sender
{
    //信息咨询服务协议 本地文件
    UCFXieYiViewController *zhuCeXieYi = [[UCFXieYiViewController alloc] init];
    zhuCeXieYi.titleName = @"信息咨询服务协议";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xinxizixunxieyi.docx" ofType:nil];
    zhuCeXieYi.filePath = [NSURL fileURLWithPath:path];
    [self.navigationController pushViewController:zhuCeXieYi animated:YES];
}

-(void)getRegisterTokenHttpRequst{
    NSDictionary *dataDic = @{ @"phoneNo":[_registerOneView phoneNumberText],@"userId":@"1"};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagGetRegisterToken owner:self signature:NO];
}
#pragma mark -RequsetDelegate

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
    if (tag.intValue == kSxTagRegistMobileCheck) {
        if([rstcode intValue] == 1)
        {
            [self getRegisterTokenHttpRequst];
        } else if([rstcode intValue] == 3) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"立即拨打", nil];
            [alertView show];
        } else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (tag.integerValue == kSXTagGetRegisterToken){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[dic objectSafeForKey:@"ret"] boolValue]){
            UCFRegisterStepTwoViewController *twoController = [[UCFRegisterStepTwoViewController alloc] initWithPhoneNumber:[_registerOneView phoneNumberText]];
            twoController.isLimitFactoryCode = isLimitFactoryCode;
            twoController.registerTokenStr = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"registTicket"];
            [self.navigationController pushViewController:twoController animated:YES];
        }
    } else if (tag.integerValue == kSXTagRegistCheckQUDAO) {
        if ([rstcode isEqualToString:@"1"]) {
            isLimitFactoryCode = YES;
        } else {
            isLimitFactoryCode = NO;
        }
        //点下一步前先验证手机号
        NSString *strParameters = [NSString stringWithFormat:@"vString=%@&type=%@",[_registerOneView phoneNumberText],@"1"];
        if (strParameters) {
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSxTagRegistMobileCheck owner:self];
        }
    }
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [AuxiliaryFunc showToastMessage:@"当前没有网络，请检查网络！" withView:self.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
    }
}

@end
