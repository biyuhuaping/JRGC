//
//  UCFCollectionRootModel.m
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionRootModel.h"

@implementation UCFCollectionRootModel


@end

@implementation UCFCollectionDataModel


@end


@implementation UCFCollectionPagedataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"result" : [UCFCollcetionResult class]};
}


@end





@implementation UCFCollcetionResult


@end
