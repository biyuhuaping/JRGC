//
//  UIView+RoundingCorners.h
//  JRGC
//
//  Created by zrc on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RoundingCorners)
- (void)rc_bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
@end

NS_ASSUME_NONNULL_END
