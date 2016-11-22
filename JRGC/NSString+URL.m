//
//  NSString+URL.m
//  JRGC
//
//  Created by 狂战之巅 on 16/4/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)
- (NSString *)URLEncodedString
{
    
    
    //CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ",kCFStringEncodingUTF8);
    //NSString *out1 = [NSString stringWithString:(__bridge NSString *)escaped];
    //CFRelease(escaped);//记得释放
    //return out1;
    
    
    NSString *charactersToEscape = @"?!@#$^&%*+,:;=\'\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
    
    
    //CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          //(__bridge CFStringRef) self,
                                                                          //nil,
                                                                          //CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          //kCFStringEncodingUTF8);
    //NSString *encodedString1 = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    
    //CFRelease(encodedCFString);
    //return encodedString1;
    
}
- (BOOL)newRangeOfString:(NSString *)searchString
{
    if (self == nil || searchString == nil)
    {
        return NO;
    }
    else
    {
        
        if ([self rangeOfString:searchString].location != NSNotFound)
        {
            return YES;
        }
        else
        {
            return NO;
        }

    }
}
@end
