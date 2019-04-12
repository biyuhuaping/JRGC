//
//  UCFNewLoginViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewLoginViewController.h"
#import "NZLabel.h"
#import "UCFNewLoginInputView.h"
#import "UCFLoginApi.h"
#import "UCFLoginModel.h"
#import "UCFRegisterInputPhoneNumViewController.h"
#import "UCFNewFindPassWordViewController.h"
#import "UCFUserAllStatueRequest.h"
#import "UCFLockHandleViewController.h"
@interface UCFNewLoginViewController ()<UITextFieldDelegate,YTKChainRequestDelegate>

@property (nonatomic, strong) NZLabel     *loginLabel;//注册

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UCFNewLoginInputView *loginInputView;

@property (nonatomic, strong) NZLabel     *serviceLabel;

@property (nonatomic, strong) UIView     *leftView;

@property (nonatomic, strong) UIView     *rightView;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *pwd;

@property (nonatomic, copy) NSString *isCompany;

@property (nonatomic, strong)UCFLoginModel *model;

@end

@implementation UCFNewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.loginLabel];
    [self.rootLayout addSubview:self.loginInputView];
    [self.rootLayout addSubview:self.serviceLabel];
    [self.rootLayout addSubview:self.leftView];
    [self.rootLayout addSubview:self.rightView];
    
    [self setSetNavgationPopDisabled:YES];
    [self addLeftButtons];
    [self addRightButton];
}
- (void)addRightButton
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 44, 44);
    rightbutton.backgroundColor = [UIColor whiteColor];
    [rightbutton setTitle:@"注册" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:[Color color:PGColorOpttonTextRedColor] forState:UIControlStateNormal];
    [rightbutton setTitleColor:[Color color:PGColorOpttonTextRedColor] forState:UIControlStateHighlighted];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;

}
- (void)clickRightBtn
{
    UCFRegisterInputPhoneNumViewController *uc = [[UCFRegisterInputPhoneNumViewController alloc] init];
    [SingGlobalView.rootNavController pushViewController:uc animated:YES complete:^(BOOL finished) {
        [SingGlobalView.rootNavController removeViewController:self];
    }];
}
- (void)addLeftButtons
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    [leftButton setImage:[UIImage imageNamed:@"calculator_gray_close.png"]forState:UIControlStateNormal];
    //[leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)getToBack
{
    [SingGlobalView.rootNavController popViewControllerAnimated:YES];
}
- (NZLabel *)loginLabel
{
    if (nil == _loginLabel) {
        _loginLabel = [NZLabel new];
        _loginLabel.myTop = 40;
        _loginLabel.leftPos.equalTo(@26);
        _loginLabel.textAlignment = NSTextAlignmentLeft;
        _loginLabel.font = [Color gc_Font:30.0];
        _loginLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _loginLabel.text = @"登录";
        [_loginLabel sizeToFit];
    }
    return _loginLabel;
}
- (NZLabel *)serviceLabel
{
    if (nil == _serviceLabel) {
        _serviceLabel = [NZLabel new];
        _serviceLabel.myBottom = 50;
//        _serviceLabel.myLeft= 25;
//        _serviceLabel.myRight= 25;
        _serviceLabel.myCenterX = 0;
        _serviceLabel.numberOfLines = 0;
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
        _serviceLabel.font = [Color gc_Font:13.0];
        _serviceLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        _serviceLabel.text = @"金融工场专业互联网金融信息服务机构";
//        _serviceLabel.userInteractionEnabled = YES;
//        [_serviceLabel setFontColor:[Color color:PGColorOptionCellContentBlue] string:@"400-0322-988"];
        [_serviceLabel sizeToFit];
        
        
        
        
        //        __weak typeof(self) weakSelf = self;
//        [_serviceLabel addLinkString:@"400-0322-988" block:^(ZBLinkLabelModel *linkModel) {
//            //拨打客服电话
//            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        }];
    }
    return _serviceLabel;
}

- (UIView *)leftView
{
    if (nil == _leftView) {
        _leftView = [UIView new];
        _leftView.rightPos.equalTo(_serviceLabel.leftPos).offset(15);
        _leftView.myLeft = 25;
        _leftView.centerYPos.equalTo(_serviceLabel.centerYPos);
        _leftView.myHeight = 1;
        _leftView.backgroundColor = [Color color:PGColorOptionInputDefaultBlackGray];
    }
    return _leftView;
}

