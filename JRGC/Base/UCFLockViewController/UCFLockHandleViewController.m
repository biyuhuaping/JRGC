 //
//  UCFLockHandleViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/9.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFLockHandleViewController.h"
#import "LLLockIndicator.h"
#import "UIButton+Misc.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "UCFLoginViewController.h"
#import "UCFVerifyLoginViewController.h"
#import "AppDelegate.h"
#import "AuxiliaryFunc.h"
#import "RegisterSuccessAlert.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "UIImage+GIF.h"
#import "LockFlagSingle.h"
#import "Touch3DSingle.h"
#import "UCFOldUserGuideViewController.h"
#import "BaseNavigationViewController.h"
#import "ToolSingleTon.h"
#define kTipColorNormal [UIColor blackColor]
#define kTipColorError [UIColor redColor]
@interface UCFLockHandleViewController ()
{
    int nRetryTimesRemain; // 剩余几次输入机会
    NSDictionary *userInfoDict;
    BOOL isClickCgAndCertiBtn;
    BOOL statusBarDiffrrent;
}

@property (strong, nonatomic) UIImageView *preSnapImageView; // 上一界面截图
@property (strong, nonatomic) UIImageView *currentSnapImageView; // 当前界面截图
@property (nonatomic, strong) LLLockIndicator* indecator; // 九点指示图
@property (nonatomic, strong) LLLockView* lockview; // 触摸田字控件
@property (strong, nonatomic) UILabel *tipLable;//修改提示
@property (strong, nonatomic) UILabel *nameLabel;//显示用户名
@property (strong, nonatomic) UIButton *tipButton; // 忘记密码按钮
@property (strong, nonatomic) UIButton *changeAcoutButton; // 重设/(取消)的提示按钮
@property (strong, nonatomic) UIButton *clearButton; // 清空按钮
@property (strong, nonatomic) UIImageView *headImageView;//头像image

@property (nonatomic, strong) NSString* savedPassword; // 本地存储的密码
@property (nonatomic, strong) NSString* passwordOld; // 旧密码
@property (nonatomic, strong) NSString* passwordNew; // 新密码
@property (nonatomic, strong) NSString* passwordconfirm; // 确认密码
@property (nonatomic, strong) NSString* tip1; // 三步提示语
@property (nonatomic, strong) NSString* tip2;
@property (nonatomic, strong) NSString* tip3;
@property (nonatomic, strong) UIButton *reminderButton;
@property (nonatomic, strong) UIButton *changeAccountBtn;
@property (strong, nonatomic) UILabel *errorLabel;//错误提示
@property (strong, nonatomic) UILabel *titleLabel;//设置手势
@property (strong, nonatomic) UIButton *runButton;//跳过按钮
@property (strong, nonatomic) UILabel *runLabel;
@property (strong, nonatomic) UIButton *cancelButton;//取消按钮
@property (strong, nonatomic) UILabel *cancelLabel;


@property (strong, nonatomic) UIScrollView      *baseScrollView;
@end

@implementation UCFLockHandleViewController

- (id)initWithType:(LLLockViewType)type
{
    self = [super init];
    if (self) {
        _nLockViewType = type;
        _isFromRegister = NO;
        isClickCgAndCertiBtn = NO;
        statusBarDiffrrent = NO;
    }
    return self;
}

#pragma mark TouchID
//touchID 的准备工作
- (void)prepareTouchID
{
//    TODO:其实只需要加载一次就可以了
    CFErrorRef error = NULL;
    SecAccessControlRef sacObject;
    sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                kSecAccessControlUserPresence, &error);
    if(sacObject == NULL || error != NULL)
    {
        NSLog(@"can't create sacObject: %@", error);
        return;
    }
    
    NSDictionary *attributes = @{
                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                 (__bridge id)kSecAttrService: @"SampleService",
                                 (__bridge id)kSecValueData: [@"SECRET_PASSWORD_TEXT" dataUsingEncoding:NSUTF8StringEncoding],
                                 (__bridge id)kSecUseNoAuthenticationUI: @YES,
                                 (__bridge id)kSecAttrAccessControl: (__bridge id)sacObject
                                 };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_ADD_STATUS", nil), [self keychainErrorToString:status]];
        NSLog(@"msg = %@",msg);
    });
}
- (NSString *)keychainErrorToString: (NSInteger)error
{
    
    NSString *msg = [NSString stringWithFormat:@"%ld",(long)error];
    
    switch (error) {
        case errSecSuccess:
            msg = NSLocalizedString(@"SUCCESS", nil);
            break;
        case errSecDuplicateItem:
            msg = NSLocalizedString(@"ERROR_ITEM_ALREADY_EXISTS", nil);
            break;
        case errSecItemNotFound :
            msg = NSLocalizedString(@"ERROR_ITEM_NOT_FOUND", nil);
            break;
        case -26276:
            msg = NSLocalizedString(@"ERROR_ITEM_AUTHENTICATION_FAILED", nil);
            
        default:
            break;
    }
    
    return msg;
}
#pragma mark - life cycle
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        statusBarDiffrrent = YES;
    }
    BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"isUserShowTouchIdLockView"];
    //系统touchID开启 和 处于解锁页面 和 用户打开指纹解锁 三者缺一不可
    if ([self checkTouchIdIsOpen] && _nLockViewType == LLLockViewTypeCheck && isOpen) {
        [self prepareTouchID];
        //绘制有touchID的界面
        [self initTouchIDLockView];
    } else { 
        [self initLockView];
    }


}
//Error Domain=com.apple.LocalAuthentication Code=-5 "Passcode not set." UserInfo=0x155b1ec0 {NSLocalizedDescription=Passcode not set.}
//Error Domain=com.apple.LocalAuthentication Code=-5 "Passcode not set." UserInfo=0x17427bd80 {NSLocalizedDescription=Passcode not set.}8.0.2
//Error Domain=com.apple.LocalAuthentication Code=-6 "Biometry is not available on this device." UserInfo={NSLocalizedDescription=Biometry is not available on this device.}
//在7上没有效果，为空数据
//判断touchid 是否打开
- (BOOL)checkTouchIdIsOpen
{
    LAContext *lol = [[LAContext alloc] init];
    lol.localizedFallbackTitle = @"";
    NSError *error = nil;
    //TODO:TOUCHID是否存在
    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        return YES;
    } else {
        return NO;
    }
    return NO;
}
//启动touchID 进行验证
- (void)openTouchId:(UIButton *)button
{
    
    LAContext *lol = [[LAContext alloc] init];
    lol.localizedFallbackTitle = @"";
    NSError *error = nil;
    NSString *showStr = @"通过home键验证已有手机指纹";
    //TODO:TOUCHID是否存在
    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //TODO:TOUCHID开始运作
        [lol evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:showStr reply:^(BOOL succes, NSError *error)
         {
             if (succes) {
                 NSLog(@"指纹验证成功");
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUserShowTouchIdLockView"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [self hide];
                     if (_nLockViewType == LLLockViewTypeCreate) {
                         [MBProgressHUD displayHudError:@"您已成功开启指纹解锁" withShowTimes:2];
                     }
                 }];
             }
             else
             {
                 NSLog(@"%@",error.localizedDescription);
                 switch (error.code) {
                     case LAErrorSystemCancel:
                     {
                         NSLog(@"Authentication was cancelled by the system");
                         //切换到其他APP，系统取消验证Touch ID
                         break;
                     }
                     case LAErrorUserCancel:
                     {
                         NSLog(@"Authentication was cancelled by the user");
                         //用户取消验证Touch ID
                         if (_nLockViewType == LLLockViewTypeModify || _nLockViewType == LLLockViewTypeCreate) {
                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 [self hide];
                             }];
                         }
                         break;
                     }
                     case LAErrorUserFallback:
                     {
                         NSLog(@"User selected to enter custom password");
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                             //用户选择输入密码，切换主线程处理
                         }];
                         break;
                     }
                     default:
                     {
                         if (_nLockViewType == LLLockViewTypeModify || _nLockViewType == LLLockViewTypeCreate) {
                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                 [self hide];
                             }];
                         }
                         break;
                     }
                 }
             }
         }];
        
    }
    else
    {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                //没有touchID 的报错
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
    }

}
//切换到指纹解锁页面
- (void)changeScrollViewOffSet:(UIButton *)button
{
    CGPoint offX =  _baseScrollView.contentOffset;
    if (offX.x == ScreenWidth) {
        offX.x = 0.0f;
        [LockFlagSingle sharedManager].showSection = LockGesture;
    } else {
        offX.x = ScreenWidth;
        [self openTouchId:nil];
        [LockFlagSingle sharedManager].showSection = LockFingerprint;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _baseScrollView.contentOffset = CGPointMake(offX.x, 0);
    }];
}

