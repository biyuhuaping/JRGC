//
//  UCFIntoBatchPageRequest.m
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFIntoBatchPageRequest.h"
@interface UCFIntoBatchPageRequest()
@property(nonatomic, strong)NSString *tenderId;
@end


@implementation UCFIntoBatchPageRequest

- (instancetype)initWithTenderID:(NSString *)tenderId
{
    if (self = [super init]) {
        self.tenderId = tenderId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"api/invest/v2/intoDealBatch.json";
}
- (id)requestArgument {
    return @{@"tenderId":_tenderId,@"fromSite":@"1"};
}
- (NSString *)modelClass
{
    return @"UCFBatchPageRootModel";
}
@end
