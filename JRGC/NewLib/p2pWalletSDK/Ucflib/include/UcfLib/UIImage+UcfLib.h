//
//  UIImage+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UcfLib)

- (UIImage *)subImageInRect:(CGRect)rect;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleToFitSize:(CGSize)size;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

+ (UIImage *)rotateImage:(UIImage *)image;
- (UIImage *)fixOrientation;

+ (UIImage *)screenShotImage;
+ (UIImage *)imageWithColor:(UIColor *)color;

- (NSString *)base64Image;

+ (UIImage *)imageWithColor:(UIColor *)color andImg:(UIImage *)img;
+ (void)cacheImage:(NSString *)url gotBlock:(void (^)(UIImage *image))finished;

+ (UIImage *)libImage:(NSString *)name;
+ (UIImage *)bankImage:(NSString *)bankCode;

@end
