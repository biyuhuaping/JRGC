//
//  UCFPublicPopupWindow.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPublicPopupWindow.h"
#import "UIView+TYAlertView.h"
// if you want blur efffect contain this
#import "TYAlertController+BlurEffects.h"
#import "BaseNavigationViewController.h"
#import "UCFPublicPopupWindowView.h"
@interface UCFPublicPopupWindow()<PublicPopupWindowViewDelegate>

@property (nonatomic, strong) UCFPublicPopupWindowView *fir ;

@end

@implementation UCFPublicPopupWindow

+ (UCFPublicPopupWindow *)sharedManager
{
    static UCFPublicPopupWindow *popWindow = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        popWindow = [[self alloc] init];
        
    });
    return popWindow;
}
- (instancetype)init
{
    if (self =[super init]) {
    }
    return self;
}

- (void)showPopViewInController:(UIViewController *__nonnull)controller andType:(POPWINDOWS)type
{
    [self showPopViewInController:controller andType:type withContent:nil withTitle:nil];
}

- (void)showPopViewInController:(UIViewController *__nonnull)controller andType:(POPWINDOWS)type withContent:(NSString *__nonnull)contentStr
{
    [self showPopViewInController:controller andType:type withContent:contentStr withTitle:nil];
}

- (void)showPopViewInController:(UIViewController *__nonnull)controller andType:(POPWINDOWS)type withContent:(NSString *__nonnull)contentStr withTitle:(NSString *__nonnull)titleStr//带标题和内容的弹窗
{
    if (self.isPopShow) {
        return;
    }
    else
    {
        self.isPopShow = !self.isPopShow;
        if (!contentStr) {
            self.fir = [[UCFPublicPopupWindowView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, PGScreenHeight) withType:type];
        }
        else
        {
            
            if (!titleStr) {
                self.fir = [[UCFPublicPopupWindowView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, PGScreenHeight) withType:type withContent:contentStr];
            }
            else
            {
                 self.fir = [[UCFPublicPopupWindowView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, PGScreenHeight) withType:type withContent:contentStr withTitle:titleStr];
            }
        }
        
        // use UIView Category
        self.fir.delegate = self;
        [self.fir.enterButton addTarget:self action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.fir.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.fir.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        if (controller == nil || ![controller isKindOfClass:[UIViewController class]]) {
            [self.fir showInWindow];
        }
        else{
            [self.fir showInController:controller ];
        }
    }
}

- (void)popClickCloseBackgroundView
{
    [self closePopupWindowView];
}
- (void)enterButtonClick
{
    [self closePopupWindowView];
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([self.delegate respondsToSelector:@selector(popEnterClick)]) {
        
        [self.delegate popEnterClick];
    }
}
- (void)cancelButtonClick
{
    [self closePopupWindowView];
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([self.delegate respondsToSelector:@selector(popCancelClick)]) {
        
        
        [self.delegate popCancelClick];
    }
}
- (void)closeButtonClick
{
     [self closePopupWindowView];
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([self.delegate respondsToSelector:@selector(popCloseClick)]) {
        
       
        [self.delegate popCloseClick];
    }
}

- (void)closePopupWindowView
{
    if (self.isPopShow) {
        //当前有弹窗
        [self clearPopupWindowView];
    }
}

- (void)clearPopupWindowView
{
    self.isPopShow = NO;
    if (self.fir) {
        [self.fir hideView];
        self.fir.delegate = nil;
        if ([self.fir superview]) {
            [self.fir removeFromSuperview];
        }
        self.fir = nil;
    }
}
@end
