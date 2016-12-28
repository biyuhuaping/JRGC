//
//  UCFGuaPopViewController.h
//  JRGC
//
//  Created by HeJing on 15/7/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuaPopViewDelegate <NSObject>

- (void)submitBtnClicked:(id)sender;

@end

@interface UCFGuaPopViewController : UIViewController<UITextFieldDelegate>

- (void)hideView;
- (void)showPopView:(UIViewController *)controller;

@property(nonatomic,weak) id<GuaPopViewDelegate> delegate;
@property (nonatomic, strong) UILabel *errorInfoLbl;//错误提示label
@property (nonatomic, strong) UITextField *cardNumField;//刮刮卡号
@property (nonatomic, strong) UITextField *passwordField;//刮刮卡密码

@end
