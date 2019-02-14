//
//  LineOfSendVerifyCodeView.m
//  JIMEITicket
//
//  Created by kuangzhanzhidian on 2018/5/23.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "LineOfSendVerifyCodeView.h"
#import "Timer.h"
@interface LineOfSendVerifyCodeView()


@end

@implementation LineOfSendVerifyCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withPhoneNum:(NSString *)phoneNum
{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        
        self.backgroundColor = [Color color:PGColorOptionThemeWhite];
        self.phoneNum = phoneNum;
        [self.rootLayout addSubview:self.verifyCodeButton];
       [self.rootLayout addSubview:self.voiceVerifyCodeButton];
        
//        [self.rootLayout addSubview:self.lineView];
//        [self.rootLayout addSubview:self.verticalView];
    }
    return self;
}


- (CQCountDownButton *)verifyCodeButton
{
    if (nil == _verifyCodeButton) {
        __weak __typeof__(self) weakSelf = self;
    
        _verifyCodeButton = [[CQCountDownButton alloc] initWithDuration:[Timer getCountDownPhoneNum:self.phoneNum andComeFrom:COUNTDOWNRESMS] buttonClicked:^{
            //------- 按钮点击 -------//
            if ([self.voiceVerifyCodeButton getIsCountDown]  ) {
                //语音验证码在倒计时时,不允许点击短信验证码
                return ;
            }
            // 请求数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                //回调事件
                weakSelf.verifyCodebackBlock();
            });
        } countDownStart:^{
            //------- 倒计时开始 -------//
            NSLog(@"倒计时开始");
        } countDownUnderway:^(NSInteger restCountDownNum) {
            //------- 倒计时进行中 -------//
             [weakSelf.verifyCodeButton setTitleColor:[Color color:PGColorOptionTitleGray] forState:UIControlStateNormal];
            [weakSelf.verifyCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取", restCountDownNum] forState:UIControlStateNormal];

        } countDownCompletion:^{
            //------- 倒计时结束 -------//
            [weakSelf.verifyCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
            [weakSelf.verifyCodeButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
            NSLog(@"倒计时结束");
        }];

        _verifyCodeButton.rightPos.equalTo(@26);
        _verifyCodeButton.widthSize.equalTo(@110);
        _verifyCodeButton.heightSize.equalTo(self.rootLayout.heightSize);
        _verifyCodeButton.centerYPos.equalTo(self.rootLayout.centerYPos);
        [_verifyCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        _verifyCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _verifyCodeButton.titleLabel.font = [Color font:13.0];
        [_verifyCodeButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
//        [_verifyCodeButton setTitleColor:[Color color:PGColorOptionSettingPWBeforeInputLightTextColor] forState:UIControlStateDisabled];
    }

    return _verifyCodeButton;
}
//语音
- (CQCountDownButton *)voiceVerifyCodeButton
{
    if (nil == _voiceVerifyCodeButton) {
        __weak __typeof__(self) weakSelf = self;
        
        _voiceVerifyCodeButton = [[CQCountDownButton alloc] initWithDuration:[Timer getCountDownPhoneNum:self.phoneNum andComeFrom:COUNTDOWNREVMS] buttonClicked:^{
            //------- 按钮点击 -------//
            // 请求数据
            if ([self.verifyCodeButton getIsCountDown]) {
                //短信验证码在倒计时时,不允许点击语音验证码
                return ;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //回调事件
                weakSelf.voiceVerifyCodebackBlock();
            });
        } countDownStart:^{
            //------- 倒计时开始 -------//
            NSLog(@"倒计时开始");
        } countDownUnderway:^(NSInteger restCountDownNum) {
            //------- 倒计时进行中 -------//
            [weakSelf.voiceVerifyCodeButton setTitleColor:[Color color:PGColorOptionTitleGray] forState:UIControlStateNormal];
            [weakSelf.voiceVerifyCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取", restCountDownNum] forState:UIControlStateNormal];
            
        } countDownCompletion:^{
            //------- 倒计时结束 -------//
            [weakSelf.voiceVerifyCodeButton setTitle:@"语音验证码" forState:UIControlStateNormal];
            [weakSelf.voiceVerifyCodeButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
            NSLog(@"倒计时结束");
        }];
        
        _voiceVerifyCodeButton.leftPos.equalTo(@26);
        _voiceVerifyCodeButton.widthSize.equalTo(@110);
        _voiceVerifyCodeButton.heightSize.equalTo(self.rootLayout.heightSize);
        _voiceVerifyCodeButton.centerYPos.equalTo(self.rootLayout.centerYPos);
        [_voiceVerifyCodeButton setTitle:@"语音验证码" forState:UIControlStateNormal];
        _voiceVerifyCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _voiceVerifyCodeButton.titleLabel.font = [Color font:13.0];
        [_voiceVerifyCodeButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
        //        [_verifyCodeButton setTitleColor:[Color color:PGColorOptionSettingPWBeforeInputLightTextColor] forState:UIControlStateDisabled];
    }
    
    return _voiceVerifyCodeButton;
}

@end