- (void)initLockView
{
    float marinToTop = kIS_Iphone4?[Common calculateNewSizeBaseMachine:63]:38;
//    //没有打开的情况下，默认关闭
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,kIS_Iphone4?[Common calculateNewSizeBaseMachine:65]:50, ScreenWidth, [Common calculateNewSizeBaseMachine:24])];
    _titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:24]];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"设置手势";
    [self.view addSubview:_titleLabel];
    
    self.runLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIS_Iphone4?ScreenWidth - [Common calculateNewSizeBaseMachine:80]:ScreenWidth - 92,kIS_Iphone4?[Common calculateNewSizeBaseMachine:70]:56, [Common calculateNewSizeBaseMachine:50], [Common calculateNewSizeBaseMachine:13])];
    _runLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    _runLabel.textColor = [UIColor whiteColor];
    _runLabel.textAlignment = NSTextAlignmentRight;
    _runLabel.text = @"跳过";
    _runLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_runLabel];
    
    self.runButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _runButton.frame = CGRectMake(_runLabel.frame.origin.x, _runLabel.frame.origin.y, _runLabel.frame.size.width*1.5, 30);
    [_runButton addTarget:self action:@selector(dealWithrunBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_runButton];
    
    //取消按钮
    self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIS_Iphone4?[Common calculateNewSizeBaseMachine:36]:36,kIS_Iphone4?[Common calculateNewSizeBaseMachine:70]:56, [Common calculateNewSizeBaseMachine:50], [Common calculateNewSizeBaseMachine:13])];
    _cancelLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    _cancelLabel.textColor = [UIColor whiteColor];
    _cancelLabel.textAlignment = NSTextAlignmentLeft;
    _cancelLabel.text = @"取消";
    _cancelLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cancelLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(_cancelLabel.frame.origin.x, _cancelLabel.frame.origin.y, _cancelLabel.frame.size.width*1.5, 30);
    [_cancelButton addTarget:self action:@selector(dealWithCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0 - 40, marinToTop, 80, 80)];
    //_headImageView.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserMsg"];
    NSString *headUrl = nil;
    if (dict) {
        headUrl = [dict objectForKey:@"headurl"];
    }
    
    _headImageView.image = [UIImage imageNamed:@"password_head.png"];
    
    [self.view addSubview:_headImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame) + (kIS_Iphone4?[Common calculateNewSizeBaseMachine:15]:3), ScreenWidth, [Common calculateNewSizeBaseMachine:18])];
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_nameLabel];
    
    self.indecator = [[LLLockIndicator alloc] initWithFrame:CGRectMake((ScreenWidth - (kIS_Iphone4?[Common calculateNewSizeBaseMachine:50]:47)) / 2, CGRectGetMaxY(_titleLabel.frame) + (kIS_Iphone4?[Common calculateNewSizeBaseMachine:28]:15), kIS_Iphone4?[Common calculateNewSizeBaseMachine:51]:47, kIS_Iphone4?[Common calculateNewSizeBaseMachine:51]:47)];
    [self.view addSubview:_indecator];
    
    self.lockview = [[LLLockView alloc] initWithFrame:CGRectMake((ScreenWidth - [Common calculateNewSizeBaseMachine:320]) / 2,kIS_Iphone4?[Common calculateNewSizeBaseMachine:215]:200-45, [Common calculateNewSizeBaseMachine:320], [Common calculateNewSizeBaseMachine:320])];
    [self.view addSubview:_lockview];
    
    self.preSnapImageView = [[UIImageView alloc] init];
    self.currentSnapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.indecator.backgroundColor = [UIColor clearColor];
    self.lockview.backgroundColor = [UIColor clearColor];
    
    UIView *baseBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    baseBkView.userInteractionEnabled = YES;
    baseBkView.backgroundColor = UIColorWithRGB(0x2b3b52);
    [self.view insertSubview:baseBkView atIndex:0];
    
    self.lockview.delegate = self;
    
    self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_indecator.frame) + (kIS_Iphone4?[Common calculateNewSizeBaseMachine:28]:15), ScreenWidth, [Common calculateNewSizeBaseMachine:18])];
    _tipLable.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:18]];
    _tipLable.textColor = kTipColorError;
    _tipLable.textAlignment = NSTextAlignmentCenter;
    _tipLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tipLable];
    
    self.errorLabel = [[UILabel alloc] init];
    _errorLabel.frame = CGRectMake(0, CGRectGetMaxY(_tipLable.frame) + (kIS_Iphone4?[Common calculateNewSizeBaseMachine:10]:0), ScreenWidth, [Common calculateNewSizeBaseMachine:12]);
    _errorLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:12]];
    _errorLabel.textColor = kTipColorError;
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_errorLabel];
    
    self.reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reminderButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _reminderButton.frame = CGRectMake(kIS_Iphone4?[Common calculateNewSizeBaseMachine:30]:35,kIS_Iphone4?ScreenHeight-[Common calculateNewSizeBaseMachine:45]:ScreenHeight-35, [Common calculateNewSizeBaseMachine:80], [Common calculateNewSizeBaseMachine:25]);
    [_reminderButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_reminderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reminderButton setBackgroundColor:[UIColor clearColor]];
    [_reminderButton addTarget:self action:@selector(dealWithPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reminderButton];
    _reminderButton.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    
    // 切换账户按钮
    self.changeAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeAccountBtn.frame = CGRectMake(kIS_Iphone4?ScreenWidth-[Common calculateNewSizeBaseMachine:(30+80)]:ScreenWidth-35-80,kIS_Iphone4?ScreenHeight-[Common calculateNewSizeBaseMachine:45]:ScreenHeight-35, [Common calculateNewSizeBaseMachine:80], [Common calculateNewSizeBaseMachine:25]);
    [_changeAccountBtn setTitle:@"切换账户" forState:UIControlStateNormal];
    [_changeAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeAccountBtn setBackgroundColor:[UIColor clearColor]];
    [_changeAccountBtn addTarget:self action:@selector(changeAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeAccountBtn];
    _changeAccountBtn.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearButton.frame = CGRectMake((ScreenWidth - 120)/2,CGRectGetMaxY(_lockview.frame) + (kIS_Iphone4?-25:-35),120, 33);
    [_clearButton setTitle:@"重新输入" forState:UIControlStateNormal];
    [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_clearButton setBackgroundColor:[UIColor clearColor]];
    [_clearButton addTarget:self action:@selector(clearPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearButton];
    _clearButton.titleLabel.font = [UIFont systemFontOfSize:15.8f];
}
- (void)openTouchidAlert
{
    BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"isUserShowTouchIdLockView"];
    if (isOpen) {
        _baseScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openTouchId:nil];
        });
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_baseScrollView.contentOffset.x == ScreenWidth) {
        [LockFlagSingle sharedManager].showSection = LockFingerprint;
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [ToolSingleTon sharedManager].checkIsInviteFriendsAlert = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckInviteFriendsAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEINVESTDATA" object:nil];
}
// 绘制有touchID 的界面
- (void)initTouchIDLockView
{
    //注册升起touch_id 系统的默认提醒框
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openTouchidAlert:) name:@"openTouchIdAlert" object:nil];
    [LockFlagSingle sharedManager].disappearType = DisHome;
