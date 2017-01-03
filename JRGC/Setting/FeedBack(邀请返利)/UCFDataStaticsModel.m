//
//  UCFDataStaticsModel.m
//  JRGC
//
//  Created by njw on 2016/12/30.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFDataStaticsModel.h"
#import <objc/runtime.h>

@implementation UCFDataStaticsModel
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
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil) {
            if ([key isEqualToString:@"chartDetail"]) {
                NSMutableArray *arry = [NSMutableArray array];
                for (NSDictionary *dic in propertyValue) {
                    UCFDataDetailModel *detail = [UCFDataDetailModel dataDetailModelWithDict:dic];
                    [arry addObject:detail];
                }
                self.chartDetail = arry;
            }
            else
                [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
        } else {
            [self setValue:@"" forKey:key];
            DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
    }
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

+ (instancetype)dataStaticsModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
