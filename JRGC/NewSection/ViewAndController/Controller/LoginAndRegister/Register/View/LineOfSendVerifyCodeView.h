//
//  LineOfSendVerifyCodeView.h
//  JIMEITicket
//
//  Created by kuangzhanzhidian on 2018/5/23.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseView.h"
#import "CQCountDownButton.h"
typedef void(^verifyCodeCallBackBlock)(void);
typedef void(^voiceVerifyCodeCallBackBlock)(void);
@interface LineOfSendVerifyCodeView : BaseView


@property (nonatomic, strong) CQCountDownButton *verifyCodeButton;

@property (nonatomic, strong) CQCountDownButton *voiceVerifyCodeButton;

@property (nonatomic,strong) verifyCodeCallBackBlock verifyCodebackBlock;

@property (nonatomic,strong) voiceVerifyCodeCallBackBlock voiceVerifyCodebackBlock;

@property (nonatomic, copy) NSString *phoneNum;
- (instancetype)initWithFrame:(CGRect)frame withPhoneNum:(NSString *)phoneNum;
@end
