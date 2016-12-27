//
//  UCFRetrievePasswordStepOneView.h
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RetrievePasswordStepOneDelegate <NSObject>

- (void)nextStep:(id)sender;

- (void)concactUs:(id)sender;

@end

@interface UCFRetrievePasswordStepOneView : UIView<UITextFieldDelegate>


@property (nonatomic,weak) id<RetrievePasswordStepOneDelegate>delegate;


- (NSString*)getPhoneFieldText;
- (NSString*)getUserNameText;

@end
