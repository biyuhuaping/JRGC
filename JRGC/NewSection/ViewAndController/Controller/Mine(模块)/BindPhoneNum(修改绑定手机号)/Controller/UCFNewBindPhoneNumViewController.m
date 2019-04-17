//
//  UCFNewBindPhoneNumViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/29.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBindPhoneNumViewController.h"
#import "SharedSingleton.h"
#import "MD5Util.h"
#import "NZLabel.h"
#import "UCFNewBindPhoneNumSMSViewController.h"
#import "UIImageView+NetImageView.h"
@interface UCFNewBindPhoneNumViewController() <UITextFieldDelegate, UIAlertViewDelegate>{
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}
@property (nonatomic, strong) MyRelativeLayout *rootLayout;

// 标题
@property (strong, nonatomic) NZLabel *titleLabel;
// 已绑定的手机号
@property (strong, nonatomic) NZLabel *bindedPhoneLabel;
// 新手机号
@property (strong, nonatomic) UITextField *moddifyPhoneTextField;

@property (nonatomic, strong) UIView *moddifyPhoneLine;

@property (nonatomic, strong) UIImageView *moddifyPhoneImageView;

// 登录密码
@property (strong, nonatomic) UITextField *loginPwdTextField;

@property (nonatomic, strong) UIImageView *passWordImageView;

@property (nonatomic, strong) UIButton *showPassWordBtn;

@property (nonatomic, strong) UIView *passWordLine;
// 下一步
@property (strong, nonatomic) UIButton *nextBtn;

@end
@implementation UCFNewBindPhoneNumViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self addLeftButton];
    
    [self.rootLayout addSubview:self.titleLabel];
    [self.rootLayout addSubview:self.bindedPhoneLabel];
    [self.rootLayout addSubview:self.moddifyPhoneTextField];
    [self.rootLayout addSubview:self.moddifyPhoneLine];
    [self.rootLayout addSubview:self.moddifyPhoneImageView];
    [self.rootLayout addSubview:self.loginPwdTextField];
    [self.rootLayout addSubview:self.passWordImageView];
    [self.rootLayout addSubview:self.showPassWordBtn];
    [self.rootLayout addSubview:self.passWordLine];
    [self.rootLayout addSubview:self.nextBtn];
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

- (NZLabel *)bindedPhoneLabel
{
    if (nil == _bindedPhoneLabel) {
        _bindedPhoneLabel = [NZLabel new];
        _bindedPhoneLabel.topPos.equalTo(self.titleLabel.bottomPos);
        _bindedPhoneLabel.leftPos.equalTo(@26);
        _bindedPhoneLabel.textAlignment = NSTextAlignmentLeft;
        _bindedPhoneLabel.font = [Color gc_Font:15.0];
        _bindedPhoneLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _bindedPhoneLabel.text = [NSString stringWithFormat:@"绑定手机%@",self.authedPhone];
        [_bindedPhoneLabel sizeToFit];
    }
    return _bindedPhoneLabel;
}

