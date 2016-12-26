//
//  UIView+Border.h
//  JRGC
//
//  Created by 周博 on 15/10/29.
//  Copyright © 2015年 周博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
