//
//  Toast.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/9.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "Toast.h"

@implementation Toast
/*
找到的一个简单办法：hud.userInteractionEnabled = NO;
也就是关闭hud的用户交互即可。这样就不会影响hud所在的父视图的用户交互了。

//单例方法
+ (MBProgressHUD *)sharedManager
{
    static dispatch_once_t onceToken ;
    static MBProgressHUD *hud = nil;
    dispatch_once(&onceToken, ^{
        hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        hud.userInteractionEnabled = NO;// 防止HUD阻塞用户交互 fy2016年07月27日16:52:35
        isAddHud = NO;
    }) ;
    return hud;
}
 
 
 
 
 MBProgressHUD *hud;
 //有文本
 hud = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
 hud.userInteractionEnabled = YES;
 hud.label.text = waitString;
 hud.removeFromSuperViewOnHide = YES;
 
 //无文本
 hud = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
 hud.userInteractionEnabled = YES;
 hud.removeFromSuperViewOnHide = YES;
 
 如果网络状况不好或者服务器反应延迟，那么MBProgressHUD显示的提示信息会一直停留在界面上并且影响父视图的用户交互。
 如何在显示提示信息的同时还能继续交互呢？
 
 找到的一个简单办法：hud.userInteractionEnabled = NO;
 也就是关闭hud的用户交互即可。这样就不会影响hud所在的父视图的用户交互了。 
 
 因为某些原因调用MBProgressHUD的时候没注意不在主线成，导致程序总崩溃在MBProgressHUD的这一句
 NSAssert([NSThread isMainThread], @"MBProgressHUD needs to be accessed on the main thread.");
 
 
 
 [NSThread isMainThread]的意思是判断是否在主线程。
 
 NSAssert：是指在开发期间使用的、让程序在运行时进行自检的代码（通常是一个子程序或宏）。断言为真，则表明程序运行正常，而断言为假，则意味着它已经在代码中发现了意料之外的错误。断言对于大型的复杂程序或可靠性要求极高的程序来说尤其有用。
 
 MBProgressHUD needs to be accessed on the main thread 是说必须在主线程中使用MBProgressHUD
 
 很多人经常会忽略这个问题直接注释掉这段demo，同时会发现多出奇奇怪怪的问题。也有很多小白不知所措，个人认为可以主动切换回主线程操作，
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
//回到主线线程

});
直接避免许多麻烦


 MBP的用法：
 
 1、
 
 // 使用MBProgressHUD最重要的准则是当要执行一个耗时任务时,不能放在主线程上影响UI的刷新
 // 正确地使用方式是在主线程上创建MBProgressHUD,然后在子线程上执行耗时操作,执行完再在主线程上刷新UI
 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
 // Do something...
 dispatch_async(dispatch_get_main_queue(), ^{
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 });
 });
 
 2、
 
 UI的更新应当总是在主线程上完成的,一些MBProgressHUD 上的属性的setter方法考虑到了线程安全,可以被后台线程安全地调用.这些setter包括setMode:, setCustomView:, setLabelText:, setLabelFont:, setDetailsLabelText:, setDetailsLabelFont: 和 setProgress:.
 
 如果你需要在主线程上执行一个耗时的操作,你需要在执行前稍微延时一下,以使得在阻塞主线程之前,UIKit有足够的时间去更新UI(即绘制HUD).
 
 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 // 如果上面那句话之后就要在主线程执行一个长时间操作,那么要先延时一下让HUD先画好
 // 不然在执行任务前没画出来就显示不出来了
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 // Do something...
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 });
 MBP处理耗时操作的时候要放在主线程中处理，否则会crash。
 
 */
@end
