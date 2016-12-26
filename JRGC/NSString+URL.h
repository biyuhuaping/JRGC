//
//  NSString+URL.h
//  JRGC
//
//  Created by 狂战之巅 on 16/4/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)
- (NSString *)URLEncodedString;
- (BOOL)newRangeOfString:(NSString *)searchString;
@end
