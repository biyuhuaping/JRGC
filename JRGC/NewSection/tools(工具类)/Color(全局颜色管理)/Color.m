//
//  Color.m
//  JIEMO
//
//  Created by 狂战之巅 on 2016/12/26.
//  Copyright © 2016年 狂战之巅. All rights reserved.
//

#import "Color.h"



@implementation Color

+ (UIColor*)color:(PGColorOptions)colorOptions
{
    //执行颜色数组：
    static  unsigned char colors[][3] = {
 
        {0xeb,0xeb,0xee},          //背景颜色--灰色 0xebebee
        {0xFF,0xFF,0xFF},          //主题色--白色 0xFFFFFF
        {0xFF,0x4E,0x11},          //文字颜色--橘色 0xFF4E11
        {0x00,0x00,0x00},               //文字颜色--黑色 0x000000
        {0x33,0x33,0x33},           //文字颜色--黑灰色 0x333333
        {0xB1,0xB5,0xC2},                //文字颜色--灰色 0xB1B5C2
        {0xe3,0xe5,0xea},                //Cell分割线颜色--灰色 0xE3E5EA
        {0x91,0xac,0xfb},          //Cell内容文字颜色--蓝色色 0x91ACFB
        {0xFF,0x17,0x1C},          //红色字体颜色FF171C
        {0xFF,0x41,0x33},           //文字颜色--红色 FF4133
        {0xB1,0xB5,0xC2},    //输入框默认文字颜色--灰色B1B5C2
        {0xca,0xcb,0xd9},    //按钮背景颜色--灰色CACBD9
        {0x85,0x97,0xcd},              //光标背景颜色--灰色8597CD
        {0xff,0x1e,0x2e},              //登录标题颜色--红色FF1E2E
};
    
    return [UIColor colorWithRed:colors[colorOptions][0]/255.0 green:colors[colorOptions][1]/255.0 blue:colors[colorOptions][2]/255.0 alpha:1];
}

+ (UIFont*)font:(CGFloat)size
{
    return  [self font:size andFontName:nil];
}

+ (UIFont*)font:(CGFloat)size andFontName:(NSString *)name
{
    //中文显示平方字体，英文显示ding.
    // [NSLocale preferredLanguages]
    
    if (nil == name) {
        UIFont *font =  [UIFont systemFontOfSize:size];
        return  font;
    }
    else
    {
        UIFont *font =  [UIFont fontWithName:name size:size];
        return  font;
    }
    
}
+ (UIFont*)gc_ANC_font:(CGFloat)size
{
    return  [self font:size andFontName:@"AvenirNextCondensed-Regular"];;
}
+ (UIFont*)gc_Font:(CGFloat)size
{
    return  [self font:size andFontName:@"PingFangSC-Regular"];;
}
+ (UIFont *)scaleFontSize:(CGFloat)size andFontName:(NSString *)name
{
    //按比例计算的size
    CGFloat scaleSize = size * PGScreenWidth/750;
    
    if (nil == name) {
        UIFont *font =  [UIFont systemFontOfSize:scaleSize];
        return  font;
    }
    else
    {
        UIFont *font =  [UIFont fontWithName:name size:scaleSize];
        return  font;
    }
}



+ (UIColor *)colorWithHexString:(NSString *)color withAlpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];

}


@end
