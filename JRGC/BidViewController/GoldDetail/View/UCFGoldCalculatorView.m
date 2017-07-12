//
//  UCFGoldCalculatorView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCalculatorView.h"

@interface UCFGoldCalculatorView ()

@end

@implementation UCFGoldCalculatorView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    NSLog(@" initWithCoder =====> 执行了");
    if (self) {
        self.calculatorView.layer.masksToBounds = YES;
        self.calculatorView.layer.cornerRadius = 4;
        UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
        [self addGestureRecognizer:frade];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
#endif

    }
    return self;
}
#pragma ----
/**
 *  键盘抬起和消失，调整收益框位置
 *
 *  @param notification 键盘通知包体
 */
- (void)calculatorKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)calculatorKeyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}
/**
 *  调整收益框位置
 *
 *  @param height 键盘高度
 *  @param time   键盘弹起动画时间
 */
-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)time
{
    UIView *baseView = [self viewWithTag:999];
    if (height == 0) {
        baseView.center = self.center;
    } else {
        CGFloat bottomEdgeSpace = ScreenHeight - CGRectGetMaxY(baseView.frame);
        if (bottomEdgeSpace < height) {
            //计算器视图不可以完全显示
            baseView.frame = CGRectMake(CGRectGetMinX(baseView.frame), CGRectGetMinY(baseView.frame) - (height - bottomEdgeSpace) , CGRectGetWidth(baseView.frame), CGRectGetHeight(baseView.frame));
        } else {
            //计算器视图可以完全显示
        }
    }
    
}
/**
 *  收起键盘
 */
- (void)fadeKeyboard
{
    [self.goldMoneyTextField resignFirstResponder];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@" awakeFromNib =====> 执行了");
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.calculatorView.layer.masksToBounds = YES;
    self.calculatorView.layer.cornerRadius = 4;
    NSLog(@" layoutSubviews =====> 执行了");
    NSLog(@"此时view的frame====》 %@",NSStringFromCGRect(self.frame));
    
}
- (void)removeBtn{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeView:(id)sender {
    
     [self removeFromSuperview];
}
@end
