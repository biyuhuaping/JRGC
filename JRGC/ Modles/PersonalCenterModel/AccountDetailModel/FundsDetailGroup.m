//
//  FundsDetailGroup.m
//  JRGC
//
//  Created by NJW on 15/4/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "FundsDetailGroup.h"
#import <objc/runtime.h>
#import "FundsDetailModel.h"

@implementation FundsDetailGroup
+ (instancetype)fundDetailGroupWithDict:(NSDictionary *)dict
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
        if ([key isEqualToString:@"content"]) {
            propertyValue = [dataSource valueForKey:@"content"];
            NSMutableArray *temp = [NSMutableArray array];
            if ([propertyValue isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in propertyValue) {
                    FundsDetailModel *model = [FundsDetailModel fundDetailModelWithDict:dict];
                    [temp addObject:model];
                }
                _content = temp;
            }
        }
        else {
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue && ![key isEqualToString:@"content"]) {
                [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
            }
            else {
                [self setValue:@"" forKey:key];
                DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
            }
        }
    }
}

//- (void)setContent:(NSDictionary *)content
//{
//    _content = content;
//    _fundsDetail = [FundsDetailModel fundDetailWithDict:content];
//}

@end
