//
//  UCFTransBidInfoModel.m
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransBidInfoModel.h"

@implementation UCFTransBidInfoModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"contractMsg" : [UCFTransContractmsg class], @"prdLabelsList" : [UCFTransPrdlabelslist class]};
}


@end

@implementation UCFTransPrdtransferfore


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation UCFTransPrdclaimsreveal

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"safetySecurityList" : [UCFTransSafetysecuritylist class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation UCFTransSafetysecuritylist


@end


@implementation UCFTransUserothermsg


@end


@implementation UCFTransPrdguaranteemess


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation UCFTransOrderuser


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation UCFTransContractmsg


@end


@implementation UCFTransPrdlabelslist


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


