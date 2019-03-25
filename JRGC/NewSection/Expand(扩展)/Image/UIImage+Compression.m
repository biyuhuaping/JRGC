//
//  UIImage+Compression.m
//  JRGC
//
//  Created by zrc on 2019/3/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UIImage+Compression.h"

@implementation UIImage (Compression)
+ (UIImage *)imageCompressForTargetWidth:(CGFloat)defineWidth
{
    //        UIImage *newImage      = nil;
    //        CGSize imageSize       = self.size;
    //        CGFloat width          = imageSize.width;
    //        CGFloat height         = imageSize.height;
    //        CGFloat targetWidth    = defineWidth;
    //        CGFloat targetHeight   = height / (width / targetWidth);
    //        CGSize size            = CGSizeMake(targetWidth, targetHeight);
    //        CGFloat scaleFactor    = 0.0;
    //        CGFloat scaledWidth    = targetWidth;
    //        CGFloat scaledHeight   = targetHeight;
    //        CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    //        if(CGSizeEqualToSize(imageSize, size) == NO){
    //            CGFloat newWidthFactor  = targetWidth / width;
    //            CGFloat newHeightFactor = targetHeight / height;
    //            if(newWidthFactor > newHeightFactor){
    //                scaleFactor = newWidthFactor;
    //            }
    //            else{
    //                scaleFactor = newHeightFactor;
    //            }
    //            scaledWidth = width * scaleFactor;
    //            scaledHeight = height * scaleFactor;
    //            if(newWidthFactor > newHeightFactor){
    //                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    //            }else if(newWidthFactor < newHeightFactor){
    //                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    //            }
    //        }
    //        //    UIGraphicsBeginImageContext(size);
    //        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    //
    //        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //        CGRect thumbnailRect      = CGRectZero;
    //        thumbnailRect.origin      = thumbnailPoint;
    //        thumbnailRect.size.width  = scaledWidth;
    //        thumbnailRect.size.height = scaledHeight;
    //
    //        [self drawInRect:thumbnailRect];
    //
    //        newImage = UIGraphicsGetImageFromCurrentImageContext();
    //        if(newImage == nil){
    //            NSLog(@"scale image fail");
    //        }
    //
    //        UIGraphicsEndImageContext();
    //        return newImage;
    return [UIImage new];
}

+ (UIImage *)imageGradientByColorArray:(NSArray *)colors ImageSize:(CGSize)size gradientType:(GradientType)gradientType
{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)gc_styleImageSize:(CGSize)size {
    NSArray *colorArray = [NSArray arrayWithObjects:UIColorWithRGB(0xFF4133),UIColorWithRGB(0xFF7F40), nil];
    return [self imageGradientByColorArray:colorArray ImageSize:size gradientType:leftToRight];
}
+ (UIImage*) imageWithUIView:(UIView*) view{
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}
@end
