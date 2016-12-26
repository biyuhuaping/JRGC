//
//  UCFRegisterTwoView.h
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterTwoViewDelegate <NSObject>

- (void)codeBtnClicked:(id)sender;

- (void)submitBtnClicked:(id)sender;

- (void)soudLabelClick:(UITapGestureRecognizer*)tap;

@end

@interface UCFRegisterTwoView : UIView<UITextFieldDelegate>


@property(nonatomic,weak) id<RegisterTwoViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame phoneNumber:(NSString*)number;
- (NSString*)getVerficationCode;
- (NSString*)getUserName;
- (NSString*)getPassword;
- (NSString*)getRefereesCode;

- (void)setVatifacationBtnVisible:(BOOL)isVisible;
- (void)setVatifacationTitle:(NSString*)str;
- (void)setVerifiFieldFirstReponder;
- (void)setVatiLabelHide:(BOOL)isHide;
- (void)showVatiLabelText;
- (void)resetAllControlFrame;

@end
