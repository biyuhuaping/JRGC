//
//  UIImage+Misc.h
//  

#import <UIKit/UIKit.h>

/*
 不要通过直接调用，要通过ImageManager类间接调用，因为通过ImageManger类进行了缓存
 */
@interface UIImage (Misc)

/*
主要用于不同类型设备使用相同一张图片的情形，这些图片保存在Image文件夹下，这样可以减少安装包大小
 */
+ (UIImage *)getImageWithAbsoluteImageName:(NSString *)imageName;

+ (UIImage *)getImageWithAbsoluteImageName:(NSString *)imageName
                                     scale:(CGFloat)scale;

+ (UIImage *)getImageWithImageName:(NSString *)imageName
                             scale:(CGFloat)scale;

+ (UIImage*) createImageWithColor: (UIColor*) color;

//旋转image到相应的度数
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
