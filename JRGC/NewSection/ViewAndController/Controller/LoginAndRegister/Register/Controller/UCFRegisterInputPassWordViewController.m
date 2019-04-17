//
//  UCFRegisterInputPassWordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterInputPassWordViewController.h"
#import "NZLabel.h"
#import "SharedSingleton.h"
#import "UCFRegisterUserBaseMessRegisterApi.h"
#import "UCFRegisterUserBaseMessRegisterModel.h"
#import "IQKeyboardManager.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "MD5Util.h"
#import "FMDeviceManager.h"
#import "UCFLockHandleViewController.h"
@interface UCFRegisterInputPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) NZLabel     *passWordTitleLabel;//设置登录密码标题

@property (nonatomic, strong) UIImageView *passWordImageView; //密码

@property (nonatomic, strong) UITextField *passWordField;

@property (nonatomic, strong) UIButton *showPassWordBtn;

@property (nonatomic, strong) UIView *passWordLine;


@property (nonatomic, strong) UIImageView *recommendImageView;//工厂码

@property (nonatomic, strong) UITextField *recommendField;

@property (nonatomic, strong) UIView *recommendLine;

@property (nonatomic, strong) NZLabel     *recommendTitleLabel;//工场码提示标题

@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation UCFRegisterInputPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
   
    [self.rootLayout addSubview:self.passWordTitleLabel];
    [self.rootLayout addSubview:self.passWordImageView];
    [self.rootLayout addSubview:self.passWordField];
    [self.rootLayout addSubview:self.showPassWordBtn];
    [self.rootLayout addSubview:self.passWordLine];
    [self.rootLayout addSubview:self.recommendImageView];
    [self.rootLayout addSubview:self.recommendField];
    [self.rootLayout addSubview:self.recommendLine];
    [self.rootLayout addSubview:self.recommendTitleLabel];
    [self.rootLayout addSubview:self.registerBtn];
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
- (void)addLeftButton
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
    [self.rootLayout endEditing:NO];
    [self.rt_navigationController popToRootViewControllerAnimated:YES];
}

- (NZLabel *)passWordTitleLabel
{
    if (nil == _passWordTitleLabel) {
        _passWordTitleLabel = [NZLabel new];
        _passWordTitleLabel.myTop = 40;
        _passWordTitleLabel.leftPos.equalTo(@26);
        _passWordTitleLabel.textAlignment = NSTextAlignmentLeft;
        _passWordTitleLabel.font = [Color gc_Font:30.0];
        _passWordTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _passWordTitleLabel.text = @"请设置登录密码";
        [_passWordTitleLabel sizeToFit];
    }
    return _passWordTitleLabel;
}

