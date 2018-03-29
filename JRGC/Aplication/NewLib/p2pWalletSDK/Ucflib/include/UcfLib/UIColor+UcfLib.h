//
//  UIColor+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UcfLib)

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;

+ (NSString *) changeUIColorToRGB:(UIColor *)color;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

@end
