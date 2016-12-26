//
//  RegisterSuccessAlert.m
//  JRGC
//
//  Created by HeJing on 15/5/7.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "RegisterSuccessAlert.h"
#import "UIImage+Misc.h"
#import "Common.h"

#define kWindowWidth 320
#define kWindowHeight 400
#define ALERTLABELYPOS 224
#define ALERTLABELXPOS 44

@interface RegisterSuccessAlert ()
{
    NSString *_voucherStr;
    NSString *_doneCertificationStr;
    NSString *_bdStr;
}


@property (nonatomic, strong) UIImageView *backImageView;//背景
@property (nonatomic, strong) UIButton *closeBtn;//关闭按钮
@property (nonatomic, strong) UIButton *lookBtn;//先看看按钮
@property (nonatomic, strong) UIButton *certificationBtn;//立即认证按钮
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *shadowView;//灰色遮罩
@property (nonatomic, strong) UILabel *vouchersLabel;
@property (nonatomic, strong) UILabel *doneCertificationLabel;
@property (nonatomic, strong) UILabel *bdLabel;
@property (nonatomic, strong) UILabel *guLabel;

@end

@implementation RegisterSuccessAlert

- (id)init
{
    self = [super init];
    if (self) {
        [self initChildViews];
    }
    return self;
}

