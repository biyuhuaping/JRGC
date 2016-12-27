//
//  UCFRedEnvelopeModel.m
//  JRGC
//
//  Created by NJW on 15/5/14.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRedEnvelopeModel.h"
#import <objc/runtime.h>

@implementation UCFRedEnvelopeModel
- (NSArray*)propertyKeys
{
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

- (void)refletDataFromOtherObject:(id)dataSource
{
    for (NSString *key in [self propertyKeys]) {
        id propertyValue = [dataSource valueForKey:key];
        if ([key isEqualToString:@"redEnvelopeType"]) {
            return;
        }
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil) {
            [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
        } else {
            [self setValue:@"" forKey:key];
//          DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
    }
}

-(id)initWithDictionary:(NSDictionary *)dicJson
{
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

+ (instancetype)redEnvelopeWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}
@end
