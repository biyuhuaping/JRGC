//
//  MPPwdTextField.h
//  UcfPaySDK
//
//  Created by vinn on 6/18/14.
//  Copyright (c) 2014 UCF. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  kUcfPwdMaxLength        6

typedef void (^UcfPwdTextChangedBlock)(NSString *pwd);

@protocol UcfPwdTextFieldDelegate <NSObject>

- (void)mpTextFieldTextChanged:(NSString *)pwd;

@end

@interface UcfPwdTextField : UIView

@property(nonatomic, copy) UcfPwdTextChangedBlock textChangeBlock;
@property(nonatomic, assign) id<UcfPwdTextFieldDelegate> delegate;

- (void)clearInput;
- (void)pwdFieldBecomeFirstResponder;
- (void)pwdFieldResignFirstResponder;

- (void)setTextFieldInputAccessView:(UIView *)accView;

@end
