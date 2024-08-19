//
//  UCFTouchIDViewController.m
//  JRGC
//
//  Created by zrc on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTouchIDViewController.h"
#import "UCFLockConfig.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "UCFNewLockContainerViewController.h"
#import "UCFNewVerificationLoginPassWordViewController.h"
@interface UCFTouchIDViewController ()
@property(nonatomic, strong)UIImageView *headImageView;

@property(nonatomic, strong)UILabel *nameLabel;

@property(nonatomic, strong)UILabel *tipLab;

@property(nonatomic, strong)UILabel *tipLab1;

@property(nonatomic, strong)UIImageView *touchIDAmition;

@property(nonatomic, strong)UIButton *restartTouchId;

@property(nonatomic, assign)BOOL    isFaceID;

@property(nonatomic, strong)UIButton  *switchPageBtn;

@property(nonatomic, strong)UIButton    *reminderButton;

@property(nonatomic, strong)UIButton    *changeAccountBtn;

@end

@implementation UCFTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Color color:PGColorOptionThemeWhite];
}

- (void)switchPageBtnClick:(UIButton *)button
{
    [(UCFNewLockContainerViewController  *)self.parentViewController childControlerCallShow:self];
}
- (void)dealWithPassword:(UIButton *)button
{
    UCFNewVerificationLoginPassWordViewController *controller = [[UCFNewVerificationLoginPassWordViewController alloc] init];
    controller.titleString = [NSString stringWithFormat:@""];
    [self.parentViewController.rt_navigationController pushViewController:controller animated:YES];
}
- (void)changeAccountBtnClicked:(UIButton *)button
{
     [SingleUserInfo loadLoginViewController];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.parentViewController.childViewControllers.count == 1) {
        self.switchPageBtn.myVisibility = MyVisibility_Invisible;
    }
}
- (void)loadView
{

    [super loadView];
    [self checkTouchIdIsOpen];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    [self.rootLayout addSubview:self.headImageView];
    [self.rootLayout addSubview:self.nameLabel];
    [self.rootLayout addSubview:self.tipLab];
    [self.rootLayout addSubview:self.tipLab1];
    [self.rootLayout addSubview:self.touchIDAmition];
    [self.rootLayout addSubview:self.restartTouchId];
    [self.rootLayout addSubview:self.switchPageBtn];
    [self.rootLayout addSubview:self.reminderButton];
    [self.rootLayout addSubview:self.changeAccountBtn];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self openTouchId:nil];
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
                 [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES complete:nil];
             } else {
                 if (error) {
                     switch (error.code) {
                         case LAErrorUserCancel:
                             NSLog(@"Authentication was cancelled by the user");
                             //用户取消验证Touch ID
     
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

                             break;
                     }
                     return ;
                 }
             }
         });
         
         
     }];
}
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.widthSize.equalTo(@(85 * HeightScale));
        _headImageView.heightSize.equalTo(@(85 * HeightScale));
        _headImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _headImageView.topPos.equalTo(@(70 * HeightScale));
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserMsg"];
        NSString *headUrl = nil;
        if (dict) {
            headUrl = [dict objectForKey:@"headurl"];
        }
        _headImageView.image = [UIImage imageNamed:@"password_head.png"];
    }
    return _headImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _nameLabel.topPos.equalTo(self.headImageView.bottomPos).offset(18 * HeightScale);
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = [NSString stringWithFormat:@"hi %@",SingleUserInfo.loginData.userInfo.mobile];
        _nameLabel.font = [UIFont systemFontOfSize:18*HeightScale];
        _nameLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
    
}
- (UILabel *)tipLab
{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.topPos.equalTo(self.nameLabel.bottomPos).offset(15 * HeightScale);
        _tipLab.centerXPos.equalTo(self.rootLayout.centerXPos);
        _tipLab.font = [UIFont systemFontOfSize:23 * HeightScale];
        _tipLab.textColor = [Color color:PGColorOptionTitleBlack];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.backgroundColor = [UIColor clearColor];
        _tipLab.text = @"点击扫描区域进行";
        [_tipLab sizeToFit];
    }
    return _tipLab;
}
- (UILabel *)tipLab1
{
    if (!_tipLab1) {
        _tipLab1 = [[UILabel alloc] init];
        _tipLab1.topPos.equalTo(self.tipLab.bottomPos).offset(5);
        _tipLab1.centerXPos.equalTo(self.rootLayout.centerXPos);
        _tipLab1.font = [UIFont systemFontOfSize:23 * HeightScale];
        _tipLab1.textColor = [Color color:PGColorOptionTitleBlack];
        _tipLab1.textAlignment = NSTextAlignmentCenter;
        _tipLab1.backgroundColor = [UIColor clearColor];
        _tipLab1.text = _isFaceID ? @"面容解锁" : @"指纹解锁";
        [_tipLab1 sizeToFit];
    }
    return _tipLab1;
}
- (UIImageView *)touchIDAmition
{
    if (!_touchIDAmition) {
        _touchIDAmition = [[UIImageView alloc] init];
        if (_isFaceID) {
            _touchIDAmition.mySize = CGSizeMake(230, 230);
            _touchIDAmition.topPos.equalTo(self.tipLab1.bottomPos).offset(86);
            _touchIDAmition.centerXPos.equalTo(self.rootLayout.centerXPos);
            _touchIDAmition.image = [UIImage imageNamed:@"face_bg_round"];
            UIImageView *centerImageView = [[UIImageView alloc] init];
            centerImageView.mySize = CGSizeMake(100, 100);
            centerImageView.centerXPos.equalTo(_touchIDAmition.centerXPos);
            centerImageView.centerYPos.equalTo(_touchIDAmition.centerYPos);
            centerImageView.image = [UIImage imageNamed:@"face_bg_head"];
            [self.rootLayout addSubview:centerImageView];
            
        } else {
            _touchIDAmition.mySize = CGSizeMake(120, 120);
            _touchIDAmition.image = [UIImage imageNamed:@"touch_id"];
            _touchIDAmition.centerXPos.equalTo(self.rootLayout.centerXPos);
            _touchIDAmition.centerYPos.equalTo(self.rootLayout.centerYPos).offset(30);
        }
    }
    return _touchIDAmition;

}

