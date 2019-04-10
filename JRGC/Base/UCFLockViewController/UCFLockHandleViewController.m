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
#import "UCFVerifyLoginViewController.h"
#import "AppDelegate.h"
#import "AuxiliaryFunc.h"
#import "RegisterSuccessAlert.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "UIImage+GIF.h"
#import "LockFlagSingle.h"
#import "Touch3DSingle.h"
#import "BaseNavigationViewController.h"
#import "ToolSingleTon.h"
#import "UCFRegisterFinshViewController.h"
#import "MongoliaLayerCenter.h"
#import "UCFCouponPopup.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UCFNewModifyPasswordViewController.h"
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
//@property (strong, nonatomic) UILabel *runLabel;
@property (strong, nonatomic) UIButton *cancelButton;//取消按钮
@property (strong, nonatomic) UILabel *cancelLabel;
@property (strong, nonatomic) UILabel *touchIDTipLab;

@property (strong, nonatomic) UIScrollView      *baseScrollView;
@property (assign, nonatomic) BOOL              isFaceID;
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
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action
{
    return nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    ((RTContainerController *) (self.rt_navigationController.viewControllers.lastObject)).fd_interactivePopDisabled = YES;
    
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
        [self openTouchId:nil];
    } else {
        [self initLockView];
    }
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
//启动touchID 进行验证
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
                     if (_nLockViewType == LLLockViewTypeCreate) {
                         [MBProgressHUD displayHudError:_isFaceID ? @"您已成功开启面容解锁" : @"您已成功开启指纹解锁" withShowTimes:2];
                     }
            
                 } else {
                     if (error) {
                         switch (error.code) {
                             case LAErrorUserCancel:
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
                                 if (_nLockViewType == LLLockViewTypeModify || _nLockViewType == LLLockViewTypeCreate) {
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

    CGFloat statBarHeight = StatusBarHeight1;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,statBarHeight, ScreenWidth, 44)];
    _titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:18]];
    _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"设置手势";
    [self.view addSubview:_titleLabel];
    

    
    self.runButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _runButton.frame = CGRectMake(15 ,StatusBarHeight1 , 45, 45);
    _runButton.imageEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    [_runButton addTarget:self action:@selector(dealWithrunBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_runButton setImage:[UIImage imageNamed:@"calculator_gray_close"] forState:UIControlStateNormal];
    [self.view addSubview:_runButton];
    
    self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 45, ScreenWidth, 23)];
    _tipLable.font = [UIFont systemFontOfSize:23];
    _tipLable.textColor = [Color color:PGColorOptionTitleBlack];
    _tipLable.textAlignment = NSTextAlignmentCenter;
    _tipLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tipLable];
    
    self.indecator = [[LLLockIndicator alloc] initWithFrame:CGRectMake((ScreenWidth - 50) / 2, CGRectGetMaxY(self.tipLable.frame) + 30, 50, 50)];
    [self.view addSubview:_indecator];
    
    
    self.errorLabel = [[UILabel alloc] init];
    _errorLabel.frame = CGRectMake(0, CGRectGetMaxY(_indecator.frame) + 25, ScreenWidth, 18);
    _errorLabel.font = [UIFont systemFontOfSize:16];
    _errorLabel.textColor = [Color color:PGColorOpttonTextRedColor];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_errorLabel];
    
    
    self.lockview = [[LLLockView alloc] initWithFrame:CGRectMake((ScreenWidth - [Common calculateNewSizeBaseMachine:320]) / 2,CGRectGetMaxY(self.indecator.frame) + 30, [Common calculateNewSizeBaseMachine:320], [Common calculateNewSizeBaseMachine:320])];
    [self.view addSubview:_lockview];
    
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearButton.frame = CGRectMake((ScreenWidth - 120)/2,CGRectGetMaxY(_lockview.frame) + 25,120, 33);
    _clearButton.titleLabel.font = [Color gc_Font:19];
    [_clearButton setTitle:@"重新绘制" forState:UIControlStateNormal];
    [_clearButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
    [_clearButton setBackgroundColor:[UIColor clearColor]];
    [_clearButton addTarget:self action:@selector(clearPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearButton];

    
    //取消按钮  安全中心进来会有 暂时先放着
    self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIS_Iphone4?[Common calculateNewSizeBaseMachine:36]:36,kIS_Iphone4?[Common calculateNewSizeBaseMachine:70]:56, [Common calculateNewSizeBaseMachine:50], [Common calculateNewSizeBaseMachine:13])];
    _cancelLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:13]];
    _cancelLabel.textColor = [Color color:PGColorOptionTitleBlack];
    _cancelLabel.textAlignment = NSTextAlignmentLeft;
    _cancelLabel.text = @"取消";
    _cancelLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cancelLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(_cancelLabel.frame.origin.x, _cancelLabel.frame.origin.y, _cancelLabel.frame.size.width*1.5, 30);
    [_cancelButton addTarget:self action:@selector(dealWithCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0 - 85/2, statBarHeight + 44 + 6, 85, 85)];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserMsg"];
    NSString *headUrl = nil;
    if (dict) {
        headUrl = [dict objectForKey:@"headurl"];
    }
    _headImageView.image = [UIImage imageNamed:@"password_head.png"];
    [self.view addSubview:_headImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame) + 18, ScreenWidth, [Common calculateNewSizeBaseMachine:18])];
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [Color color:PGColorOptionTitleBlack];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_nameLabel];
    

    
    self.preSnapImageView = [[UIImageView alloc] init];
    self.currentSnapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.indecator.backgroundColor = [UIColor clearColor];
    self.lockview.backgroundColor = [UIColor clearColor];
    
    UIView *baseBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    baseBkView.userInteractionEnabled = YES;
    baseBkView.backgroundColor = [UIColor whiteColor];

    [self.view insertSubview:baseBkView atIndex:0];
    
    self.lockview.delegate = self;
    
    self.reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reminderButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _reminderButton.frame = CGRectMake(CGRectGetMinX(self.lockview.frame),statBarHeight > 20 ? ScreenHeight - 100 : ScreenHeight - 60, 80, 25);
    [_reminderButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_reminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_reminderButton setBackgroundColor:[UIColor clearColor]];
    [_reminderButton addTarget:self action:@selector(dealWithPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reminderButton];
    _reminderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // 切换账户按钮
    self.changeAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeAccountBtn.frame = CGRectMake(CGRectGetMaxX(self.lockview.frame) - 80,CGRectGetMinY(_reminderButton.frame) , 80, 25);
    [_changeAccountBtn setTitle:@"切换账户" forState:UIControlStateNormal];
    [_changeAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_changeAccountBtn setBackgroundColor:[UIColor clearColor]];
    [_changeAccountBtn addTarget:self action:@selector(changeAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeAccountBtn];
    _changeAccountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    

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
}
// 绘制有touchID 的界面
- (void)initTouchIDLockView
{
    //注册升起touch_id 系统的默认提醒框
    [LockFlagSingle sharedManager].disappearType = DisHome;
    
    CGFloat statBarHeight = StatusBarHeight1;

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUserShowTouchIdLockView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //头像
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0 - 85/2, statBarHeight + 44 + 6, 85, 85)];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserMsg"];
    NSString *headUrl = nil;
    if (dict) {
        headUrl = [dict objectForKey:@"headurl"];
    }
    _headImageView.image = [UIImage imageNamed:@"password_head.png"];
    [self.view addSubview:_headImageView];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame) + 18, ScreenWidth, [Common calculateNewSizeBaseMachine:18])];
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [Color color:PGColorOptionTitleBlack];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_nameLabel];
    
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(_tipLable.frame))];
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.backgroundColor = [UIColor clearColor];
    _baseScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - CGRectGetMaxY(_nameLabel.frame));
    [self.view addSubview:_baseScrollView];
    
    //第一屏 手势解锁
    self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 25)];
    _tipLable.font = [UIFont systemFontOfSize:23];
    _tipLable.textColor = [Color color:PGColorOptionTitleBlack];
    _tipLable.textAlignment = NSTextAlignmentCenter;
    _tipLable.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:_tipLable];
    
    self.errorLabel = [[UILabel alloc] init];
    _errorLabel.frame = CGRectMake(0,CGRectGetMaxY(_tipLable.frame) + 10, ScreenWidth, 18);
    _errorLabel.font = [UIFont systemFontOfSize:16];
    _errorLabel.textColor = [Color color:PGColorOpttonTextRedColor];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:_errorLabel];
    

    
    
    self.lockview = [[LLLockView alloc] initWithFrame:CGRectMake((ScreenWidth - [Common calculateNewSizeBaseMachine:320])/2, CGRectGetMaxY(_errorLabel.frame) - [Common calculateNewSizeBaseMachine:5], [Common calculateNewSizeBaseMachine:320], [Common calculateNewSizeBaseMachine:320])];
    [_baseScrollView addSubview:_lockview];
    
    self.preSnapImageView = [[UIImageView alloc] init];
    self.currentSnapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.lockview.backgroundColor = [UIColor clearColor];
    
    UIView *baseBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    baseBkView.userInteractionEnabled = YES;
    baseBkView.backgroundColor = [Color color:PGColorOptionThemeWhite];
    [self.view insertSubview:baseBkView atIndex:0];
    
    self.lockview.delegate = self;
    
    UIButton *changeVerificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeVerificationBtn.frame  = CGRectMake((ScreenWidth - 180)/2, CGRectGetMaxY(self.lockview.frame) , 180, 25);
    changeVerificationBtn.backgroundColor = [UIColor clearColor];
    changeVerificationBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lockview.frame), ScreenWidth, 30);
    changeVerificationBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [changeVerificationBtn setTitle:@"切换至指纹解锁" forState:UIControlStateNormal];
    [changeVerificationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeVerificationBtn addTarget:self action:@selector(changeScrollViewOffSet:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:changeVerificationBtn];

    
    //第二屏 指纹解锁
    UILabel *zhiWenTipLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth,10, ScreenWidth, 60)];
    zhiWenTipLab.font = [UIFont systemFontOfSize:22];
    zhiWenTipLab.textColor = [UIColor blackColor];
    zhiWenTipLab.text = @"点击扫描区域进行\n指纹解锁";
    zhiWenTipLab.numberOfLines = 0;
    zhiWenTipLab.textAlignment = NSTextAlignmentCenter;
    zhiWenTipLab.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:zhiWenTipLab];
    
    UIImageView *touchIDAmition = [[UIImageView alloc] init];
    if (_isFaceID) {
        touchIDAmition.frame = CGRectMake(ScreenWidth + (ScreenWidth - 230)/2, CGRectGetMaxY(zhiWenTipLab.frame) + 60, 230, 230);
        touchIDAmition.image = [UIImage imageNamed:@"face_bg_round"];
        
        UIImageView *centerImageView = [[UIImageView alloc] init];
        centerImageView.frame = CGRectMake((230 - 100)/2, (230 - 100)/2, 100, 100);
        centerImageView.image = [UIImage imageNamed:@"face_bg_head"];
        [touchIDAmition addSubview:centerImageView];
    } else {
        touchIDAmition.frame = CGRectMake(ScreenWidth + (ScreenWidth - 120)/2, CGRectGetMaxY(zhiWenTipLab.frame) + 60, 120, 120);
        touchIDAmition.image = [UIImage imageNamed:@"touch_id"];
    }

    [_baseScrollView addSubview:touchIDAmition];
    

    UIButton *restartTouchId = [UIButton buttonWithType:UIButtonTypeCustom];
    restartTouchId.frame = touchIDAmition.frame;
    restartTouchId.backgroundColor = [UIColor clearColor];
    [restartTouchId addTarget:self action:@selector(openTouchId:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:restartTouchId];
    
    UIButton *changeVerificationBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    changeVerificationBtn1.frame  =CGRectMake(ScreenWidth  + (ScreenWidth - 180)/2,CGRectGetMaxY(self.lockview.frame), 180, 25);
    changeVerificationBtn1.backgroundColor = [UIColor clearColor];
    changeVerificationBtn1.titleLabel.font = [UIFont systemFontOfSize:17];
    [changeVerificationBtn1 setTitle:@"切换至手势解锁" forState:UIControlStateNormal];
    [changeVerificationBtn1 addTarget:self action:@selector(changeScrollViewOffSet:) forControlEvents:UIControlEventTouchUpInside];
    [changeVerificationBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_baseScrollView addSubview:changeVerificationBtn1];

    NSInteger useLockView = [[[NSUserDefaults standardUserDefaults] valueForKey:@"useLockView"] integerValue];
    if (useLockView == 1) {
        changeVerificationBtn1.hidden = NO;
    } else {
        changeVerificationBtn1.hidden = YES;

    }
    
    self.reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reminderButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    _reminderButton.frame = CGRectMake(CGRectGetMinX(self.lockview.frame) + 25,statBarHeight > 20 ? ScreenHeight - 110 : ScreenHeight - 70, 80, 25);
    [_reminderButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_reminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_reminderButton setBackgroundColor:[UIColor clearColor]];
    [_reminderButton addTarget:self action:@selector(dealWithPassword:) forControlEvents:UIControlEventTouchUpInside];
    _reminderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_reminderButton];
    
    // 切换账户按钮
    self.changeAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeAccountBtn.frame = CGRectMake(CGRectGetMaxX(self.lockview.frame) - 100,CGRectGetMinY(_reminderButton.frame) , 80, 25);
    [_changeAccountBtn setTitle:@"切换账户" forState:UIControlStateNormal];
    [_changeAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_changeAccountBtn setBackgroundColor:[UIColor clearColor]];
    [_changeAccountBtn addTarget:self action:@selector(changeAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _changeAccountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_changeAccountBtn];
    
    _baseScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
}
- (void)dealWithrunBtn:(id)sender
{
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
            
            UCFRegisterFinshViewController * VC = [[UCFRegisterFinshViewController alloc] initWithNibName:@"UCFRegisterFinshViewController" bundle:nil];
            VC.isPresentViewController = YES;
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            VC.rootVc = delegate.tabBarController;
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
            NSInteger personInt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"personCenterClick"] integerValue];
            if (personInt == 1) {
                [delegate.tabBarController setSelectedIndex:4];
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [delegate.tabBarController presentViewController:nav animated:NO completion:^{
                }];
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];
        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"leapGestureLock" object:nil];
            [UCFCouponPopup startQueryCouponPopup];
            
        }
    
    //状态为0则表示不使用手势密码 1 则是使用
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useLockView"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUserShowTouchIdLockView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES complete:nil];
}

