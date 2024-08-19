//
//  UIImage+Compression.h
//  JRGC
//
//  Created by zrc on 2019/3/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compression)
/**
 *  压缩图片
 *
 *  @param defineWidth 要压缩的目标尺寸
 *
 *  @return 压缩后的图片
 */
+ (UIImage *)imageCompressForTargetWidth:(CGFloat)defineWidth;


/**
 绘制渐变Image
 
 @param array 渐变颜色数组
 @param size 绘制图片大小
 @return 图片
 */
+ (UIImage *)imageGradientByColorArray:(NSArray *)colors ImageSize:(CGSize)size gradientType:(GradientType)gradientType;


/**
 工场的渐变颜色主体
 
 @param size 获取渐变图片的大小
 @return 渐变图片
 */
+ (UIImage *)gc_styleImageSize:(CGSize)size;

/**
 工场按钮禁用背景y

 @param size 获取渐变图片的大小
 @return 灰色图片
 */
+ (UIImage *)gc_styleGrayImageSize:(CGSize)size;

+ (UIImage*) imageWithUIView:(UIView*) view;
@end

NS_ASSUME_NONNULL_END
