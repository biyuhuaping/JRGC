//
//  UCFBatchPageRootModel.m
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBatchPageRootModel.h"

@implementation UCFBatchPageRootModel


@end

@implementation UCFBatchPageData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"contractMsg" : [UCFBatchPageContractmsg class]};
}


@end


@implementation UCFBatchPageColprdclaimdetail


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation UCFBatchPageContractmsg


@end
