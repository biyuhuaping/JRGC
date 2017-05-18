//
//  UITextField+UPExtension.h
//  UcfPayCommonSDK
//
//  Created by 杨名宇 on 16/1/25.
//  Copyright © 2016年 Ucf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (UcfLib)

- (NSRange) selectedRange;
- (void)setSelectedRange:(NSRange)range;
- (void)setHeaderImage:(UIImage *)headerImage headerWidth:(CGFloat)width;
- (void)setLeftPadding:(CGFloat)padding;
- (void)setLeftTitle:(NSString *)title;

@end
