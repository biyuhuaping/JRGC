//
//  UCFNewHomeListModel.m
//  JRGC
//
//  Created by zrc on 2019/2/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewHomeListModel.h"

@implementation UCFNewHomeListModel


@end

@implementation UCFNewHomeDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"group" : [UCFNewHomeGroupModel class]};
}


@end


@implementation UCFNewHomeGroupModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"prdList" : [UCFNewHomeListPrdlist class]};
}


@end


@implementation UCFNewHomeListPrdlist


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end
