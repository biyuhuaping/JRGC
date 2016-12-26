//
//  UIButton+Misc.h
//  

#import <UIKit/UIKit.h>

@interface UIButton (Misc)

+ (UIButton *)getAButtonWithFrame:(CGRect)frame nomalTitle:(NSString *)title1 hlTitle:(NSString *)title2 titleColor:(UIColor *)tColor bgColor:(UIColor *)BgColor nbgImage:(NSString *)image1 hbgImage:(NSString *)image2 action:(SEL)selector target:(id)delegate buttonTpye:(UIButtonType)theButtonTpye;

/*
 normalImage参数不能为空.
 */
+ (UIButton *)buttonWithTarget:(id)target
                        origin:(CGPoint)origin
                   normalBgImage:(UIImage *)normalImage
              highLightedBgImage:(UIImage *)highLightedImage
                 disabledBgImage:(UIImage *)disabledImage
                 selectedImage:(UIImage *)selectedImage
                      selector:(SEL)selector;

/*
 函数内部调用:[self buttonWithTarget:target
                            origin:origin
                       normalImage:normalImage
                  highLightedImage:nil
                     disabledImage:nil
                     selectedImage:nil
                          selector:selector];
 */
+ (UIButton *)buttonWithTarget:(id)target
                        origin:(CGPoint)origin
                   normalImage:(UIImage *)normalImage
                      selector:(SEL)selector;

@end
