//
//  AuxiliaryFunc.h
//  
#import <Foundation/Foundation.h>

@interface AuxiliaryFunc : NSObject

+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message;
+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message delegate:(id <UIAlertViewDelegate>) delegate;
+ (UIAlertView *)showReEnterAlertViewWithMessage:(NSString *)message delegate:(id <UIAlertViewDelegate>) delegate;
+ (void)moveViewToDisplay:(UIView *)view scrollView:(UIScrollView *)scrollView;
+ (NSString*)convertToDBString:(NSString*) str;
+ (NSString*)deleteZhuanYiFu:(NSMutableString*)str;
+ (NSString*)deleteHuanHang:(NSMutableString*)str;
+ (UIEdgeInsets)getResizableImageEdgeInsetsWithImage:(UIImage *)image;
+ (void)showToastMessage:(NSString *)message withView:(UIView *)view;
+ (UIAlertView *)showAlertViewdelegate:(id <UIAlertViewDelegate>) delegate;
@end
