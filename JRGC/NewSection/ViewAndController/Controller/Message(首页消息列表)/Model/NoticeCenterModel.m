//
//  NoticeCenterModel.m
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "NoticeCenterModel.h"

@implementation NoticeCenterModel


@end

@implementation NoticeCenterModelData


@end


@implementation NoticeCenterNoicepage

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"result" : [NoticeResult class]};
}


@end


@implementation NoticePagination


@end


@implementation NoticeResult


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end



