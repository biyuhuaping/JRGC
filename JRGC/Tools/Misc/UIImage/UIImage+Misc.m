//
//  UIImage+Misc.m
//  

#import "UIImage+Misc.h"

@implementation UIImage (Misc)

+ (UIImage *)getImageWithAbsoluteImageName:(NSString *)imageName
{
    return [self getImageWithAbsoluteImageName:imageName scale:2.0f];
}

+ (UIImage *)getImageWithAbsoluteImageName:(NSString *)imageName
                                     scale:(CGFloat)scale
{
    return [self getImageWithImageName:imageName pathComponent:@"Image/" scale:scale];
}

+ (UIImage *)getImageWithImageName:(NSString *)imageName
                     pathComponent:(NSString *)pathComponent
                             scale:(CGFloat)scale
{
    UIImage *image = nil;
    if (imageName.length > 0) {
        NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", pathComponent, imageName]];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if (image) {
            image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
        }
    }
    return image;
}

+ (UIImage *)getImageWithImageName:(NSString *)imageName
                             scale:(CGFloat)scale
{
    return [self getImageWithImageName:imageName pathComponent:@"" scale:scale];
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end
