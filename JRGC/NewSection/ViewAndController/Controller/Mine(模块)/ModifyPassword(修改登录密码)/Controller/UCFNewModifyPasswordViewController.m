//
//  UCFNewModifyPasswordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/29.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewModifyPasswordViewController.h"
#import "BaseAlertView.h"
#import "MD5Util.h"
#import "SharedSingleton.h"
#import "NZLabel.h"
#import "AppDelegate.h"
#import "UCFNewFindPassWordViewController.h"
@interface UCFNewModifyPasswordViewController ()<UITextFieldDelegate>
{
    BOOL _isSecureTextEntry;
    UIButton *_eyeButton;
}
@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UIButton *backButton; //返回按钮

@property (nonatomic, strong) NZLabel     *modifyLabel;//修改登录密码

@property (nonatomic, strong) UIImageView *oldPassWordImageView; //密码

@property (nonatomic, strong) UIView *oldPassWordLine;

@property (strong, nonatomic) UITextField *oldPasswordTextField;



@property (nonatomic, strong) UIImageView *passWordImageView; //密码

@property (nonatomic, strong) UIButton *showPassWordBtn;

@property (nonatomic, strong) UIView *passWordLine;

@property (strong, nonatomic) UITextField *lastPasswordTextField;



@property (strong, nonatomic) UIButton *handInButton;

@property (nonatomic, strong) UIButton *forgetBtn;//忘记密码


@end

@implementation UCFNewModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"修改登录密码";
//    baseTitleLabel.text = @"修改登录密码";
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
//    [self addLeftButton];
    //  设置隐藏导航栏
    _isSecureTextEntry = YES;
    self.isHideNavigationBar = YES;
    
    // 初始化界面
