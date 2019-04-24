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
@interface UCFTouchIDViewController ()
@property(nonatomic, strong)UIImageView *headImageView;

@property(nonatomic, strong)UILabel *nameLabel;

@property(nonatomic, strong)UILabel *tipLab;

@property(nonatomic, strong)UILabel *tipLab1;

@property(nonatomic, strong)UIImageView *touchIDAmition;

@property(nonatomic, assign)BOOL    isFaceID;

@property(nonatomic, strong)UIButton  *switchPageBtn;

@property(nonatomic, strong)UIButton    *reminderButton;

@property(nonatomic, strong)UIButton    *changeAccountBtn;

@end

@implementation UCFTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)switchPageBtnClick:(UIButton *)button
{
    
}
- (void)dealWithPassword:(UIButton *)button
{
    
}
- (void)changeAccountBtnClicked:(UIButton *)button
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
        _nameLabel.text = @"hi 158****3245";
        _nameLabel.font = [UIFont systemFontOfSize:14*HeightScale];
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
        _tipLab1.topPos.equalTo(self.tipLab.bottomPos);
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
            _touchIDAmition.centerYPos.equalTo(self.rootLayout.centerYPos);
        }
    }
    return _touchIDAmition;

}
- (UIButton *)switchPageBtn
{
    if (!_switchPageBtn) {
        _switchPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchPageBtn.backgroundColor = [UIColor clearColor];
        _switchPageBtn.centerXPos.equalTo(self.rootLayout.centerXPos);
        _switchPageBtn.titleLabel.font = [UIFont systemFontOfSize:17 *HeightScale];
        [_switchPageBtn setTitle:@"切换至手势解锁" forState:UIControlStateNormal];
        _switchPageBtn.widthSize.equalTo(@200);
        _switchPageBtn.heightSize.equalTo(@40);
        _switchPageBtn.topPos.equalTo(_touchIDAmition.bottomPos).offset(HeightScale >=1 ? 100 : 60);
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
        _reminderButton.centerYPos.equalTo(_switchPageBtn.centerYPos).offset(60);
        [_reminderButton setTitle:@"忘记密码" forState:UIControlStateNormal];
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
