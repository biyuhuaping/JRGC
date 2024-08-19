//
//  UCFMyBatchBidListRequest.m
//  JRGC
//  //我的投资的批量投资列表;
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMyBatchBidListRequest.h"
@interface UCFMyBatchBidListRequest()
@property(nonatomic, copy)NSString *index;
@end


@implementation UCFMyBatchBidListRequest

- (instancetype)initWithPageIndex:(NSInteger)index
{
    if (self = [super init]) {
        self.index = [NSString stringWithFormat:@"%ld",index];
    }
    return self;
}
- (NSString *)requestUrl {
    return @"api/myInvest/v2/myBatchInvest.json";
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {
    return @{@"page":self.index,@"pageSize":@"20"};
}

- (NSString *)modelClass
{
    return @"UCFMyBatchBidModel";
}
@end
