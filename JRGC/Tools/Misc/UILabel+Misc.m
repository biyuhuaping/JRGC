//
//  UILabel+Misc.m
//  

#import "UILabel+Misc.h"

@implementation UILabel (Misc)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    if (textColor) {
        label.textColor = textColor;
    }
    if (font) {
        label.font = font;
    }
    label.numberOfLines = 0;
    //[label sizeToFit];
    return label;
}

@end
