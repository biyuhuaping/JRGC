//
//  UCFBidDetailModel.m
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBidDetailModel.h"




@implementation UCFBidDetailModel


@end

@implementation BidDetailData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"safetySecurityList" : [DetailSafetysecuritylist class], @"prdLabelsList" : [DetailPrdlabelslist class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation DetailSafetysecuritylist


@end


@implementation DetailPrdlabelslist


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