- (void)dealWithCancelBtn:(id)sender
{
    if ([_souceVc isEqualToString:@"securityCenter"]) {
        //设置成功之后返回安全中心页
        [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES complete:nil];
    }

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
    UCFVerifyLoginViewController *controller = [[UCFVerifyLoginViewController alloc] init];
    [self.rt_navigationController pushViewController:controller animated:YES];
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
    [SingleUserInfo loadLoginViewController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (statusBarDiffrrent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    if (self.baseScrollView.contentOffset.x != ScreenWidth) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_COUPON_CENTER object:nil];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
#ifdef LLLockAnimationOn
    [self capturePreSnap];
#endif
    
    [super viewWillAppear:animated];
    
    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        statusBarDiffrrent = YES;
    }
    [self.navigationController setNavigationBarHidden:YES];
    [_errorLabel setHidden:YES];
    [_headImageView setHidden:YES];
    [_clearButton setHidden:YES];
    _nameLabel.text = @"";
    [self setBtnHide:YES];
    [_titleLabel setHidden:NO];
    
    //从安全中心过来 跳过按钮隐藏
    if ([_souceVc isEqualToString:@"securityCenter"]) {
        [_runButton setHidden:YES];
        [_cancelButton setHidden:NO];
        [_cancelLabel setHidden:NO];
    } else {
        [_runButton setHidden:NO];
        [_cancelButton setHidden:YES];
        [_cancelLabel setHidden:YES];
    }
    _tipLable.textColor = [Color color:PGColorOptionTitleBlack];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIndecatorBtn:) name:@"setindecatorbtnnofication" object:nil];
    // 初始化内容
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            [_headImageView setHidden:NO];
            _nameLabel.frame = CGRectMake(0, CGRectGetMaxY(_headImageView.frame) + 18, ScreenWidth, 15);
            _nameLabel.text = [NSString stringWithFormat:@"hi %@",SingleUserInfo.loginData.userInfo.mobile];
            BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"isUserShowTouchIdLockView"];
            //系统touchID开启 和 处于解锁页面 和 用户打开指纹解锁 三者缺一不可
            
            if ([self checkTouchIdIsOpen] && _nLockViewType == LLLockViewTypeCheck && isOpen) {
                _tipLable.frame = CGRectMake(0, 10, ScreenWidth, 23);
            } else {
                _tipLable.frame = CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) + 20, ScreenWidth, 23);
            }
            _tipLable.text = @"请绘制解锁密码";
            
            self.indecator.hidden = YES;
            [_titleLabel setHidden:YES];
            [_runButton setHidden:YES];
            [_cancelButton setHidden:YES];
            [_cancelLabel setHidden:YES];
            [self setBtnHide:NO];
        }
            break;
        case LLLockViewTypeCreate:
        {
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
        } else  if([LockFlagSingle sharedManager].showSection == LockGesture){
            _baseScrollView.contentOffset = CGPointMake(0, 0);
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
            NSDictionary *normalStrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                            NSForegroundColorAttributeName : UIColorWithRGB(0x94bde4)
                                            };
            NSString *str = [NSString stringWithFormat:@"密码输入错误，您还可以尝试 %d 次", nRetryTimesRemain];
            NSRange strRg = [str rangeOfString:[NSString stringWithFormat:@"%d",nRetryTimesRemain]];
            NSMutableAttributedString *StrAttri = [[NSMutableAttributedString alloc] initWithString:str attributes:normalStrDict];

            NSDictionary *redStrDict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                                              NSForegroundColorAttributeName : UIColorWithRGB(0xfd4d4c)
                                              };
            [StrAttri addAttributes:redStrDict range:strRg];

            [self setErrorTip:StrAttri errorPswd:string];
            //_nameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastLoginName"];
        } else {
            
            // 强制注销该账户，并清除手势密码，以便重设
            [SingleUserInfo deleteUserData];
            [SingleUserInfo loadLoginViewController];
            [LockFlagSingle sharedManager].disappearType = DisDefault;
            [LLLockPassword saveLockPassword:nil];
            [SingGlobalView.rootNavController removeViewController:self];
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
            NSDictionary *redStrDict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
                                         NSForegroundColorAttributeName : [Color color:PGColorOpttonTextRedColor]
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
            [self setTip:@"请再次绘制解锁密码"];
            
             [_errorLabel setHidden:NO];
            _errorLabel.text = @"两次绘制的密码不一致";
            [self shakeAnimationForView:_errorLabel];

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
    [_tipLable setTextColor:[Color color:PGColorOptionTitleBlack]];
    
    
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
    [self.indecator showErrorCircles:string];
    // 直接_变量的坏处是
    [_errorLabel setHidden:NO];
    _errorLabel.attributedText = tip;
    
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
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {

        }
            break;
        case LLLockViewTypeCreate:
        case LLLockViewTypeModify:
        {
            [LLLockPassword saveLockPassword:self.passwordNew];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useLockView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            [LLLockPassword saveLockPassword:nil];
        }
    }
    if (_nLockViewType == LLLockViewTypeCheck || _nLockViewType == LLLockViewTypeCreate) {
        [UCFCouponPopup startQueryCouponPopup];
    }
    // 在这里可能需要回调上个页面做一些刷新什么的动作
    [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES complete:nil];
