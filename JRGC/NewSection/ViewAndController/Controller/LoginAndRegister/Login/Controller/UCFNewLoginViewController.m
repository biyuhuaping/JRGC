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

@interface UCFNewLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NZLabel     *loginLabel;//注册

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UIButton *forgetBtn;//忘记密码

@property (nonatomic, strong) UCFNewLoginInputView *loginInputView;

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
    [self.rootLayout addSubview:self.forgetBtn];
    
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
    
    
//    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];UU
//    [cancleButton setTitle:@"注册" forState:UIControlStateNormal];
//    [cancleButton setTitleColor:[Color color:PGColorOpttonTextRedColor] forState:UIControlStateNormal];
//    [cancleButton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
////    rightItem.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);//设置向左偏移
//    self.navigationItem.rightBarButtonItem = rightItem;
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

-(UCFNewLoginInputView *)loginInputView
{
    if (_loginInputView == nil) {
        _loginInputView = [[UCFNewLoginInputView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 258)];
        _loginInputView.topPos.equalTo(self.loginLabel.bottomPos);
        _loginInputView.myLeft = 0;
        _loginInputView.personalInput.userField.delegate = self;
        _loginInputView.personalInput.passWordField.delegate = self;
        _loginInputView.personalInput.loginBtn.tag = 1000;
        [_loginInputView.personalInput.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _loginInputView.enterpriseInput.userField.delegate = self;
        _loginInputView.enterpriseInput.passWordField.delegate = self;
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
    NSString *username ,*pwd , *isCompany;
    if (btn.tag == 1000) {
        //个人用户点击登录
        username = self.loginInputView.personalInput.userField.text;
        pwd      = self.loginInputView.personalInput.passWordField.text;
        isCompany = @"个人";
    }
    else
    {
        //企业用户点击登录
        username = self.loginInputView.enterpriseInput.userField.text;
        pwd      = self.loginInputView.enterpriseInput.passWordField.text;
        isCompany = @"企业";
    }
    
    UCFLoginApi * request = [[UCFLoginApi alloc] initWithUsername:username andPwd:pwd andIsCompany:isCompany];
    //    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFLoginModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            
            [SingleUserInfo setUserData:model.data withPassWord:pwd andInputAccountText:username];
            
            [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES];
        }
        else{
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}

- (UIButton*)forgetBtn{
    
    if(_forgetBtn == nil)
    {
        _forgetBtn = [UIButton buttonWithType:0];
        _forgetBtn.topPos.equalTo(self.loginInputView.bottomPos).offset(15);
        _forgetBtn.leftPos.equalTo(@25);
        _forgetBtn.widthSize.equalTo(@70);
        _forgetBtn.heightSize.equalTo(@30);
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _forgetBtn.titleLabel.font= [Color gc_Font:13.0];
        [_forgetBtn setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(buttonforgetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}
-(void)buttonforgetClick
{}
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
