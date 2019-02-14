//
//  UCFRegisterInputVerificationCodeViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterInputVerificationCodeViewController.h"
#import "NZLabel.h"
#import "HWTFCursorView.h"
#import "LineOfSendVerifyCodeView.h"
#import "Timer.h"
#import "UCFRegisterSendCodeApi.h"
#import "UCFRegisterSendCodeModel.h"
@interface UCFRegisterInputVerificationCodeViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) NZLabel     *verificationCodeTitleLabel;//输入验证码标题

@property (nonatomic, strong) NZLabel     *verificationCodeContentLabel;//输入验证码内容

@property (nonatomic, strong) HWTFCursorView *verificationCodeView;//验证码

@property (nonatomic, strong) LineOfSendVerifyCodeView *lineSendVCView;// 获取验证码

@property (nonatomic, copy) NSString *isVmsStr;

@end

@implementation UCFRegisterInputVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview:self.verificationCodeTitleLabel];
    [self.rootLayout addSubview:self.verificationCodeContentLabel];
    [self.rootLayout addSubview:self.verificationCodeView];
    [self.rootLayout addSubview:self.lineSendVCView];
    

//    (^endLayoutBlock)(void)
}
- (void)starCountDown
{
    NSInteger countDownSms = [Timer getCountDownPhoneNum:self.phoneNum andComeFrom:COUNTDOWNRESMS];
    NSInteger countDownVms = [Timer getCountDownPhoneNum:self.phoneNum andComeFrom:COUNTDOWNREVMS];
    if (countDownVms == 60) {
        //说明语音没有进行倒计时
        if (countDownSms == 60) {
            //说明短息没有进行倒计时,需要去请求短息接口
            [self requestAgainVerificationCode:@"SMS"];
        }
        else
        {
            [self.lineSendVCView.verifyCodeButton startCountDown];
        }
    }
    else{
        //说明语音开始进行倒计时
        [self.lineSendVCView.voiceVerifyCodeButton startCountDown];
    }
}

- (NZLabel *)verificationCodeTitleLabel
{
    if (nil == _verificationCodeTitleLabel) {
        _verificationCodeTitleLabel = [NZLabel new];
        _verificationCodeTitleLabel.myTop = 40;
        _verificationCodeTitleLabel.leftPos.equalTo(@26);
        _verificationCodeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _verificationCodeTitleLabel.font = [Color gc_Font:30.0];
        _verificationCodeTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _verificationCodeTitleLabel.text = @"请输入验证码";
        [_verificationCodeTitleLabel sizeToFit];
    }
    return _verificationCodeTitleLabel;
}
- (NZLabel *)verificationCodeContentLabel
{
    if (nil == _verificationCodeContentLabel) {
        _verificationCodeContentLabel = [NZLabel new];
        _verificationCodeContentLabel.topPos.equalTo(self.verificationCodeTitleLabel.bottomPos).offset(10);
        _verificationCodeContentLabel.leftPos.equalTo(self.verificationCodeTitleLabel.leftPos);
        _verificationCodeContentLabel.textAlignment = NSTextAlignmentLeft;
        _verificationCodeContentLabel.font = [Color gc_Font:15.0];
        _verificationCodeContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _verificationCodeContentLabel.text = [NSString stringWithFormat:@"验证码已发送至 %@",self.phoneNum];
        [_verificationCodeContentLabel sizeToFit];
    }
    return _verificationCodeContentLabel;
}

- (HWTFCursorView *)verificationCodeView
{
    if  (nil == _verificationCodeView ) {
        _verificationCodeView = [[HWTFCursorView alloc] initWithCount:6 margin:10];
        CGFloat w = PGScreenWidth - 26 * 2;
        CGFloat h = 50;
        _verificationCodeView.frame = CGRectMake(0, 0, w, h);
        _verificationCodeView.topPos.equalTo(self.verificationCodeContentLabel.bottomPos).offset(40);
        _verificationCodeView.centerXPos.equalTo(self.rootLayout.centerXPos);
        @PGWeakObj(self);
        _verificationCodeView.backBlock = ^(void) {
            //输入完成后的回调
            [selfWeak requestVerificationCode];
        };
    }
    return _verificationCodeView;
}


- (LineOfSendVerifyCodeView *)lineSendVCView
{
    if (nil == _lineSendVCView) {
        _lineSendVCView = [[LineOfSendVerifyCodeView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 44) withPhoneNum:self.phoneNum];
        _lineSendVCView.topPos.equalTo(self.verificationCodeView.bottomPos);
        _lineSendVCView.centerXPos.equalTo(self.rootLayout.centerXPos);
        @PGWeakObj(self);
        _lineSendVCView.verifyCodebackBlock = ^(void) {
            [selfWeak requestAgainVerificationCode:@"SMS"];
        };
        _lineSendVCView.voiceVerifyCodebackBlock = ^(void) {
            [selfWeak requestAgainVerificationCode:@"VMS"];
        };
        [_lineSendVCView.verifyCodeButton startCountDown];
    }
    return _lineSendVCView;
}

- (void)requestAgainVerificationCode:(NSString *)typeStr
{
    //重新获取验证码验证码接口  //语音@"VMS";短信 @"SMS"
    self.isVmsStr = typeStr;
    UCFRegisterSendCodeApi * request = [[UCFRegisterSendCodeApi alloc] initWithDestPhoneNo:self.verificationCodeView.code andIsVms:typeStr];
    //    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFRegisterSendCodeModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            if ([self.isVmsStr isEqualToString:@"VMS"])
            {
                [MBProgressHUD displayHudError:@"系统正在准备外呼，请保持手机信号畅通"];
                [self.lineSendVCView.voiceVerifyCodeButton startCountDown]; //短信开始倒计时
            }
            else
            {
                 [self.lineSendVCView.verifyCodeButton startCountDown];//语音开始倒计时开始倒计时
            }

            [self performSelector:@selector(veriFieldFstRepder:) withObject:nil afterDelay:2.5];
//            [self verificatioCodeSend]; //获取语音验证码也是在短信验证码进行倒计时
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:model.message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服", nil];
            alertView.tag = 1001;
//            [NSTimer scheduledTimerWithTimeInterval:55.0f target:self selector:@selector(performDismiss:) userInfo:alertView repeats:NO];
            [alertView show];
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
    
}
- (void)veriFieldFstRepder:(NSNumber*)delay
{
     [self.verificationCodeView textFieldResignFirstResponder];
}

- (void)requestVerificationCode
{
    //校验验证码接口
    
    
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
