//
//  UCFHomeListNavView.h
//  JRGC
//
//  Created by njw on 2017/5/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFHomeListNavView;
@protocol UCFHomeListNavViewDelegate <NSObject>

- (void)homeListNavView:(UCFHomeListNavView *)navView didClicked:(UIButton *)loginAndRegister;

@end

@interface UCFHomeListNavView : UIView
@property (weak, nonatomic) UIButton *loginAndRegisterButton;
@property (assign, nonatomic) CGFloat offset;
@property (weak, nonatomic) id<UCFHomeListNavViewDelegate> delegate;
@end
