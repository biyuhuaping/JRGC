//
//  UCFCreateLockViewController.m
//  JRGC
//
//  Created by zrc on 2019/4/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCreateLockViewController.h"
#import "UCFLockConfig.h"
#import "LLLockIndicator.h"
#import "LLLockView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "LLLockPassword.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "UCFRegisterdSucceedViewController.h"
@interface UCFCreateLockViewController ()<LLLockDelegate>
@property(nonatomic, strong)UILabel *titleLabe; //标题
@property(nonatomic, strong)UIButton *runButton;//跳过按钮
@property(nonatomic, strong)UILabel  *tipLab;   //用户提醒标签

@property(nonatomic, strong)LLLockIndicator *indecator; //轨迹指示器
@property(nonatomic, strong)LLLockView  *lockView;

@property(nonatomic, strong)UILabel  *errorLabel; //错误提醒
@property(nonatomic, strong)UIButton *clearButton; //重新绘制
@property(nonatomic, assign)RCLockViewType nLockViewType;

@property (nonatomic, strong) NSString  *passwordNew; // 新密码
@property (nonatomic, strong) NSString  *passwordconfirm; // 确认密码

@property (nonatomic, assign)BOOL isFaceID;
@end

@implementation UCFCreateLockViewController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    self.view.backgroundColor = [Color color:PGColorOptionThemeWhite];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    ((RTContainerController *) (self.parentViewController.rt_navigationController.viewControllers.lastObject)).fd_interactivePopDisabled = YES;
    // 禁用返回手势
    if ([self.parentViewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.parentViewController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}
- (void)initData
{

    _clearButton.myVisibility = MyVisibility_Invisible;
    _errorLabel.myVisibility = MyVisibility_Invisible;
    _nLockViewType = RCLockViewTypeCreate;
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIndecatorBtn:) name:@"setindecatorbtnnofication" object:nil];
}
/**
 同步手势密码轨迹到指示器
 
 @param info <#info description#>
 */
