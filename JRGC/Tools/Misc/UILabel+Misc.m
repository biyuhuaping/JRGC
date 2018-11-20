//
//  UILabel+Misc.m
//  

#import "UILabel+Misc.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
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

static inline CGFloat ZBFlushFactorForTextAlignment(NSTextAlignment textAlignment) {
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            return 0.5f;
        case NSTextAlignmentRight:
            return 1.0f;
        case NSTextAlignmentLeft:
        default:
            return 0.0f;
    }
}

#pragma mark - Public methods
- (void)setBoldFontToRange:(NSRange)range
{
    NSString *fontNameBold = [NSString stringWithFormat:@"%@-Bold", [[self.font familyName] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    if (![UIFont fontWithName:fontNameBold size:self.font.pointSize]) {
#ifdef NZDEBUG
        NSLog(@"%s: Font not found: %@", __PRETTY_FUNCTION__, fontNameBold);
#endif
        return;
    }
    
    UIFont *font = [UIFont fontWithName:fontNameBold size:self.font.pointSize];
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributed addAttribute:NSFontAttributeName value:font range:range];
    
    self.attributedText = attributed;
}

- (void)setBoldFontToString:(NSString *)string
{
    NSRange range = [self.text rangeOfString:string];
    [self setBoldFontToRange:range];
}

- (void)setFontColor:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributed addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.attributedText = attributed;
}

- (void)setFontColor:(UIColor *)color string:(NSString *)string
{
    NSRange range = [self.text rangeOfString:string];
    [self setFontColor:color range:range];
}

- (void)setFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributed addAttribute:NSFontAttributeName value:font range:range];
    
    self.attributedText = attributed;
}

- (void)setFont:(UIFont *)font string:(NSString *)string
{
    NSRange range = [self.text rangeOfString:string];
    [self setFont:font range:range];
}
- (void)setLineSpace:(CGFloat)space string:(NSString *)string
{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [self setAttributedText:attributedString1];
    [self sizeToFit];
}
@end
