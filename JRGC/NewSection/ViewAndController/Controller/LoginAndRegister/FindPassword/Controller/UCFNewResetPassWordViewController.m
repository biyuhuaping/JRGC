//
//  UCFNewResetPassWordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewResetPassWordViewController.h"
#import "BaseScrollview.h"
#import "UCFNewResetPassWordInPutView.h"
#import "UCFNewResetPassWordSMSCodeView.h"
#import "NZLabel.h"
#import "IQKeyboardManager.h"
#import "SharedSingleton.h"
#import "UCFRegisterSendCodeApi.h"
#import "UCFRegisterSendCodeModel.h"
#import "UCFNewFindPassWordRetrievePwdModel.h"
#import "UCFNewFindPassWordRetrievePwdApi.h"
#import "BaseAlertView.h"

@interface UCFNewResetPassWordViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) NZLabel     *resetPassWordLabel;//重置密码

@property (nonatomic, strong) NZLabel     *resetPassWordPhoneLabel;//验证码已发送至 13912349999

@property (nonatomic, strong) NZLabel     *resetPassWordSMSLabel;//收不到短信？点击获取语音验证码

@property (nonatomic, strong)  UCFNewResetPassWordInPutView *passWordView;

@property (nonatomic, strong)  UCFNewResetPassWordSMSCodeView *smsCodeView;

@property (nonatomic, strong) UIButton *enterButton; //确认按钮

@property (nonatomic, strong) NZLabel *serviceLabel; //找回密码遇到问题，请联系客服400-0322-988

@property (nonatomic, copy)   NSString *isVmsStr;
@end

@implementation UCFNewResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
//    [self.rootLayout addSubview: self.scrollView];
//    [self.scrollView addSubview:self.scrollLayout];
    
    
    [self.rootLayout addSubview:self.resetPassWordLabel];
    [self.rootLayout addSubview:self.resetPassWordPhoneLabel];
    [self.rootLayout addSubview:self.resetPassWordSMSLabel];
    [self.rootLayout addSubview:self.passWordView];
    [self.rootLayout addSubview:self.smsCodeView];
    [self.rootLayout addSubview:self.enterButton];
    [self.rootLayout addSubview:self.serviceLabel];
    
    [self statVerifyCodeRequest:@"SMS"];
    [self addLeftButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = NO;
}
- (BaseScrollview *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [BaseScrollview new];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _scrollView.leftPos.equalTo(@0);
        _scrollView.rightPos.equalTo(@0);
        _scrollView.topPos.equalTo(@10);
        _scrollView.bottomPos.equalTo(@0);
    }
    return _scrollView;
}

