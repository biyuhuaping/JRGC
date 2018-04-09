//
//  MPKeyboard.h
//  UcfPaySDK
//
//  Created by Jeff on 14-6-17.
//  Copyright (c) 2014年 UCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UcfNumKeyboardDelegate <NSObject>

- (void) numberKeyboardInput:(NSInteger) number;
- (void) numberKeyboardBackspace;
- (void) numberKeyboardXBtnTapped;

@end

@interface UcfNumKeyboard : UIView

@property (nonatomic, assign) id<UcfNumKeyboardDelegate> delegate;
@property (nonatomic, retain) NSArray *numArray;

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)numArray;

- (void)hideXBtn;
- (void)showXBtn;
- (void)changeXText:(NSString *)text;

@end
