//
//  NSString+Misc.h
//  

#import <Foundation/Foundation.h>

@interface NSString (Misc)

+ (NSString *)urlEncodeStr:(NSString *)inStr;

+ (NSAttributedString *)content:(NSString *)content withColor:(UIColor*)color1 title:(NSString *)title titleColor:(UIColor*)color2;
+ (NSAttributedString *)content:(NSString *)content withColor:(UIColor*)color1 font1:(UIFont*)font1 title:(NSString *)title titleColor:(UIColor*)color2 font2:(UIFont*)font2;

// 获取随机名字 例如：王**
+ (NSString *)getRandNameWithRealName:(NSString *)realName;
@end
