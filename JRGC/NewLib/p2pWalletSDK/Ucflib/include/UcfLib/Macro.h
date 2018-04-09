//
//  Macro.h
//  UcfWallet
//
//  Created by 杨名宇 on 5/24/16.
//  Copyright © 2016 UcfPay. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define IOS10_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS6_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define RGBA(R,G,B, A)   [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define APP_DELEGATE (AppDelegate*)[[UIApplication sharedApplication]delegate]
#define APPLICATIONFRAME [[UIScreen mainScreen]bounds]//程序可用窗口frame（不含状态栏）
#define SCREEN_WIDTH APPLICATIONFRAME.size.width //屏幕宽度
#define SCREEN_HEIGHT APPLICATIONFRAME.size.height //屏幕高度

#define PROPERTY_ASSIGN     @property(nonatomic,assign)
#define PROPERTY_STRONG     @property(nonatomic,strong)
#define PROPERTY_WEAK       @property(nonatomic,weak)
#define PROPERTY_COPY       @property(nonatomic,copy)

#define UCF_AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	UCF_DEF_SINGLETON
#define UCF_DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#define LISTEN(Edelegate,Eselector,EnotifyName,Eobject) [[NSNotificationCenter defaultCenter]addObserver:Edelegate selector:Eselector name:EnotifyName object:Eobject]
#define UNLISTEN(Edelegate,EnotifyName,Eobject) [[NSNotificationCenter defaultCenter]removeObserver:Edelegate name:EnotifyName object:Eobject]
#define TRIGGER(EnotifyName,Eobject) [[NSNotificationCenter defaultCenter]postNotificationName:EnotifyName object:Eobject]

#if DEBUG
#define NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define NSLog(format, ...)
#endif

#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#import "UcfAlertManager.h"

#define ShowLoading     [[UcfAlertManager sharedInstance] showLoadingWithMsg:@""]
#define ShowLoadingInView(view)     [[UcfAlertManager sharedInstance] showLoadingInView:view]
#define HideLoading     [[UcfAlertManager sharedInstance] hideHud]
#define ShowHud(Msg)    [[UcfAlertManager sharedInstance] showHud:Msg]
#define ShowAlert(Msg)  [[UcfAlertManager sharedInstance] showAlert:Msg]

#endif /* Macro_h */
