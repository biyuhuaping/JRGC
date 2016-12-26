//
//  UIButton+Misc.m
//  

#import "UIButton+Misc.h"

@implementation UIButton (Misc)

+ (UIButton *)getAButtonWithFrame:(CGRect)frame nomalTitle:(NSString *)title1 hlTitle:(NSString *)title2 titleColor:(UIColor *)tColor bgColor:(UIColor *)BgColor nbgImage:(NSString *)image1 hbgImage:(NSString *)image2 action:(SEL)selector target:(id)delegate buttonTpye:(UIButtonType)theButtonTpye
{
    UIButton *button = nil;
    if (theButtonTpye) {
        button = [UIButton buttonWithType:theButtonTpye];
        
    }else{
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    button.frame = frame;
    if (title1) {[button setTitle:title1 forState:UIControlStateNormal];}
    if (title2) {[button setTitle:title1 forState:UIControlStateHighlighted];}
    if (tColor) {
        [button setTitleColor:tColor forState:UIControlStateNormal];
    }
    
    if (BgColor) {
        [button setBackgroundColor:BgColor];
    }
    
    if (image1) {[button setBackgroundImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];}
    if (image2) {[button setBackgroundImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];}
    if (delegate && selector) {
        [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
    
}

+ (UIButton *)buttonWithTarget:(id)target
                        origin:(CGPoint)origin
                   normalBgImage:(UIImage *)normalImage
              highLightedBgImage:(UIImage *)highLightedImage
                 disabledBgImage:(UIImage *)disabledImage
                 selectedImage:(UIImage *)selectedImage
                      selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(origin.x, origin.y, normalImage.size.width, normalImage.size.height);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setExclusiveTouch:YES];
    if (highLightedImage) {
        [button setBackgroundImage:highLightedImage forState:UIControlStateHighlighted];
    }
    if (disabledImage) {
        [button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    }
    if (selectedImage) {
        [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    }
    [button addTarget:target
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)buttonWithTarget:(id)target
                        origin:(CGPoint)origin
                   normalImage:(UIImage *)normalImage
                      selector:(SEL)selector
{
    return [self buttonWithTarget:target
                           origin:origin
                      normalBgImage:normalImage
                 highLightedBgImage:nil
                    disabledBgImage:nil
                    selectedImage:nil
                         selector:selector];
}



@end
