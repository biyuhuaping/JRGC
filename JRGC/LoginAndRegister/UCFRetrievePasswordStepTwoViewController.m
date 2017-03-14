//
//  UCFRetrievePasswordStepTwoViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRetrievePasswordStepTwoViewController.h"
#import "BaseAlertView.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "MD5Util.h"

@interface UCFRetrievePasswordStepTwoViewController ()
{
    UCFRetrievePasswordStepTwoView *_retTwoStepView;
    NSString *_phoneNumber;
    NSString *_userName;
    NSString *_mobileTicket;
    NSString *_curVerifyType;
}

@end

@implementation UCFRetrievePasswordStepTwoViewController

- (id)initWithPhoneNumber:(NSString*)phoneNum andUserName:(NSString *)userName
{
    self = [super init];
    if (self) {
        _phoneNumber = phoneNum;
        _userName = userName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"找回密码";
    [self addLeftButton];
    _retTwoStepView = [[UCFRetrievePasswordStepTwoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight) phoneNumber:_phoneNumber];
    _retTwoStepView.delegate = self;
    [self.view addSubview:_retTwoStepView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self.view addSubview:lineView];
    [self sendFindPwdCode:@"SMS"];//普通短信渠道
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([_retTwoStepView.timer isValid]) {
        [_retTwoStepView.timer invalidate];
    }
}
-(void)codeBtnClicked:(id)sender{
     [self sendFindPwdCode:@"SMS"];//普通短信渠道
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

#pragma mark -RetrieveViewDelegate

- (void)submitBtnClicked:(id)sender
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:_retTwoStepView.getVerficationCode forKey:@"validateCode"];//validateCode
    [parDic setValue:[MD5Util MD5Pwd:_retTwoStepView.getPassword] forKey:@"pwd"];
    [parDic setValue:_phoneNumber forKey:@"phoneNum"];
    [[NetworkModule sharedNetworkModule] newPostReq:parDic tag:kSXTagChangedPwd owner:self signature:NO];
}
-(void)sendFindPwdCode:(NSString *)type{
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber,@"destPhoneNo", type,@"isVms",@"8",@"type",@"1",@"userId", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagRegisterSendCodeAndFindPwd owner:self signature:NO];
}

//语音验证码
- (void)soudLabelClick:(UITapGestureRecognizer *)tap nowTime:(int)tm
{
    if (tm > 0 && tm < 60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%d秒后重新获取",tm] withView:self.view];
        return;
    } else {
        [self sendFindPwdCode:@"VMS"];//发送语音验证码
    }
}

- (void)veriFieldFstRepder:(NSNumber*)delay
{
    [_retTwoStepView setVerifiFieldFirstReponder];
}

#pragma mark -RequsetDelegate

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) performDismiss:(NSTimer *)timer
{
    UIAlertView *alert = [timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    BOOL rstcode = [[dic objectSafeForKey:@"ret"] boolValue ];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagRegisterSendCodeAndFindPwd) {
        if(rstcode)
        {
            [MBProgressHUD displayHudError:rsttext];
            [self performSelector:@selector(veriFieldFstRepder:) withObject:nil afterDelay:2.5];
            [_retTwoStepView verificatioCodeSend];
        }
//        else if ([rstcode intValue] == 6) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服", nil];
//            alertView.tag = 1001;
//            [NSTimer scheduledTimerWithTimeInterval:55.0f target:self selector:@selector(performDismiss:) userInfo:alertView repeats:NO];
//            [alertView show];
//        } else if ([rstcode intValue] == 3) {
//            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    } else if (tag.intValue == kSXTagChangedPwd) {
        if (rstcode){
            [[BaseAlertView getShareBaseAlertView] showStringOnTop:rsttext];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
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
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4000322988"]];
        }
    } else {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