//    [LockFlagSingle sharedManager].showSection = LockFingerprint;
    float marinToTop = [Common calculateNewSizeBaseMachine:56];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUserShowTouchIdLockView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //头像
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0 - 40, marinToTop, 80, 80)];
    //_headImageView.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserMsg"];
    NSString *headUrl = nil;
    if (dict) {
        headUrl = [dict objectForKey:@"headurl"];
    }
    _headImageView.image = [UIImage imageNamed:@"password_head.png"];
    [self.view addSubview:_headImageView];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame) + [Common calculateNewSizeBaseMachine:5], ScreenWidth, [Common calculateNewSizeBaseMachine:18])];
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_nameLabel];
    
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(_nameLabel.frame))];
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.backgroundColor = [UIColor clearColor];
    _baseScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - CGRectGetMaxY(_nameLabel.frame));
    [self.view addSubview:_baseScrollView];
    
    //第一屏 手势解锁
    self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, ([Common calculateNewSizeBaseMachine:10]), ScreenWidth, [Common calculateNewSizeBaseMachine:18])];
    _tipLable.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:18]];
    _tipLable.textColor = kTipColorError;
    _tipLable.textAlignment = NSTextAlignmentCenter;
    _tipLable.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:_tipLable];
    
    self.errorLabel = [[UILabel alloc] init];
    _errorLabel.frame = CGRectMake(0, CGRectGetMaxY(_tipLable.frame) + ([Common calculateNewSizeBaseMachine:10]), ScreenWidth, [Common calculateNewSizeBaseMachine:12]);
    _errorLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:12]];
    _errorLabel.textColor = kTipColorError;
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:_errorLabel];
    
    self.lockview = [[LLLockView alloc] initWithFrame:CGRectMake((ScreenWidth - [Common calculateNewSizeBaseMachine:320])/2, CGRectGetMaxY(_errorLabel.frame) - [Common calculateNewSizeBaseMachine:25], [Common calculateNewSizeBaseMachine:320], [Common calculateNewSizeBaseMachine:320])];
    [_baseScrollView addSubview:_lockview];
    
    self.preSnapImageView = [[UIImageView alloc] init];
    self.currentSnapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.lockview.backgroundColor = [UIColor clearColor];
    
    UIView *baseBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    baseBkView.userInteractionEnabled = YES;
    baseBkView.backgroundColor = UIColorWithRGB(0x2b3b52);
    [self.view insertSubview:baseBkView atIndex:0];
    
    self.lockview.delegate = self;
    
    UIButton *changeVerificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeVerificationBtn.frame  = CGRectMake((ScreenWidth - 180)/2, CGRectGetMaxY(self.lockview.frame) - [Common calculateNewSizeBaseMachine:18.7], 180, [Common calculateNewSizeBaseMachine:25]);
    changeVerificationBtn.backgroundColor = [UIColor clearColor];
    if (ScreenHeight ==  667.0f) {
        changeVerificationBtn.frame  = CGRectMake((ScreenWidth - 180)/2, CGRectGetMaxY(self.lockview.frame) - [Common calculateNewSizeBaseMachine:18.7] + 13, 180, [Common calculateNewSizeBaseMachine:25]);
    } else if (ScreenHeight == 736.0f) {
        changeVerificationBtn.frame  = CGRectMake((ScreenWidth - 180)/2, CGRectGetMaxY(self.lockview.frame) - [Common calculateNewSizeBaseMachine:18.7] + 20, 180, [Common calculateNewSizeBaseMachine:25]);
    }
    changeVerificationBtn.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    [changeVerificationBtn setTitle:@"切换至指纹解锁" forState:UIControlStateNormal];
    [changeVerificationBtn addTarget:self action:@selector(changeScrollViewOffSet:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:changeVerificationBtn];

    self.reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reminderButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _reminderButton.frame = CGRectMake([Common calculateNewSizeBaseMachine:30],CGRectGetHeight(_baseScrollView.frame)-[Common calculateNewSizeBaseMachine:45], [Common calculateNewSizeBaseMachine:80], [Common calculateNewSizeBaseMachine:25]);
    [_reminderButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_reminderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reminderButton setBackgroundColor:[UIColor clearColor]];
    [_reminderButton addTarget:self action:@selector(dealWithPassword:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:_reminderButton];
    _reminderButton.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    
    // 切换账户按钮
    self.changeAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeAccountBtn.frame = CGRectMake(ScreenWidth-[Common calculateNewSizeBaseMachine:(30+80)],CGRectGetHeight(_baseScrollView.frame)-[Common calculateNewSizeBaseMachine:45], [Common calculateNewSizeBaseMachine:80], [Common calculateNewSizeBaseMachine:25]);
    [_changeAccountBtn setTitle:@"切换账户" forState:UIControlStateNormal];
    [_changeAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeAccountBtn setBackgroundColor:[UIColor clearColor]];
    [_changeAccountBtn addTarget:self action:@selector(changeAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:_changeAccountBtn];
    _changeAccountBtn.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    
    //第二屏 指纹解锁
    UILabel *zhiWenTipLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth,([Common calculateNewSizeBaseMachine:10]), ScreenWidth, [Common calculateNewSizeBaseMachine:18] * 2 + 10)];
    zhiWenTipLab.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:18]];
    zhiWenTipLab.textColor = [UIColor whiteColor];
    zhiWenTipLab.text = @"点击扫描区域进行\n指纹解锁";
    zhiWenTipLab.numberOfLines = 0;
    zhiWenTipLab.textAlignment = NSTextAlignmentCenter;
    zhiWenTipLab.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:zhiWenTipLab];
    
    UIImageView *touchIDAmition = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth + (ScreenWidth - [Common calculateNewSizeBaseMachine:145])/2, CGRectGetMaxY(zhiWenTipLab.frame) + [Common calculateNewSizeBaseMachine:50], [Common calculateNewSizeBaseMachine:145], [Common calculateNewSizeBaseMachine:145])];
    touchIDAmition.image = [UIImage sd_animatedGIFNamed:@"touch_id"];
    [_baseScrollView addSubview:touchIDAmition];
    
    UIButton *restartTouchId = [UIButton buttonWithType:UIButtonTypeCustom];
    restartTouchId.frame = touchIDAmition.frame;
    restartTouchId.backgroundColor = [UIColor clearColor];
    [restartTouchId addTarget:self action:@selector(openTouchId:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:restartTouchId];
    
    UIButton *changeVerificationBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    changeVerificationBtn1.frame  = CGRectMake(ScreenWidth + (ScreenWidth - 180)/2, CGRectGetMaxY(self.lockview.frame) - [Common calculateNewSizeBaseMachine:18.7], 180, [Common calculateNewSizeBaseMachine:25]);
    changeVerificationBtn1.backgroundColor = [UIColor clearColor];
    changeVerificationBtn1.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    [changeVerificationBtn1 setTitle:@"切换至手势解锁" forState:UIControlStateNormal];
    if (ScreenHeight ==  667.0f) {
        changeVerificationBtn1.frame  = CGRectMake(ScreenWidth + (ScreenWidth - 180)/2, CGRectGetMaxY(self.lockview.frame) - [Common calculateNewSizeBaseMachine:18.7] + 13, 180, [Common calculateNewSizeBaseMachine:25]);
    } else if (ScreenHeight == 736.0f) {
        changeVerificationBtn1.frame  = CGRectMake(ScreenWidth + (ScreenWidth - 180)/2, CGRectGetMaxY(self.lockview.frame) - [Common calculateNewSizeBaseMachine:18.7] + 20, 180, [Common calculateNewSizeBaseMachine:25]);
    }
    [changeVerificationBtn1 addTarget:self action:@selector(changeScrollViewOffSet:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:changeVerificationBtn1];
    
    
    UIButton *changeAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeAccountButton.frame = CGRectMake(ScreenWidth + (ScreenWidth - [Common calculateNewSizeBaseMachine:80])/2,CGRectGetHeight(_baseScrollView.frame)-[Common calculateNewSizeBaseMachine:45], [Common calculateNewSizeBaseMachine:80], [Common calculateNewSizeBaseMachine:25]);
    changeAccountButton.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    [changeAccountButton setTitle:@"切换账户" forState:UIControlStateNormal];
    [changeAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeAccountButton setBackgroundColor:[UIColor clearColor]];
    [changeAccountButton addTarget:self action:@selector(changeAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:changeAccountButton];
    
    _baseScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
}
- (void)dealWithrunBtn:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (_isFromRegister) {
            userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUserMsg"];
            int regReward;
            NSString*regType;
            int certiReward;
            NSString*cetiType;
            int bdReward;
            NSString*bdType;
            
            NSString *firstInstType;
            int firstInstValue;
            if (userInfoDict) {
                regReward = [[userInfoDict objectForKey:@"resvalue"] intValue];
                regType = [userInfoDict objectForKey:@"restype"];
                certiReward = [[userInfoDict objectForKey:@"rzvalue"] intValue];//身份认证奖励
                cetiType = [userInfoDict objectForKey:@"rztype"];
                bdReward = [[userInfoDict objectForKey:@"bdvalue"] intValue];//绑定银行卡奖励
                bdType = [userInfoDict objectForKey:@"bdtype"];
                
                firstInstValue = [[userInfoDict objectForKey:@"firstInvestmentValue"] intValue];//绑定银行卡奖励
                firstInstType = [userInfoDict objectForKey:@"firstInvestmentType"];
            }
//            RegisterSuccessAlert *alert = [[RegisterSuccessAlert alloc] init];
            //[alert setAlertTitle:[NSString stringWithFormat:@"%d",regReward] cetiAmout:[NSString stringWithFormat:@"%d",certiReward] titleType:regType certifiType:cetiType bdAmout:[NSString stringWithFormat:@"%d",bdReward] bdType:bdType];
//            [alert setAlertTitle:[NSString stringWithFormat:@"%d",regReward] firstInstAmout:[NSString stringWithFormat:@"%d",firstInstValue] titleType:regType firstInstType:firstInstType];
            
            
            UCFOldUserGuideViewController * VC = [UCFOldUserGuideViewController createGuideHeadSetp:1];
            VC.isPresentViewController = YES; //弹出视图
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            VC.rootVc = delegate.tabBarController;
            
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
            
//             alert.delegate = delegate.tabBarController;
            NSInteger personInt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"personCenterClick"] integerValue];
            if (personInt == 1) {
                [delegate.tabBarController setSelectedIndex:3];
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
            }
//            [alert showAlert:delegate.tabBarController];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [delegate.tabBarController presentViewController:nav animated:YES completion:^{
                }];
            });
            
            //注册成功调用一次，tab上是否有红点
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];
        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"leapGestureLock" object:nil];
            if ([self.delegate respondsToSelector:@selector(lockHandleViewController:didClickLeapWithSign:)]) {
                [self.delegate lockHandleViewController:self didClickLeapWithSign:NO];
            }
        }
    }];
    //状态为0则表示不使用手势密码 1 则是使用
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useLockView"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealWithCancelBtn:(id)sender
{
    //设置成功之后返回安全中心页
    [self dismissViewControllerAnimated:NO completion:^{
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UINavigationController *navController = delegate.tabBarController.selectedViewController;
        [navController popViewControllerAnimated:YES];
    }];
}

