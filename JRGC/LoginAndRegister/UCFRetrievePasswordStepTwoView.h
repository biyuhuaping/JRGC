//
//  UCFRetrievePasswordStepTwoView.h
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RetrieveStepTwoDelegate <NSObject>

- (void)submitBtnClicked:(id)sender;

- (void)codeBtnClicked:(id)sender;

- (void)soudLabelClick:(UITapGestureRecognizer*)tap nowTime:(int)tm;

@end

@interface UCFRetrievePasswordStepTwoView : UIView<UITextFieldDelegate>


@property(nonatomic,weak) id<RetrieveStepTwoDelegate>delegate;
@property(nonatomic,retain) NSTimer *timer;

- (id)initWithFrame:(CGRect)frame phoneNumber:(NSString*)phoneNum;
- (void)verificatioCodeSend;
- (NSString*)getVerficationCode;
- (NSString*)getPassword;
- (void)setVerifiFieldFirstReponder;
- (void)setVatiLabelHide:(BOOL)isHide;

@end
