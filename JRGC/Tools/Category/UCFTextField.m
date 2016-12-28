//
//  UCFTextField.m
//  testfileView
//
//  Created by 战神归来 on 15/8/18.
//  Copyright (c) 2015年 xiangha. All rights reserved.
//

#import "UCFTextField.h"
#define keyBoardHeight 37.0f
#define FinshButtonWidth 53.0f
#define FinshButtonHeight 26.0f
@interface UCFTextField()
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIView    *view;
@property (nonatomic, strong) UIView    *bkView;
@end

@implementation UCFTextField

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)createKeyBoard
{
    self.view = self.superview;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self createKeyBoardView];
    
}
- (void)createKeyBoardView
{
    self.bkView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, keyBoardHeight)];
//    self.bkView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bkView];
    
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    linView.backgroundColor = [UIColor colorWithRed:227.0f / 255.0f green:229.0f / 255.0f blue:234.0f / 255.0f alpha:1.0];
    [self.bkView addSubview:linView];
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect exitBtFrame = CGRectMake(self.bkView.frame.size.width-FinshButtonWidth -5, (self.bkView.frame.size.height - FinshButtonHeight)/2 , FinshButtonWidth, FinshButtonHeight);
    [_exitButton setTitle:@"完成" forState:UIControlStateNormal];
    [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _exitButton.backgroundColor = [UIColor colorWithRed:130.0f / 255.0f green:150.0f / 255.0f blue:175.0f / 255.0f alpha:1.0];
    [_exitButton setFrame:exitBtFrame];
    _exitButton.layer.masksToBounds=YES;
    _exitButton.layer.cornerRadius=_exitButton.frame.size.height /10;
    [self.bkView addSubview:_exitButton];
}
- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSDictionary *info = [notification userInfo];
    NSLog(@"-->info:%@",info);
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSValue *animationDurValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    //    copy value
    [animationDurValue getValue:&animationDuration];
    
    [UIView animateWithDuration:0.25f animations:^{
        CGFloat distanceToMove = kbSize.height;
        NSLog(@"---->动态键盘高度:%f",distanceToMove);
        [self adjustPanelsWithKeyBordHeight:distanceToMove];
        
    }];
    
    _bkView.hidden=NO;
    [_exitButton addTarget:self action:@selector(CancelBackKeyboard:) forControlEvents:UIControlEventTouchDown];
    
    
}
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    NSValue *animationDurValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    //   把animationDurvalue 值拷贝到animationDuration中
    [animationDurValue getValue:&animationDuration];
    
//    [UIView beginAnimations:@"animal" context:nil];
//    [UIView setAnimationDuration:animationDuration];
    
//    if (_exitButton) {
//        
//        CGRect exitBtFrame = CGRectMake(self.view.frame.size.width - 48, self.view.frame.size.height, 48.0f, 30.0f);
//        _exitButton.frame = exitBtFrame;
//        [self.view addSubview:_exitButton];
//        
//    }
//    if (_bkView) {
//        
//        CGRect bkViewFrame = CGRectMake(0, self.view.frame.size.height,[[UIScreen mainScreen] bounds].size.width, keyBoardHeight);
//        _bkView.frame = bkViewFrame;
//        [self.view addSubview:_bkView];
//        
//    }
//    [UIView commitAnimations];
    
    
    [UIView animateWithDuration:0.25f animations:^{
        if (_bkView) {
            
            CGRect bkViewFrame = CGRectMake(0, self.view.frame.size.height,[[UIScreen mainScreen] bounds].size.width, keyBoardHeight);
            _bkView.frame = bkViewFrame;
            [self.view addSubview:_bkView];
        }
    }];
    
    
}
-(void)adjustPanelsWithKeyBordHeight:(float) height
{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
//    if (_exitButton) {
//        
//        CGRect exitBtFrame = CGRectMake(self.view.frame.size.width - 48, self.view.frame.size.height - height-30, 48.0f, 30.0f);
//        _exitButton.frame = exitBtFrame;
//        
//        [self.view addSubview:_exitButton];
//    }
    if (_bkView) {
        
        CGRect bkViewFrame = CGRectMake(0, self.view.frame.size.height - height-keyBoardHeight,[[UIScreen mainScreen] bounds].size.width, keyBoardHeight);
        _bkView.frame = bkViewFrame;
        [self.view addSubview:_bkView];
        
    }

    
}
-(void)CancelBackKeyboard:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UCFTextField *uc in [self.superview subviews]) {
        [uc resignFirstResponder];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
