//
//  UCF404ErrorView.h
//  JRGC
//
//  Created by HeJing on 15/5/26.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FourOFourViewDelegate <NSObject>

- (void)refreshBtnClicked:(id)sender fatherView:(UIView*)fhView;
@optional
- (void)refreshBackBtnClicked:(id)sender fatherView:(UIView *)fhView;

@end

@interface UCF404ErrorView : UIView

- (id)initWithFrame:(CGRect)frame errorTitle:(NSString*)titleStr;

- (void)showInView:(UIView*)fatherView;

- (void)hide;

- (void)addBackBtnView;

@property(nonatomic,weak) id<FourOFourViewDelegate>delegate;

@end