- (void)setBtnHide:(BOOL)hide
{
    [_reminderButton setHidden:hide];
    [_changeAccountBtn setHidden:hide];
}

- (void)clearPassword : (id)sender
{
    [self setTip:self.tip1];
    _nLockViewType = LLLockViewTypeCreate;
    self.passwordNew = @"";
    [self.indecator setPasswordString:@""];
    [self setErrorTip:nil errorPswd:nil];
}

- (void)dealWithPassword : (id)sender
{
    isClickCgAndCertiBtn = YES;
    UCFVerifyLoginViewController *loginViewController = [[UCFVerifyLoginViewController alloc] init];
     UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self dismissViewControllerAnimated:NO completion:^{
        [LockFlagSingle sharedManager].disappearType = DisDefault;
        [LockFlagSingle sharedManager].showSection = LockGesture;
    }];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.tabBarController presentViewController:loginNaviController animated:NO completion:^{
        
    }];
//    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//    delegate.window.rootViewController = loginNaviController;
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UUID];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLockView"];
}
/**
 *  切换账户有返回按钮，点击返回按钮加一个标示符，判断返回的时候显示手势还是指纹
 */
- (void)checkGoBackShowGestureOrFingerprint
{
    if (_baseScrollView != nil) {
        if (_baseScrollView.contentOffset.x == ScreenWidth) {
            [LockFlagSingle sharedManager].showSection = LockFingerprint;
        } else {
            [LockFlagSingle sharedManager].showSection = LockGesture;
        }
    }
}
- (void)changeAccountBtnClicked : (id)sender
{
    [self checkGoBackShowGestureOrFingerprint];
    isClickCgAndCertiBtn = YES;
    UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
    loginViewController.sourceVC = @"changeUser";
    UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self dismissViewControllerAnimated:NO completion:^{
        [LockFlagSingle sharedManager].disappearType = DisDefault;
    }];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.tabBarController presentViewController:loginNaviController animated:NO completion:^{
        
    }];
    //[[NSUserDefaults standardUserDefaults] setValue:nil forKey:UUID];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLockView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (statusBarDiffrrent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
