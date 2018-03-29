//
//  UCFRegisterOneView.h
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterOneViewDelegate <NSObject>

- (void)readBtnClicked:(id)sender;

- (void)nextBtnClicked:(id)sender;

- (void)but1Click:(id)sender;

- (void)but2Click:(id)sender;

@end

@interface UCFRegisterOneView : UIView<UITextFieldDelegate>


@property(nonatomic,weak) id<RegisterOneViewDelegate>delegate;


- (NSString*)phoneNumberText;
- (void)setFirstResponder;

@end
