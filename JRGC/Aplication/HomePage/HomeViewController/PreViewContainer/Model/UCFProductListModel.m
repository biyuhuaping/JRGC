//
//  UCFProductListModel.m
//  JRGC
//
//  Created by hanqiyuan on 2017/5/5.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFProductListModel.h"
#import <objc/runtime.h>

@implementation UCFProductListModel

+ (instancetype)productListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSDictionary class]])
        {
            return self;
        }
        if (![dict isEqual:@{}] && dict != nil) {
            [self refletDataFromOtherObject:dict];
        }
    }
    
    return self;
}

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
        if ([key isEqualToString:@"descriptionStr"]) {
            propertyValue = [dataSource valueForKey:@"description"];
        }
        
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue) {
            [self setValue:propertyValue forKey:key];
        }
        else {
            
            [self setValue:@"" forKey:key];
            DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
        
    }
}

@end
