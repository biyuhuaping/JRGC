//
//  UIImage+zhang.m
//  印章demo
//
//  Created by NJW on 15/4/22.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import "UIImage+zhang.h"
#import <CoreText/CoreText.h>

#define UIColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIImage (zhang)
+ (UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    int w = 300;
    int h = 140;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    CGContextSaveGState(context);
    
    CFStringRef font_name = CFStringCreateWithCString(NULL, "Helvetica-Bold", kCFStringEncodingMacRoman);
    
    CTFontRef font = CTFontCreateWithName(font_name, 20.0, NULL);
    
    CGColorRef color = UIColorWithRGB(0xfd4d4c).CGColor;
    
    CFStringRef keys[] = { kCTFontAttributeName , kCTForegroundColorAttributeName};
    
    CFTypeRef values[] = { font, color };
    
    CFDictionaryRef font_attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys, (const void **)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFRelease(font_name);
    
    CFRelease(font);
    
    int x = 3;
    int y = 5;
    const char *text = [text1 UTF8String];
    
    CFStringRef string = CFStringCreateWithCString(NULL, text, kCFStringEncodingMacRoman);
    
    CFAttributedStringRef attr_string = CFAttributedStringCreate(NULL, string, font_attributes);
    
    CTLineRef line = CTLineCreateWithAttributedString(attr_string);
    
    CGContextSetTextPosition(context, x, y);
    
    // Core Text uses a reference coordinate system with the origin on the bottom-left
    // flip the coordinate system before drawing or the text will appear upside down
    CGContextTranslateCTM(context, 44, 22);
    CGContextScaleCTM(context, 2.0, 2.0);
    
    CTLineDraw(line, context);
    
    CFRelease(line);
    
    CFRelease(string);
    
    CFRelease(attr_string);
    
    CGContextRestoreGState(context);
    
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}
@end
