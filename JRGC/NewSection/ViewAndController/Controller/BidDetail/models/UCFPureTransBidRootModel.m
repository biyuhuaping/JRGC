//
//  UCFPureTransBidRootModel.m
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPureTransBidRootModel.h"

@implementation UCFPureTransBidRootModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"contractMsg" : [UCFTransPureContractmsg class], @"prdLabelsList" : [UCFTransPurePrdlabelslist class]};
}


@end

@implementation UCFTransPureDataModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation UCFTransPureContractmsg


@end


@implementation UCFTransPurePrdlabelslist


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end
