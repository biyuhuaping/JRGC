//
//  CWCommon.h
//  CWCommon
//
//  Created by ; on 14-9-16.
//  Copyright (c) 2014年 DWP rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CWCommon : NSObject

+ (__nonnull instancetype)sharedClient;

#pragma mark - 根据标示符取视图
/**
 *  从storyBoard获取ViewController
 *
 *  @param story      storyBoard
 *  @param identifier 视图标示
 *
 *  @return 获取到的ViewController
 */
+ (UIViewController * __nullable)getViewControllerFromstoryboard:(NSString * __nonnull)story WithRestorationID:(NSString *__nonnull )identifier;
#pragma mark - 存储
/**
 *  存储数据到NSUserDefaults
 *
 *  @param key  存储的key
 *  @param strO 存储的对象
 */
+ (void)saveKey:(NSString *__nonnull)key withObject:(id __nonnull)strO;
#pragma mark - 获取存储
/**
 *  获取存储数据（NSUserDefaults）
 *
 *  @param key 获取的key值
 *
 *  @return 获取到的值
 */
+ (id __nullable)getValueForKey:(NSString *__nonnull)key;
#pragma mark - 裁剪图片
/**
 *  图片裁剪
 *
 *  @param superImage   原始图片
 *  @param subImageRect 裁剪的区域
 *
 *  @return 裁剪之后的图片
 */
+(UIImage * __nullable)getImageFromImage:(UIImage * __nonnull) superImage  subImageRect:(CGRect)subImageRect;
#pragma mark - 压缩图片
/**
 *  压缩图片尺寸
 *
 *  @param img  原始图片
 *  @param size 压缩的大小
 *
 *  @return 压缩之后的图片
 */
+ (UIImage * __nullable)scaleToSize:(UIImage *  __nonnull)img size:(CGSize)size;

//递归缩放图片
+(UIImage * __nullable)recureScaleImage:(UIImage * __nonnull)oldImage;

/**
 *  @brief 对照片旋转90度的处理
 *
 *  @param aImage 原照片
 *
 *  @return 返回旋转正的图片
 */
+(UIImage * __nullable)fixOrientation:(UIImage * __nonnull)aImage;


@end
