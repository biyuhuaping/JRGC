//
//  UCFMyBatchBidModel.m
//  JRGC
//
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMyBatchBidModel.h"

@implementation UCFMyBatchBidModel


@end

@implementation UCFMyBatchBidData


@end


@implementation UCFMyBatchPagedata

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"result" : [UCFMyBatchBidResult class]};
}


@end


@implementation UCFMyBatchBidResult


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end
