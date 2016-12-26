//
//  UCFGuaPopViewController.m
//  JRGC
//
//  Created by HeJing on 15/7/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFGuaPopViewController.h"
#import "Common.h"
#import "Common.h"
#import "UITextFieldFactory.h"
#import "UILabel+Misc.h"

@interface UCFGuaPopViewController ()


@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *closeBtn;//关闭按钮
@property (nonatomic, strong) UIButton *submitBtn;//提交按钮
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation UCFGuaPopViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self initChildViews];
    }
    return self;
}

- (void)guaCloseBtnClicked:(id)sender
{
    [self hideView];
}

- (void)initChildViews
{
    
    // Shadow View
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.shadowView.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *shadowTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowClicked:)];
    [_shadowView addGestureRecognizer:shadowTapGes];
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, [Common calculateNewSizeBaseMachine:400])];
    _backImageView.image = [UIImage imageNamed:@"scratchcard_bg.png"];
    _backImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackImaClicked:)];
    [_backImageView addGestureRecognizer:tapGes];

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 37)];
    
    _cardNumField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake((ScreenWidth - 201) / 2, [Common calculateNewSizeBaseMachine:214], 201, 37) delegate:self placeholder:@"请输入刮刮卡号" returnKeyType:UIReturnKeyDefault];
    _cardNumField.backgroundColor = UIColorWithRGB(0xf2f2f2);
    _cardNumField.layer.borderWidth = 0.5;
    _cardNumField.layer.borderColor = UIColorWithRGB(0xc8c8c8).CGColor;
    _cardNumField.layer.cornerRadius = 2.0;
    _cardNumField.leftView = leftView;
    _cardNumField.leftViewMode = UITextFieldViewModeAlways;
    [_backImageView addSubview:_cardNumField];
    
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 37)];
    _passwordField = [UITextFieldFactory getTextFieldObjectWithFrame:CGRectMake((ScreenWidth - 201) / 2, CGRectGetMaxY(_cardNumField.frame) + 12, 201, 37) delegate:self placeholder:@"请输入刮刮卡密码" returnKeyType:UIReturnKeyDefault];
    _passwordField.backgroundColor = UIColorWithRGB(0xf2f2f2);
    _passwordField.layer.borderWidth = 0.5;
    _passwordField.layer.borderColor = UIColorWithRGB(0xc8c8c8).CGColor;
    _passwordField.layer.cornerRadius = 2.0;
    _passwordField.leftView = leftView2;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    [_backImageView addSubview:_passwordField];
    
    _errorInfoLbl = [UILabel labelWithFrame:CGRectMake((ScreenWidth - 201) / 2, CGRectGetMaxY(_passwordField.frame) + 9, 201, 13) text:@"" textColor:UIColorWithRGB(0xfd5d4c) font:[UIFont systemFontOfSize:13]];
    [_backImageView addSubview:_errorInfoLbl];
    
    //右上关闭按钮
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:60], [Common calculateNewSizeBaseMachine:90], [Common calculateNewSizeBaseMachine:35], [Common calculateNewSizeBaseMachine:35]);
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"bigredbag_btn_close.png"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(guaCloseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_closeBtn];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake((ScreenWidth - 200) / 2, CGRectGetMaxY(_errorInfoLbl.frame) + 11, 200, 33);
    [_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setBackgroundColor:UIColorWithRGB(0xfd5d4c)];
    _submitBtn.layer.cornerRadius = 2.0;
    [_submitBtn setTitleColor:UIColorWithRGB(0xffffff) forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_submitBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [_backImageView addSubview:_submitBtn];
    
    
    // Set frames
    CGRect r;
    if (self.view.superview != nil)
    {
        // View is showing, position at center of screen
        r = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    else
    {
        // View is not visible, position outside screen bounds
        r = CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight);
    }
    self.view.frame = r;
}

- (void)submitBtnClicked:(id)sender
{
    _errorInfoLbl.text = @"";
    [_cardNumField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_delegate submitBtnClicked:sender];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kebordShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kebordHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guaguaHideView:) name:@"guaguakaHide" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"guaguakaHide" object:nil];
}

- (void)guaguaHideView:(NSNotification*)info
{
    [self hideView];
}

- (void)kebordShow:(NSNotification*)info
{
    _errorInfoLbl.text = @"";
    NSString *machineName = [Common machineName];
    if ([machineName isEqualToString:@"4"]) {
        [UIView animateWithDuration:0.2 animations:^{
            _backImageView.frame = CGRectMake (0,-120,ScreenWidth, 400);
        }];
    } else if ([machineName isEqualToString:@"5"]) {
        [UIView animateWithDuration:0.2 animations:^{
            _backImageView.frame = CGRectMake (0,-30,ScreenWidth, 400);
        }];
    }
}

- (void)kebordHide:(NSNotification*)info
{
    NSString *machineName = [Common machineName];
    if ([machineName isEqualToString:@"4"]) {
        [UIView animateWithDuration:0.2 animations:^{
            _backImageView.frame = CGRectMake (0,0,ScreenWidth, 400);
        }];
    } else if ([machineName isEqualToString:@"5"]) {
        [UIView animateWithDuration:0.2 animations:^{
            _backImageView.frame = CGRectMake (0,0,ScreenWidth, 400);
        }];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    

}

- (void)onBackImaClicked:(UITapGestureRecognizer*)tap
{
    [_backImageView endEditing:YES];
}

- (void)shadowClicked:(UITapGestureRecognizer*)tap
{
    //[self hideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0;
        self.view.alpha = 0;
        _backImageView.alpha = 0;
    } completion:^(BOOL completed) {
        [self.shadowView removeFromSuperview];
        [_backImageView removeFromSuperview];
        _shadowView = nil;
        _backImageView = nil;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showPopView:(UIViewController *)controller
{
    self.view.alpha = 0;
    //self.rootViewController = controller;
    
    // Add subviews
    //[self.rootViewController addChildViewController:self];
    self.shadowView.frame = [[UIApplication sharedApplication].keyWindow bounds];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:_shadowView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_backImageView];
    //[self.rootViewController.view addSubview:self.shadowView];
    //[self.rootViewController.view addSubview:self.view];
    
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

#pragma mark -textFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    _errorInfoLbl.text = @"";
//    NSString *machineName = [Common machineName];
//    if ([machineName isEqualToString:@"4"]) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _backImageView.frame = CGRectMake (0,-120,ScreenWidth, 400);
//        }];
//    } else if ([machineName isEqualToString:@"5"]) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _backImageView.frame = CGRectMake (0,-30,ScreenWidth, 400);
//        }];
//    }
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSString *machineName = [Common machineName];
//    if ([machineName isEqualToString:@"4"]) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _backImageView.frame = CGRectMake (0,0,ScreenWidth, 400);
//        }];
//    } else if ([machineName isEqualToString:@"5"]) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _backImageView.frame = CGRectMake (0,0,ScreenWidth, 400);
//        }];
//    }
//}

@end