//    [self createUI];
    [self.oldPasswordTextField becomeFirstResponder];
    [self.rootLayout addSubview:self.backButton];
    [self.rootLayout addSubview:self.modifyLabel];
    [self.rootLayout addSubview:self.oldPassWordImageView];
    [self.rootLayout addSubview:self.oldPassWordLine];
    [self.rootLayout addSubview:self.oldPasswordTextField];
    
    
    
    [self.rootLayout addSubview:self.passWordImageView];
    [self.rootLayout addSubview:self.showPassWordBtn];
    [self.rootLayout addSubview:self.passWordLine];
    [self.rootLayout addSubview:self.lastPasswordTextField];
    
    [self.rootLayout addSubview:self.handInButton];
    [self.rootLayout addSubview:self.forgetBtn];
    
    [self.navigationController.navigationBar setHidden:YES];
}
- (UIButton *)backButton
{
    if (nil == _backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setBackgroundColor:[UIColor clearColor]];
        [_backButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
        [_backButton setImage:[UIImage imageNamed:@"icon_left"]forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
        _backButton.myTop = PGStatusBarHeight;
        _backButton.myWidth = 44;
        _backButton.myHeight = 44;
        _backButton.myLeft = 10;
    }
    return _backButton;
}
- (NZLabel *)modifyLabel
{
    if (nil == _modifyLabel) {
        _modifyLabel = [NZLabel new];
        _modifyLabel.topPos.equalTo(self.backButton.bottomPos).offset(40);
        _modifyLabel.leftPos.equalTo(@26);
        _modifyLabel.textAlignment = NSTextAlignmentLeft;
        _modifyLabel.font = [Color gc_Font:30.0];
        _modifyLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _modifyLabel.text = @"修改登录密码";
        [_modifyLabel sizeToFit];
    }
    return _modifyLabel;
}

- (UIImageView *)oldPassWordImageView
{
    if (nil == _oldPassWordImageView) {
        _oldPassWordImageView = [[UIImageView alloc] init];
        _oldPassWordImageView.topPos.equalTo(self.modifyLabel.bottomPos).offset(38);
        _oldPassWordImageView.myLeft = 30;
        _oldPassWordImageView.myWidth = 25;
        _oldPassWordImageView.myHeight = 25;
        _oldPassWordImageView.image = [UIImage imageNamed:@"sign_icon_password.png"];
    }
    return _oldPassWordImageView;
}
- (UITextField *)oldPasswordTextField
{
    
    if (nil == _oldPasswordTextField) {
        _oldPasswordTextField = [UITextField new];
        _oldPasswordTextField.backgroundColor = [UIColor clearColor];
        _oldPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPasswordTextField.font = [Color font:18.0 andFontName:nil];
        _oldPasswordTextField.textAlignment = NSTextAlignmentLeft;
        _oldPasswordTextField.secureTextEntry = YES;
        _oldPasswordTextField.delegate = self;
        NSString *holderText = @"请输入原密码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[Color color:PGColorOptionInputDefaultBlackGray]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[Color gc_Font:15.0]
                            range:NSMakeRange(0, holderText.length)];
        _oldPasswordTextField.attributedPlaceholder = placeholder;
        _oldPasswordTextField.textColor = [Color color:PGColorOptionTitleBlack];
        _oldPasswordTextField.heightSize.equalTo(@25);
        _oldPasswordTextField.leftPos.equalTo(self.oldPassWordImageView.rightPos).offset(9);
        _oldPasswordTextField.myRight = 25;
        _oldPasswordTextField.centerYPos.equalTo(self.oldPassWordImageView.centerYPos);
        _oldPasswordTextField.userInteractionEnabled = YES;
        [_oldPasswordTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        UIButton *clearButton = [_oldPasswordTextField valueForKey:@"_clearButton"];
        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
            
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateHighlighted];
            
        }
    }
    return _oldPasswordTextField;
}
- (UIView *)oldPassWordLine
{
    if (nil == _oldPassWordLine) {
        _oldPassWordLine = [UIView new];
        _oldPassWordLine.topPos.equalTo(self.oldPassWordImageView.bottomPos).offset(13);
        _oldPassWordLine.centerXPos.equalTo(self.rootLayout.centerXPos);
        _oldPassWordLine.myHeight = 0.5;
        _oldPassWordLine.widthSize.equalTo(self.rootLayout.widthSize).add(-50);
        _oldPassWordLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _oldPassWordLine;
}


- (UIImageView *)passWordImageView
{
    if (nil == _passWordImageView) {
        _passWordImageView = [[UIImageView alloc] init];
        _passWordImageView.topPos.equalTo(self.oldPassWordLine.bottomPos).offset(17.5);
        _passWordImageView.myLeft = 30;
        _passWordImageView.myWidth = 25;
        _passWordImageView.myHeight = 25;
        _passWordImageView.image = [UIImage imageNamed:@"sign_icon_password.png"];
    }
    return _passWordImageView;
}

- (UITextField *)lastPasswordTextField
{
    
    if (nil == _lastPasswordTextField) {
        _lastPasswordTextField = [UITextField new];
        _lastPasswordTextField.backgroundColor = [UIColor clearColor];
        _lastPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _lastPasswordTextField.font = [Color font:18.0 andFontName:nil];
        _lastPasswordTextField.textAlignment = NSTextAlignmentLeft;
//        _lastPasswordTextField.placeholder = @"请输入新密码";
        _lastPasswordTextField.secureTextEntry = YES;
        _lastPasswordTextField.delegate = self;
        NSString *holderText = @"请输入新密码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[Color color:PGColorOptionInputDefaultBlackGray]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[Color gc_Font:15.0]
                            range:NSMakeRange(0, holderText.length)];
        _lastPasswordTextField.attributedPlaceholder = placeholder;
        _lastPasswordTextField.textColor = [Color color:PGColorOptionTitleBlack];
        _lastPasswordTextField.heightSize.equalTo(@25);
        _lastPasswordTextField.leftPos.equalTo(self.passWordImageView.rightPos).offset(9);
        _lastPasswordTextField.rightPos.equalTo(self.showPassWordBtn.leftPos);
        _lastPasswordTextField.centerYPos.equalTo(self.passWordImageView.centerYPos);
        _lastPasswordTextField.userInteractionEnabled = YES;
        [_lastPasswordTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        UIButton *clearButton = [_lastPasswordTextField valueForKey:@"_clearButton"];
        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
            
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateHighlighted];
            
        }
    }
    return _lastPasswordTextField;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectPersonalTextField]; //个人用户输入界面
}
- (void)inspectPersonalTextField
{
    if ([self inspectPersonalInputUser] && [self inspectPersonalInputPassWord])
    {
        //输入正常,按钮可点击
        self.handInButton.userInteractionEnabled = YES;
        [self.handInButton setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.handInButton setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.handInButton.userInteractionEnabled = NO;
    }
}
//个人用户账户输入判断
- (BOOL)inspectPersonalInputUser
{
    if ([_oldPasswordTextField.text isEqualToString:@""] || _oldPasswordTextField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入原密码"];
//        [_oldPasswordTextField becomeFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}
- (BOOL)inspectPersonalInputPassWord
{
    if ([_lastPasswordTextField.text isEqualToString:@""] || _lastPasswordTextField.text == nil || ![SharedSingleton isValidatePassWord:_lastPasswordTextField.text])
    {
//        if ([_lastPasswordTextField.text isEqualToString:@""] || _lastPasswordTextField.text == nil) {
//            [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入新密码"];
//        }
//        else if (![SharedSingleton isValidatePassWord:_lastPasswordTextField.text])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:@"6-16位字符，只能包含字母、数字及标点符号（需两两组合），区分大小写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
//        [_lastPasswordTextField becomeFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}
- (UIButton*)showPassWordBtn{
    
    if(nil == _showPassWordBtn)
    {
        _showPassWordBtn = [UIButton buttonWithType:0];
        _showPassWordBtn.centerYPos.equalTo(self.passWordImageView.centerYPos);
        _showPassWordBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _showPassWordBtn.rightPos.equalTo(@12.5);
        _showPassWordBtn.widthSize.equalTo(@50);
        _showPassWordBtn.heightSize.equalTo(@50);
        [_showPassWordBtn setImage:[UIImage imageNamed:@"icon_invisible_bule.png"] forState:UIControlStateNormal];
        [_showPassWordBtn addTarget:self action:@selector(setSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPassWordBtn;
}
-(void)setSelectedButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"mine_icon_ exhibition"] forState:UIControlStateNormal];
        self.lastPasswordTextField.secureTextEntry = NO;
        
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"icon_invisible_bule"] forState:UIControlStateNormal];
        self.lastPasswordTextField.secureTextEntry = YES;
    }
}
- (UIView *)passWordLine
{
    if (nil == _passWordLine) {
        _passWordLine = [UIView new];
        _passWordLine.topPos.equalTo(self.passWordImageView.bottomPos).offset(13);
        _passWordLine.myHeight = 0.5;
        _passWordLine.myLeft = 25;
        _passWordLine.myRight = 25;
        _passWordLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _passWordLine;
}
- (UIButton*)handInButton
{
    
    if(nil == _handInButton)
    {
        _handInButton = [UIButton buttonWithType:0];
        _handInButton.topPos.equalTo(self.passWordLine.bottomPos).offset(25);
        _handInButton.rightPos.equalTo(@25);
        _handInButton.leftPos.equalTo(@25);
        _handInButton.heightSize.equalTo(@40);
        [_handInButton setTitle:@"提交" forState:UIControlStateNormal];
        _handInButton.titleLabel.font= [Color gc_Font:15.0];
        _handInButton.userInteractionEnabled = NO;
        [_handInButton setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        [_handInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_handInButton addTarget:self action:@selector(handIn:) forControlEvents:UIControlEventTouchUpInside];
        _handInButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _handInButton;
}
- (UIButton*)forgetBtn{
    
    if(_forgetBtn == nil)
    {
        _forgetBtn = [UIButton buttonWithType:0];
        _forgetBtn.topPos.equalTo(self.handInButton.bottomPos).offset(10);
        _forgetBtn.leftPos.equalTo(@25);
        _forgetBtn.widthSize.equalTo(@70);
        _forgetBtn.heightSize.equalTo(@30);
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _forgetBtn.titleLabel.font= [Color gc_Font:13.0];
        [_forgetBtn addTarget:self action:@selector(buttonforgetClick) forControlEvents:UIControlEventTouchUpInside];
        [_forgetBtn setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
    }
    return _forgetBtn;
}
-(void)buttonforgetClick
{
    UCFNewFindPassWordViewController *vc = [[UCFNewFindPassWordViewController alloc] init];
    [self.rt_navigationController pushViewController:vc animated:YES];
}









//// 初始化界面
//- (void)createUI
//{
//    self.oldPasswordTextField.layer.cornerRadius = 3;
//    self.oldPasswordTextField.clipsToBounds = YES;
//    self.oldPasswordTextField.layer.borderWidth = 0.5;
//    self.oldPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.oldPasswordTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
//    self.oldPasswordTextField.secureTextEntry = YES;
//
//    self.lastPasswordTextField.layer.cornerRadius = 3;
//    self.lastPasswordTextField.clipsToBounds = YES;
//    self.lastPasswordTextField.layer.borderWidth = 0.5;
//    self.lastPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.lastPasswordTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
//    self.lastPasswordTextField.secureTextEntry = YES;
//
//    UIImageView *oldPwLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
//    oldPwLeftImageView.contentMode = UIViewContentModeCenter;
//    oldPwLeftImageView.image = [UIImage imageNamed:@"login_icon_password"];
//
//    self.oldPasswordTextField.leftView = oldPwLeftImageView;
//
//    UIImageView *lastPwLeftImageView = [[UIImageView alloc] init];
//    lastPwLeftImageView.frame = oldPwLeftImageView.frame;
//    lastPwLeftImageView.contentMode = UIViewContentModeCenter;
//    lastPwLeftImageView.image = [UIImage imageNamed:@"login_icon_password"];
//    self.lastPasswordTextField.leftView = lastPwLeftImageView;
//
//    [self.handInButton setBackgroundImage:[self.handInButton.currentBackgroundImage stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
//    [self.handInButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
//
//    self.lastPasswordTextField.rightViewMode = UITextFieldViewModeAlways;
//
//    _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _eyeButton.frame = CGRectMake(0, 0, 40, 30);
//    [_eyeButton setImage:[UIImage imageNamed:@"login_btn_visible"] forState:UIControlStateNormal];
//    [_eyeButton addTarget:self action:@selector(visibleNewPassword:) forControlEvents:UIControlEventTouchUpInside];
//    _eyeButton.contentMode = UIViewContentModeCenter;
//    self.lastPasswordTextField.rightView = _eyeButton;
//}



// 按钮的点击事件
- (void)handIn:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_oldPasswordTextField.text isEqualToString:@""] || _oldPasswordTextField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入原密码"];
        [_oldPasswordTextField becomeFirstResponder];
        return;
    }
    if ([_lastPasswordTextField.text isEqualToString:@""] || _lastPasswordTextField.text == nil) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入新密码"];
        [_lastPasswordTextField becomeFirstResponder];
        return;
    }
    if (![SharedSingleton isValidatePassWord:_lastPasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:@"6-16位字符，只能包含字母、数字及标点符号（需两两组合），区分大小写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *userName = SingleUserInfo.loginData.userInfo.userId;
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:userName forKey:@"userId"];
    [parDic setValue:[MD5Util MD5Pwd:_oldPasswordTextField.text] forKey:@"oldPwd"];
    [parDic setValue:[MD5Util MD5Pwd:_lastPasswordTextField.text] forKey:@"newPwd"];
    
    if (parDic) {
        [[NetworkModule sharedNetworkModule] newPostReq:parDic tag:kSXTagUpdatePwd owner:self signature:YES Type:SelectAccoutDefault];
    }
}

- (void)visibleNewPassword:(UIButton *)sender {
    _isSecureTextEntry = !_isSecureTextEntry;
    _lastPasswordTextField.secureTextEntry = _isSecureTextEntry;
    NSString *tempStr = _lastPasswordTextField.text;
    _lastPasswordTextField.text = @"";
    _lastPasswordTextField.text = tempStr;
    
    if (!_isSecureTextEntry) {
        [_eyeButton setImage:[UIImage imageNamed:@"login_btn_invisible"] forState:UIControlStateNormal];
    } else {
        [_eyeButton setImage:[UIImage imageNamed:@"login_btn_visible"] forState:UIControlStateNormal];
    }
}

// 触摸代理事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - RequsetDelegate

- (void)beginPost:(kSXTag)tag
{
    //    if (self.settingBaseBgView.hidden) {
    //        self.settingBaseBgView.hidden = NO;
    //    }
    //    [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    //    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
    //    self.settingBaseBgView.hidden = YES;
    
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    
    if (tag.intValue == kSXTagUpdatePwd) {
        
        if([rstcode boolValue] )
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
            alertView.tag = 10001;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
            [SingleUserInfo deleteUserData];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        //        else
        //        {
        //            [AuxiliaryFunc showReEnterAlertViewWithMessage:rsttext delegate:self];
        //        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSUInteger selectedIndex = app.tabBarController.selectedIndex;
            UINavigationController *nav = [app.tabBarController.viewControllers objectAtIndex:selectedIndex];
            [nav popToRootViewControllerAnimated:NO];
            [app.tabBarController setSelectedIndex:0];
            [SingleUserInfo loadLoginViewController];
        });
    }
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    //    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
    //    self.settingBaseBgView.hidden = YES;
}



- (void)dealloc
{
    [self.oldPasswordTextField removeFromSuperview];
    self.oldPasswordTextField = nil;
    [self.lastPasswordTextField removeFromSuperview];
    self.lastPasswordTextField = nil;
}


@end
