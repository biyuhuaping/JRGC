//
//  Color.h
//  JIEMO
//
//  Created by 狂战之巅 on 2016/12/26.
//  Copyright © 2016年 狂战之巅. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, PGColorOptions) {
    
    PGColorOptionGrayBackgroundColor = 0, //背景颜色-- 灰色 0xxf5f5f5
    PGColorOptionThemeWhite,              //主题色--白色 0xFFFFFF
    PGColorOptionTitleOrange,              //文字颜色--橘色 0xFF4E33
    PGColorOptionTitleBlack,               //文字颜色--黑色 0x000000
    PGColorOptionTitleBlackGray,           //文字颜色--黑灰色 0x000000
    PGColorOptionTitleGray,                //文字颜色--灰色 0xB1B5C2
    PGColorOptionCellSeparatorGray,        //Cell分割线颜色--灰色 0xE3E5EA
    PGColorOptionCellContentBlue,          //Cell内容文字颜色--蓝色色 0x91ACFB
    PGColorOpttonTextRedColor,             //红色字体颜色FF171C
    PGColorOptionTitlerRead,               //文字颜色--红色 FF4133
    PGColorOptionInputDefaultBlackGray,    //输入框默认文字颜色--灰色B1B5C2
    PGColorOptionButtonBackgroundColorGray,//按钮背景颜色--灰色CACBD9
    PGColorOptionCursorPurple,             //光标背景颜色--灰色8597CD
    PGColorOptionTitleLoginRead,           //登录标题颜色--红色FF1E2E
    PGColorOpttonBtnBackgroundColor,       //按钮灰色背景颜色CACBD9
    PGColorOpttonRateNoramlTextColor,      //利率字体正常FF4133
    PGColorOpttonRateRedTextColor,         //利率字体提醒 #FFCFB2
    PGColorOpttonSeprateLineColor,         //分割线 #FF7F5B
    PGColorOpttonTabeleViewBackgroundColor,//tableviewh背景色 #F5F5F5
    PGColorOpttonBankCardTextColor,//银行卡字体颜色 #FFE9E5
    PGColorOpttonBatchTextColor,        //黑色字体t颜色 #363333
    PGColorOpttonGradientBackgroundColor,        //渐变色背景#FF7F40
    PGColorOpttonRedLineBackColor,               //#FEBDB9
    PGColorOpttonBankTextGrayColor,        //银行卡标题字体灰色#A0A4B1
    PGColorOpttonRegisterdSucceedColor,        //注册成功标题字体黄色#FEF1DD
    PGColorOpttonMyVipBackgroundColor,        //我的页面vip背景色#EC2E02
    PGColorOpttonPopcContentTextColor,        //弹窗content#7780A3
    PGColorOpttonRegisterBackgroundColor,        //注册成功背景色#ff5736
    PGColorOpttonNavLineBackgroundColor,        //导航底线#e2e2e2
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