- (void)setIndecatorBtn:(NSNotification*)info
{
    NSString *str = [info.userInfo valueForKey:@"indecatorkey"];
    [self.indecator setPasswordString:str];
}
- (void)lockString:(NSString*)string
{
    LLLog(@"这次的密码=--->%@<---", string);
    switch (_nLockViewType) {
        case RCLockViewTypeCreate:
        {
            [self createPassword:string];
        }
            break;
        case RCLockViewTypeCheck:
        {

        }
            break;
        case RCLockViewTypeModify:
        {

        }
            break;
        case RCLockViewTypeClean:
        default:
        {
        }
    }
    
}
- (void)createPassword:(NSString*)string
{
    // 输入密码
    if ([self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        if ([string length] < 4) {

            self.passwordNew = @"";
            NSString *str = [NSString stringWithFormat:@"密码长度不能短于4位"];
            [self setErrorTip:str errorPswd:string];
            return;
        } else {
            self.tipLab.text = @"请再次绘制解锁密码";
            self.passwordNew = string;
            _errorLabel.myVisibility = MyVisibility_Invisible;
            _clearButton.myVisibility = MyVisibility_Visible;
        }
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        self.passwordconfirm = string;
        if ([self.passwordNew isEqualToString:self.passwordconfirm]) {
            // 成功
            LLLog(@"两次密码一致");
            [LLLockPassword saveLockPassword:string];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLockView"];
            self.tipLab.text = @"解锁密码创建成功";
            if ([_souceVc isEqualToString:@"securityCenter"]) {
                [self hide];
            } else {
                if ([self checkTouchIdIsOpen]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手势密码设置成功!" message:[NSString stringWithFormat:@"%@",_isFaceID ?@"是否启用Face ID面容解锁" : @"是否启用Touch ID指纹解锁"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"开启", nil];
                    [alert show];
                } else {
                    [self hide];
                }
            }
        } else {
            self.passwordconfirm = @"";
            _errorLabel.myVisibility = MyVisibility_Visible;
            _errorLabel.text = @"两次绘制的密码不一致";
            [_errorLabel sizeToFit];
            _clearButton.myVisibility = MyVisibility_Visible;
//            [self shakeAnimationForView:_errorLabel];
        }
    } else {
        NSAssert(1, @"设置密码意外");
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1) {
        [self openTouchId:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self hide];
    }
}
- (void)openTouchId:(UIButton *)button
{
    // 判断系统是否是iOS8.0以上 8.0以上可用
    if (!([[UIDevice currentDevice]systemVersion].doubleValue >= 8.0)) {
        NSLog(@"系统不支持");
        return;
    }
    LAContext *lol = [[LAContext alloc] init];
    lol.localizedFallbackTitle = @"";
    NSError *error = nil;
    NSString *showStr = _isFaceID ? @"面对前置摄像头进行验证" : @"通过home键验证已有手机指纹";
    [lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (error.code == LAErrorTouchIDLockout && kIS_IOS9) {
        [lol evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [self openTouchId:nil];
            }
        }];
        return;
    }
    //TODO:TOUCHID是否存在
    //TODO:TOUCHID开始运作
    [lol evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:showStr reply:^(BOOL succes, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (succes) {
                 NSLog(@"指纹验证成功");
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUserShowTouchIdLockView"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [self hide];
                 if (_nLockViewType == RCLockViewTypeCreate) {
                     ShowMessage(_isFaceID ? @"您已成功开启面容解锁" : @"您已成功开启指纹解锁");
                 }
                 
             } else {
                 if (error) {
                     switch (error.code) {
                         case LAErrorUserCancel:
                             NSLog(@"Authentication was cancelled by the user");
                             //用户取消验证Touch ID
                             if (_nLockViewType == RCLockViewTypeCreate) {
                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     [self hide];
                                 }];
                             }
                             break;
                         case LAErrorTouchIDLockout:
                             if (kIS_IOS9) {
                                 [self openTouchId:nil];
                             }
                             break;
                             
                         case LAErrorAuthenticationFailed:
                             NSLog(@"LAErrorAuthenticationFailed");
                             break;
                         case LAErrorUserFallback:
                             // 用户点击输入密码按钮
                             NSLog(@"1111");
                             break;
                         case LAErrorPasscodeNotSet:
                             //没有在设备上设置密码
                             NSLog(@"1111");
                             break;
                         case LAErrorTouchIDNotAvailable:
                             //设备不支持TouchID
                             NSLog(@"1111");
                             break;
                         case LAErrorTouchIDNotEnrolled:
                             NSLog(@"1111");
                             break;
                         default:
                             if ( _nLockViewType == RCLockViewTypeCreate) {
                                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 [self hide];
                             }
                             break;
                     }
                     return ;
                 }
             }
         });
         
         
     }];
}
// 错误
- (void)setErrorTip:(NSString*)tip errorPswd:(NSString*)string
{
    // 显示错误点点
    [self.lockView showErrorCircles:string];
    [self.indecator showErrorCircles:string];
    _errorLabel.myVisibility = MyVisibility_Visible;
    _errorLabel.text = tip;
    [_errorLabel sizeToFit];
//    [self shakeAnimationForView:_errorLabel];
}

/**
 跳过按钮点击事件
 
 @param button 跳过按钮
 */
- (void)dealWithrunBtn:(UIButton *)button
{
    [LLLockPassword saveLockPassword:@""];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useLockView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self hide];
}

/**
 重设密码

 @param button 按钮
 */
