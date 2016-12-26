//
//  BaseAlertView.m
//  SXZH
//
//  Created by JasonWong on 13-12-24.
//  Copyright (c) 2013年 www.sxzhuanhuan.com. All rights reserved.
//

#import "BaseAlertView.h"
#import "Common.h"

static BaseAlertView *alertView = nil;

@implementation BaseAlertView

@synthesize timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self.layer respondsToSelector:@selector(setCornerRadius:)]) {
            [self.layer setCornerRadius:10];
        }
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        alertLabel.numberOfLines = 0;
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [self addSubview:alertLabel];
        self.hidden = YES;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    return self;
}

- (void)dealloc
{
    [alertLabel release];
    alertLabel = nil;
    [super dealloc];
}

+ (BaseAlertView *)getShareBaseAlertView
{
    if (alertView == nil) {
        CGRect frame = CGRectMake(40,StatusBarHeight+NavigationBarHeight+5, ScreenWidth-80, 60);
        alertView = [[self alloc] initWithFrame:frame];
    }
    return alertView;
}

- (void)showString:(NSString *)string
{
    if (string == nil) {
        return;
    }
    alertLabel.text = string;
    CGSize size = [Common getStrHeightWithStr:string AndStrFont:13.0f AndWidth:CGRectGetWidth(alertLabel.frame)];
    if (size.height > 30) {
        alertLabel.frame = CGRectMake(CGRectGetMinX(alertLabel.frame), CGRectGetMinY(alertLabel.frame), CGRectGetWidth(alertLabel.frame), size.height);
        self.frame = CGRectMake(20,StatusBarHeight+NavigationBarHeight+5, ScreenWidth-40, size.height);
    }else{
        self.frame = CGRectMake(20,StatusBarHeight+NavigationBarHeight+5, ScreenWidth-40, 30);
        alertLabel.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    self.hidden = NO;
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
    if (self.timer) {
        [timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeSelf) userInfo:nil repeats:NO];
}

- (void)showStringOnTop:(NSString *)string{
    if (string == nil) {
        return;
    }
    alertView.frame = CGRectMake(40.0, StatusBarHeight, ScreenWidth-80.0, 60.0);
    alertLabel.text = string;
    self.hidden = NO;
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
    if (self.timer) {
        [timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeSelf) userInfo:nil repeats:NO];
}

- (void)removeSelf
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = kCATransitionFade;
    self.hidden = YES;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
}

@end
