//
//  Macro.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#pragma mark - 屏幕适配

#define PGScreenWidth           [[UIScreen mainScreen] bounds].size.width
#define PGScreenHeight          [[UIScreen mainScreen] bounds].size.height
#define PGWidthFactor           [[UIScreen mainScreen] bounds].size.width / 750  //宽度缩放系数
#define PGHeightFactor          [[UIScreen mainScreen] bounds].size.height / 1334//高度缩放系数
#define PGBannerHeightFactor    [[UIScreen mainScreen] bounds].size.width *(400.0f/750.0)//banner缩放比

#define PGStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏的高度
#define TOASTFont 15

#pragma mark - 系统版本定义

//获取手机系统的版本

#define PGSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//是否为iOS7及以上系统

#define PGiOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//是否为iOS8及以上系统

#define PGiOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

//是否为iOS9及以上系统

#define PGiOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

//是否为iOS10及以上系统

#define PGiOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

//是否为iOS11及以上系统

#define PGiOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)


//适配ios11
#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

#define  SingShare [Singleton shareInstance]

//定义UIImage对象

#define PGImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#pragma mark - HUD
#define ShowMessage(Msg) [[HUDManager manager] showHudWithText:Msg]
#define ShowHUD(view) [[HUDManager manager] showHUDWithView:view]
#define HideHUD(view) [[HUDManager manager] hide]

#pragma mark - weekSelf
//@PGWeakObj(self);
//@PGStrongObj(self);
#define PGWeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define PGStrongObj(o) try{}@finally{} __strong typeof(o) o = o##Weak;

#define COUNTDOWNRESMS  @"registeredSMS" //注册短信的倒计时
#define COUNTDOWNREVMS  @"registeredVMS" //注册语音的倒计时
#endif /* Macro_h */
