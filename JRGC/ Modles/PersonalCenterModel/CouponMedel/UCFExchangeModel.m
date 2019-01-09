//
//  UCFExchangeModel.m
//  JRGC
//
//  Created by biyuhuaping on 16/4/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFExchangeModel.h"
#import <objc/runtime.h>

@implementation UCFExchangeModel

- (NSArray*)propertyKeys{
    unsigned int outCount;
    objc_property_t *keyList = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = keyList[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:key];
    }
    free(keyList);
    return keys;
}

- (void)refletDataFromOtherObject:(id)dataSource{
    for (NSString *key in [self propertyKeys]) {
        id propertyValue = [dataSource valueForKey:key];
        if ([key isEqualToString:@"state"]) {
            return;
        }
        else {
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil) {
                [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
            } else {
                [self setValue:@"" forKey:key];
                //                DDLogDebug(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
            }
        }
    }
}

- (id)initWithDictionary:(NSDictionary *)dicJson{
    if (self = [super init])
    {
        if (![dicJson isKindOfClass:[NSDictionary class]])
        {
            return self;
        }
        [self refletDataFromOtherObject:dicJson];
    }
    return self;
}

+ (instancetype)couponWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

@end
