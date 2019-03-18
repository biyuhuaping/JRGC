//
//  UCFNewLoginInputNameAndPassWordView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewLoginInputNameAndPassWordView.h"
@interface UCFNewLoginInputNameAndPassWordView ()


@property (nonatomic, strong) UIImageView *userImageView; //密码

@property (nonatomic, strong) UIView *userLine;


@property (nonatomic, strong) UIImageView *passWordImageView; //密码

@property (nonatomic, strong) UIButton *showPassWordBtn;

@property (nonatomic, strong) UIView *passWordLine;

@property (nonatomic, copy) NSString *userType;

@end
@implementation UCFNewLoginInputNameAndPassWordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
- (instancetype)initWithFrame:(CGRect)frame withUserType:(NSString *)userType //个人和企业
{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        self.userType = userType;
        self.backgroundColor = [Color color:PGColorOptionThemeWhite];
        
        [self.rootLayout addSubview:self.userImageView];
        [self.rootLayout addSubview:self.userField];
        [self.rootLayout addSubview:self.userLine];
        [self.rootLayout addSubview:self.loginBtn];
        
        
        [self.rootLayout addSubview:self.passWordImageView];
        [self.rootLayout addSubview:self.passWordField];
        [self.rootLayout addSubview:self.showPassWordBtn];
        [self.rootLayout addSubview:self.passWordLine];
    }
    return self;
}
- (UIImageView *)userImageView
{
    if (nil == _userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.myTop = 37;
        _userImageView.myLeft = 30;
        _userImageView.myWidth = 25;
        _userImageView.myHeight = 25;
        if ([self.userType isEqualToString:@"个人"]) {
            _userImageView.image = [UIImage imageNamed:@"loginUserIcon.png"];
        }
        else{
            _userImageView.image = [UIImage imageNamed:@"sign_icon_phone.png"];
        }
        
    }
    return _userImageView;
}

- (UITextField *)userField
{
    
    if (nil == _userField) {
        _userField = [UITextField new];
        _userField.backgroundColor = [UIColor clearColor];
        _userField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userField.font = [Color font:15.0 andFontName:nil];
        _userField.textAlignment = NSTextAlignmentLeft;
        if ([self.userType isEqualToString:@"个人"]) {
            _userField.placeholder = @"用户名 / 邮箱 / 手机号";
        }
        else{
            _userField.placeholder = @"手机号";
            
        }
        if ([self.userType isEqualToString:@"企业"]) {
            //只有企业是纯数字键盘
             _userField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        // 读取上次登录的账号...
//        [NSDictionary dictionaryWithObjectsAndKeys:isCompany,@"isCompany",username,@"lastLoginName", nil];
        NSDictionary *dic = [[UserInfoSingle sharedManager] getLoginAccount];
        if ([dic isKindOfClass:[NSDictionary class]] && nil != dic && dic.count > 0) {
            if ([[dic objectSafeForKey:@"isCompany"] isEqualToString:@"个人"] && [self.userType isEqualToString:@"个人"]) {
                _userField.text = [dic objectSafeForKey:@"lastLoginName"];
            }
            if ([[dic objectSafeForKey:@"isCompany"] isEqualToString:@"企业"] && [self.userType isEqualToString:@"企业"]) {
                _userField.text = [dic objectSafeForKey:@"lastLoginName"];
            }
        }

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_userField.placeholder attributes:dict];
        [_userField setAttributedPlaceholder:attribute];
        _userField.textColor = [Color color:PGColorOptionTitleBlack];
        _userField.heightSize.equalTo(@25);
        _userField.leftPos.equalTo(self.userImageView.rightPos).offset(9);
        _userField.rightPos.equalTo(self.rootLayout.rightPos).offset(20);
        _userField.centerYPos.equalTo(self.userImageView.centerYPos);
        _userField.userInteractionEnabled = YES;
    }
    return _userField;
}


- (UIView *)userLine
{
    if (nil == _userLine) {
        _userLine = [UIView new];
        _userLine.topPos.equalTo(self.userImageView.bottomPos).offset(13);
        _userLine.centerXPos.equalTo(self.rootLayout.centerXPos);
        _userLine.myHeight = 0.5;
        _userLine.widthSize.equalTo(self.rootLayout.widthSize).add(-50);
        _userLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _userLine;
}

- (UIImageView *)passWordImageView
{
    if (nil == _passWordImageView) {
        _passWordImageView = [[UIImageView alloc] init];
        _passWordImageView.topPos.equalTo(self.userLine.bottomPos).offset(17.5);
        _passWordImageView.myLeft = 30;
        _passWordImageView.myWidth = 25;
        _passWordImageView.myHeight = 25;
        _passWordImageView.image = [UIImage imageNamed:@"sign_icon_password.png"];
    }
    return _passWordImageView;
}

- (UITextField *)passWordField
{
    
    if (nil == _passWordField) {
        _passWordField = [UITextField new];
        _passWordField.backgroundColor = [UIColor clearColor];
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordField.font = [Color font:15.0 andFontName:nil];
        _passWordField.textAlignment = NSTextAlignmentLeft;
        _passWordField.placeholder = @"6-16位密码，数字、字母组合";
        _passWordField.secureTextEntry = YES;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_passWordField.placeholder attributes:dict];
        [_passWordField setAttributedPlaceholder:attribute];
        _passWordField.textColor = [Color color:PGColorOptionTitleBlack];
        _passWordField.heightSize.equalTo(@25);
        _passWordField.leftPos.equalTo(self.passWordImageView.rightPos).offset(9);
        _passWordField.rightPos.equalTo(self.showPassWordBtn.leftPos);
        _passWordField.centerYPos.equalTo(self.passWordImageView.centerYPos);
        _passWordField.userInteractionEnabled = YES;
    }
    return _passWordField;
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
- (UIButton*)loginBtn
{
    
    if(nil == _loginBtn)
    {
        _loginBtn = [UIButton buttonWithType:0];
        _loginBtn.topPos.equalTo(self.passWordLine.bottomPos).offset(25);
        _loginBtn.rightPos.equalTo(@25);
        _loginBtn.leftPos.equalTo(@25);
        _loginBtn.heightSize.equalTo(@40);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font= [Color gc_Font:15.0];
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _loginBtn;
}
-(void)setSelectedButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"mine_icon_ exhibition"] forState:UIControlStateNormal];
        self.passWordField.secureTextEntry = NO;

    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"icon_invisible_bule"] forState:UIControlStateNormal];
        self.passWordField.secureTextEntry = YES;
    }
}

- (void)setLoginButtonState:(BOOL)isButtonState
{
    if (isButtonState) {
        
        //PGColorOptionButtonBackgroundColorGray
        self.loginBtn.userInteractionEnabled = YES;
        [self.loginBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        self.loginBtn.userInteractionEnabled = NO;
        [self.loginBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
    }
    
}



@end
