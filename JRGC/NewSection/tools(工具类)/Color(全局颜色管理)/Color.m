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
        
        {0x66,0xb2,0xbf},          //主题色--绿色 0x66b2bf
        {0xFF,0xFF,0xFF},          //主题色--白色 0xFFFFFF
        {0xf0,0xf0,0xf0},          //背景颜色-- 灰色 0xf0f0f0
        {0xcb,0xd4,0xd6},          //文字--文字输入前颜色 0xcbd4d6
        {0x32,0x48,0x52},          //文字--文字输入后颜色 0x324852
        {0x8c,0x99,0x9f},          //文字--列表左侧标题颜色 0x8c999f
        {0xdc,0xe0,0xe1},          //按钮--置灰的背景颜色 ＃dce0e1
        {0x47,0xb4,0xc1},          //按钮--背景颜色 ＃47b4c1
        {0xee,0xee,0xee},          //分割线--底部线条颜色 0xeeeeee
        {0x32,0x48,0x52},          //导航栏--文字颜色 0x324852
        {0xdd,0xdd,0xdd},          //首页--十字分割线底部线条颜色 0xdddddd
        {0xdd,0xdd,0xdd},          //搜索框--边框颜色  DDDDDD
        {0xf8,0xf8,0xf8},          //银行卡--添加银行卡中支持信用卡背景色 0xf8f8f8
        {0xFB,0x59,0x60},          //交易明细--列表失败红色 FB5960
        
        //从这开始往上加颜色，下面是单独的控件颜色
        {0xa4,0xac,0xbb},          //无网络的文字颜色 0xa4acbb
        {0x66,0xb2,0xbf},          //弹框--标题文字颜色  0x66b2bf
        {0x32,0x48,0x52},          //弹框--内容文字颜色  0x324852
        {0x47,0xb4,0xc1},          //弹框--按钮背景颜色  0x47b4c1
        {0x66,0xb2,0xbf},          //弹框--按钮文字颜色  0x66b2bf
        {0x47,0xb4,0xc1},          //倒计时--结束文字颜色 0x47b4c1
        {0xdd,0xdd,0xdd},          //倒计时--开始文字颜色 0xdddddd
        {0x8A,0x97,0x9D},          //tabbar--文字正常颜色 0x8A979D
        {0x66,0xB2,0xBF},          //tabbar--文字选中颜色 0x66B2BF
        {0xDB,0xE0,0xE1},            //按钮--置灰颜色 DBE0E1
        {0x99,0x99,0x99},            //下拉刷新--文字颜色 0x999999
       
    
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
