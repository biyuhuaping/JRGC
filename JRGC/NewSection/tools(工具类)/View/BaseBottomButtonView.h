//
//  BaseBottomButtonView.h
//  JFTPay
//
//  Created by kuangzhanzhidian on 2018/6/20.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseView.h"

@interface BaseBottomButtonView : BaseView

@property (nonatomic, strong) UIButton *enterButton;

- (void)setProjectionViewHidden:(BOOL)hidden;

- (void)setButtonTitleWithString:(NSString *)title;

- (void)setButtonBackgroundColor:(UIColor *)BackgroundColor;

- (void)setButtonBorderColor:(UIColor *)BackgroundColor;

- (void)setViewBackgroundColor:(UIColor *)BackgroundColor;

- (void)setButtonTitleWithColor:(UIColor *)color;
@end
