//
//  UITextFieldFactory.h
//  

#import <Foundation/Foundation.h>

@interface UITextFieldFactory : NSObject

+ (UITextField *)getTextFieldObjectWithFrame:(CGRect)frame
                                    delegate:(id<UITextFieldDelegate>)delegate
                                 placeholder:(NSString *)placeholder
                               returnKeyType:(UIReturnKeyType)returnKeyType;

@end
