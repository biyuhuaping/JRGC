//
//  UCFMineMyReceiptApi.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/17.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineMyReceiptApi.h"

@implementation UCFMineMyReceiptApi
{
//    NSString* _pageIndex;
//    NSString* _pageSize;
    
    
}
- (id)initWithpageIndex:(int)pageIndex pageSize:(int )pageSize
{
    self = [super init];
    if (self) {
//        _pageIndex=[NSString stringWithFormat:@"%d",pageIndex];
//        _pageSize= [NSString stringWithFormat:@"%d",pageSize];
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
    return MyReceiptApiURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    
//    return @{
//             @"pageIndex":_pageIndex,
//             @"pageSize":_pageSize
//             };
    return @{};
}

- (NSString *)modelClass
{
    return @"UCFMineMyReceiptModel";
}
@end