- (UIButton *)restartTouchId
{
    if (!_restartTouchId) {
        _restartTouchId = [UIButton buttonWithType:UIButtonTypeCustom];
        _restartTouchId.backgroundColor = [UIColor clearColor];
        [_restartTouchId addTarget:self action:@selector(openTouchId:) forControlEvents:UIControlEventTouchUpInside];
        if (_isFaceID) {
            _restartTouchId.mySize = CGSizeMake(230, 230);
            _restartTouchId.topPos.equalTo(self.tipLab1.bottomPos).offset(86);
            _restartTouchId.centerXPos.equalTo(self.rootLayout.centerXPos);
        } else {
            _restartTouchId.mySize = CGSizeMake(120, 120);
            _restartTouchId.centerXPos.equalTo(self.rootLayout.centerXPos);
            _restartTouchId.centerYPos.equalTo(self.rootLayout.centerYPos);
        }
    }
    return _restartTouchId;
}
- (UIButton *)switchPageBtn
{
    if (!_switchPageBtn) {
        _switchPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchPageBtn.backgroundColor = [UIColor clearColor];
        _switchPageBtn.centerXPos.equalTo(self.rootLayout.centerXPos);
        _switchPageBtn.titleLabel.font = [UIFont systemFontOfSize:18 *HeightScale];
        [_switchPageBtn setTitle:@"切换至手势解锁" forState:UIControlStateNormal];
        _switchPageBtn.widthSize.equalTo(@200);
        _switchPageBtn.heightSize.equalTo(@40);
        _switchPageBtn.bottomPos.equalTo(self.reminderButton.topPos).offset(0);
//        _switchPageBtn.topPos.equalTo(_touchIDAmition.bottomPos).offset(HeightScale >=1 ? 100 : 60);
        [_switchPageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_switchPageBtn addTarget:self action:@selector(switchPageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchPageBtn;
    
}

- (UIButton *)reminderButton
{
    if (!_reminderButton) {
        _reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reminderButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _reminderButton.leftPos.equalTo(@(50 * WidthScale));
        _reminderButton.heightSize.equalTo(@40);
        _reminderButton.bottomPos.equalTo(@(StatusBarHeight1 > 20 ? 39 + 36 : 36));
        [_reminderButton setTitle:@"密码登录" forState:UIControlStateNormal];
        [_reminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reminderButton setBackgroundColor:[UIColor clearColor]];
        [_reminderButton addTarget:self action:@selector(dealWithPassword:) forControlEvents:UIControlEventTouchUpInside];
        _reminderButton.titleLabel.font = [UIFont systemFontOfSize:15 * HeightScale];
        [_reminderButton sizeToFit];
    }
    return _reminderButton;
}
- (UIButton *)changeAccountBtn
{
    if (!_changeAccountBtn) {
        _changeAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeAccountBtn.centerYPos.equalTo(self.reminderButton.centerYPos);
        _changeAccountBtn.heightSize.equalTo(@40);
        _changeAccountBtn.rightPos.equalTo(@(50 * WidthScale));
        [_changeAccountBtn setTitle:@"切换账户" forState:UIControlStateNormal];
        [_changeAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_changeAccountBtn setBackgroundColor:[UIColor clearColor]];
        [_changeAccountBtn addTarget:self action:@selector(changeAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _changeAccountBtn.titleLabel.font = [UIFont systemFontOfSize:15 *HeightScale];
        [_changeAccountBtn sizeToFit];
    }
    return _changeAccountBtn;
}
- (BOOL)checkTouchIdIsOpen
{
    _isFaceID = NO;
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
