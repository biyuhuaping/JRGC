//
//  UCFMicroBankChangeTradersPasswordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/16.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankChangeTradersPasswordViewController.h"
#import "BaseScrollview.h"
#import "UCFMicroBankOpenAccountDepositCellView.h"
#import "UCFMicroBankOpenAccountDepositSMSCodeCellView.h"
#import "UCFMicroBankOpenAccountDepositBankListCellView.h"
#import "UCFHuiShangChooseBankViewController.h"
#import "NZLabel.h"
#import "NSString+Misc.h"

#import "UCFMicroBankOpenAccountGetOpenAccountInfoAPI.h"
#import "UCFMicroBankOpenAccountGetOpenAccountInfoModel.h"
#import "UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI.h"
#import "UCFMicroBankOpenAccountZXGetOpenAccountInfoModel.h"
#import "UCFMicroBankIdentifysendCodeInfoAPI.h"
#import "UCFMicroBankIdentifysendCodeInfoModel.h"
#import "UCFMicroBankOpenAccountViewController.h"
#import "UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonModel.h"
#import "UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi.h"

#import "FullWebViewController.h"
#import "AccountWebView.h"
#import "AccountSuccessVC.h"
#import "UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView.h"
@interface UCFMicroBankChangeTradersPasswordViewController ()
<UIScrollViewDelegate,UITextFieldDelegate,UCFHuiShangChooseBankViewControllerDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *nameView; //姓名

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *idView; //身份证

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *phoneView; //手机号

@property (nonatomic, strong) UIButton *enterButton; //确认按钮

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositSMSCodeCellView *smsView;//获取短信验证码

@property (nonatomic, strong) NZLabel *smsLabel; //短信验证码

@property (nonatomic, strong) UCFMicroBankOpenAccountGetOpenAccountInfoModel *GetOpenAccountModel;

@property (nonatomic, assign) BOOL isCompanyAgent; //是否是企业用户
@end

@implementation UCFMicroBankChangeTradersPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    baseTitleLabel.text = @"验证身份";
    [self addLeftButton];
    
    self.isCompanyAgent = SingleUserInfo.loginData.userInfo.isCompanyAgent;
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview: self.scrollView];
    [self.scrollView addSubview:self.scrollLayout];
    
    [self loadLayoutView];
    [self queryUserData];
  
}
- (void)loadLayoutView
{
    [self.scrollLayout addSubview:self.nameView];
    [self.scrollLayout addSubview:self.idView];
    [self.scrollLayout addSubview:self.phoneView];
    [self.scrollLayout addSubview:self.smsView];
    [self.scrollLayout addSubview:self.enterButton];
    [self.scrollLayout addSubview:self.smsLabel];
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

- (UCFMicroBankOpenAccountDepositCellView *)nameView
{
    if (nil == _nameView) {
        _nameView = [[UCFMicroBankOpenAccountDepositCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _nameView.myTop = 0;
        _nameView.myLeft = 0;
        _nameView.titleImageView.image = [UIImage imageNamed:@"list_icon_name"];
        _nameView.contentField.delegate = self;
//        _nameView.contentField.placeholder = @"请输入真实姓名";
        _nameView.contentField.enabled = NO;
        [_nameView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameView;
}

- (UCFMicroBankOpenAccountDepositCellView *)idView
{
    if (nil == _idView) {
        _idView = [[UCFMicroBankOpenAccountDepositCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _idView.topPos.equalTo(self.nameView.bottomPos);
        _idView.myLeft = 0;
        _idView.titleImageView.image = [UIImage imageNamed:@"list_icon_id"];
        _idView.contentField.delegate = self;
        if (self.isCompanyAgent)
        {
            _idView.contentField.placeholder = @"请输入社会信用代码/组织机构代码";
        }
        else
        {
            _idView.contentField.placeholder = @"请输入身份证号";
        }
        [_idView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _idView;
}

- (UCFMicroBankOpenAccountDepositCellView *)phoneView
{
    if (nil == _phoneView) {
        _phoneView = [[UCFMicroBankOpenAccountDepositCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _phoneView.topPos.equalTo(self.idView.bottomPos);
        _phoneView.myLeft = 0;
        _phoneView.titleImageView.image = [UIImage imageNamed:@"list_icon_phone"];
        _phoneView.contentField.delegate = self;
//        _phoneView.contentField.placeholder = @"请输入手机号码";
        _phoneView.contentField.enabled = NO;
        [_phoneView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneView;
}

- (UCFMicroBankOpenAccountDepositSMSCodeCellView *)smsView
{
    if (nil == _smsView) {
        _smsView = [[UCFMicroBankOpenAccountDepositSMSCodeCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _smsView.topPos.equalTo(self.phoneView.bottomPos);
        _smsView.myLeft = 0;
        _smsView.contentField.delegate = self;
        @PGWeakObj(self);
        _smsView.backBlock = ^(void) {
            [selfWeak statVerifyCodeRequest:@"SMS"];
        };
        [_smsView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _smsView;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectTextField];
}

- (UIButton*)enterButton
{
    
    if(nil == _enterButton)
    {
        _enterButton = [UIButton buttonWithType:0];
        _enterButton.topPos.equalTo(self.smsView.bottomPos).offset(20);
        _enterButton.rightPos.equalTo(@25);
        _enterButton.leftPos.equalTo(@25);
        _enterButton.heightSize.equalTo(@40);
        [_enterButton setTitle:@"修改交易密码" forState:UIControlStateNormal];
        _enterButton.titleLabel.font= [Color gc_Font:15.0];
        [_enterButton setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        _enterButton.userInteractionEnabled = NO;
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtoClick) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _enterButton;
}

- (void)enterButtoClick
{
    UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi * request = [[UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonApi alloc] initWithIdCardNo:self.idView.contentField.text validateCode:self.smsView.contentField.text AccoutType: self.accoutType];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonModel *model = [request.responseJSONModel copy];
        if (model.ret == YES)
        {
            AccountWebView *webView = [[AccountWebView alloc] initWithNibName:@"AccountWebView" bundle:nil];
            webView.title = @"即将跳转";
            webView.url = model.data.url;
            webView.webDataDic =  [NSDictionary dictionaryWithObjectsAndKeys:model.data.tradeReq.PARAMS,@"PARAMS", nil];
            [self.rt_navigationController pushViewController:webView animated:YES complete:^(BOOL finished) {
                //进入设置交易密码页面,把开户页面的根视图去掉,返回不再返回到开户页面,直接到h开户页面的上一级
                [self.rt_navigationController removeViewController: self.parentViewController];
            }];
        }
        else
        {
//            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
- (void)changeTransactionPassword
{
    for (UCFMicroBankOpenAccountViewController *vc in self.rt_navigationController.rt_viewControllers) {
        if ([vc isKindOfClass:[UCFMicroBankOpenAccountViewController class]]) {
            vc.openAccountSucceed = YES;
        }
    }
}

- (NZLabel *)smsLabel
{
    if (nil == _smsLabel) {
        _smsLabel = [NZLabel new];
        _smsLabel.centerXPos.equalTo(self.enterButton.centerXPos);
        _smsLabel.myWidth = PGScreenWidth - 50;
        _smsLabel.topPos.equalTo(self.enterButton.bottomPos).offset(12);
        _smsLabel.textAlignment = NSTextAlignmentLeft;
        _smsLabel.font = [Color gc_Font:13.0];
        _smsLabel.textColor = [Color color:PGColorOptionTitleGray];
        //自动折行设置
        _smsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _smsLabel.numberOfLines = 0;
        _smsLabel.userInteractionEnabled = YES;
        
    }
    return _smsLabel;
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    //身份证号
//    if (textField == self.phoneView.contentField)
//    {
//        if (self.isCompanyAgent) {
//            //是机构用户证件号小于20位
//            if (textField.text.length >=20  && ![string isEqualToString:@""]) {
//                return NO;
//            }
//        }
//        else
//        {
//            //个人用户xz身份证号小于18位
//            if (textField.text.length > 18 && ![string isEqualToString:@""]) {
//                return NO;
//            }
//            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
//            if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
//                return NO;
//            }
//            return YES;
//        }
//    }
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField == self.nameView.contentField && ![self inspectNameViewInPut]) {//&& ![Common isChinese:_textField1.text]
//        [AuxiliaryFunc showToastMessage:@"请输入正确的姓名" withView:self.view];
//        return;
//    }
    if (textField == self.idView.contentField && ![self inspectIdViewInPut])
    {
        if (self.isCompanyAgent || [SingleUserInfo.loginData.userInfo.openStatus integerValue]== 5) {
            [AuxiliaryFunc showToastMessage:@"请输入正确的证件号" withView:self.view];
        }
        else {
            [AuxiliaryFunc showToastMessage:@"请输入正确的身份证号码" withView:self.view];
        }
        return;
    }
//    else if(textField == self.phoneView.contentField && ![self inspectPhoneView]){
//        [AuxiliaryFunc showToastMessage:@"请输入正确的手机号码" withView:self.view];
//        return;
//    }
    else if (textField == self.smsView.contentField && ![self inspectSmsView]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的短信验证码" withView:self.view];
        return;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)inspectTextField
{
    if ([self inspectIdViewInPut]  && [self inspectSmsView]) {
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
- (BOOL)inspectNameViewInPut
{
    if (![self.nameView.contentField.text isEqualToString:@""] && self.nameView.contentField.text.length > 0) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectIdViewInPut
{
    //不做位数校验
    if (![self.idView.contentField.text isEqualToString:@""] && self.idView.contentField.text.length > 0) {
        return YES;
    }
    else
    {
        return NO;
    }
    
    //    if (self.isCompanyAgent)
    //    {
    //        //如果是机构用户
    //        if (![Common isEnglishAndNumbers:self.idView.contentField.text]) {
    //            [AuxiliaryFunc showToastMessage:@"请输入正确的证件号" withView:self.view];
    //            return NO;
    //        }
    //        else
    //        {
    //            return YES;
    //        }
    //    }
    //    else
    //    {
    //        //个人用户  //排除机构、和特殊用户(港澳台)
    //        if (![self.idView.contentField.text isEqualToString:@""] && self.idView.contentField.text.length > 0 ) {
    //            return YES;
    //        }
    //        else
    //        {
    //            return NO;
    //        }
    //    }
}
- (BOOL)inspectPhoneView
{
    if (self.phoneView.contentField.text.length == 11 && [Common isOnlyNumber:self.phoneView.contentField.text] ) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectSmsView
{
    if (self.smsView.contentField.text.length >0 && ![self.smsView.contentField.text isEqualToString:@""] ) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)statVerifyCodeRequest:(NSString *)isVms
{
    NSString *isVmsNew = isVms;//SMS："普通短信渠道"；VMS："验证码语音渠道"
    //type 1：提现；3：修改绑定银行卡；4：修改注册手机号5：设置交易密码；6：开户；7：换卡；9：修改银行预留手机号；10：验证注册手机号 11：资产证明验证码
    if (![self inspectPhoneView]) {
        [AuxiliaryFunc showToastMessage:@"请输入正确的手机号" withView:self.view];
        return;
    }
    
    UCFMicroBankIdentifysendCodeInfoAPI * request = [[UCFMicroBankIdentifysendCodeInfoAPI alloc] initWithDestPhoneNo:self.GetOpenAccountModel.data.userInfo.phoneNum isVms:isVmsNew type:@"5" AccoutType:self.accoutType];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        UCFMicroBankIdentifysendCodeInfoModel *model = [request.responseJSONModel copy];
        if (model.ret == YES)
        {
            [self.smsView.verifyCodeButton startCountDown];
            __weak typeof(self) weakSelf = self;
            
            NSString *replaceStr = [NSString replaceStringWithAsterisk:self.GetOpenAccountModel.data.userInfo.phoneNum startLocation:3 lenght:self.GetOpenAccountModel.data.userInfo.phoneNum.length -7];
            self.smsLabel.text = [NSString stringWithFormat:@"已向手机%@发送短信验证码，若收不到，请点击这里获取语音验证码。",replaceStr];
            [self.smsLabel sizeToFit];
            [self.smsLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"点击这里"];
            [self.smsLabel addLinkString:@"点击这里" block:^(ZBLinkLabelModel *linkModel) {
                if (![weakSelf.smsView.verifyCodeButton getIsCountDown]) {
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
- (void)queryUserData
{
    UCFMicroBankOpenAccountGetOpenAccountInfoAPI * request = [[UCFMicroBankOpenAccountGetOpenAccountInfoAPI alloc] initWithAccoutType:SelectAccoutTypeP2P];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        self.GetOpenAccountModel = [request.responseJSONModel copy];
        if (self.GetOpenAccountModel.ret == YES)
        {
            //获取徽商开户页面信息
            SingleUserInfo.loginData.userInfo.openStatus = self.GetOpenAccountModel.data.openStatus;
            
            
            
            //            _nameView.contentField.enabled=NO;
            
            if (self.GetOpenAccountModel.data.userInfo.realName.length > 0)
            {
                //                用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码
                self.nameView.contentField.text = self.GetOpenAccountModel.data.userInfo.realName;
                SingleUserInfo.loginData.userInfo.realName = self.GetOpenAccountModel.data.userInfo.realName;
            }
            if (self.GetOpenAccountModel.data.userInfo.phoneNum.length > 0)
            {
                //                NSString *asteriskIdCardNo = [NSString replaceStringWithAsterisk:self.GetOpenAccountModel.data.userInfo.idCardNo startLocation:3 lenght:self.GetOpenAccountModel.data.userInfo.idCardNo.length -7];
                //                self.idView.contentField.text   = asteriskIdCardNo;
                NSString *str = self.GetOpenAccountModel.data.userInfo.phoneNum;
                if (str.length < 7) {
                    return ;
                }
                self.phoneView.contentField.text   = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
            }

            if (self.GetOpenAccountModel.data.userInfo.notSupportDes.length > 0)
            {
                BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:self.GetOpenAccountModel.data.userInfo.notSupportDes cancelButtonTitle:nil clickButton:^(NSInteger index) {} otherButtonTitles:@"确定"];
                [alert show];
            }
            [SingleUserInfo setUserData:SingleUserInfo.loginData];
            [self inspectTextField];//查询是否全部都已经填写
        }
        else
        {
//            ShowMessage(self.GetOpenAccountModel.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
@end