#ifdef LLLockAnimationOn
    [self capturePreSnap];
#endif
    
    [super viewWillAppear:animated];
    
    [ToolSingleTon sharedManager].checkIsInviteFriendsAlert = NO;
    
    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        statusBarDiffrrent = YES;
    }
    [_errorLabel setHidden:YES];
    [_headImageView setHidden:YES];
    [_clearButton setHidden:YES];
    _nameLabel.text = @"";
    [self setBtnHide:YES];
    [_titleLabel setHidden:NO];
    
    //从安全中心过来 跳过按钮隐藏
    if ([_souceVc isEqualToString:@"securityCenter"]) {
        [_runButton setHidden:YES];
        [_runLabel setHidden:YES];
        [_cancelButton setHidden:NO];
        [_cancelLabel setHidden:NO];
    } else {
        [_runLabel setHidden:NO];
        [_runButton setHidden:NO];
        [_cancelButton setHidden:YES];
        [_cancelLabel setHidden:YES];
    }
    _tipLable.textColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIndecatorBtn:) name:@"setindecatorbtnnofication" object:nil];
    // 初始化内容
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            _tipLable.text = @"请绘制解锁密码";
            _errorLabel.frame = CGRectMake(0,kIS_Iphone4?CGRectGetMaxY(_tipLable.frame) + [Common calculateNewSizeBaseMachine:12] : CGRectGetMaxY(_tipLable.frame) + 10, ScreenWidth, [Common calculateNewSizeBaseMachine:12]);
            [_headImageView setHidden:NO];
            [_titleLabel setHidden:YES];
            [_runButton setHidden:YES];
            [_runLabel setHidden:YES];
            [_cancelButton setHidden:YES];
            [_cancelLabel setHidden:YES];
            [self setBtnHide:NO];
            self.indecator.hidden = YES;
            _nameLabel.text = [NSString stringWithFormat:@"hi %@",[[NSUserDefaults standardUserDefaults] valueForKey:PHONENUM]];
        }
            break;
        case LLLockViewTypeCreate:
        {
            _errorLabel.frame = CGRectMake(0,kIS_Iphone4?CGRectGetMaxY(_tipLable.frame) + [Common calculateNewSizeBaseMachine:12] : CGRectGetMaxY(_tipLable.frame) + 10, ScreenWidth, [Common calculateNewSizeBaseMachine:12]);
            _tipLable.text = @"请绘制解锁密码";
            self.indecator.hidden = NO;
        }
            break;
        case LLLockViewTypeModify:
        {
            _tipLable.text = @"请绘制解锁密码";
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            _tipLable.text = @"请输入密码以清除密码";
        }
    }
    
    // 尝试机会
    nRetryTimesRemain = [[[NSUserDefaults standardUserDefaults] valueForKey:@"nRetryTimesRemain"] intValue];
    
    self.passwordOld = @"";
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    
    // 本地保存的手势密码
    self.savedPassword = [LLLockPassword loadLockPassword];
    LLLog(@"本地保存的密码是%@", self.savedPassword);
    
    [self updateTipButtonStatus];
    
    //返回的时候再次判断该显示指纹还是手势
    if (_baseScrollView != nil) {
        if ([LockFlagSingle sharedManager].showSection == LockFingerprint) {
            _baseScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
//            [LockFlagSingle sharedManager].showSection = LockFingerprint;
        } else  if([LockFlagSingle sharedManager].showSection == LockGesture){
            _baseScrollView.contentOffset = CGPointMake(0, 0);
//            [LockFlagSingle sharedManager].showSection = LockGesture;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString*)string
{
    // 验证密码正确
    if ([string isEqualToString:self.savedPassword]) {
        
        if (_nLockViewType == LLLockViewTypeModify) { // 验证旧密码
            
            self.passwordOld = string; // 设置旧密码，说明是在修改
            
            [self setTip:@"请输入新的密码"]; // 这里和下面的delegate不一致，有空重构
            
        } else if (_nLockViewType == LLLockViewTypeClean) { // 清除密码
            
            [LLLockPassword saveLockPassword:nil];
            [self hide];
            
            [self showAlert:self.tip2];
            
        } else { // 验证成功
            [self hide];
        }
        
    }
    // 验证密码错误
    else if (string.length > 0) {
        
        nRetryTimesRemain--;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:nRetryTimesRemain] forKey:@"nRetryTimesRemain"];
        if (nRetryTimesRemain > 0) {
            NSDictionary *normalStrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                            NSForegroundColorAttributeName : UIColorWithRGB(0x94bde4)
                                            };
            NSString *str = [NSString stringWithFormat:@"密码输入错误，您还可以尝试 %d 次", nRetryTimesRemain];
            NSRange strRg = [str rangeOfString:[NSString stringWithFormat:@"%d",nRetryTimesRemain]];
            NSMutableAttributedString *StrAttri = [[NSMutableAttributedString alloc] initWithString:str attributes:normalStrDict];

            NSDictionary *redStrDict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                                              NSForegroundColorAttributeName : UIColorWithRGB(0xfd4d4c)
                                              };
            [StrAttri addAttributes:redStrDict range:strRg];

            [self setErrorTip:StrAttri errorPswd:string];
            //_nameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastLoginName"];
        } else {
            
            // 强制注销该账户，并清除手势密码，以便重设
            [self dismissViewControllerAnimated:NO completion:^{
                AppDelegate *delegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
                UCFLoginViewController *loginViewController = [[UCFLoginViewController alloc] init];
                loginViewController.sourceVC = @"errorNum";
                UINavigationController *loginNaviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
                [delegate.window.rootViewController presentViewController:loginNaviController animated:YES completion:nil];
                [LockFlagSingle sharedManager].disappearType = DisDefault;
            }]; // 由于是强制登录，这里必须以NO ani的方式才可
            [LLLockPassword saveLockPassword:nil];

        }
        
    } else {
        NSAssert(YES, @"意外情况");
    }
}

