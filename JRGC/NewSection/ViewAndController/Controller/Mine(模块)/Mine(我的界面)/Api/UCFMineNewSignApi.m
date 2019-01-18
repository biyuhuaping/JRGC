//
//  UCFMineNewSignApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineNewSignApi.h"

@implementation UCFMineNewSignApi
{
    NSString* _token;
    
    
}
- (id)initWithApptzticket:(NSString *)token
{
    self = [super init];
    if (self) {
        _token= token;
    }
    return self;
}
/**
 *  @author KZ, 17-09-11 20:09:12
 *
 *  请求的借口
 *
 *  @return 返回需要请求的借口的URI
 */
- (NSString *)requestUrl {
    return NewSignApiURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    
    
    return @{
             @"apptzticket":_token
             };
  
    
}

- (NSString *)modelClass
{
    return @"UCFMineNewSignModel";
}
@end
