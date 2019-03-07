//
//  UCFRegisterInputPhoneNumViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterInputPhoneNumViewController.h"
#import "NZLabel.h"
#import "UCFRegistVerificationMobileApi.h"
#import "UCFRegistVerificationMobileModel.h"
#import "UCFRegisterGetRegisterInfoModel.h"
#import "UCFRegisterGetRegisterInfoApi.h"
#import "UCFXieYiViewController.h"
#import "UCFNewLoginViewController.h"
#import "IQKeyboardManager.h"
#import "UCFRegisterInputVerificationCodeViewController.h"

@interface UCFRegisterInputPhoneNumViewController ()<YTKChainRequestDelegate,UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UIButton *closeBtn; //关闭按钮

@property (nonatomic, strong) UIButton *loginBtn; //d切换到登录按钮

@property (nonatomic, strong) NZLabel     *registerLabel;//注册

@property (nonatomic, strong) NZLabel     *registerContentLabel;//注册内容

@property (nonatomic, strong) UIImageView *registerImageView;//注册的图片

@property (nonatomic, strong) UIImageView *registerPhoneImageView;//注册的手机图片

@property (nonatomic, strong) UITextField *registerPhoneField;//注册的手机号

@property (nonatomic, strong) UIView *registerPhoneLine;//注册的图片

@property (nonatomic, strong) UIButton *nextBtn; //下一步按钮

@property (nonatomic, strong) NZLabel     *registerAgreeLabel;//注册协议

@end

