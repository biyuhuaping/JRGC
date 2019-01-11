//
//  Color.h
//  JIEMO
//
//  Created by 狂战之巅 on 2016/12/26.
//  Copyright © 2016年 狂战之巅. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, PGColorOptions) {
    PGColorOptionThemeGreenColor = 0,          //主题色--绿色 0x66b2bf
    PGColorOptionThemeWhite,                   //主题色--白色 0xFFFFFF
    PGColorOptionGrayBackgroundColor,          //背景颜色-- 灰色 0xf0f0f0
    PGColorOptionBeforeInputGrayTextColor,     //文字--文字输入前颜色 0xcbd4d6
    PGColorOptionAfterInputGrayTextColor,      //文字--文字输入后颜色 0x324852
    PGColorOptionTbaleTitleGrayTextColor,      //文字--列表左侧标题颜色 0x8c999f
    PGColorOptionButtonEnableColor,            //按钮--置灰的背景颜色 ＃dce0e1
    PGColorOptionButtonColor,                  //按钮--背景颜色 ＃47b4c1
    PGColorOptionCuttingLineColor,             //分割线--底部线条颜色 0xeeeeee
    PGColorOptionNavigationTitleColor,         //导航栏--文字颜色 0x324852
    PGColorHomePageCuttingLineColor,           //首页--十字分割线底部线条颜色 0xdddddd
    PGColorSerchBarPageBoraderColor,           //搜索框--边框颜色  DDDDDD
    PGColorOptionCreditCardSpecialBackgroundColor,   //银行卡--添加银行卡中支持信用卡背景色 0xf8f8f8
    PGColorOptionTransactionDetailsRedColor,   //交易明细--列表失败红色 FB5960
    
    
    //从这开始往上加颜色，下面是单独的控件颜色
    PGColorOptionErroTextColor,                //无网络的文字颜色 0xa4acbb
    PGColorOptionAlertTitleColor,              //弹框--标题文字颜色  0x66b2bf
    PGColorOptionAlertContentColor,            //弹框--内容文字颜色  0x324852
    PGColorOptionAlertButtonColor,             //弹框--按钮背景颜色  0x47b4c1
    PGColorOptionAlertButtonTitleColor,        //弹框--按钮文字颜色  0x66b2bf
    PGColorOptionVerificationCodeColor,        //倒计时--结束文字颜色 0x47b4c1
    PGColorOptionStartVerificationCodeColor,   //倒计时--开始文字颜色 0xdddddd
    PGColorOptionTabbarTitleNormalColor,       //tabbar--文字正常颜色 0x8A979D
    PGColorOptionTabbarTitleSelectedColor,     //tabbar--文字选中颜色 0x66B2BF
    PGColorOptionButtonEnablePressColor,        //按钮--置灰颜色 DBE0E1
    PGColorOptionLoadingTitleColor              //下拉刷新--文字颜色 0x999999
    
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

@end
