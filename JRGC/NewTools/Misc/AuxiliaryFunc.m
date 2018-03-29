//
//  AuxiliaryFunc.m
//

#import "AuxiliaryFunc.h"
#import "NSDateManager.h"
#import "MBProgressHUD.h"

@implementation AuxiliaryFunc

+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message
{
    return [AuxiliaryFunc showAlertViewWithMessage:message delegate:nil];
}

+ (void)showToastMessage:(NSString *)message withView:(UIView *)view {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:2.0f];
}


+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message delegate:(id <UIAlertViewDelegate>) delegate
{
    if (message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [NSTimer scheduledTimerWithTimeInterval:55.0f target:self selector:@selector(performDismiss:) userInfo:alertView repeats:NO];
        [alertView show];
        return alertView;
    }
    return nil;
}

+ (UIAlertView *)showReEnterAlertViewWithMessage:(NSString *)message delegate:(id <UIAlertViewDelegate>) delegate
{
    if (message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:delegate cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [NSTimer scheduledTimerWithTimeInterval:55.0f target:self selector:@selector(performDismiss:) userInfo:alertView repeats:NO];
        [alertView show];
        return alertView;
    }
    return nil;
}

+ (UIAlertView *)showAlertViewdelegate:(id <UIAlertViewDelegate>) delegate
{
    return nil;
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您今天还没有签到哦!" message:@"投资多多！好礼送不停！\n签到就有机会抽到红包哦！" delegate:delegate cancelButtonTitle:@"给钱也不想" otherButtonTitles:@"立即签到", nil];
//    [alertView show];
//    [NSTimer scheduledTimerWithTimeInterval:55.0f target:self selector:@selector(performDismiss:) userInfo:alertView repeats:NO];
//    return alertView;
}
+ (void) performDismiss:(NSTimer *)timer
{
    UIAlertView *alert = [timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

+ (void)moveViewToDisplay:(UIView *)view scrollView:(UIScrollView *)scrollView
{
    CGPoint point = [view convertPoint:CGPointMake(0.0f, view.frame.size.height) toView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat yOff = point.y - 200.0f;
    if (yOff > 0) {
        [scrollView setContentOffset:CGPointMake(0.0f, scrollView.contentOffset.y + yOff) animated:YES];
    }
}


+ (NSString *)convertToDBString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"\'" withString:@"\'\'"];
}

//去除字符串中的转义符
+ (NSString*)deleteZhuanYiFu:(NSMutableString*)str
{
    NSString *character = nil;
    for (int i = 0; i < str.length; i ++) {
        character = [str substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"]) {
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    return str;
}

//去除字符串中的换行符
+ (NSString*)deleteHuanHang:(NSMutableString*)str
{
    NSString *character = nil;
    for (int i = 0; i < str.length; i ++) {
        character = [str substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\n"]) {
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    return str;
}

+ (UIEdgeInsets)getResizableImageEdgeInsetsWithImage:(UIImage *)image
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (image) {
        CGFloat edgeInsetsH = image.size.width / 2 - 1;
        CGFloat edgeInsetsV = image.size.height / 2 - 1;
        edgeInsets = UIEdgeInsetsMake(edgeInsetsV, edgeInsetsH, edgeInsetsV, edgeInsetsH);
    }
    return edgeInsets;
}

@end
