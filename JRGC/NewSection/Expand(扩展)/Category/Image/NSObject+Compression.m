//
//  NSObject+Compression.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "NSObject+Compression.h"

@implementation NSObject (Compression)
- (UIImage *)imageCompressForTargetWidth:(CGFloat)defineWidth
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
@end