//#ifdef LLLockAnimationOn
//    [self captureCurrentSnap];
//    // 隐藏控件
//    for (UIView* v in self.view.subviews) {
//        if (v.tag > 10000) continue;
//        v.hidden = YES;
//    }
//    // 动画解锁
//    [self animateUnlock];
//
//    //设置成功之后返回安全中心页
//    if ([_souceVc isEqualToString:@"securityCenter"]) {
//        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        UINavigationController *navController = delegate.tabBarController.selectedViewController;
//        [navController popViewControllerAnimated:YES];
//    }
//#else
//
//    [self dismissViewControllerAnimated:NO completion:^{
//        [AuxiliaryFunc showAlertViewWithMessage:@"恭喜您注册成功!" delegate:self];
//    }];
//#endif
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
            UCFRegisterFinshViewController * VC = [[UCFRegisterFinshViewController alloc] initWithNibName:@"UCFRegisterFinshViewController" bundle:nil];
            VC.isPresentViewController = YES;
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            VC.rootVc = delegate.tabBarController;
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
            NSInteger personInt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"personCenterClick"] integerValue];
            if (personInt == 1) {
                [delegate.tabBarController setSelectedIndex:4];
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
            }
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
//    UCFOldUserGuideViewController * VC = [UCFOldUserGuideViewController createGuideHeadSetp:1];
//    VC.isPresentViewController = YES; //弹出视图
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    VC.rootVc = delegate.tabBarController;
//    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
//    //[delegate.tabBarController addChildViewController:nav];
//    //delegate.tabBarController.viewControllers = @[nav];
//    //[nav pushViewController:VC animated:YES];
//    [delegate.tabBarController presentViewController:nav animated:YES completion:^{
//        
//    }];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (self.nLockViewType == LLLockViewTypeModify) return;
    if (self.nLockViewType == LLLockViewTypeCreate && self.isFromRegister) return;
    if (isClickCgAndCertiBtn) {
        return;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:CheckIsInitiaLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setindecatorbtnnofication" object:nil];
    
    if (!_isFromRegister) {
        [[MongoliaLayerCenter sharedManager] showLogic];
    }
}

@end
