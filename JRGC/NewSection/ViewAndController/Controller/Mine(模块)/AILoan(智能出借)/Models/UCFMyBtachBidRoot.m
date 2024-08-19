//
//  UCFMyBtachBidRoot.m
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMyBtachBidRoot.h"

@implementation UCFMyBtachBidRoot


@end

@implementation UCFMyBatchBidDetaiData


@end


@implementation UCFMyBatchBidDetaiPagedata

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"result" : [UCFMyBatchBidDetaiResult class]};
}


@end





@implementation UCFMyBatchBidDetaiResult


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation UCFMyBatchBidDetaiColprdclaimdetail


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end
