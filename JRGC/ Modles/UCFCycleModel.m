//
//  UCFCycleModel.m
//  JRGC
//
//  Created by 金融工场 on 15/1/16.
//  Copyright (c) 2015年 www.ucfgroup.com. All rights reserved.
//

#import "UCFCycleModel.h"
#import <objc/runtime.h>

@implementation UCFCycleModel

+ (UCFCycleModel *)getCycleModelByDataDict:(NSDictionary *)dicJson
{
    if (![dicJson isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    UCFCycleModel *model = [[UCFCycleModel alloc] init];
    unsigned int outCount,i;
    objc_property_t *keyList = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = keyList[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:key];
    }
    free(keyList);
    for (NSString *key in keys) {
        id propertyValue = [dicJson valueForKey:key];
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil) {
            [model setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
        } else {
            [model setValue:@"" forKey:key];
            DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
    }
    return model;
}

@end
