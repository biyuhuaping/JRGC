//
//  RegisterSuccessAlert.h
//  JRGC
//
//  Created by HeJing on 15/5/7.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegSuccessDelegate <NSObject>

- (void)lookBtnClicked:(id)sender;

- (void)certificationBtnClicked:(id)sender;

@end

@interface RegisterSuccessAlert : UIViewController

- (void)hideView;
- (void)showAlert:(UIViewController *)controller;
- (void)setAlertTitle:(NSString*)amount1 cetiAmout:(NSString*)amount2 titleType:(NSString*)type certifiType:(NSString*)type2 bdAmout:(NSString*)bdamount bdType:(NSString*)bdtype;
- (void)setAlertTitle:(NSString*)amount1 firstInstAmout:(NSString*)firstInstValue titleType:(NSString *)type firstInstType:(NSString *)firstInstType;


@property(nonatomic,weak) id<RegSuccessDelegate> delegate;

@end
