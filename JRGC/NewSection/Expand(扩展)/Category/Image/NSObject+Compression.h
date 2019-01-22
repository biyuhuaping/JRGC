//
//  NSObject+Compression.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;
@interface NSObject (Compression)
/**
 *  压缩图片
 *
 *  @param defineWidth 要压缩的目标尺寸
 *
 *  @return 压缩后的图片
 */
- (UIImage *)imageCompressForTargetWidth:(CGFloat)defineWidth;


/**
 绘制渐变Image

 @param array 渐变颜色数组
 @param size 绘制图片大小
 @return 图片
 */
- (UIImage *)imageGradientByColorArray:(NSArray *)colors ImageSize:(CGSize)size gradientType:(GradientType)gradientType;
    
@end
