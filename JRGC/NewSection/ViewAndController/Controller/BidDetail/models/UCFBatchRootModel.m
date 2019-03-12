//
//  UCFBatchRootModel.m
//  JRGC
//
//  Created by zrc on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBatchRootModel.h"

@implementation UCFBatchRootModel


@end

@implementation UCFBatchDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"prdClaimsOrderList" : [UCFBatchPrdclaimsorderlistModel class]};
}


@end


@implementation UCFBatchPrdclaimsorderlistModel


@end



