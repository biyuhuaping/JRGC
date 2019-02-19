//
//  HUDManager.h
//
//  Created by biyuhuaping on 2016/11/8.
//  Copyright © 2018年 zhoubo. All rights reserved.
//

#import "HUDManager.h"

#import "MBProgressHUD.h"

@interface HUDManager ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HUDManager

+ (instancetype)manager{
    static HUDManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HUDManager alloc] init];
    });
    return manager;
}

- (void)showHUDWithView:(UIView *)view{
//    如果你需要在主线程上执行一个耗时的操作,你需要在执行前稍微延时一下,以使得在阻塞主线程之前,UIKit有足够的时间去更新UI(即绘制HUD).
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 如果上面那句话之后就要在主线程执行一个长时间操作,那么要先延时一下让HUD先画好
    // 不然在执行任务前没画出来就显示不出来了
    
        // Do something...
//       self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//       self.hud.removeFromSuperViewOnHide = YES;
        [self hide] ;
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        self.hud = [[MBProgressHUD alloc] initWithView:view ];
//
//
//        //修改样式，否则等待框背景色将为半透明
//
//        self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//
//        self.hud.yOffset =  -1 *PGStatusBarHeight -44 ;
//        //设置等待框背景色为黑色
//
//        self.hud.bezelView.backgroundColor = [UIColor blackColor];
//
//        self.hud.removeFromSuperViewOnHide = YES;
//
//        //设置菊花框为白色
//
//        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//        [view addSubview:self.hud];
//
//        [self.hud showAnimated:YES];
        if (nil == view.window) {
            UIWindow *windows = [self topUseableWindow];
            self.hud = [MBProgressHUD showHUDAddedTo:windows animated:YES];

        }
        else
        {
            self.hud = [MBProgressHUD showHUDAddedTo:view.window animated:YES];
        }
//        self.hud = [MBProgressHUD showHUDAddedTo:[self topUseableWindow] animated:YES];
//        self.hud.mode = MBProgressHUDModeCustomView;
//        UIImageView *cusImageV = [[UIImageView alloc] init];
        
//        NSMutableArray * arrOrigin = [NSMutableArray array];
//        for (int i = 1; i<= 35; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_bg%zd", i]];
//            [arrOrigin addObject:image];
//        }
////        self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
////        self.hud.bezelView.color = [UIColor clearColor];
//         self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//
//         self.hud.bezelView.color = [UIColor clearColor];
//
//         self.hud.bezelView.alpha = 0;
////        self.hud.bezelView.alpha = 0.6;
//        [cusImageV setAnimationImages:arrOrigin];
//        [cusImageV setAnimationDuration:1];
//        [cusImageV setAnimationRepeatCount:0];
//        [cusImageV startAnimating];
//
//        self.hud.customView = cusImageV;
//        self.hud.customView.backgroundColor =[UIColor clearColor];
//        self.hud.backgroundColor = [Color colorWithHexString:@"#000000" withAlpha:0.8];
//        self.hud.animationType = MBProgressHUDAnimationFade;
//        [self.hud showAnimated:YES];
        
    });
    
//        找到的一个简单办法：hud.userInteractionEnabled = NO;
//        也就是关闭hud的用户交互即可。这样就不会影响hud所在的父视图的用户交互了
  
    
//  异步执行任务，一般用不到dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // Do something...
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//    });
}
- (UIWindow*)topUseableWindow{
    
    NSArray *windows = [[UIApplication sharedApplication]windows];
    
    __block UIWindow*window =nil;
    
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //键盘的window,键盘退出就不存在了，不可使用
        
        if(obj && ![obj isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            
            window = obj;
            
            *stop =YES;
            
        }
    }];
  
    
    return window;
    
}

- (void)showHudWithText:(NSString *)text{
    
    if(text && text.length >0)
    {
        if ([NSThread isMainThread])
        {
            [self createHudWithString:text];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线线程
                [self createHudWithString:text];
                
            });
        }
    }
}
- (void)createHudWithString:(NSString *)text
{
    if (![text isKindOfClass:[NSString class]]) {
        return;
    }
    
    MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:[self window] animated:YES];
    textHud.detailsLabelText = text;
    textHud.mode = MBProgressHUDModeText;
    textHud.color = [UIColor blackColor];
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
//    textHud.yOffset =   (PGStatusBarHeight + 44) / 2 - PGScreenHeight/2 +44 ;
//    textHud.xOffset = 0.0f;
    textHud.removeFromSuperViewOnHide = YES;
//    textHud.detailsLabelColor = [Color color:PGColorOptionThemeWhite];
    textHud.detailsLabelFont = [UIFont systemFontOfSize:TOASTFont];
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 36) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TOASTFont]} context:nil];
//    //11，背景框的最小大小
//    textHud.minSize = CGSizeMake(rect.size.width+40, 40);
    textHud.margin = 20;//设置各个元素距离矩形边框的距离，可以根据这个设置提示框的大小
    //15,设置最短显示时间，为了避免显示后立刻被隐藏   默认是0
    textHud.minShowTime = 1;
    [textHud hide:YES afterDelay:1.5];
}
-(UIWindow *)window{
//    显示NSAssert(view, @"View must not be nil.")错误提示
    return [UIApplication sharedApplication].keyWindow;
}
- (void)hide{
   
    if ([NSThread isMainThread])
    {
        [self hideHud];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线线程
            [self hideHud];
            
        });
    }
   
}
- (void)hideHud
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.hud hide:YES];
        self.hud = nil;
  });
    
}

@end
