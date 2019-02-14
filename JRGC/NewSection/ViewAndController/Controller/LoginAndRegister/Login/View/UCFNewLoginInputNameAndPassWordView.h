//
//  UCFNewLoginInputNameAndPassWordView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewLoginInputNameAndPassWordView : BaseView

@property (nonatomic, strong) UITextField *userField;

@property (nonatomic, strong) UITextField *passWordField;

@property (nonatomic, strong) UIButton *loginBtn; //登录按钮

- (instancetype)initWithFrame:(CGRect)frame withUserType:(NSString *)userType; //个人和企业

- (void)setLoginButtonState:(BOOL)isButtonState;

@end

NS_ASSUME_NONNULL_END
