//
//  UILabel+Misc.h
//  

#import <UIKit/UIKit.h>

@interface UILabel (Misc)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font;

@end