- (void)createPassword:(NSString*)string
{
    // 输入密码
    if ([self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        if ([string length] < 4) {
            [self setTip:self.tip1];
            NSDictionary *redStrDict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                                         NSForegroundColorAttributeName : UIColorWithRGB(0xfd4d4c)
                                         };
            NSString *str = [NSString stringWithFormat:@"密码长度不能短于4位"];
            NSMutableAttributedString *strAttri = [[NSMutableAttributedString alloc] initWithString:str attributes:redStrDict];

            [self setErrorTip:strAttri errorPswd:string];
            self.passwordNew = @"";
            return;
        }
        [_errorLabel setHidden:YES];
        self.passwordNew = string;
        [_clearButton setHidden:NO];
        [self setTip:self.tip2];
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        
        self.passwordconfirm = string;
        
        if ([self.passwordNew isEqualToString:self.passwordconfirm]) {
            // 成功
            LLLog(@"两次密码一致");
            
            [LLLockPassword saveLockPassword:string];
            if ([self checkTouchIdIsOpen]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手势密码设置成功!" message:@"是否启用Touch ID指纹解锁" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"开启", nil];
                [alert show];
            } else {
                [self hide];
            }
            
        } else {
            
            self.passwordconfirm = @"";
            [self setTip:@"两次绘制的密码不一致"];
//            NSDictionary *redStrDict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
//                                         NSForegroundColorAttributeName : UIColorWithRGB(0xfd4d4c)
//                                         };
//            NSString *str = [NSString stringWithFormat:@"与上一次绘制不一致，请重新绘制"];
//            NSMutableAttributedString *strAttri = [[NSMutableAttributedString alloc] initWithString:str attributes:redStrDict];
            //[self setErrorTip:strAttri errorPswd:string];
            
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
#pragma mark - 显示提示
- (void)setTip:(NSString*)tip
{
    [_tipLable setText:tip];
    [_tipLable setTextColor:[UIColor whiteColor]];
    
    
    _tipLable.alpha = 0;
    [UIView animateWithDuration:0.8
                     animations:^{
                         _tipLable.alpha = 1;
                     }completion:^(BOOL finished){
                     }
     ];
}

// 错误
- (void)setErrorTip:(NSMutableAttributedString*)tip errorPswd:(NSString*)string
{
    // 显示错误点点
    [self.lockview showErrorCircles:string];
    
    // 直接_变量的坏处是
    [_errorLabel setHidden:NO];
    _errorLabel.attributedText = tip;
    //[_errorLabel setTextColor:kTipColorError];
    
    [self shakeAnimationForView:_errorLabel];
}

#pragma mark 新建/修改后保存
- (void)updateTipButtonStatus
{
    LLLog(@"重设TipButton");
    if ((_nLockViewType == LLLockViewTypeCreate || _nLockViewType == LLLockViewTypeModify) &&
        ![self.passwordNew isEqualToString:@""]) // 新建或修改 & 确认时 才显示按钮
    {
        [self.tipButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [self.tipButton setAlpha:1.0];
        
    } else {
        [self.tipButton setAlpha:0.0];
    }
    
    // 更新指示圆点
    if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]){
        self.indecator.hidden = NO;
        [self.indecator setPasswordString:self.passwordNew];
    } else {
        //self.indecator.hidden = YES;
    }
}

- (void)setIndecatorBtn:(NSNotification*)info
{
    NSString *str = [info.userInfo valueForKey:@"indecatorkey"];
    [self.indecator setPasswordString:str];
}

#pragma mark - 点击了按钮
- (IBAction)tipButtonPressed:(id)sender {
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    [self setTip:self.tip1];
    [self updateTipButtonStatus];
}

#pragma mark - 点击了按钮
- (IBAction)changeAcountButtonPressed:(id)sender {
    
}

#pragma mark - 成功后返回
- (void)hide
{
    [LockFlagSingle sharedManager].disappearType = DisDefault;
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLockView"];
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            //应用在后台运行超过60秒后有锁，从3DTouch进入时需要重新请求接口。
            if ([Touch3DSingle sharedTouch3DSingle].isShowLock) {// && [[Touch3DSingle sharedTouch3DSingle].type isEqualToString:@"0"]) {
                [Touch3DSingle sharedTouch3DSingle].isShowLock = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"responds3DTouchClick" object:nil];
            }
        }
            break;
        case LLLockViewTypeCreate:
        case LLLockViewTypeModify:
        {
            [LLLockPassword saveLockPassword:self.passwordNew];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLockView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([self.delegate respondsToSelector:@selector(lockHandleViewController:didClickLeapWithSign:)]) {
                [self.delegate lockHandleViewController:self didClickLeapWithSign:YES];
            }
            
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            [LLLockPassword saveLockPassword:nil];
        }
    }
    
    // 在这里可能需要回调上个页面做一些刷新什么的动作
    
