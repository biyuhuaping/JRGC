//
//  UCFLoginView.h
//  JRGC
//
//  Created by qinwei on 15/3/31.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFLoginViewDelegate <NSObject>

- (void)userLogin:(id)sender;
- (void)resetPassword:(id)sender;
- (void)regisiterBtn:(id)sender;
- (void)seletedSegmentedControl:(NSInteger)seletedTag;


@end

@interface UCFLoginView : UIView<UITextFieldDelegate>


@property(nonatomic,assign) id<UCFLoginViewDelegate>delegate;

- (NSString*)userNameFieldText;
- (void)setUserNameFieldText:(NSString*)text;
- (NSString*)passwordFieldText;
- (void)setFirstResponder;
- (void)setPasswordFieldText:(NSString*)text;

@end
