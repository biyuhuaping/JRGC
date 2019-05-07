//
//  UCFNewBindPhoneNumSMSViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBindPhoneNumSMSViewController.h"
#import "NZLabel.h"
#import "IQKeyboardManager.h"
#import "UCFNewResetPassWordSMSCodeView.h"
#import "UCFMicroBankIdentifysendCodeInfoAPI.h"
#import "UCFMicroBankIdentifysendCodeInfoModel.h"
#import "UCFToolsMehod.h"
#import "UCFSecurityCenterViewController.h"
@interface UCFNewBindPhoneNumSMSViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) NZLabel     *titleLabel;//重置密码

@property (nonatomic, strong) NZLabel     *resetPhoneSMSLabel;//收不到短信？点击获取语音验证码

@property (strong, nonatomic) UITextField *moddifyPhoneTextField;// 新手机号

@property (nonatomic, strong) UIView *moddifyPhoneLine;

@property (nonatomic, strong) UIImageView *moddifyPhoneImageView;

@property (nonatomic, strong)  UCFNewResetPassWordSMSCodeView *smsCodeView;

@property (nonatomic, strong) UIButton *enterButton; //确认按钮

@property (nonatomic, copy)   NSString *isVmsStr;
@end

@implementation UCFNewBindPhoneNumSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.titleLabel];
    [self.rootLayout addSubview:self.resetPhoneSMSLabel];
    [self.rootLayout addSubview:self.moddifyPhoneTextField];
    [self.rootLayout addSubview:self.moddifyPhoneLine];
    [self.rootLayout addSubview:self.moddifyPhoneImageView];
    [self.rootLayout addSubview:self.smsCodeView];
    [self.rootLayout addSubview:self.enterButton];
    
    [self addLeftButton];
    
}
- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.myTop = 40;
        _titleLabel.leftPos.equalTo(@26);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [Color gc_Font:30.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabel.text = @"修改绑定手机号";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)moddifyPhoneImageView
{
    if (nil == _moddifyPhoneImageView) {
        _moddifyPhoneImageView = [[UIImageView alloc] init];
        _moddifyPhoneImageView.topPos.equalTo(self.titleLabel.bottomPos).offset(38);
        _moddifyPhoneImageView.myLeft = 33;
        _moddifyPhoneImageView.myWidth = 25;
        _moddifyPhoneImageView.myHeight = 25;
        _moddifyPhoneImageView.image = [UIImage imageNamed:@"sign_icon_phone.png"];
    }
    return _moddifyPhoneImageView;
}
- (UITextField *)moddifyPhoneTextField
{
    
    if (nil == _moddifyPhoneTextField) {
        _moddifyPhoneTextField = [UITextField new];
        _moddifyPhoneTextField.backgroundColor = [UIColor clearColor];
        _moddifyPhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _moddifyPhoneTextField.font = [Color font:18.0 andFontName:nil];
        _moddifyPhoneTextField.textAlignment = NSTextAlignmentLeft;
//        _moddifyPhoneTextField.placeholder = @"请输入新绑定手机号";
        _moddifyPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moddifyPhoneTextField.delegate = self;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
//        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_moddifyPhoneTextField.placeholder attributes:dict];
//        [_moddifyPhoneTextField setAttributedPlaceholder:attribute];
        NSString *holderText = @"请输入新绑定手机号";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[Color color:PGColorOptionInputDefaultBlackGray]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[Color gc_Font:15.0]
                            range:NSMakeRange(0, holderText.length)];
        _moddifyPhoneTextField.attributedPlaceholder = placeholder;
        _moddifyPhoneTextField.textColor = [Color color:PGColorOptionTitleBlack];
        _moddifyPhoneTextField.heightSize.equalTo(@25);
        _moddifyPhoneTextField.leftPos.equalTo(self.moddifyPhoneImageView.rightPos).offset(9);
        _moddifyPhoneTextField.myRight = 25;
        _moddifyPhoneTextField.centerYPos.equalTo(self.moddifyPhoneImageView.centerYPos);
        _moddifyPhoneTextField.userInteractionEnabled = YES;
        [_moddifyPhoneTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        UIButton *clearButton = [_moddifyPhoneTextField valueForKey:@"_clearButton"];
        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
            
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateHighlighted];
            
        }
    }
    return _moddifyPhoneTextField;
}
- (UIView *)moddifyPhoneLine
{
    if (nil == _moddifyPhoneLine) {
        _moddifyPhoneLine = [UIView new];
        _moddifyPhoneLine.topPos.equalTo(self.moddifyPhoneImageView.bottomPos).offset(13);
        _moddifyPhoneLine.centerXPos.equalTo(self.rootLayout.centerXPos);
        _moddifyPhoneLine.myHeight = 0.5;
        _moddifyPhoneLine.widthSize.equalTo(self.rootLayout.widthSize).add(-58);
        _moddifyPhoneLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _moddifyPhoneLine;
}
- (UCFNewResetPassWordSMSCodeView *)smsCodeView
{
    if (nil == _smsCodeView) {
        _smsCodeView = [[UCFNewResetPassWordSMSCodeView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 60)];
        _smsCodeView.topPos.equalTo(self.moddifyPhoneLine.bottomPos);
        _smsCodeView.myLeft = 0;
        _smsCodeView.contentField.delegate = self;
        @PGWeakObj(self);
        _smsCodeView.backBlock = ^(void) {
            if ([selfWeak inspectPhoneNum]) {
                [selfWeak statVerifyCodeRequest:@"SMS"];
            }else
            {
                ShowMessage(@"请输入正确的手机号");
            }
            
        };
        [_smsCodeView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _smsCodeView;
}
- (NZLabel *)resetPhoneSMSLabel
{
    if (nil == _resetPhoneSMSLabel) {
        _resetPhoneSMSLabel = [NZLabel new];
        _resetPhoneSMSLabel.myLeft = 26;
        _resetPhoneSMSLabel.myRight = 26;
        _resetPhoneSMSLabel.topPos.equalTo(self.smsCodeView.bottomPos).offset(25);
        _resetPhoneSMSLabel.textAlignment = NSTextAlignmentLeft;
        _resetPhoneSMSLabel.font = [Color gc_Font:13.0];
        _resetPhoneSMSLabel.textColor = [Color color:PGColorOptionTitleGray];
        //自动折行设置
        _resetPhoneSMSLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _resetPhoneSMSLabel.numberOfLines = 0;
        _resetPhoneSMSLabel.userInteractionEnabled = YES;
        _resetPhoneSMSLabel.wrapContentHeight = YES;
        //        /**视图可见，等价于hidden = false*/
        //        MyVisibility_Visible,
        //        /**视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域*/
        //        MyVisibility_Invisible,
        //        /**视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域*/
        //        MyVisibility_Gone
        _resetPhoneSMSLabel.myVisibility = MyVisibility_Gone;
        
    }
    return _resetPhoneSMSLabel;
}
- (UIButton*)enterButton
{
    if(_enterButton == nil)
    {
        _enterButton = [UIButton buttonWithType:0];
        _enterButton.topPos.equalTo(self.resetPhoneSMSLabel.bottomPos).offset(25);
        _enterButton.rightPos.equalTo(@25);
        _enterButton.leftPos.equalTo(@25);
        _enterButton.heightSize.equalTo(@40);
        [_enterButton setTitle:@"提交" forState:UIControlStateNormal];
        _enterButton.titleLabel.font= [Color gc_Font:15.0];
        _enterButton.userInteractionEnabled = NO;
        [_enterButton setBackgroundColor:[Color color:PGColorOptionButtonBackgroundColorGray]];
        [_enterButton setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        _enterButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
        [_enterButton addTarget:self action:@selector(enterButtoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}


- (void)textFieldEditChanged:(UITextField *)textField
{
    if (textField == self.moddifyPhoneTextField) {
        [Common setPhoneNumSpacing:self.moddifyPhoneTextField];
    }
    [self inspectTextField]; //个人用户输入界面
}

- (void)inspectTextField
{
    if ([self inspectSmsView] && [self inspectPhoneNum]) {
        //输入正常,按钮可点击
        self.enterButton.userInteractionEnabled = YES;
        [self.enterButton setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.enterButton setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.enterButton.userInteractionEnabled = NO;
    }
}
- (BOOL)inspectPhoneNum
{
     NSString *inputStr = [self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (inputStr && inputStr.length == 11) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectSmsView
{
    if (self.smsCodeView.contentField.text.length >0 && ![self.smsCodeView.contentField.text isEqualToString:@""] ) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)enterButtoClick
{
    NSString* str = [self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:SingleUserInfo.loginData.userInfo.userId];
    NSDictionary *dic = @{@"phoneNum": str, @"userId":userId, @"validateCode":self.smsCodeView.contentField.text};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagUpdateMobile owner:self signature:YES Type:SelectAccoutDefault];
}
- (void)statVerifyCodeRequest:(NSString *)isVms
{
    //重新获取验证码验证码接口  //语音@"VMS";短信 @"SMS" 2注册 8找回密码  //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
    self.isVmsStr = isVms;
    
    NSString *isVmsNew = isVms;//SMS："普通短信渠道"；VMS："验证码语音渠道"
    UCFMicroBankIdentifysendCodeInfoAPI * request = [[UCFMicroBankIdentifysendCodeInfoAPI alloc] initWithDestPhoneNo:[self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isVms:isVmsNew type:@"4" AccoutType:SelectAccoutDefault];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        UCFMicroBankIdentifysendCodeInfoModel *model = [request.responseJSONModel copy];
        if (model.ret == YES)
        {
            [self.smsCodeView.verifyCodeButton startCountDown];
            __weak typeof(self) weakSelf = self;
            
//            NSString *replaceStr = [NSString replaceStringWithAsterisk:self.moddifyPhoneTextField.text startLocation:3 lenght:self.moddifyPhoneTextField.text.length -7];
            self.resetPhoneSMSLabel.text = [NSString stringWithFormat:@"收不到短信？点击获取语音验证码。"];
            self.resetPhoneSMSLabel.topPos.equalTo(self.smsCodeView.bottomPos).offset(10);
            self.resetPhoneSMSLabel.myVisibility = MyVisibility_Visible;
            [self.resetPhoneSMSLabel sizeToFit];
            [self.resetPhoneSMSLabel setFontColor:[Color color:PGColorOptionCellContentBlue] string:@"语音验证码"];
            [self.resetPhoneSMSLabel addLinkString:@"语音验证码" block:^(ZBLinkLabelModel *linkModel) {
                if (![weakSelf.smsCodeView.verifyCodeButton getIsCountDown]) {
                    [weakSelf statVerifyCodeRequest:@"VMS"];
                }
                
            }];
            if ([isVmsNew isEqualToString:@"VMS"]) {
                [AuxiliaryFunc showToastMessage:@"系统正在准备外呼，请保持手机信号畅通" withView:self.view];
            }
        }
        else
        {
//            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    [self.smsCodeView.contentField resignFirstResponder];
    [self.moddifyPhoneTextField resignFirstResponder];
    //    if (self.settingBaseBgView.hidden) {
    //        self.settingBaseBgView.hidden = NO;
    //    }
    //    [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    //    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
    //    self.settingBaseBgView.hidden = YES;
    
    NSString *data = (NSString *)result;
    //    DDLogDebug(@"首页获取最新项目列表：%@",data);
    [self.smsCodeView.contentField resignFirstResponder];
    [self.moddifyPhoneTextField resignFirstResponder];
    
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
    //    if (tag.intValue == kSXTagSendMessageforTicket) {
    //        [self getValidCodeWithTicket:dic[@"sendmessageticket"]];
    //    }
    if (tag.intValue == kSXTagUpdateMobile) {
        bool ret = [dic[@"ret"] boolValue];
        rsttext = [dic objectSafeForKey:@"message"];
        if (ret) {
            NSString* str = [self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
//            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"lastLoginName"];
            NSString *mobile  = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:@"mobile"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            SingleUserInfo.loginData.userInfo.mobile = mobile;
            [SingleUserInfo setUserData:SingleUserInfo.loginData];
//            [self.rt_navigationController removeViewControllerToRootanimated:NO];
//            [self.rt_navigationController popViewControllerAnimated:YES];
            for (UCFBaseViewController *vc in self.rt_navigationController.rt_viewControllers) {
                if ([vc isKindOfClass:[UCFSecurityCenterViewController class]]) {
                    if ([vc respondsToSelector:@selector(refresh)]) {
                        [vc refresh];
                    }
                    [self.rt_navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if ( tag.intValue == kSXTagUpdateMobile) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