#ifdef LLLockAnimationOn
    [self captureCurrentSnap];
    // 隐藏控件
    for (UIView* v in self.view.subviews) {
        if (v.tag > 10000) continue;
        v.hidden = YES;
    }
    // 动画解锁
    [self animateUnlock];
    
    //设置成功之后返回安全中心页
    if ([_souceVc isEqualToString:@"securityCenter"]) {
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UINavigationController *navController = delegate.tabBarController.selectedViewController;
        [navController popViewControllerAnimated:YES];
    }
#else
    [self dismissViewControllerAnimated:NO completion:^{
        [AuxiliaryFunc showAlertViewWithMessage:@"恭喜您注册成功!" delegate:self];
    }];
#endif
}

#pragma mark - delegate 每次划完手势后
- (void)lockString:(NSString *)string
{
    LLLog(@"这次的密码=--->%@<---", string) ;
    
    switch (_nLockViewType) {
            
        case LLLockViewTypeCheck:
        {
            self.tip1 = @"请输入解锁密码";
            [self checkPassword:string];
        }
            break;
        case LLLockViewTypeCreate:
        {
            self.tip1 = @"请绘制解锁密码";
            self.tip2 = @"请再次绘制解锁密码";
            self.tip3 = @"解锁密码创建成功";
            [self createPassword:string];
        }
            break;
        case LLLockViewTypeModify:
        {
            self.tip1 = @"请绘制解锁密码";
            self.tip2 = @"请再次绘制解锁密码";
            self.tip3 = @"解锁密码创建成功";
            [self createPassword:string];
//            if ([self.passwordOld isEqualToString:@""]) {
//                self.tip1 = @"请输入原来的密码";
//                [self checkPassword:string];
//            } else {
//                self.tip1 = @"请输入新的密码";
//                self.tip2 = @"请再次输入密码";
//                self.tip3 = @"密码修改成功";
//                [self createPassword:string];
//            }
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            self.tip1 = @"请输入密码以清除密码";
            self.tip2 = @"清除密码成功";
            [self checkPassword:string];
        }
    }
    
    [self updateTipButtonStatus];
}

