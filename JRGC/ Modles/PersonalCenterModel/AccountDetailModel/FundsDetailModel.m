//
//  FundsDetailModel.m
//  JRGC
//
//  Created by NJW on 15/4/28.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "FundsDetailModel.h"
#import <objc/runtime.h>

@implementation FundsDetailModel
+ (instancetype)fundDetailModelWithDict:(NSDictionary *)dict
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
        [self refletDataFromOtherObject:dict];
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
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue) {
            if ([key isEqualToString:@"waterTypeName"]&&[propertyValue isEqualToString:@""]) {
                [self setValue:[dataSource valueForKey:@"remark"] forKey:key];
            }
            else if ([key isEqualToString:@"actType"]) {
                id propertyValue = [dataSource valueForKey:key];
                if ([propertyValue integerValue]==3) {
                    [self setValue:@"资金账户" forKey:key];
                }
                else if ([propertyValue integerValue] == 5) {
                    [self setValue:@"工豆账户" forKey:key];
                }
            }
            
            else [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
        }
        else {
            [self setValue:@"" forKey:key];
            DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@", self.waterTypeName, self.actType, self.createTime, self.cashValue, self.remark, self.frozen];
}
@end
