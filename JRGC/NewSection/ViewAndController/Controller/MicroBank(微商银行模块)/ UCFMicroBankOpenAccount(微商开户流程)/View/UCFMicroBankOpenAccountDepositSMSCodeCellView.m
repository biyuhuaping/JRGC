//
//  UCFMicroBankOpenAccountDepositSMSCodeCellView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountDepositSMSCodeCellView.h"

@interface UCFMicroBankOpenAccountDepositSMSCodeCellView()

@property (nonatomic, strong) UIView *itemLineView;//下划线

@property (nonatomic, strong) UIView *cuttingLineView;//分割线

@property (nonatomic, strong) UIImageView *titleImageView;



@end
@implementation UCFMicroBankOpenAccountDepositSMSCodeCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [self.rootLayout addSubview:self.titleImageView];
        [self.rootLayout addSubview:self.contentField];
        [self.rootLayout addSubview:self.verifyCodeButton];
        [self.rootLayout addSubview:self.itemLineView];
        [self.rootLayout addSubview:self.cuttingLineView];
    }
    return self;
}
- (UIImageView *)titleImageView
{
    if (nil == _titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _titleImageView.myLeft = 15;
        _titleImageView.myWidth = 22;
        _titleImageView.myHeight = 22;
        _titleImageView.image = [UIImage imageNamed:@"verification_code"];
    }
    return _titleImageView;
}

- (UITextField *)contentField
{
    if (nil == _contentField) {
        _contentField = [UITextField new];
        _contentField.backgroundColor = [UIColor clearColor];
        //        _contentField.delegate = self;
        //        _contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contentField.font = [Color gc_Font:15.0];
        _contentField.placeholder = @"请输入短息验证码";
        _contentField.keyboardType =  UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_contentField.placeholder attributes:dict];
        [_contentField setAttributedPlaceholder:attribute];
        
        //        NSString *phoneStr = [UserObeject getUserDataMobile];
        //        if (phoneStr != nil && phoneStr.length > 0) {
        //            _atTextField.text = phoneStr;
        //        }
        //        UIButton *clearButton = [_atTextField valueForKey:@"_clearButton"];
        //        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
        //
        //            [clearButton setImage:[UIImage imageNamed:@"register_clear_icon.png"] forState:UIControlStateNormal];
        //            [clearButton setImage:[UIImage imageNamed:@"register_clear_icon.png"] forState:UIControlStateHighlighted];
        //
        //        }
        _contentField.textColor = [Color color:PGColorOptionTitleBlack];
        _contentField.heightSize.equalTo(self.rootLayout.heightSize);
        _contentField.leftPos.equalTo(self.titleImageView.rightPos).offset(13);
        _contentField.rightPos.equalTo(self.cuttingLineView.leftPos);
        _contentField.centerYPos.equalTo(self.rootLayout.centerYPos);
        
    }
    return _contentField;
}

- (UIView *)cuttingLineView
{
    if (nil == _cuttingLineView) {
        _cuttingLineView = [UIView new];
        _cuttingLineView.myWidth = 0.5;
        _cuttingLineView.myHeight = 20;
        _cuttingLineView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _cuttingLineView.myRight = 123;
        _cuttingLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _cuttingLineView;
}

- (UIView *)itemLineView
{
    if (nil == _itemLineView) {
        _itemLineView = [UIView new];
        _itemLineView.myBottom = 1;
        _itemLineView.myHeight = 0.5;
        _itemLineView.leftPos.equalTo(self.contentField.leftPos);
        _itemLineView.myRight = 0;
        _itemLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _itemLineView.hidden = YES;
        //
    }
    return _itemLineView;
}
- (CQCountDownButton *)verifyCodeButton
{
    if (nil == _verifyCodeButton) {
        __weak __typeof__(self) weakSelf = self;
        
        _verifyCodeButton = [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
            //------- 按钮点击 -------//
            //        [SVProgressHUD showWithStatus:@"正在获取验证码..."];
            // 请求数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                int a = arc4random() % 2;
                //                if (a == 0) {
                //                    // 获取成功
                //                    //                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                //                    // 获取到验证码后开始倒计时
                //                    [weakSelf.verifyCodeButton startCountDown];
                //                } else {
                //                    // 获取失败
                //                    //                [SVProgressHUD showErrorWithStatus:@"获取失败，请重试"];
                //                    weakSelf.verifyCodeButton.enabled = YES;
                //                }
                
                //回调事件
                weakSelf.backBlock();
            });
        } countDownStart:^{
            //------- 倒计时开始 -------//
            NSLog(@"倒计时开始");
        } countDownUnderway:^(NSInteger restCountDownNum) {
            //------- 倒计时进行中 -------//
            [weakSelf.verifyCodeButton setTitleColor:[Color color:PGColorOptionInputDefaultBlackGray] forState:UIControlStateNormal];
            [weakSelf.verifyCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取", restCountDownNum] forState:UIControlStateNormal];
            
        } countDownCompletion:^{
            //------- 倒计时结束 -------//
            [weakSelf.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [weakSelf.verifyCodeButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
            NSLog(@"倒计时结束");
        }];
        
        _verifyCodeButton.rightPos.equalTo(@0);
        _verifyCodeButton.widthSize.equalTo(@122);
        _verifyCodeButton.heightSize.equalTo(self.rootLayout.heightSize);
        _verifyCodeButton.centerYPos.equalTo(self.rootLayout.centerYPos);
        [_verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verifyCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _verifyCodeButton.titleLabel.font = [Color gc_Font:15.0];
        [_verifyCodeButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
        //        [_verifyCodeButton setTitleColor:[Color color:PGColorOptionSettingPWBeforeInputLightTextColor] forState:UIControlStateDisabled];
    }
    
    return _verifyCodeButton;
}
@end