#pragma mark - 解锁动画
// 截屏，用于动画
#ifdef LLLockAnimationOn
- (UIImage *)imageFromView:(UIView *)theView
{
//    UIGraphicsBeginImageContext(theView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [theView.layer renderInContext:context];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return theImage;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(app.window.bounds.size, NO, 0.0);
    // There he is! The new API method
    [app.window drawViewHierarchyInRect:app.window.frame afterScreenUpdates:NO];
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

// 上一界面截图
- (void)capturePreSnap
{
    self.preSnapImageView.hidden = YES; // 默认是隐藏的
    self.preSnapImageView.image = [self imageFromView:self.presentingViewController.view];
}

// 当前界面截图
- (void)captureCurrentSnap
{
    self.currentSnapImageView.hidden = YES; // 默认是隐藏的
    self.currentSnapImageView.image = [self imageFromView:self.view];
}

- (void)animateUnlock{
    
    self.currentSnapImageView.hidden = NO;
    self.preSnapImageView.hidden = NO;
    
    static NSTimeInterval duration = 0.5;
    
    // currentSnap
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
    
    CABasicAnimation *opacityAnimation;
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue=[NSNumber numberWithFloat:1];
    opacityAnimation.toValue=[NSNumber numberWithFloat:0];
    
    CAAnimationGroup* animationGroup =[CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO; // 防止最后显现
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [self.currentSnapImageView.layer addAnimation:animationGroup forKey:nil];
    
    // preSnap
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1];
    
    animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    
    [self.preSnapImageView.layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.currentSnapImageView.hidden = YES;
//    __weak __typeof(self)weakSelf = self;
    if (_isFromRegister) {
        [self dismissViewControllerAnimated:NO completion:^{
            userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUserMsg"];
            int regReward;
            NSString*regType;
            int certiReward;
            NSString*cetiType;
            int bdReward;
            NSString*bdType;
            
            NSString *firstInstType;
            int firstInstValue;
            if (userInfoDict) {
                regReward = [[userInfoDict objectForKey:@"resvalue"] intValue];
                regType = [userInfoDict objectForKey:@"restype"];
                certiReward = [[userInfoDict objectForKey:@"rzvalue"] intValue];//身份认证奖励
                cetiType = [userInfoDict objectForKey:@"rztype"];
                bdReward = [[userInfoDict objectForKey:@"bdvalue"] intValue];//绑定银行卡奖励
                bdType = [userInfoDict objectForKey:@"bdtype"];
                
                firstInstValue = [[userInfoDict objectForKey:@"firstInvestmentValue"] intValue];//绑定银行卡奖励
                firstInstType = [userInfoDict objectForKey:@"firstInvestmentType"];
            }
        
//            RegisterSuccessAlert *alert = [[RegisterSuccessAlert alloc] init];
//            alert.delegate = weakSelf;
//            [alert setAlertTitle:[NSString stringWithFormat:@"%d",regReward] cetiAmout:[NSString stringWithFormat:@"%d",certiReward] titleType:regType certifiType:cetiType bdAmout:[NSString stringWithFormat:@"%d",bdReward] bdType:bdType];
//            [alert setAlertTitle:[NSString stringWithFormat:@"%d",regReward] firstInstAmout:[NSString stringWithFormat:@"%d",firstInstValue] titleType:regType firstInstType:firstInstType];
//            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            NSInteger personInt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"personCenterClick"] integerValue];
//            if (personInt == 1) {
//                [delegate.tabBarController setSelectedIndex:3];
//                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
//            }
//            [alert showAlert:delegate.tabBarController];
            
            //设置手势密码后弹出徽商流程
            UCFOldUserGuideViewController * VC = [UCFOldUserGuideViewController createGuideHeadSetp:1];
            VC.isPresentViewController = YES; //弹出视图
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            VC.rootVc = delegate.tabBarController;
            
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
            
            //             alert.delegate = delegate.tabBarController;
            NSInteger personInt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"personCenterClick"] integerValue];
            if (personInt == 1) {
                [delegate.tabBarController setSelectedIndex:3];
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
            }
            //            [alert showAlert:delegate.tabBarController];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [delegate.tabBarController presentViewController:nav animated:YES completion:^{
                }];
            });
            
            //注册成功调用一次，tab上是否有红点
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];
        }];
    } else {
        [self dismissViewControllerAnimated:NO completion:^{
            // 发送通知刷新个人中心
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        }];
    }
    [LockFlagSingle sharedManager].disappearType = DisDefault;
}

#endif

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

#pragma mark - 提示信息
- (void)showAlert:(NSString*)string
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:string
                                                   delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma -regAlertDelegate
- (void)lookBtnClicked:(id)sender
{
    
}

- (void)certificationBtnClicked:(id)sender
{
    //__weak typeof(self) weakSelf = self;
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
//    IDAuthViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"idauth"];
//    controller.title = @"身份认证";
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    controller.rootVc = delegate.tabBarController;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    nav.navigationBarHidden = YES;
//    [delegate.tabBarController presentViewController:nav animated:YES completion:^{
//        
//    }];
    
    
//    __weak typeof(self) weakSelf = self;
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
    //IDAuthViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"idauth"];
    //controller.title = @"身份认证";
    //AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //controller.rootVc = delegate.tabBarController;
    //BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:controller];
    //nav.navigationBarHidden = YES;
    //[delegate.tabBarController presentViewController:nav animated:YES completion:^{
    //
    //    }];
    UCFOldUserGuideViewController * VC = [UCFOldUserGuideViewController createGuideHeadSetp:1];
    VC.isPresentViewController = YES; //弹出视图
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    VC.rootVc = delegate.tabBarController;
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
    //[delegate.tabBarController addChildViewController:nav];
    //delegate.tabBarController.viewControllers = @[nav];
    //[nav pushViewController:VC animated:YES];
    [delegate.tabBarController presentViewController:nav animated:YES completion:^{
        
    }];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (self.nLockViewType == LLLockViewTypeModify) return;
    if (self.nLockViewType == LLLockViewTypeCreate && self.isFromRegister) return;
    if (isClickCgAndCertiBtn) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CheckIsInitiaLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setindecatorbtnnofication" object:nil];
}

@end