- (UIView *)rightView
{
    if (nil == _rightView) {
        _rightView = [UIView new];
        _rightView.leftPos.equalTo(_serviceLabel.rightPos).offset(15);
        _rightView.myRight = 25;
        _rightView.centerYPos.equalTo(_serviceLabel.centerYPos);
        _rightView.myHeight = 1;
        _rightView.backgroundColor = [Color color:PGColorOptionInputDefaultBlackGray];
    }
    return _rightView;
}
-(UCFNewLoginInputView *)loginInputView
{
    if (_loginInputView == nil) {
        _loginInputView = [[UCFNewLoginInputView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 318)];
        _loginInputView.topPos.equalTo(self.loginLabel.bottomPos);
        _loginInputView.myLeft = 0;
        _loginInputView.personalInput.userField.delegate = self;
        [_loginInputView.personalInput.userField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _loginInputView.personalInput.passWordField.delegate = self;
        [_loginInputView.personalInput.passWordField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _loginInputView.personalInput.loginBtn.tag = 1000;
        [_loginInputView.personalInput.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_loginInputView.personalInput.forgetBtn addTarget:self action:@selector(buttonforgetClick) forControlEvents:UIControlEventTouchUpInside];
        
        _loginInputView.enterpriseInput.userField.delegate = self;
        [_loginInputView.enterpriseInput.userField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _loginInputView.enterpriseInput.passWordField.delegate = self;
         [_loginInputView.enterpriseInput.passWordField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _loginInputView.enterpriseInput.loginBtn.tag = 1001;
        [_loginInputView.enterpriseInput.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        @property (nonatomic, strong) UCFNewLoginInputNameAndPassWordView *personalInput;//个人用户界面
//
//        @property (nonatomic, strong) UCFNewLoginInputNameAndPassWordView *enterpriseInput;//企业用户界面
    }
    return _loginInputView;
}

- (void)loginBtnClick:(UIButton *)btn
{
    if (btn.tag == 1000) {
        //个人用户点击登录
        self.username = self.loginInputView.personalInput.userField.text;
        self.pwd      = self.loginInputView.personalInput.passWordField.text;
        self.isCompany = @"个人";
    }
    else
    {
        //企业用户点击登录
        self.username = self.loginInputView.enterpriseInput.userField.text;
        self.pwd      = self.loginInputView.enterpriseInput.passWordField.text;
        self.isCompany = @"企业";
    }
    
    
    
    UCFLoginApi * request = [[UCFLoginApi alloc] initWithUsername:self.username andPwd:self.pwd andIsCompany:self.isCompany];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFLoginModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {

            [SingleUserInfo saveLoginAccount:[NSDictionary dictionaryWithObjectsAndKeys:self.isCompany,@"isCompany",self.username,@"lastLoginName", nil]];
            [SingleUserInfo setUserData:model.data withPassWord:self.pwd];
            [SingGlobalView.rootNavController pushViewController:[self cretateLockViewWithType:LLLockViewTypeCreate] animated:YES complete:^(BOOL finished) {
                [SingGlobalView.rootNavController removeViewController:self];
            }];
            
        }
        else{
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self

    }];
    
    
//    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
//    UCFLoginApi * request = [[UCFLoginApi alloc] initWithUsername:self.username andPwd:self.pwd andIsCompany:self.isCompany];
//
//    [chainReq addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        self.model = [request.responseJSONModel copy];
//        DDLogDebug(@"---------%@",self.model);
//        if (self.model.ret == YES) {
//
//            //登录成功就去查询账户数据,否则个别页面会因数据不对显示错误
//            UCFUserAllStatueRequest *request1 = [[UCFUserAllStatueRequest alloc] initWithUserId:self.model.data.userInfo.userId];
//            [chainRequest addRequest:request1 callback:nil];
//        }
//        else{
//            ShowMessage(self.model.message);
//        }
//    }];
//
//    chainReq.delegate = self;
//    // start to send request
//    [chainReq start];
//
    
    
    
    
}
- (UCFLockHandleViewController *)cretateLockViewWithType:(LLLockViewType)type
{
    UCFLockHandleViewController *lockVc = [[UCFLockHandleViewController alloc] initWithType:type];
    lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return lockVc;
}
//- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
//    // all requests are done
//
//    for (YTKBaseRequest *request in chainRequest.requestArray)
//    {
//        if ([request isKindOfClass:[UCFUserAllStatueRequest class]])
//        {
//            NSDictionary *dic = request.responseObject;
//            if ([dic[@"ret"] boolValue]) {
//                NSDictionary *userDict = dic[@"data"][@"userSatus"];
//
//                [SingleUserInfo saveLoginAccount:[NSDictionary dictionaryWithObjectsAndKeys:self.isCompany,@"isCompany",self.username,@"lastLoginName", nil]];
//                self.model.data.userInfo.zxOpenStatus = [NSString stringWithFormat:@"%@",userDict[@"zxOpenStatus"]];
//                self.model.data.userInfo.openStatus = [NSString stringWithFormat:@"%@",userDict[@"openStatus"]];
//                self.model.data.userInfo.nmAuthorization = [userDict[@"nmGoldAuthStatus"] boolValue];
//                self.model.data.userInfo.isNewUser = [userDict[@"isNew"] boolValue];
//                self.model.data.userInfo.isRisk = [userDict[@"isRisk"] boolValue];
//                self.model.data.userInfo.isAutoBid = [userDict[@"isAutoBid"] boolValue];
//                self.model.data.userInfo.zxAuthorization = [NSString stringWithFormat:@"%@",userDict[@"zxAuthorization"]];
//                self.model.data.userInfo.isCompanyAgent = [userDict[@"company"] boolValue];
////                [SingleUserInfo setUserData:SingleUserInfo.loginData];
//                [SingleUserInfo setUserData:self.model.data withPassWord:self.pwd];
//                [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES];
//            }
//            else
//            {
//                ShowMessage(dic[@"message"]);
//            }
//        }
//    }
//}
//- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
//    // some one of request is failed
//
//}
-(void)buttonforgetClick
{
    UCFNewFindPassWordViewController *vc = [[UCFNewFindPassWordViewController alloc] init];
    [SingGlobalView.rootNavController pushViewController:vc animated:YES];
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectPersonalTextField]; //个人用户输入界面
    [self inspectEnterpriseTextField];//企业用户输入界面
}

- (void)inspectPersonalTextField
{
    if ([self inspectPersonalInputUser] && [self inspectPersonalInputPassWord])
    {
        //输入正常,按钮可点击
        self.loginInputView.personalInput.loginBtn.userInteractionEnabled = YES;
        [self.loginInputView.personalInput.loginBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.loginInputView.personalInput.loginBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.loginInputView.personalInput.loginBtn.userInteractionEnabled = NO;
    }
}
- (void)inspectEnterpriseTextField
{
    if ([self inspectEnterpriseInputUser] && [self inspectEnterpriseInputPassWord])
    {
        //输入正常,按钮可点击
        self.loginInputView.enterpriseInput.loginBtn.userInteractionEnabled = YES;
        [self.loginInputView.enterpriseInput.loginBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.loginInputView.enterpriseInput.loginBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.loginInputView.enterpriseInput.loginBtn.userInteractionEnabled = NO;
    }
}
//个人用户账户输入判断
- (BOOL)inspectPersonalInputUser
{
    if (self.loginInputView.personalInput.userField.text.length >0 && ![self.loginInputView.personalInput.userField.text isEqualToString:@""]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectPersonalInputPassWord
{
    if (self.loginInputView.personalInput.passWordField.text.length >0 && ![self.loginInputView.personalInput.passWordField.text isEqualToString:@""]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
//企业用户账户输入判断
- (BOOL)inspectEnterpriseInputUser
{
    if (self.loginInputView.enterpriseInput.userField.text.length >0 && ![self.loginInputView.enterpriseInput.userField.text isEqualToString:@""]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectEnterpriseInputPassWord
{
    if (self.loginInputView.enterpriseInput.passWordField.text.length >0 && ![self.loginInputView.enterpriseInput.passWordField.text isEqualToString:@""]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.loginInputView.personalInput.userField && [self.loginInputView.personalInput.userField.text isEqualToString:@""] ) {//&& ![Common isChinese:_textField1.text]
        [AuxiliaryFunc showToastMessage:@"请输入用户名" withView:self.view];
        return;
    }
    else if (textField == self.loginInputView.enterpriseInput.userField && [self.loginInputView.enterpriseInput.userField.text isEqualToString:@""] )
    {//&& ![Common isChinese:_textField1.text]
        [AuxiliaryFunc showToastMessage:@"请输入用户名" withView:self.view];
        return;
    }
    else if (textField == self.loginInputView.personalInput.passWordField && [self.loginInputView.personalInput.passWordField.text isEqualToString:@""])
    {
        [AuxiliaryFunc showToastMessage:@"请输入密码" withView:self.view];
        return;
    }
    else if(textField == self.loginInputView.enterpriseInput.passWordField && [self.loginInputView.enterpriseInput.passWordField.text isEqualToString:@""])
    {
        [AuxiliaryFunc showToastMessage:@"请输入密码" withView:self.view];
        return;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.rootLayout endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    //写你要实现的：页面跳转的相关代码
////    如：[self.navigationController popViewControllerAnimated:YES];
//    return NO;
//}

@end
