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
@interface UCFCreateLockViewController ()
@property(nonatomic, strong)UILabel *titleLabe; //标题
@property(nonatomic, strong)UIButton *runButton;//跳过按钮
@property(nonatomic, strong)UILabel  *tipLab;   //用户提醒标签

@property(nonatomic, strong)LLLockIndicator *indecator; //轨迹指示器
@property(nonatomic, strong)LLLockView  *lockView;

@property(nonatomic, strong)UILabel  *errorLabel; //错误提醒
@end

@implementation UCFCreateLockViewController

- (void)loadView
{
    [super loadView];
    
    [self.rootLayout addSubview:self.titleLabe];
    [self.rootLayout addSubview:self.runButton];
    [self.rootLayout addSubview:self.tipLab];
    [self.rootLayout addSubview:self.indecator];
    [self.rootLayout addSubview:self.errorLabel];
}

- (UILabel *)titleLabe
{
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc] init];
        _titleLabe.heightSize.equalTo(@44);
        _titleLabe.centerXPos.equalTo(self.rootLayout.centerXPos);
        _titleLabe.topPos.equalTo(@0);
        _titleLabe.font = [Color gc_Font:18];
        _titleLabe.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabe.textAlignment = NSTextAlignmentCenter;
        _titleLabe.backgroundColor = [UIColor clearColor];
        _titleLabe.text = @"设置手势";
    }
    return _titleLabe;
}
- (UIButton *)runButton
{
    if (!_runButton) {
        _runButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _runButton.leftPos.equalTo(@15);
        _runButton.topPos.equalTo(@0);
        _runButton.widthSize.equalTo(@44);
        _runButton.heightSize.equalTo(@44);
        _runButton.imageEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_runButton addTarget:self action:@selector(dealWithrunBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_runButton setImage:[UIImage imageNamed:@"calculator_gray_close"] forState:UIControlStateNormal];
    }
    return _runButton;
}
- (UILabel *)tipLab
{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.leftPos.equalTo(@0);
        _tipLab.topPos.equalTo(self.titleLabe.bottomPos).offset(45 * HeightScale);
        _tipLab.widthSize.equalTo(self.rootLayout.widthSize);
        _tipLab.heightSize.equalTo(@(30 * HeightScale));
        _tipLab.font = [UIFont systemFontOfSize:23];
        _tipLab.textColor = [Color color:PGColorOptionTitleBlack];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.backgroundColor = [UIColor clearColor];
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
        _errorLabel.topPos.equalTo(_indecator.bottomPos).offset(30 * HeightScale);
        _errorLabel.widthSize.equalTo(self.rootLayout.widthSize);
        _errorLabel.leftPos.equalTo(@0);
        _errorLabel.font = [UIFont systemFontOfSize:16 * HeightScale];
        _errorLabel.textColor = [Color color:PGColorOpttonTextRedColor];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.backgroundColor = [UIColor clearColor];
    }
    return _errorLabel;

}
- (LLLockView *)lockView
{
    if (!_lockView) {
        _lockView = [[LLLockView alloc] initWithFrame:CGRectMake((ScreenWidth - [Common calculateNewSizeBaseMachine:320]) / 2,CGRectGetMaxY(self.indecator.frame) + 30, [Common calculateNewSizeBaseMachine:320], [Common calculateNewSizeBaseMachine:320])];
        _lockView.useFrame = YES;
    }
    return _lockView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

}

/**
 跳过按钮点击事件

 @param button 跳过按钮
 */
- (void)dealWithrunBtn:(UIButton *)button
{
    
}

@end
