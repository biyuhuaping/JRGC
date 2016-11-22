//
//  BaseAlertView.h
//  SXZH
//
//  Created by JasonWong on 13-12-24.
//  Copyright (c) 2013年 www.sxzhuanhuan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseAlertView : UIView
{
    UILabel *alertLabel;
    NSTimer *timer;
}

@property(nonatomic,retain) NSTimer *timer;

+ (BaseAlertView *)getShareBaseAlertView;
- (void) showString:(NSString *)string;
- (void) showStringOnTop:(NSString *)string;


@end
