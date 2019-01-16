//
//  Color.h
//  JIEMO
//
//  Created by 狂战之巅 on 2016/12/26.
//  Copyright © 2016年 狂战之巅. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, PGColorOptions) {
    

    PGColorOptionGrayBackgroundColor = 0, //背景颜色-- 灰色 0xebebee
    PGColorOptionThemeWhite,              //主题色--白色 0xFFFFFF
    PGColorOptionTitleOrange,              //文字颜色--橘色 0xFF4E11
    PGColorOptionTitleBlack,               //文字颜色--黑色 0x000000
    PGColorOptionTitleBlackGray,           //文字颜色--黑灰色 0x333333
    PGColorOptionTitleGray,                //文字颜色--灰色 0xB1B5C2
    PGColorOptionCellSeparatorGray,        //Cell分割线颜色--灰色 0xE3E5EA
    PGColorOptionCellContentBlue,          //Cell内容文字颜色--蓝色色 0x91ACFB
    PGColorOpttonTextRedColor,            //红色字体颜色
    
    
};


@interface Color : NSObject
/**
 *  @author KZ, 17-09-12 17:09:18
 *
 *  生成枚举color
 *
 *  @param colorOptions 枚举颜色值
 *
 *  @return 生成后color
 */
+ (UIColor*)color:(PGColorOptions)colorOptions;

/**
 *  @author KZ, 17-09-12 17:09:10
 *
 *  生成font
 *
 *  @param size 字号
 *
 *  @return 生成后font
 */
+ (UIFont*)font:(CGFloat)size;
/**
 *  @author KZ, 17-09-12 17:09:10
 *
 *  生成font
 *
 *  @param size 字号
 *  @param name 名字
 *
 *  @return 生成后font
 */
+ (UIFont*)font:(CGFloat)size andFontName:(NSString *)name;

/*!
 *  @author KZ, 17-09-26
 *
 *  按比例生成font
 *
 *  @param size 字号
 *  @param name 名字
 *
 *  @return 生成后的font
 */
+ (UIFont *)scaleFontSize:(CGFloat)size andFontName:(NSString *)name;

/**
 *  @author KZ, 17-09-12 17:09:03
 *
 *  生成16进制的color
 *
 *  @param color 16进制的字符串
 *
 *  @return 生成后的color
 */
+ (UIColor *)colorWithHexString:(NSString *)color withAlpha:(CGFloat)alpha;

/**
 工场默认字体PingFangSC-Regular

 @param size 字体大小
 @return 生成后的font
 */
+ (UIFont*)gc_Font:(CGFloat)size;

/**
 工场默认字体PingFangSC-Regular

 @param size 字体大小
 @return AvenirNextCondensed-Regular 字体
 
 */
+ (UIFont*)gc_ANC_font:(CGFloat)size;
@end
