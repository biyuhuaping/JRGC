//
//  UILabel+Misc.h
//  

#import <UIKit/UIKit.h>

@interface UILabel (Misc)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font;

- (void)setBoldFontToRange:(NSRange)range;
- (void)setBoldFontToString:(NSString *)string;

- (void)setFontColor:(UIColor *)color range:(NSRange)range;
- (void)setFontColor:(UIColor *)color string:(NSString *)string;

- (void)setFont:(UIFont *)font range:(NSRange)range;
- (void)setFont:(UIFont *)font string:(NSString *)string;

/**
 设置行间距

 @param space 行间距
 @param string 文本
 */
- (void)setLineSpace:(CGFloat)space string:(NSString *)string;
@end