- (UIImageView *)moddifyPhoneImageView
{
    if (nil == _moddifyPhoneImageView) {
        _moddifyPhoneImageView = [[UIImageView alloc] init];
        _moddifyPhoneImageView.topPos.equalTo(self.bindedPhoneLabel.bottomPos).offset(38);
        _moddifyPhoneImageView.myLeft = 30;
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
        _moddifyPhoneTextField.font = [Color font:15.0 andFontName:nil];
        _moddifyPhoneTextField.textAlignment = NSTextAlignmentLeft;
        _moddifyPhoneTextField.placeholder = @"请输入原绑定手机号";
        _moddifyPhoneTextField.delegate = self;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_moddifyPhoneTextField.placeholder attributes:dict];
        [_moddifyPhoneTextField setAttributedPlaceholder:attribute];
        _moddifyPhoneTextField.textColor = [Color color:PGColorOptionTitleBlack];
        _moddifyPhoneTextField.heightSize.equalTo(@25);
        _moddifyPhoneTextField.leftPos.equalTo(self.moddifyPhoneImageView.rightPos).offset(9);
        _moddifyPhoneTextField.myRight = 25;
        _moddifyPhoneTextField.centerYPos.equalTo(self.moddifyPhoneImageView.centerYPos);
        _moddifyPhoneTextField.userInteractionEnabled = YES;
        [_moddifyPhoneTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
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
        _moddifyPhoneLine.widthSize.equalTo(self.rootLayout.widthSize).add(-50);
        _moddifyPhoneLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _moddifyPhoneLine;
}


- (UIImageView *)passWordImageView
{
    if (nil == _passWordImageView) {
        _passWordImageView = [[UIImageView alloc] init];
        _passWordImageView.topPos.equalTo(self.moddifyPhoneLine.bottomPos).offset(17.5);
        _passWordImageView.myLeft = 30;
        _passWordImageView.myWidth = 25;
        _passWordImageView.myHeight = 25;
        _passWordImageView.image = [UIImage imageNamed:@"sign_icon_password.png"];
    }
    return _passWordImageView;
}

- (UITextField *)loginPwdTextField
{
    
    if (nil == _loginPwdTextField) {
        _loginPwdTextField = [UITextField new];
        _loginPwdTextField.backgroundColor = [UIColor clearColor];
        _loginPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _loginPwdTextField.font = [Color font:15.0 andFontName:nil];
        _loginPwdTextField.textAlignment = NSTextAlignmentLeft;
        _loginPwdTextField.placeholder = @"请输入登录密码";
        _loginPwdTextField.secureTextEntry = YES;
        _loginPwdTextField.delegate = self;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_loginPwdTextField.placeholder attributes:dict];
        [_loginPwdTextField setAttributedPlaceholder:attribute];
        _loginPwdTextField.textColor = [Color color:PGColorOptionTitleBlack];
        _loginPwdTextField.heightSize.equalTo(@25);
        _loginPwdTextField.leftPos.equalTo(self.passWordImageView.rightPos).offset(9);
        _loginPwdTextField.rightPos.equalTo(self.showPassWordBtn.leftPos);
        _loginPwdTextField.centerYPos.equalTo(self.passWordImageView.centerYPos);
        _loginPwdTextField.userInteractionEnabled = YES;
        [_loginPwdTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _loginPwdTextField;
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
        self.loginPwdTextField.secureTextEntry = NO;
        
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"icon_invisible_bule"] forState:UIControlStateNormal];
        self.loginPwdTextField.secureTextEntry = YES;
    }
}
- (UIButton*)nextBtn
{
    
    if(_nextBtn == nil)
    {
        _nextBtn = [UIButton buttonWithType:0];
        _nextBtn.topPos.equalTo(self.passWordLine.bottomPos).offset(25);
        _nextBtn.rightPos.equalTo(@25);
        _nextBtn.leftPos.equalTo(@25);
        _nextBtn.heightSize.equalTo(@40);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font= [Color gc_Font:15.0];
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundColor:[Color color:PGColorOptionButtonBackgroundColorGray]];
        [_nextBtn setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        _nextBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
        [_nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectTextField]; //个人用户输入界面
}

- (void)inspectTextField
{
    if ([self inspectPassWord] && [self inspectPhoneNum]) {
        //输入正常,按钮可点击
        self.nextBtn.userInteractionEnabled = YES;
        [self.nextBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.nextBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
    }
}
- (BOOL)inspectPassWord
{
    if ([SharedSingleton isValidatePassWord:self.loginPwdTextField.text]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)inspectPhoneNum
{
    if (self.moddifyPhoneTextField.text && self.moddifyPhoneTextField.text.length == 11) {
        return YES;
    }
    else
    {
        return NO;
    }
}



//// 初始化界面
//- (void)createUI
//{
//    //    self.bindedPhoneLabel.text = self.authedPhone == nil ? @"" : self.authedPhone;
//    
//    baseTitleLabel.text = @"绑定手机号";
//    if (self.authedPhone == nil) {
//        self.bindedPhoneLabel.text = @"";
//    }
//    else {
//        self.bindedPhoneLabel.text = self.authedPhone;
//    }
//    
//    self.moddifyPhoneTextField.layer.cornerRadius = 3;
//    self.moddifyPhoneTextField.clipsToBounds = YES;
//    self.moddifyPhoneTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
//    self.moddifyPhoneTextField.layer.borderWidth = 0.5;
//    
//    UIImageView *idImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
//    idImageView.image = [UIImage imageNamed:@"login_icon_phone"];
//    idImageView.contentMode = UIViewContentModeCenter;
//    self.moddifyPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.moddifyPhoneTextField.leftView = idImageView;
//    
//    self.loginPwdTextField.layer.cornerRadius = 3;
//    self.loginPwdTextField.clipsToBounds = YES;
//    self.loginPwdTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
//    self.loginPwdTextField.layer.borderWidth = 0.5;
//    
//    UIImageView *loginPwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
//    loginPwdImageView.image = [UIImage imageNamed:@"login_icon_password"];
//    loginPwdImageView.contentMode = UIViewContentModeCenter;
//    self.loginPwdTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.loginPwdTextField.leftView = loginPwdImageView;
//    
//    [self.nextStep setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
//    [self.nextStep setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
//    
//    [self.moddifyPhoneTextField becomeFirstResponder];
//    
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [self.moddifyPhoneTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//}

// 键盘通知
//- (void)keyboardFrameChanged:(NSNotification *)noti
//{
//    NSValue *keyboardFrame = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//
//    CGFloat keyboardY = CGRectGetMinY([keyboardFrame CGRectValue]);
//    CGFloat textfieldBottomY = CGRectGetMaxY(self.loginPwdTextField.frame);
//    if (keyboardY < textfieldBottomY + 10) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.view.frame = CGRectMake(0, keyboardY - textfieldBottomY - 10, ScreenWidth, ScreenHeight);
//        }];
//    }
//    else {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        }];
//    }
//}
//
//#pragma mark - UITextField
////1.在UITextField的代理方法中实现手机号只能输入数字并满足我们的要求（首位只能是1，其他必须是0~9的纯数字）
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == _moddifyPhoneTextField) {
//        previousTextFieldContent = textField.text;
//        previousSelection = textField.selectedTextRange;
//        if (range.location == 0){
//            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1"] invertedSet];
//            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//            BOOL basicTest = [string isEqualToString:filtered];
//            if (!basicTest){
//                //[self showMyMessage:@"只能输入数字"];
//                return NO;
//            }
//        }
//        else {
//            NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
//            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//            if ([string rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
//                return NO;
//            }
//        }
//    }
//    return YES;
//}
//
////3.让手机号实现344格式
//- (void)textFieldEditingChanged:(UITextField *)textField
//{
//    //限制手机账号长度（有两个空格）
//    if (textField.text.length > 13) {
//        textField.text = [textField.text substringToIndex:13];
//    }
//
//    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
//
//    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    //正在执行删除操作时为0，否则为1
//    char editFlag = 0;
//    if (currentStr.length <= preStr.length) {
//        editFlag = 0;
//    } else {
//        editFlag = 1;
//    }
//
//    NSMutableString *tempStr = [NSMutableString new];
//
//    int spaceCount = 0;
//    if (currentStr.length < 3 && currentStr.length > -1) {
//        spaceCount = 0;
//    }else if (currentStr.length < 7 && currentStr.length > 2) {
//        spaceCount = 1;
//    }else if (currentStr.length < 12 && currentStr.length > 6) {
//        spaceCount = 2;
//    }
//
//    for (int i = 0; i < spaceCount; i++) {
//        if (i == 0) {
//            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
//        }else if (i == 1) {
//            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
//        }else if (i == 2) {
//            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
//        }
//    }
//
//    if (currentStr.length == 11) {
//        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
//    }
//    if (currentStr.length < 4) {
//        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
//    }else if(currentStr.length > 3 && currentStr.length < 12) {
//        NSString *str = [currentStr substringFromIndex:3];
//        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
//        if (currentStr.length == 11) {
//            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
//        }
//    }
//    textField.text = tempStr;
//    // 当前光标的偏移位置
//    NSUInteger curTargetCursorPosition = targetCursorPosition;
//
//    if (editFlag == 0) {
//        //删除
//        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
//            curTargetCursorPosition = targetCursorPosition - 1;
//        }
//    }else {
//        //添加
//        if (currentStr.length == 8 || currentStr.length == 4) {
//            curTargetCursorPosition = targetCursorPosition + 1;
//        }
//    }
//    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
//    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
//}
//
//
//
////  下一步按钮的点击事件
- (IBAction)nextStep:(id)sender {
    [self.view endEditing:YES];
    NSString* str = [self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *oldPhoneNum = [Common deleteStrHeadAndTailSpace:str];
    if (oldPhoneNum.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请输入原绑定手机号" withView:self.view];
        //        [self.moddifyPhoneTextField becomeFirstResponder];
        return;
    }
    NSString *password = [Common deleteStrHeadAndTailSpace:self.loginPwdTextField.text];
    if (password.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请输入登录密码" withView:self.view];
        //        [self.loginPwdTextField becomeFirstResponder];
        return;
    }
    BOOL isPhoneNum = [SharedSingleton checkPhoneNumber:str];
    if (!isPhoneNum) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alertView.tag = 99;
        [alertView show];
        return;
    }
    //    BOOL isPassword = [SharedSingleton isValidatePassWord:self.loginPwdTextField.text];
    //    if (!isPassword) {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码格式错误" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
    //        alertView.tag = 100;
    //        [alertView show];
    //        return;
    //    }
    [self getIsValidPhoneNumAndPasswordFromNetData];
    //    UCFModifyPhoneViewController *modifyPhone = [[UCFModifyPhoneViewController alloc] init];
    //    modifyPhone.title = @"修改绑定手机号";
    //    [self.navigationController pushViewController:modifyPhone animated:YES];

}
// 获取网络数据
- (void)getIsValidPhoneNumAndPasswordFromNetData
{
    NSString* phoneNumberStr = [self.moddifyPhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *isCompanyStr  = [NSString stringWithFormat:@"%d",SingleUserInfo.loginData.userInfo.isCompanyAgent];
    NSDictionary *param = @{@"username": phoneNumberStr, @"pwd": [MD5Util MD5Pwd:self.loginPwdTextField.text],@"isCompany":isCompanyStr};
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagValidBindedPhone owner:self signature:YES Type:SelectAccoutTypeP2P ];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    //    DDLogDebug(@"首页获取最新项目列表：%@",data);

    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];

    if (tag.intValue == kSXTagValidBindedPhone)
    {
        if ([rstcode boolValue] ) {
//            UCFModifyPhoneViewController *modifyPhone = [[UCFModifyPhoneViewController alloc]initWithNibName:@"UCFModifyPhoneViewController" bundle:nil];
//            modifyPhone.title = @"修改绑定手机号";
//            modifyPhone.rootVc = _uperViewController;
//            [self.navigationController pushViewController:modifyPhone animated:YES];
            UCFNewBindPhoneNumSMSViewController *modifyPhone = [[UCFNewBindPhoneNumSMSViewController alloc] init];
            [self.rt_navigationController pushViewController:modifyPhone animated:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
            alertView.tag = [rstcode  integerValue];
            [alertView show];
        }
    }
}

// 警告框代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 2:
            return;
        case 3: {
            self.loginPwdTextField.text = @"";
            [self.loginPwdTextField becomeFirstResponder];
        }
            break;
        case 4: {
            self.loginPwdTextField.text = @"";
            [self.moddifyPhoneTextField becomeFirstResponder];
        }
            break;
        case 99:
            [self.moddifyPhoneTextField becomeFirstResponder];
            break;
        case 100:
            [self.loginPwdTextField becomeFirstResponder];
            break;
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagValidBindedPhone) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
@end
