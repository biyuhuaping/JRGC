//
//  UCFQueryBannerByTypeAPI.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFQueryBannerByTypeAPI.h"

@implementation UCFQueryBannerByTypeAPI
{
    NSInteger _type;
    
    
}
- (id)initWithBannerType:(NSInteger )type
{
    self = [super init];
    if (self) {
        _type = type;
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
    return QueryBannerByTypeURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    
    {
        return @{
                 @"type":[NSString stringWithFormat:@"%ld",(long)_type],
                 };
    }
    
}

- (NSString *)modelClass
{
    return @"UCFQueryBannerByTypeModel";
}
@end