- (MyLinearLayout *)scrollLayout
{
    if (nil == _scrollLayout) {
        _scrollLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _scrollLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _scrollLayout.heightSize.lBound(self.scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _scrollLayout;
}
- (NZLabel *)resetPassWordLabel
{
    if (nil == _resetPassWordLabel) {
        _resetPassWordLabel = [NZLabel new];
        _resetPassWordLabel.myTop = 40;
        _resetPassWordLabel.myLeft = 26;
        _resetPassWordLabel.textAlignment = NSTextAlignmentLeft;
        _resetPassWordLabel.font = [Color gc_Font:30.0];
        _resetPassWordLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _resetPassWordLabel.text = @"重置密码";
        [_resetPassWordLabel sizeToFit];
    }
    return _resetPassWordLabel;
}
- (NZLabel *)resetPassWordPhoneLabel
{
    if (nil == _resetPassWordPhoneLabel) {
        _resetPassWordPhoneLabel = [NZLabel new];
        _resetPassWordPhoneLabel.topPos.equalTo(self.resetPassWordLabel.bottomPos).offset(10);
        _resetPassWordPhoneLabel.myLeft = 26;
        _resetPassWordPhoneLabel.textAlignment = NSTextAlignmentLeft;
        _resetPassWordPhoneLabel.font = [Color gc_Font:15.0];
        _resetPassWordPhoneLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _resetPassWordPhoneLabel.text = @"验证码已发送至 ";
        [_resetPassWordPhoneLabel sizeToFit];
    }
    return _resetPassWordPhoneLabel;
}

- (NZLabel *)resetPassWordSMSLabel
{
    if (nil == _resetPassWordSMSLabel) {
        _resetPassWordSMSLabel = [NZLabel new];
        _resetPassWordSMSLabel.myLeft = 26;
        _resetPassWordSMSLabel.myRight = 26;
        _resetPassWordSMSLabel.topPos.equalTo(self.resetPassWordPhoneLabel.bottomPos).offset(10);
        _resetPassWordSMSLabel.textAlignment = NSTextAlignmentLeft;
        _resetPassWordSMSLabel.font = [Color gc_Font:13.0];
        _resetPassWordSMSLabel.textColor = [Color color:PGColorOptionTitleGray];
        //自动折行设置
        _resetPassWordSMSLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _resetPassWordSMSLabel.numberOfLines = 0;
//        /**视图可见，等价于hidden = false*/
//        MyVisibility_Visible,
//        /**视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域*/
//        MyVisibility_Invisible,
//        /**视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域*/
//        MyVisibility_Gone
        _resetPassWordSMSLabel.myVisibility = MyVisibility_Gone;
        
    }
    return _resetPassWordSMSLabel;
}

- (UCFNewResetPassWordSMSCodeView *)smsCodeView
{
    if (nil == _smsCodeView) {
        _smsCodeView = [[UCFNewResetPassWordSMSCodeView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _smsCodeView.topPos.equalTo(self.resetPassWordSMSLabel.bottomPos).offset(30);
        _smsCodeView.myLeft = 0;
        _smsCodeView.contentField.delegate = self;
        @PGWeakObj(self);
        _smsCodeView.backBlock = ^(void) {
            [selfWeak statVerifyCodeRequest:@"SMS"];
        };
        [_smsCodeView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _smsCodeView;
}

- (UCFNewResetPassWordInPutView *)passWordView
{
    if (nil == _passWordView) {
        _passWordView = [[UCFNewResetPassWordInPutView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _passWordView.contentField.delegate = self;
        _passWordView.topPos.equalTo(self.smsCodeView.bottomPos);
        [_passWordView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _passWordView.myLeft = 0;
    }
    return _passWordView;
}

- (UIButton*)enterButton
{
    if(_enterButton == nil)
    {
        _enterButton = [UIButton buttonWithType:0];
        _enterButton.topPos.equalTo(self.passWordView.bottomPos).offset(25);
        _enterButton.rightPos.equalTo(@25);
        _enterButton.leftPos.equalTo(@25);
        _enterButton.heightSize.equalTo(@40);
        [_enterButton setTitle:@"确认" forState:UIControlStateNormal];
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
- (NZLabel *)serviceLabel
{
    if (nil == _serviceLabel) {
        _serviceLabel = [NZLabel new];
        _serviceLabel.topPos.equalTo(self.enterButton.bottomPos).offset(20);
        _serviceLabel.myLeft= 25;
        _serviceLabel.myRight= 25;
        _serviceLabel.numberOfLines = 0;
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
        _serviceLabel.font = [Color gc_Font:13.0];
        _serviceLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        _serviceLabel.text = @"找回密码遇到问题，请联系客服400-0322-988";
        _serviceLabel.userInteractionEnabled = YES;
        [_serviceLabel setFontColor:[Color color:PGColorOptionCellContentBlue] string:@"400-0322-988"];
        [_serviceLabel sizeToFit];
        //        __weak typeof(self) weakSelf = self;
        [_serviceLabel addLinkString:@"400-0322-988" block:^(ZBLinkLabelModel *linkModel) {
            //拨打客服电话
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
    }
    return _serviceLabel;
}

- (void)enterButtoClick
{
    UCFNewFindPassWordRetrievePwdApi * request = [[UCFNewFindPassWordRetrievePwdApi alloc] initWithPhoneNum:self.phoneNum andValidateCode:self.smsCodeView.contentField.text andPwd:self.passWordView.contentField.text];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        UCFNewFindPassWordRetrievePwdModel *model = [request.responseJSONModel copy];
        if (model.ret == YES)
        {
            [[BaseAlertView getShareBaseAlertView] showStringOnTop:model.message];
            [self.rt_navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self

    }];
}
- (void)statVerifyCodeRequest:(NSString *)isVms
{
    //重新获取验证码验证码接口  //语音@"VMS";短信 @"SMS" 2注册 8找回密码
    self.isVmsStr = isVms;
    
    UCFRegisterSendCodeApi * request = [[UCFRegisterSendCodeApi alloc] initWithDestPhoneNo:self.phoneNum andIsVms:isVms andType:@"8"];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFRegisterSendCodeModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES)
        {
            [self.smsCodeView.verifyCodeButton startCountDown];
            __weak typeof(self) weakSelf = self;
            
            NSString *replaceStr = [NSString replaceStringWithAsterisk:self.phoneNum startLocation:3 lenght:self.phoneNum.length -7];
            self.resetPassWordSMSLabel.myVisibility = MyVisibility_Visible;
            self.resetPassWordSMSLabel.text = [NSString stringWithFormat:@"已向手机%@发送短信验证码，若收不到，请点击这里获取语音验证码。",replaceStr];
            [self.resetPassWordSMSLabel sizeToFit];
            [self.resetPassWordSMSLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"点击这里"];
            [self.resetPassWordSMSLabel addLinkString:@"点击这里" block:^(ZBLinkLabelModel *linkModel) {
                if (![weakSelf.smsCodeView.verifyCodeButton getIsCountDown]) {
                    [weakSelf statVerifyCodeRequest:@"VMS"];
                }
                
            }];
            if ([self.isVmsStr isEqualToString:@"VMS"]) {
                [AuxiliaryFunc showToastMessage:@"系统正在准备外呼，请保持手机信号畅通" withView:self.view];
            }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField == self.passWordView.contentField) {
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    } else if (textField == self.smsCodeView.contentField) {
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.smsCodeView.contentField && ![self inspectSmsView] ) {//&& ![Common isChinese:_textField1.text]
        [AuxiliaryFunc showToastMessage:@"请输入正确的短信验证码" withView:self.view];
        return;
    }else if (textField == self.passWordView.contentField && ![self inspectPassWord]){
        [AuxiliaryFunc showToastMessage:@"密码格式不正确" withView:self.view];
        return;
    }
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectTextField];
}

- (void)inspectTextField
{
    if ([self inspectSmsView] && [self inspectPassWord]) {
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

- (BOOL)inspectPassWord
{
    if ([SharedSingleton isValidatePassWord:self.passWordView.contentField.text]) {
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
@end
