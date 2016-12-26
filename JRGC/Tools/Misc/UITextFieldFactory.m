//
//  UITextFieldFactory.m
//  

#import "UITextFieldFactory.h"

@implementation UITextFieldFactory

+ (UITextField *)getTextFieldObjectWithFrame:(CGRect)frame
                                    delegate:(id<UITextFieldDelegate>)delegate
                                 placeholder:(NSString *)placeholder
                               returnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    textField.returnKeyType = returnKeyType;
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.delegate = delegate;
    return textField;
}

@end
