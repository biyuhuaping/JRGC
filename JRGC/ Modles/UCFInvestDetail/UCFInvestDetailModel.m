//
//  UCFInvestDetailModel.m
//  JRGC
//
//  Created by NJW on 15/5/12.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFInvestDetailModel.h"
#import <objc/runtime.h>

@implementation UCFInvestDetailModel
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
        if ([key isEqualToString:@"Id"]) {
            id propertyValue = [dataSource valueForKey:@"id"];
            [self setValue:propertyValue forKey:key];
        }
        else if ([key isEqualToString:@"refundSummarys"]) {
            id propertyValue = [dataSource valueForKey:@"refundSummarys"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in propertyValue) {
                UCFRefundDetailModel *refundDetail = [UCFRefundDetailModel refundDetailWithDict:dict];
                [temp addObject:refundDetail];
            }
            self.refundSummarys = temp;
        }
        else if ([key isEqualToString:@"gradeIncreases"]) {
            id propertyValue = [dataSource valueForKey:@"gradeIncreases"];
            [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
        }
        else if ([key isEqualToString:@"contractClauses"]) {
            id propertyValue = [dataSource valueForKey:@"contractClauses"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in propertyValue) {
                UCFConstractModel *model = [UCFConstractModel constractWithDict:dict];
                [temp addObject:model];
            }
            self.contractClauses = temp;
        }
        else {
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil) {
                [self setValue:propertyValue forKey:key];
            } else {
                [self setValue:@"" forKey:key];
                DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
            }
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

+ (instancetype)investDetailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}
@end
