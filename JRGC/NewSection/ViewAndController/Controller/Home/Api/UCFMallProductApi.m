//
//  UCFMallProductApi.m
//  JRGC
//
//  Created by zrc on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMallProductApi.h"

@implementation UCFMallProductApi
- (NSString *)requestUrl {
    return @"api/publicMsg/v2/mallProductShow.json";
}
- (id)requestArgument {
    return nil;
}
- (NSString *)modelClass
{
    return @"UCFHomeMallDataModel";
}
@end
