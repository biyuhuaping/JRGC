//
//  UIView+Border.m
//  JRGC
//
//  Created by 周博 on 15/10/29.
//  Copyright © 2015年 周博. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)
@dynamic borderColor,borderWidth,cornerRadius;

- (void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

@end
