//
//  MPTextField.h
//  UcfPaySDK
//
//  Created by vinn on 5/19/14.
//  Copyright (c) 2014 UCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+UcfLib.h"

@class UcfTextField;

@protocol UcfTextFieldDelegate <NSObject>

@optional
-(void)mpTextFieldTextChanged:(UcfTextField *)textField withText:(NSString *)text;

@end

@interface UcfTextField : UITextField

@property(nonatomic) NSInteger charsLimit;
@property(nonatomic) BOOL useBankCodeFormat;
@property(nonatomic, assign) id<UcfTextFieldDelegate> mpTextFieldDelegate;

- (void)setHeaderImage:(UIImage *)headerImage headerWidth:(CGFloat)width;
- (void)setLeftPadding:(CGFloat)padding;
- (void)setRightPadding:(CGFloat)padding;
- (void)textFieldShake;

- (NSString *)normalizedText;

@end