@implementation UCFRegisterInputPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    PGStatusBarHeight    @3x
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.closeBtn];
    [self.rootLayout addSubview:self.loginBtn];
    [self.rootLayout addSubview:self.registerLabel];
    [self.rootLayout addSubview:self.registerContentLabel];
    [self.rootLayout addSubview:self.registerImageView];
    [self.rootLayout addSubview:self.registerPhoneImageView];
    [self.rootLayout addSubview:self.registerPhoneField];
    [self.rootLayout addSubview:self.registerPhoneLine];
    [self.rootLayout addSubview:self.nextBtn];
    [self.rootLayout addSubview:self.registerAgreeLabel];
    [self addLeftButtons];
    [self addRightButton];
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
- (void)addRightButton
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 44, 44);
    rightbutton.backgroundColor = [UIColor whiteColor];
    [rightbutton setTitle:@"登录" forState:UIControlStateNormal];
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
    UCFNewLoginViewController *uc = [[UCFNewLoginViewController alloc] init];
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
- (UIButton *)closeBtn
{
    if (nil == _closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.topPos.equalTo(@0);
        _closeBtn.leftPos.equalTo(@25);
        _closeBtn.myHeight = 35;
        _closeBtn.myHeight = 35;
        _closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_closeBtn setImage:[UIImage imageNamed:@"registericon_close.png"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(buttonCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)loginBtn
{
    if (nil == _loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.myRight = 25;
        _loginBtn.topPos.equalTo(self.closeBtn.topPos);
        _loginBtn.myHeight = 35;
        _loginBtn.myHeight = 45;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _loginBtn.titleLabel.font = [Color gc_Font:18.0];
        [_loginBtn setTitleColor:[Color color:PGColorOptionTitlerRead] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(buttonloginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (NZLabel *)registerLabel
{
    if (nil == _registerLabel) {
        _registerLabel = [NZLabel new];
        _registerLabel.topPos.equalTo(self.closeBtn.bottomPos).offset(40);
        _registerLabel.leftPos.equalTo(self.closeBtn.leftPos);
        _registerLabel.textAlignment = NSTextAlignmentLeft;
        _registerLabel.font = [Color gc_Font:30.0];
        _registerLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _registerLabel.text = @"注册";
        [_registerLabel sizeToFit];
    }
    return _registerLabel;
}

- (NZLabel *)registerContentLabel
{
    if (nil == _registerContentLabel) {
        _registerContentLabel = [NZLabel new];
        _registerContentLabel.topPos.equalTo(self.registerLabel.bottomPos).offset(10);
        _registerContentLabel.leftPos.equalTo(self.registerLabel.leftPos);
        _registerContentLabel.textAlignment = NSTextAlignmentLeft;
        _registerContentLabel.font = [Color gc_Font:15.0];
        _registerContentLabel.textColor = self.registerLabel.textColor;
        _registerContentLabel.text = @"完成注册领取新手大礼包";
        [_registerContentLabel sizeToFit];
    }
    return _registerContentLabel;
}

- (UIImageView *)registerImageView
{
    if (nil == _registerImageView) {
        _registerImageView = [[UIImageView alloc] init];
        _registerImageView.topPos.equalTo(self.registerContentLabel.bottomPos).offset(16);
        _registerImageView.leftPos.equalTo(self.registerLabel.leftPos);
        _registerImageView.myRight = 25;
        _registerImageView.myHeight = 160;
    }
    return _registerImageView;
}


- (UIImageView *)registerPhoneImageView
{
    if (nil == _registerPhoneImageView) {
        _registerPhoneImageView = [[UIImageView alloc] init];
        _registerPhoneImageView.topPos.equalTo(self.registerImageView.bottomPos).offset(38);
        _registerPhoneImageView.leftPos.equalTo(self.registerLabel.leftPos).offset(5);
        _registerPhoneImageView.myWidth = 25;
        _registerPhoneImageView.myHeight = 25;
        _registerPhoneImageView.image = [UIImage imageNamed:@"sign_icon_phone.png"];
    }
    return _registerPhoneImageView;
}


- (UIView *)registerPhoneLine
{
    if (nil == _registerPhoneLine) {
        _registerPhoneLine = [UIView new];
        _registerPhoneLine.leftPos.equalTo(self.registerLabel.leftPos);
        _registerPhoneLine.myHeight = 0.5;
        _registerPhoneLine.topPos.equalTo(self.registerPhoneImageView.bottomPos).offset(13);
        _registerPhoneLine.myRight = 25;
        _registerPhoneLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _registerPhoneLine;
}



- (UITextField *)registerPhoneField
{
    if (nil == _registerPhoneField) {
        _registerPhoneField = [UITextField new];
        _registerPhoneField.backgroundColor = [UIColor clearColor];
        _registerPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _registerPhoneField.font = [Color font:15.0 andFontName:nil];
        _registerPhoneField.textAlignment = NSTextAlignmentLeft;
        _registerPhoneField.placeholder = @"请输入手机号";
        _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_registerPhoneField.placeholder attributes:dict];
        [_registerPhoneField setAttributedPlaceholder:attribute];
        _registerPhoneField.textColor = [Color color:PGColorOptionTitleBlack];
        _registerPhoneField.heightSize.equalTo(@25);
        _registerPhoneField.leftPos.equalTo(self.registerPhoneImageView.rightPos).offset(9);
        _registerPhoneField.rightPos.equalTo(self.rootLayout.rightPos).offset(25);
        _registerPhoneField.centerYPos.equalTo(self.registerPhoneImageView.centerYPos);
         [_registerPhoneField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
//        设置清除按钮图片
        UIButton *clearButton = [_registerPhoneField valueForKey:@"_clearButton"];
        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {

            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateHighlighted];

        }
    }
    return _registerPhoneField;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    if ([self inspectRegisterPhone]) {
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
- (BOOL)inspectRegisterPhone
{
    if (self.registerPhoneField.text.length == 11 && [Common isOnlyNumber:self.registerPhoneField.text]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (UIButton*)nextBtn
{
    
    if(_nextBtn == nil)
    {
        _nextBtn = [UIButton buttonWithType:0];
        _nextBtn.topPos.equalTo(self.registerPhoneLine.bottomPos).offset(25);
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
        [_nextBtn addTarget:self action:@selector(buttonNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (NZLabel *)registerAgreeLabel
{
    if (nil == _registerAgreeLabel) {
        _registerAgreeLabel = [NZLabel new];
        _registerAgreeLabel.topPos.equalTo(self.nextBtn.bottomPos).offset(20);
        _registerAgreeLabel.myLeft= 25;
        _registerAgreeLabel.myRight= 25;
        _registerAgreeLabel.numberOfLines = 0;
        _registerAgreeLabel.textAlignment = NSTextAlignmentLeft;
        _registerAgreeLabel.font = [Color gc_Font:13.0];
        _registerAgreeLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        _registerAgreeLabel.text = @"*注册即视为本人已阅读并同意《金融工场用户服务协议》";
        [_registerAgreeLabel setFontColor:[Color color:PGColorOptionCellContentBlue] string:@"《金融工场用户服务协议》"];
        [_registerAgreeLabel sizeToFit];
        __weak typeof(self) weakSelf = self;
        [_registerAgreeLabel addLinkString:@"《金融工场用户服务协议》" block:^(ZBLinkLabelModel *linkModel) {
            //注册协议 加载本地文件
            UCFXieYiViewController *zhuCeXieYi = [[UCFXieYiViewController alloc] init];
            zhuCeXieYi.titleName = @"金融工场用户服务协议";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"jrgcuserxieyi" ofType:@"docx"];
            zhuCeXieYi.filePath = [NSURL fileURLWithPath:path];
            [weakSelf.rt_navigationController pushViewController:zhuCeXieYi animated:YES];
        }];
    }
    return _registerAgreeLabel;
}
- (void)buttonCloseClick:(UIButton *)btn
{
    
}
- (void)buttonloginClick:(UIButton *)btn
{
    
}
- (void)buttonNextBtnClick:(UIButton *)btn
{
    UCFRegistVerificationMobileApi * request = [[UCFRegistVerificationMobileApi alloc] initWithphoneNum:self.registerPhoneField.text];
    request.animatingView = self.view;
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFRegistVerificationMobileModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            //电话号码可以允许注册
            UCFRegisterInputVerificationCodeViewController *vc = [[UCFRegisterInputVerificationCodeViewController alloc] init];
            vc.phoneNum = self.registerPhoneField.text;
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
        else if(model.code == 3) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:model.message delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"立即拨打", nil];
            [alertView show];
        } else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:model.message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alertView show];
        }
//        else{
//            ShowMessage(model.message);
//        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self

    }];
    
    
    
    
    
//    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
//
//    [chainReq addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
////        RegisterApi *result = (RegisterApi *)baseRequest;
////        NSString*userId = [result userId];
//        UCFRegistVerificationMobileModel *model = [baseRequest.responseJSONModel copy];
//        DDLogDebug(@"---------%@",model);
//        if (model.ret == YES) {
//            //电话可以允许注册
//            UCFRegisterGetRegisterInfoApi *api = [[UCFRegisterGetRegisterInfoApi alloc]initWithphoneNum:self.registerPhoneField.text];
//            [chainRequest addRequest:api callback:nil];
//        }
//        else if(model.code == 3) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:model.message delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"立即拨打", nil];
//            [alertView show];
//        } else
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:model.message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//
//
//
//    }];
//
//    chainReq.delegate = self;
//    // start to send request
//    [chainReq start];
//


}
//- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
//    // all requests are done
//
//    for (YTKBaseRequest *request in chainRequest.requestArray) {
//        if ([request isKindOfClass:[UCFRegistVerificationMobileApi class]]) {
//
//        }
//        if ([request isKindOfClass:[UCFRegisterGetRegisterInfoApi class]]) {
//            UCFRegisterGetRegisterInfoModel *model = request.responseJSONModel;
//            if(model.ret){
//
//                UCFRegisterInputVerificationCodeViewController *vc = [[UCFRegisterInputVerificationCodeViewController alloc] init];
//                vc.registerTokenStr = model.data.registTicket;
//                vc.phoneNum = self.registerPhoneField.text;
//                [self.rt_navigationController pushViewController:vc animated:YES];
//
//
////                UCFRegisterStepTwoViewController *twoController = [[UCFRegisterStepTwoViewController alloc] initWithPhoneNumber:[_registerOneView phoneNumberText]];
////                twoController.isLimitFactoryCode = isLimitFactoryCode;
////                twoController.registerTokenStr = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"registTicket"];
////                [self.navigationController pushViewController:twoController animated:YES];
//            }
//        }
//    }
//
//}
- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
    
}
    

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.registerPhoneField) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if ([self isMobile:text]) {
            self.nextBtn.userInteractionEnabled = YES;
            [self.nextBtn setBackgroundColor:[Color color:PGColorOptionButtonBackgroundColorGray]];
//            [_nextBtn setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
            [self.nextBtn.layer addSublayer:[self setGradualChangingColor:self.nextBtn fromColor:@"FF4133" toColor:@"FF7F40"]];      //渐变开始
        }else{
            self.nextBtn.userInteractionEnabled = NO;
            [self.nextBtn setBackgroundColor:[Color color:PGColorOptionButtonBackgroundColorGray]];
            [self.nextBtn setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        }
    }
    return YES;
}


- (void)but1Click:(id)sender
{
    //注册协议 加载本地文件
    UCFXieYiViewController *zhuCeXieYi = [[UCFXieYiViewController alloc] init];
    zhuCeXieYi.titleName = @"金融工场用户服务协议";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jrgcuserxieyi" ofType:@"docx"];
    zhuCeXieYi.filePath = [NSURL fileURLWithPath:path];
    [self.navigationController pushViewController:zhuCeXieYi animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
    }
}

//绘制渐变色颜色的方法
- (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色 （因为这个按钮有三段变色，所以有三个元素）
    gradientLayer.colors = @[(__bridge id)[self colorWithHex:fromHexColorStr].CGColor,(__bridge id)[self colorWithHex:toHexColorStr].CGColor,
                             (__bridge id)[self colorWithHex:fromHexColorStr].CGColor];
    
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    //  设置颜色变化点，取值范围 0.0~1.0 （所以变化点有三个）
    gradientLayer.locations = @[@0,@0.5,@1];
    
    return gradientLayer;
}
//获取16进制颜色的方法
-(UIColor *)colorWithHex:(NSString *)hexColor {
    hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([hexColor length] < 6) {
        return nil;
    }
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rs = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gs = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bs = [hexColor substringWithRange:range];
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rs] scanHexInt:&r];
    [[NSScanner scannerWithString:gs] scanHexInt:&g];
    [[NSScanner scannerWithString:bs] scanHexInt:&b];
    if ([hexColor length] == 8) {
        range.location = 4;
        NSString *as = [hexColor substringWithRange:range];
        [[NSScanner scannerWithString:as] scanHexInt:&a];
    } else {
        a = 255;
    }
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
}

- (BOOL)isMobile:(NSString *)str
{
    if (str.length <0 ) {
        return NO;
    }else
    {
        NSString *string =  [str substringWithRange:NSMakeRange(0,1)];
        if ([string isEqualToString:@"1"]) {
            return YES;
        }
        else
        {
            return NO;
        }
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