- (UIImageView *)passWordImageView
{
    if (nil == _passWordImageView) {
        _passWordImageView = [[UIImageView alloc] init];
        _passWordImageView.topPos.equalTo(self.passWordTitleLabel.bottomPos).offset(38);
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
        _passWordField.delegate = self;
//            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_passWordField.placeholder attributes:dict];
        [_passWordField setAttributedPlaceholder:attribute];
        _passWordField.textColor = [Color color:PGColorOptionTitleBlack];
        _passWordField.heightSize.equalTo(@25);
        _passWordField.leftPos.equalTo(self.passWordImageView.rightPos).offset(9);
        _passWordField.rightPos.equalTo(self.showPassWordBtn.leftPos).offset(10);
        _passWordField.centerYPos.equalTo(self.passWordImageView.centerYPos);
        [_passWordField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
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
        _passWordLine.topPos.equalTo(self.passWordImageView.bottomPos).offset(12);
        _passWordLine.myHeight = 0.5;
        _passWordLine.myLeft = 25;
        _passWordLine.myRight = 25;
        _passWordLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _passWordLine;
}

- (UIImageView *)recommendImageView
{
    if (nil == _recommendImageView) {
        _recommendImageView = [[UIImageView alloc] init];
        _recommendImageView.topPos.equalTo(self.passWordImageView.bottomPos).offset(35);
        _recommendImageView.leftPos.equalTo(self.passWordImageView.leftPos);
        _recommendImageView.heightSize.equalTo(self.passWordImageView.heightSize);
        _recommendImageView.widthSize.equalTo(self.passWordImageView.widthSize);
        _recommendImageView.image = [UIImage imageNamed:@"sign_icon_gong.png"];
    }
    return _recommendImageView;
}

- (UITextField *)recommendField
{
    if (nil == _recommendField) {
        _recommendField = [UITextField new];
        _recommendField.backgroundColor = [UIColor clearColor];
        _recommendField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _recommendField.font = [Color font:15.0 andFontName:nil];
        _recommendField.textAlignment = NSTextAlignmentLeft;
        _recommendField.placeholder = @"推荐人工场码(选填)";
        _recommendField.delegate = self;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_recommendField.placeholder attributes:dict];
        [_recommendField setAttributedPlaceholder:attribute];
        _recommendField.textColor = [Color color:PGColorOptionTitleBlack];
        _recommendField.heightSize.equalTo(@25);
        _recommendField.leftPos.equalTo(self.recommendImageView.rightPos).offset(9);
        _recommendField.rightPos.equalTo(self.rootLayout.rightPos).offset(25);
        _recommendField.centerYPos.equalTo(self.recommendImageView.centerYPos);
        
    }
    return _recommendField;
}

- (UIView *)recommendLine
{
    if (nil == _recommendLine) {
        _recommendLine = [UIView new];
        _recommendLine.topPos.equalTo(self.recommendImageView.bottomPos).offset(12);
        _recommendLine.myHeight = 0.5;
        _recommendLine.myLeft = 25;
        _recommendLine.myRight = 25;
        _recommendLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _recommendLine;
}

- (NZLabel *)recommendTitleLabel
{
    if (nil == _recommendTitleLabel) {
        _recommendTitleLabel = [NZLabel new];
        _recommendTitleLabel.topPos.equalTo(self.recommendLine.bottomPos).offset(10);
        _recommendTitleLabel.leftPos.equalTo(@25);
        _recommendTitleLabel.textAlignment = NSTextAlignmentLeft;
        _recommendTitleLabel.font = [Color gc_Font:13.0];
        _recommendTitleLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        _recommendTitleLabel.text = @"输入推荐人工场码，将获得更多返利（没有可不填）";
        [_recommendTitleLabel sizeToFit];
    }
    return _recommendTitleLabel;
}


- (UIButton*)registerBtn{
    
    if(_registerBtn == nil)
    {
        _registerBtn = [UIButton buttonWithType:0];
        _registerBtn.topPos.equalTo(self.recommendTitleLabel.bottomPos).offset(24);
        _registerBtn.rightPos.equalTo(@25);
        _registerBtn.leftPos.equalTo(@25);
        _registerBtn.heightSize.equalTo(@40);
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font= [Color gc_Font:15.0];
        _registerBtn.userInteractionEnabled = NO;
        [_registerBtn setBackgroundColor:[Color color:PGColorOptionButtonBackgroundColorGray]];
        [_registerBtn setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        _registerBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
        [_registerBtn addTarget:self action:@selector(buttonregisterClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
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

- (void)buttonregisterClick
{
    if (self.recommendField.text != nil && ![self.recommendField.text isEqualToString:@""])
    {
        //有推荐码,就先去检测推荐码,然后再请求注册,没有就直接请求注册
        NSString *strParameters = [NSString stringWithFormat:@"pomoCode=%@",self.recommendField.text];
        if (strParameters) {
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagValidpomoCode owner:self Type:SelectAccoutDefault];
        }
    }
    else
    {
        //同盾
        // 获取设备管理器实例
        FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
        //        manager->getDeviceInfoAsync(nil, self);
        //#warning 同盾修改
        NSString *blackBox = manager->getDeviceInfo();
        //        NSLog(@"同盾设备指纹数据: %@", blackBox);
        [self requestRegister:@"" andToken_id:blackBox];
    }
    
}
-(void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    if (tag.intValue == kSXTagValidpomoCode) {
        if (rstcode && [rstcode intValue] == 1) {
            //同盾
            // 获取设备管理器实例
            FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
            //            manager->getDeviceInfoAsync(nil, self);
            //#warning 同盾修改
            NSString *blackBox = manager->getDeviceInfo();
            //            DDLogDebug(@"同盾设备指纹数据: %@", blackBox);
            [self requestRegister:self.recommendField.text andToken_id:blackBox];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [AuxiliaryFunc showToastMessage:@"当前没有网络，请检查网络！" withView:self.view];
}
- (void)requestRegister:(NSString *)FactoryCode andToken_id:(NSString *)token_id
{
    UCFRegisterUserBaseMessRegisterApi * request = [[UCFRegisterUserBaseMessRegisterApi alloc] initWithFactoryCode:FactoryCode andPhoneNo:self.phoneNo andPwd:self.passWordField.text andRegistTicket:self.registTicket andToken_id:token_id];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFRegisterUserBaseMessRegisterModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            
            [SingleUserInfo saveLoginAccount:[NSDictionary dictionaryWithObjectsAndKeys:@"个人",@"isCompany",self.phoneNo,@"lastLoginName", nil]];
            [SingleUserInfo setUserData:model.data withPassWord:self.passWordField.text];
            [self.rootLayout endEditing:YES];
            [SingGlobalView.rootNavController pushViewController:[self cretateLockViewWithType:LLLockViewTypeCreate] animated:YES complete:^(BOOL finished) {
                //                [SingGlobalView.tabBarController.selectedViewController.navigationController popToRootViewControllerAnimated:NO];
                //                [SingGlobalView.tabBarController setSelectedIndex:0];
                [SingGlobalView.rootNavController removeViewController:self];
            }];            
        }
        else{
            if(model.code == 2) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户名格式不正确" message:model.message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [alertView show];
            } else if(model.code == 4) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:model.message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:model.message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [alertView show];
            }
//            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
- (UCFLockHandleViewController *)cretateLockViewWithType:(LLLockViewType)type
{
    UCFLockHandleViewController *lockVc = [[UCFLockHandleViewController alloc] initWithType:type];
    lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return lockVc;
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.rootLayout endEditing:YES];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField == self.passWordField) {
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
//    else if (textField == self.recommendField) {
//        if (existedLength - selectedLength + replaceLength > 6) {
//            return NO;
//        }
//    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passWordField) {
        if (![self inspectPassWord]) {
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码格式不正确" message:@"6-16位字符，只能包含字母、数字及标点符号（必须组合），区分大小写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            ShowMessage(@"密码格式不正确");
            return;
        }
    }
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectTextField];
}
- (void)inspectTextField
{
    if ([self inspectPassWord]) {
        //输入正常,按钮可点击
        self.registerBtn.userInteractionEnabled = YES;
        [self.registerBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.registerBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.registerBtn.userInteractionEnabled = NO;
    }
}
- (BOOL)inspectPassWord
{
    if ([SharedSingleton isValidatePassWord:self.passWordField.text]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
