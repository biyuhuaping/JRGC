//
//  UCFUnlockViewController.m
//  JRGC
//
//  Created by zrc on 2019/4/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFUnlockViewController.h"
#import "UCFLockConfig.h"
#import "LLLockView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "LLLockPassword.h"
#import "UCFNewLockContainerViewController.h"
#import "UCFNewVerificationLoginPassWordViewController.h"
@interface UCFUnlockViewController ()<LLLockDelegate>
{
    int nRetryTimesRemain; // 剩余几次输入机会
}
@property(nonatomic, strong)UIImageView *headImageView;

@property(nonatomic, strong)UILabel *nameLabel;

@property(nonatomic, strong)UILabel *tipLab;

@property(nonatomic, strong)UILabel *errorLabel;

@property(nonatomic, strong)LLLockView  *lockView;

@property(nonatomic, strong)UIButton  *switchPageBtn;

@property(nonatomic, strong)UIButton    *reminderButton;

@property(nonatomic, strong)UIButton    *changeAccountBtn;

@property (nonatomic, strong) NSString  *savedPassword; // 本地存储的密码
@end

@implementation UCFUnlockViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.parentViewController.childViewControllers.count == 1) {
        self.switchPageBtn.myVisibility = MyVisibility_Invisible;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _errorLabel.myVisibility = MyVisibility_Invisible;

    ((RTContainerController *) (self.rt_navigationController.viewControllers.lastObject)).fd_interactivePopDisabled = YES;
    // 本地保存的手势密码
    self.savedPassword = [LLLockPassword loadLockPassword];
    LLLog(@"本地保存的密码是%@", self.savedPassword);
    // 尝试机会
    nRetryTimesRemain = [[[NSUserDefaults standardUserDefaults] valueForKey:@"nRetryTimesRemain"] intValue];
    self.view.backgroundColor = [Color color:PGColorOptionThemeWhite];
}
- (void)lockString:(NSString*)string
{
    [self checkPassword:string];
}
#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString*)string
{
    // 验证密码正确
    if ([string isEqualToString:self.savedPassword]) {
        [self hide];
    } else if (string.length > 0) {  // 验证密码错误
        nRetryTimesRemain--;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:nRetryTimesRemain] forKey:@"nRetryTimesRemain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (nRetryTimesRemain > 0) {
            NSDictionary *normalStrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:15 * HeightScale],
                                            NSForegroundColorAttributeName : [Color color:PGColorOptionTitlerRead]
                                            };
            NSString *str = [NSString stringWithFormat:@"密码输入错误，您还可以尝试 %d 次", nRetryTimesRemain];
            NSRange strRg = [str rangeOfString:[NSString stringWithFormat:@"%d",nRetryTimesRemain]];
            NSMutableAttributedString *StrAttri = [[NSMutableAttributedString alloc] initWithString:str attributes:normalStrDict];
            
            NSDictionary *redStrDict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15 * HeightScale],
                                         NSForegroundColorAttributeName : [Color color:PGColorOptionTitlerRead]
                                         };
            [StrAttri addAttributes:redStrDict range:strRg];
            
            [self setErrorTip:StrAttri errorPswd:string];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useLockView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 强制注销该账户，并清除手势密码，以便重设
            [SingleUserInfo deleteUserData];
            [LLLockPassword saveLockPassword:nil];

            [SingGlobalView.rootNavController popToRootViewControllerAnimated:NO complete:^(BOOL finished) {
                [SingleUserInfo loadLoginViewController];
            }];

        }
    } else {
        NSAssert(YES, @"意外情况");
    }
}
// 错误
- (void)setErrorTip:(NSMutableAttributedString*)tip errorPswd:(NSString*)string
{
    // 显示错误点点
    [self.lockView showErrorCircles:string];
    _errorLabel.myVisibility = MyVisibility_Visible;
    _errorLabel.attributedText = tip;
    [_errorLabel sizeToFit];
//    [self shakeAnimationForView:_errorLabel];
}

- (void)hide
{
    [SingGlobalView.rootNavController popToRootViewControllerAnimated:YES complete:nil];
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
- (void)loadView
{
    [super loadView];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    [self.rootLayout addSubview:self.headImageView];
    [self.rootLayout addSubview:self.nameLabel];
    [self.rootLayout addSubview:self.tipLab];
    [self.rootLayout addSubview:self.errorLabel];
    [self.rootLayout addSubview:self.lockView];
    [self.rootLayout addSubview:self.switchPageBtn];
    [self.rootLayout addSubview:self.reminderButton];
    [self.rootLayout addSubview:self.changeAccountBtn];
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
        _tipLab.text = @"请绘制解锁密码";
        [_tipLab sizeToFit];
    }
    return _tipLab;
}
- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.topPos.equalTo(self.tipLab.bottomPos).offset(16 * HeightScale);
        _errorLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _errorLabel.font = [UIFont systemFontOfSize:16 * HeightScale];
        _errorLabel.textColor = [Color color:PGColorOptionCellContentBlue];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.text = @"密码输入错误，您还可以尝试5次";
        [_errorLabel sizeToFit];
    }
    return _errorLabel;
    
}
- (LLLockView *)lockView
{
    if (!_lockView) {
        _lockView = [[LLLockView alloc] initWithFrame:CGRectMake((ScreenWidth - [Common calculateNewSizeBaseMachine:320]) / 2,HeightScale >= 1 ? 270 * HeightScale : 237 * HeightScale, [Common calculateNewSizeBaseMachine:320], [Common calculateNewSizeBaseMachine:320])];
        _lockView.useFrame = YES;
        _lockView.delegate = self;
    }
    return _lockView;
}
- (UIButton *)switchPageBtn
{
    if (!_switchPageBtn) {
        _switchPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchPageBtn.backgroundColor = [UIColor clearColor];
        _switchPageBtn.centerXPos.equalTo(self.rootLayout.centerXPos);
        _switchPageBtn.titleLabel.font = [UIFont systemFontOfSize:18 *HeightScale];
        [_switchPageBtn setTitle:@"切换至指纹解锁" forState:UIControlStateNormal];
        _switchPageBtn.widthSize.equalTo(@200);
        _switchPageBtn.heightSize.equalTo(@40);
//        _switchPageBtn.topPos.equalTo(@(HeightScale >=1 ? CGRectGetMaxY(self.lockView.frame) : CGRectGetMaxY(self.lockView.frame) - 20));
        _switchPageBtn.bottomPos.equalTo(self.reminderButton.topPos).offset(0);
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
//        _reminderButton.centerYPos.equalTo(_switchPageBtn.centerYPos).offset(HeightScale >=1 ? 60 : 40 *HeightScale);
        _reminderButton.bottomPos.equalTo(@(StatusBarHeight1 > 20 ? 39 + 36 : 36));

        [_reminderButton setTitle:@"密码登录" forState:UIControlStateNormal];
        [_reminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reminderButton setBackgroundColor:[UIColor clearColor]];
        [_reminderButton addTarget:self action:@selector(dealWithPassword:) forControlEvents:UIControlEventTouchUpInside];
        _reminderButton.titleLabel.font = [UIFont systemFontOfSize:15 * HeightScale];
        [self.view addSubview:_reminderButton];
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
- (void)switchPageBtnClick:(UIButton *)button
{
    [(UCFNewLockContainerViewController  *)self.parentViewController childControlerCallShow:self];

}
@end
