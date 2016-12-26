//
//  NSString+Misc.m
//  

#import "NSString+Misc.h"

@implementation NSString (Misc)

+ (NSString *)urlEncodeStr:(NSString *)inStr
{
    if (inStr.length > 0) {
        NSString *encodedValue = [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)inStr, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8)) autorelease];
        return encodedValue;
    }
    return inStr;
}

+ (NSAttributedString *)content:(NSString *)content withColor:(UIColor*)color1 title:(NSString *)title titleColor:(UIColor*)color2

{
    NSDictionary *toNameStrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                    NSForegroundColorAttributeName : color1
                                    };
    
    NSMutableAttributedString *toNameStrAttri = [[NSMutableAttributedString alloc] initWithString:content attributes:toNameStrDict];
    
    NSDictionary *fromNameStrDict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                                      NSForegroundColorAttributeName : color2
                                      };
    
    NSAttributedString *fromNameStrAttri;
    if ([title isKindOfClass:[NSNull class]]){
        title = @"无";
    }
    
    fromNameStrAttri = [[NSAttributedString alloc] initWithString:title attributes:fromNameStrDict];
    [toNameStrAttri appendAttributedString:fromNameStrAttri];
    
    return toNameStrAttri;
}

+ (NSAttributedString *)content:(NSString *)content withColor:(UIColor*)color1 font1:(UIFont*)font1 title:(NSString *)title titleColor:(UIColor*)color2 font2:(UIFont*)font2

{
    NSDictionary *toNameStrDict = @{NSFontAttributeName : font1,
                                    NSForegroundColorAttributeName : color1
                                    };
    
    NSMutableAttributedString *toNameStrAttri = [[NSMutableAttributedString alloc] initWithString:content attributes:toNameStrDict];
    
    NSDictionary *fromNameStrDict = @{NSFontAttributeName : font2,
                                      NSForegroundColorAttributeName : color2
                                      };
    
    NSAttributedString *fromNameStrAttri;
    if ([title isKindOfClass:[NSNull class]]){
        title = @"无";
    }
    
    fromNameStrAttri = [[NSAttributedString alloc] initWithString:title attributes:fromNameStrDict];
    [toNameStrAttri appendAttributedString:fromNameStrAttri];
    
    return toNameStrAttri;
}

// 获取随机名字 例如：王**
+ (NSString *)getRandNameWithRealName:(NSString *)realName
{
    NSMutableString *muStr = (NSMutableString *)realName;
    NSUInteger length = realName.length;
    if (length>3) {
        NSInteger randIndex = arc4random() % length;
        for (int i=0; i<length; i++) {
            if (randIndex != i) {
                [muStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
    }
    else {
        
    }
    
    return nil;
}


@end
