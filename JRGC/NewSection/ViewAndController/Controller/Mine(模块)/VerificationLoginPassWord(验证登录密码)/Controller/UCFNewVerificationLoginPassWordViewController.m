//
//  UCFNewVerificationLoginPassWordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewVerificationLoginPassWordViewController.h"
#import "BaseAlertView.h"
#import "MD5Util.h"
#import "SharedSingleton.h"
#import "NZLabel.h"
#import "AppDelegate.h"
#import "UCFNewFindPassWordViewController.h"

@interface UCFNewVerificationLoginPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) NZLabel     *modifyLabel;//验证登录密码

@property (nonatomic, strong) NZLabel     *titleLabel;

@property (nonatomic, strong) UIImageView *oldPassWordImageView; //密码

@property (nonatomic, strong) UIView *oldPassWordLine;

@property (strong, nonatomic) UITextField *oldPasswordTextField;

@property (nonatomic, strong) UIButton *showPassWordBtn;


@property (strong, nonatomic) UIButton *handInButton;

@property (nonatomic, strong) UIButton *forgetBtn;//忘记密码
@end

@implementation UCFNewVerificationLoginPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self addLeftButton];
    //  设置隐藏导航栏
    self.isHideNavigationBar = YES;
    
    [self.oldPasswordTextField becomeFirstResponder];
    
    [self.rootLayout addSubview:self.modifyLabel];
    [self.rootLayout addSubview:self.titleLabel];
    [self.rootLayout addSubview:self.oldPassWordImageView];
    [self.rootLayout addSubview:self.oldPassWordLine];
    [self.rootLayout addSubview:self.oldPasswordTextField];
    [self.rootLayout addSubview:self.showPassWordBtn];
    
    [self.rootLayout addSubview:self.handInButton];
    [self.rootLayout addSubview:self.forgetBtn];
}
- (NZLabel *)modifyLabel
{
    if (nil == _modifyLabel) {
        _modifyLabel = [NZLabel new];
        _modifyLabel.myTop = 40;
        _modifyLabel.leftPos.equalTo(@26);
        _modifyLabel.textAlignment = NSTextAlignmentLeft;
        _modifyLabel.font = [Color gc_Font:30.0];
        _modifyLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _modifyLabel.text = @"验证登录密码";
        [_modifyLabel sizeToFit];
    }
    return _modifyLabel;
}

- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.topPos.equalTo(self.modifyLabel.bottomPos);
        _titleLabel.leftPos.equalTo(@26);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [Color gc_Font:15.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabel.text = self.titleString;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UIImageView *)oldPassWordImageView
{
    if (nil == _oldPassWordImageView) {
        _oldPassWordImageView = [[UIImageView alloc] init];
        _oldPassWordImageView.topPos.equalTo(self.titleLabel.bottomPos).offset(38);
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
        _oldPasswordTextField.font = [Color font:15.0 andFontName:nil];
        _oldPasswordTextField.textAlignment = NSTextAlignmentLeft;
        _oldPasswordTextField.placeholder = @"请输入密码";
        _oldPasswordTextField.secureTextEntry = YES;
        _oldPasswordTextField.delegate = self;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_oldPasswordTextField.placeholder attributes:dict];
        [_oldPasswordTextField setAttributedPlaceholder:attribute];
        _oldPasswordTextField.textColor = [Color color:PGColorOptionTitleBlack];
        _oldPasswordTextField.heightSize.equalTo(@25);
        _oldPasswordTextField.leftPos.equalTo(self.oldPassWordImageView.rightPos).offset(9);
        _oldPasswordTextField.myRight = 25;
        _oldPasswordTextField.centerYPos.equalTo(self.oldPassWordImageView.centerYPos);
        _oldPasswordTextField.userInteractionEnabled = YES;
        [_oldPasswordTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oldPasswordTextField;
}

- (UIButton*)showPassWordBtn{
    
    if(nil == _showPassWordBtn)
    {
        _showPassWordBtn = [UIButton buttonWithType:0];
        _showPassWordBtn.centerYPos.equalTo(self.oldPassWordImageView.centerYPos);
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
        self.oldPasswordTextField.secureTextEntry = NO;
        
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"icon_invisible_bule"] forState:UIControlStateNormal];
        self.oldPasswordTextField.secureTextEntry = YES;
    }
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

- (UIButton*)handInButton
{
    
    if(nil == _handInButton)
    {
        _handInButton = [UIButton buttonWithType:0];
        _handInButton.topPos.equalTo(self.oldPassWordLine.bottomPos).offset(25);
        _handInButton.rightPos.equalTo(@25);
        _handInButton.leftPos.equalTo(@25);
        _handInButton.heightSize.equalTo(@40);
        [_handInButton setTitle:@"提交验证" forState:UIControlStateNormal];
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
        _forgetBtn.topPos.equalTo(self.handInButton.bottomPos).offset(15);
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
// 按钮的点击事件
- (void)handIn:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self.oldPasswordTextField.text isEqualToString:@""]) {
        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入密码"];
        [self.oldPasswordTextField becomeFirstResponder];
        return;
    }
    
    
    
    NSString* phoneNumberStr = [self.oldPasswordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *isCompanyStr  = [NSString stringWithFormat:@"%d",SingleUserInfo.loginData.userInfo.isCompanyAgent];
    NSDictionary *param = @{@"username":SingleUserInfo.loginData.userInfo.loginName, @"pwd": [MD5Util MD5Pwd:phoneNumberStr],@"isCompany":isCompanyStr};
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagValidBindedPhone owner:self signature:YES Type:SelectAccoutTypeP2P ];
}
#pragma mark -RequsetDelegate

-(void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    if (tag.intValue == kSXTagValidBindedPhone) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([dic[@"ret"] boolValue]) {
            //            if ([_sourceVC isEqualToString:@"securityCenter_touchID"]) {
            //
            //            } else if ([_sourceVC isEqualToString:@"securityCenter"]) {
            //
            //            } else {
            //
            //            }
            
            //            [LLLockPassword saveLockPassword:nil];
            //            [self loginSuccess:dic];
//            [self gesturePage];
        } else {
            NSString *rsttext =  dic[@"message"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil];
            [alertView show];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    
    if (tag.intValue == kSXTagLogin||tag.intValue == kSXTagValidBindedPhone||tag.intValue == kSXTagUserLogout) {
        [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectPersonalTextField]; //个人用户输入界面
}
- (void)inspectPersonalTextField
{
    if ([self inspectPersonalInputUser])
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
    if ([self.oldPasswordTextField.text isEqualToString:@""] || self.oldPasswordTextField.text == nil || ![SharedSingleton isValidatePassWord:self.oldPasswordTextField.text]) {
//        [[BaseAlertView getShareBaseAlertView] showStringOnTop:@"请输入原密码"];
        //        [_oldPasswordTextField becomeFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
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