- (void)initChildViews
{
    //背景Image
    _backImageView = [[UIImageView alloc] init];
    _backImageView.image = [UIImage imageNamed:@"success_bg.png"];
    
    //送代金券
    _vouchersLabel = [[UILabel alloc] init];
    _vouchersLabel.textAlignment = NSTextAlignmentCenter;
    _vouchersLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    _vouchersLabel.textColor = UIColorWithRGB(0x555555);
    //认证再送
    _doneCertificationLabel = [[UILabel alloc] init];
    _doneCertificationLabel.textAlignment = NSTextAlignmentCenter;
    _doneCertificationLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    _doneCertificationLabel.textColor = UIColorWithRGB(0x555555);
    
    _bdLabel = [[UILabel alloc] init];
    _bdLabel.textAlignment = NSTextAlignmentCenter;
    _bdLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    _bdLabel.textColor = UIColorWithRGB(0x555555);
    
    _guLabel = [[UILabel alloc] init];
    _guLabel.textAlignment = NSTextAlignmentCenter;
    _guLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]];
    _guLabel.textColor = UIColorWithRGB(0x555555);
    _guLabel.text = @"工场就是这么任性!";
    
    //右上关闭按钮
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"bigredbag_btn_close.png"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //先看看按钮
    _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lookBtn setTitle:@"先看看" forState:UIControlStateNormal];
    _lookBtn.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:14]];
    [_lookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lookBtn setBackgroundImage:[UIImage createImageWithColor:UIColorWithRGB(0x8296af)] forState:UIControlStateNormal];
    _lookBtn.layer.cornerRadius = 2;
    _lookBtn.layer.masksToBounds = YES;
    [_lookBtn addTarget:self action:@selector(lookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //认证按钮
    _certificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _certificationBtn.titleLabel.font = [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:14]];
    [_certificationBtn setTitle:@"立即认证" forState:UIControlStateNormal];
    [_certificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_certificationBtn setBackgroundImage:[UIImage createImageWithColor:UIColorWithRGB(0xfd4d4c)] forState:UIControlStateNormal];
    _certificationBtn.layer.cornerRadius = 2;
    _certificationBtn.layer.masksToBounds = YES;
    [_certificationBtn addTarget:self action:@selector(certificationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Add Subvies
    [self.view addSubview:_backImageView];
    [self.view addSubview:_closeBtn];
    [self.view addSubview:_lookBtn];
    [self.view addSubview:_certificationBtn];
    [self.view addSubview:_vouchersLabel];
    [self.view addSubview:_bdLabel];
    [self.view addSubview:_guLabel];
    [self.view addSubview:_doneCertificationLabel];
    
    // Shadow View
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.shadowView.backgroundColor = [UIColor blackColor];
    
    // Set frames
    CGRect r;
    if (self.view.superview != nil)
    {
        // View is showing, position at center of screen
        r = CGRectMake(0, 0, [Common calculateNewSizeBaseMachine:kWindowWidth], [Common calculateNewSizeBaseMachine:kWindowHeight]);
    }
    else
    {
        // View is not visible, position outside screen bounds
        r = CGRectMake(0, -[Common calculateNewSizeBaseMachine:kWindowHeight], [Common calculateNewSizeBaseMachine:kWindowWidth], [Common calculateNewSizeBaseMachine:kWindowHeight]);
    }
    self.view.frame = r;
}

- (void)setAlertTitle:(NSString*)amount1 cetiAmout:(NSString*)amount2 titleType:(NSString *)type certifiType:(NSString *)type2 bdAmout:(NSString *)bdamount bdType:(NSString *)bdtype
{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    //amount1 注册成功获得数量的奖励
    if ([amount1 intValue] > 0) {
        if ([type isEqualToString:@"0"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元现金",[amount1 intValue]];
        } else if ([type isEqualToString:@"1"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d工豆",[amount1 intValue]];
        } else if ([type isEqualToString:@"A"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元返现券",[amount1 intValue]];
        } else if ([type isEqualToString:@"2"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元体验本金",[amount1 intValue]];
        } else if ([type isEqualToString:@"3"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d次抽奖机会",[amount1 intValue]];
        } else if ([type isEqualToString:@"4"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元红包",[amount1 intValue]];
        }
    } else {
        str1 = @"";
    }
    //amount2
    if ([amount2 intValue] > 0) {
        if ([type2 isEqualToString:@"0"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[amount2 intValue]];
        } else if ([type2 isEqualToString:@"1"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[amount2 intValue]];
        } else if ([type2 isEqualToString:@"A"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[amount2 intValue]];
        } else if ([type2 isEqualToString:@"2"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[amount2 intValue]];
        } else if ([type2 isEqualToString:@"3"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[amount2 intValue]];
        } else if ([type2 isEqualToString:@"4"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[amount2 intValue]];
        }
    } else {
        str2 = @"";
    }
    //bdamount
    if ([bdamount intValue] > 0) {
        if ([bdtype isEqualToString:@"0"]) {
            str3 = [NSString stringWithFormat:@"绑定银行卡再送%d元",[amount2 intValue]];
        } else if ([bdtype isEqualToString:@"1"]) {
            str3 = [NSString stringWithFormat:@"绑定银行卡再送%d元",[amount2 intValue]];
        } else if ([bdtype isEqualToString:@"A"]) {
            str3 = [NSString stringWithFormat:@"绑定银行卡再送%d元",[amount2 intValue]];
        } else if ([bdtype isEqualToString:@"2"]) {
            str3 = [NSString stringWithFormat:@"绑定银行卡再送%d元",[amount2 intValue]];
        } else if ([bdtype isEqualToString:@"3"]) {
            str3 = [NSString stringWithFormat:@"绑定银行卡再送%d元",[amount2 intValue]];
        } else if ([bdtype isEqualToString:@"4"]) {
            str3 = [NSString stringWithFormat:@"绑定银行卡再送%d元",[amount2 intValue]];
        }
    } else {
        str3 = @"";
    }
    _voucherStr = str1;
    _doneCertificationStr = str2;
    _bdStr = str3;
    
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]],
                                    NSForegroundColorAttributeName : [UIColor redColor]
                                    };
    
    if (![str1 isEqualToString:@""]) {
        NSMutableAttributedString *newStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
        NSRange attriRange1 = [str1 rangeOfString:amount1];
        [newStr1 addAttributes:attribute range:attriRange1];
        _vouchersLabel.attributedText = newStr1;
    }
    if (![str2 isEqualToString:@""]) {
        NSMutableAttributedString *newStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
        NSRange attriRange2 = [str2 rangeOfString:amount2];
        NSRange attriRange3 = [str2 rangeOfString:@"身份认证"];
        [newStr2 addAttributes:attribute range:attriRange2];
        [newStr2 addAttributes:attribute range:attriRange3];
        _doneCertificationLabel.attributedText = newStr2;
    }
    if (![str3 isEqualToString:@""]) {
        NSMutableAttributedString *newStr3 = [[NSMutableAttributedString alloc] initWithString:str3];
        NSRange bdRange1 = [str3 rangeOfString:amount2];
        NSRange bdRange2 = [str3 rangeOfString:@"绑定银行卡"];
        [newStr3 addAttributes:attribute range:bdRange1];
        [newStr3 addAttributes:attribute range:bdRange2];
        _bdLabel.attributedText = newStr3;
    }
}

- (void)setAlertTitle:(NSString*)amount1 firstInstAmout:(NSString*)firstInstValue titleType:(NSString *)type firstInstType:(NSString *)firstInstType
{
    NSString *str1;
    NSString *str2;
    //amount1 注册成功获得数量的奖励
    if ([amount1 intValue] > 0) {
        if ([type isEqualToString:@"0"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元现金",[amount1 intValue]];
        } else if ([type isEqualToString:@"1"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d工豆",[amount1 intValue]];
        } else if ([type isEqualToString:@"A"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元返现券",[amount1 intValue]];
        } else if ([type isEqualToString:@"2"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元体验本金",[amount1 intValue]];
        } else if ([type isEqualToString:@"3"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d次抽奖机会",[amount1 intValue]];
        } else if ([type isEqualToString:@"4"]) {
            str1 = [NSString stringWithFormat:@"恭喜您注册成功！已获%d元红包",[amount1 intValue]];
        }
    } else {
        str1 = @"恭喜您注册成功！";
    }
    //amount2
    if ([firstInstValue intValue] > 0) {
        if ([firstInstType isEqualToString:@"0"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[firstInstValue intValue]];
        } else if ([firstInstType isEqualToString:@"1"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[firstInstValue intValue]];
        } else if ([firstInstType isEqualToString:@"A"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[firstInstValue intValue]];
        } else if ([firstInstType isEqualToString:@"2"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[firstInstValue intValue]];
        } else if ([firstInstType isEqualToString:@"3"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[firstInstValue intValue]];
        } else if ([firstInstType isEqualToString:@"4"]) {
            str2 = [NSString stringWithFormat:@"首次投资最高送%d元",[firstInstValue intValue]];
        }
    } else {
        str2 = @"";
    }
    _voucherStr = str1;
    _doneCertificationStr = str2;
    _bdStr = @"";
    
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]],
                                NSForegroundColorAttributeName : [UIColor redColor]
                                };
    
    if (![str1 isEqualToString:@""]) {
        NSMutableAttributedString *newStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
        NSRange attriRange1 = [str1 rangeOfString:amount1];
        [newStr1 addAttributes:attribute range:attriRange1];
        _vouchersLabel.attributedText = newStr1;
    }
    if (![str2 isEqualToString:@""]) {
        NSMutableAttributedString *newStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
        NSRange attriRange2 = [str2 rangeOfString:firstInstValue];
        NSRange attriRange3 = [str2 rangeOfString:@"投资"];
        [newStr2 addAttributes:attribute range:attriRange2];
        [newStr2 addAttributes:attribute range:attriRange3];
        _doneCertificationLabel.attributedText = newStr2;
    }
}

- (void)closeBtnClicked:(id)sender
{
    [self hideView];
}

- (void)lookBtnClicked:(id)sender
{
    [self hideView];
    [_delegate lookBtnClicked:sender];
}

- (void)certificationBtnClicked:(id)sender
{
    [self hideView];
    [_delegate certificationBtnClicked:sender];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _closeBtn.frame = CGRectMake([Common calculateNewSizeBaseMachine:kWindowWidth] - [Common calculateNewSizeBaseMachine:60], [Common calculateNewSizeBaseMachine:100], [Common calculateNewSizeBaseMachine:35], [Common calculateNewSizeBaseMachine:35]);
    
    _backImageView.frame = CGRectMake(0, 0, [Common calculateNewSizeBaseMachine:kWindowWidth], [Common calculateNewSizeBaseMachine:kWindowHeight]);
    
    _vouchersLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], [Common calculateNewSizeBaseMachine:ALERTLABELYPOS], (ScreenWidth - [Common calculateNewSizeBaseMachine:ALERTLABELXPOS]*2), [Common calculateNewSizeBaseMachine:40]);
    _vouchersLabel.numberOfLines = 0;
    _vouchersLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _vouchersLabel.textAlignment = NSTextAlignmentLeft;
    
    //第一个奖励label位置
    _doneCertificationLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], CGRectGetMaxY(_vouchersLabel.frame), (ScreenWidth - [Common calculateNewSizeBaseMachine:ALERTLABELXPOS]*2), [Common calculateNewSizeBaseMachine:15]);
    
    //第二个奖励label位置
    _bdLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], CGRectGetMaxY(_doneCertificationLabel.frame) + [Common calculateNewSizeBaseMachine:6], (ScreenWidth - [Common calculateNewSizeBaseMachine:ALERTLABELXPOS]*2), [Common calculateNewSizeBaseMachine:15]);
    
    _guLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], CGRectGetMaxY(_bdLabel.frame) + [Common calculateNewSizeBaseMachine:6], (ScreenWidth - [Common calculateNewSizeBaseMachine:ALERTLABELXPOS]*2), [Common calculateNewSizeBaseMachine:15]);
    if ([_bdStr isEqualToString:@""]) {
        _guLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], CGRectGetMaxY(_bdLabel.frame) - [Common calculateNewSizeBaseMachine:6], (ScreenWidth - [Common calculateNewSizeBaseMachine:ALERTLABELXPOS]*2), [Common calculateNewSizeBaseMachine:15]);
    }
    
    _lookBtn.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], [Common calculateNewSizeBaseMachine:kWindowHeight] - [Common calculateNewSizeBaseMachine:70], [Common calculateNewSizeBaseMachine:110], [Common calculateNewSizeBaseMachine:33]);
    _certificationBtn.frame = CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:154], [Common calculateNewSizeBaseMachine:kWindowHeight] - [Common calculateNewSizeBaseMachine:70], [Common calculateNewSizeBaseMachine:110], [Common calculateNewSizeBaseMachine:33]);
    
    if ([_doneCertificationStr isEqualToString:@""] && [_voucherStr isEqualToString:@""] && [_bdStr isEqualToString:@""]) {
        _vouchersLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], [Common calculateNewSizeBaseMachine:ALERTLABELYPOS], (ScreenWidth - [Common calculateNewSizeBaseMachine:ALERTLABELXPOS]*2), [Common calculateNewSizeBaseMachine:45]);
        
        NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:[Common calculateNewSizeBaseMachine:15]],
                                    NSForegroundColorAttributeName : [UIColor redColor]
                                    };
        
        NSMutableAttributedString *newStr1 = [[NSMutableAttributedString alloc] initWithString:@"继续完成身份认证，绑定银行卡后就可以进行投资啦！"];
        NSRange attriRange1 = [@"继续完成身份认证，绑定银行卡后就可以进行投资啦！" rangeOfString:@"完成身份认证，绑定银行卡"];
        [newStr1 addAttributes:attribute range:attriRange1];
        _vouchersLabel.attributedText = newStr1;

        _vouchersLabel.numberOfLines = 0;
        _vouchersLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _vouchersLabel.textAlignment = NSTextAlignmentLeft;
        
        _guLabel.frame = CGRectMake([Common calculateNewSizeBaseMachine:ALERTLABELXPOS], CGRectGetMaxY(_vouchersLabel.frame), (ScreenWidth - [Common calculateNewSizeBaseMachine:ALERTLABELXPOS]*2), [Common calculateNewSizeBaseMachine:45]);
        _guLabel.numberOfLines = 0;
        _guLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _guLabel.textAlignment = NSTextAlignmentLeft;
        _guLabel.text = @"收益多多，更有丰富的返利活动等着你！快去认证吧！";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0;
        self.view.alpha = 0;
    } completion:^(BOOL completed) {
        [self.shadowView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showAlert:(UIViewController *)controller
{
    self.view.alpha = 0;
    self.rootViewController = controller;
    
    // Add subviews
    [self.rootViewController addChildViewController:self];
    self.shadowView.frame = controller.view.bounds;
    [self.rootViewController.view addSubview:self.shadowView];
    [self.rootViewController.view addSubview:self.view];
    
    // Animate in the alert view
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0.75;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.center = self.rootViewController.view.center;
//        }];
    }];

}

@end
