//
//  UCFMineIntoCoinPageApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineIntoCoinPageApi.h"

@implementation UCFMineIntoCoinPageApi
{
        NSString* _vip;
    
    
}
- (id)initWithPageType:(NSString *)vip
{
    self = [super init];
    if (self) {
        _vip= vip;
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
    return IntoCoinPageApiURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {

    if (_vip == nil ||[_vip isEqualToString:@""]) {
        return @{};
    }else
    {
        return @{
                 @"pageType":_vip
                 };
    }
    
}

- (NSString *)modelClass
{
    return @"UCFMineIntoCoinPageModel";
}
@end