- (void)clearPassword:(UIButton *)button
{
    self.passwordNew = @"";
    [self.indecator setPasswordString:@""];
    _errorLabel.myVisibility = MyVisibility_Invisible;
    self.tipLab.text = @"请绘制解锁密码";
    [self.tipLab sizeToFit];
}
- (void)hide
{
    if (_isFromRegist) {
        [SingGlobalView.rootNavController popToRootViewControllerAnimated:NO complete:^(BOOL finished) {
            UCFRegisterdSucceedViewController *vc = [[UCFRegisterdSucceedViewController alloc] init];
            RTRootNavigationAddPushController *nav = SingGlobalView.tabBarController.selectedViewController;
            [nav pushViewController:vc animated:NO complete:^(BOOL finished) {
            }];
        }];

        
    } else {
        [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES];

    }
}
- (void)loadView
{
    [super loadView];
    
    [self.rootLayout addSubview:self.titleLabe];
    [self.rootLayout addSubview:self.runButton];
    [self.rootLayout addSubview:self.tipLab];
    [self.rootLayout addSubview:self.indecator];
    [self.rootLayout addSubview:self.errorLabel];
    [self.rootLayout addSubview:self.lockView];
    [self.rootLayout addSubview:self.clearButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (UILabel *)titleLabe
{
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc] init];
        _titleLabe.heightSize.equalTo(@44);
        _titleLabe.centerXPos.equalTo(self.rootLayout.centerXPos);
        
        _titleLabe.topPos.equalTo(@(StatusBarHeight1));
        _titleLabe.font = [Color gc_Font:18];
        _titleLabe.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabe.textAlignment = NSTextAlignmentCenter;
        _titleLabe.backgroundColor = [UIColor clearColor];
        _titleLabe.text = @"设置手势";
        [_titleLabe sizeToFit];
    }
    return _titleLabe;
}
- (UIButton *)runButton
{
    if (!_runButton) {
        _runButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _runButton.leftPos.equalTo(@15);
        _runButton.centerYPos.equalTo(self.titleLabe.centerYPos);
        _runButton.widthSize.equalTo(@44);
        _runButton.heightSize.equalTo(@44);
        [_runButton addTarget:self action:@selector(dealWithrunBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_runButton setImage:[UIImage imageNamed:@"calculator_gray_close"] forState:UIControlStateNormal];
    }
    return _runButton;
}
- (UILabel *)tipLab
{
    if (!_tipLab) {
//        NSLog(@"%.2f",HeightScale);
        _tipLab = [[UILabel alloc] init];
        _tipLab.leftPos.equalTo(@0);
        _tipLab.topPos.equalTo(self.titleLabe.bottomPos).offset(40 * HeightScale);
        _tipLab.widthSize.equalTo(self.rootLayout.widthSize);
        _tipLab.heightSize.equalTo(@(30 * HeightScale));
        _tipLab.font = [UIFont systemFontOfSize:23 * HeightScale];
        _tipLab.textColor = [Color color:PGColorOptionTitleBlack];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.backgroundColor = [UIColor clearColor];
        _tipLab.text = @"请绘制解锁密码";
        [_tipLab sizeToFit];
    }
    return _tipLab;
}
- (LLLockIndicator *)indecator
{
    if (!_indecator) {
        _indecator = [[LLLockIndicator alloc] initWithFrame:CGRectMake((ScreenWidth - 50) / 2, 185 * HeightScale, 50, 50)];
        _indecator.useFrame = YES;
    }
    return _indecator;
}
- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.topPos.equalTo(@(CGRectGetMaxY(self.indecator.frame))).offset(30 * HeightScale);
        _errorLabel.heightSize.equalTo(@20);
        _errorLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _errorLabel.font = [UIFont systemFontOfSize:16 * HeightScale];
        _errorLabel.textColor = [Color color:PGColorOpttonTextRedColor];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.text = @"密码长度不得低于4位";
        [_errorLabel sizeToFit];
    }
    return _errorLabel;

}
- (LLLockView *)lockView
{
    if (!_lockView) {
        _lockView = [[LLLockView alloc] initWithFrame:CGRectMake((ScreenWidth - [Common calculateNewSizeBaseMachine:320]) / 2,CGRectGetMaxY(self.indecator.frame) + 25 * HeightScale, [Common calculateNewSizeBaseMachine:320], [Common calculateNewSizeBaseMachine:320])];
        _lockView.useFrame = YES;
        _lockView.delegate = self;
    }
    return _lockView;
}
- (UIButton *)clearButton
{
    if(!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.topPos.equalTo(@(CGRectGetMaxY(self.lockView.frame)));
        _clearButton.widthSize.equalTo(@120);
        _clearButton.heightSize.equalTo(@40);
        _clearButton.centerXPos.equalTo(self.rootLayout.centerXPos);
        _clearButton.titleLabel.font = [Color gc_Font:19 * HeightScale];
        [_clearButton setTitle:@"重新绘制" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
        [_clearButton setBackgroundColor:[UIColor clearColor]];
        [_clearButton addTarget:self action:@selector(clearPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}
#pragma mark 抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}
- (BOOL)checkTouchIdIsOpen
{
    LAContext *lol = [[LAContext alloc] init];
    lol.localizedFallbackTitle = @"";
    NSError *error = nil;
    //TODO:TOUCHID是否存在
    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        
        NSString *localizedReason = @"指纹登录";
        if (@available(iOS 11.0, *)) {
            if (lol.biometryType == LABiometryTypeTouchID) {
                _isFaceID = NO;
            }else if (lol.biometryType == LABiometryTypeFaceID){
                localizedReason = @"人脸识别";
                _isFaceID = YES;
            }
        }
        
        return YES;
    } else {
        return NO;
    }
    return NO;
}
@end
