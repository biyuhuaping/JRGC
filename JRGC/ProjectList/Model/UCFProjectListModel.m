//
//  UCFProjectListModel.m
//  JRGC
//
//  Created by NJW on 2016/11/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFProjectListModel.h"
#import "UCFProjectLabel.h"
#import <objc/runtime.h>

@implementation UCFProjectListModel

+ (instancetype)projectListWithDict:(NSDictionary *)dict
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
        id propertyValue;
        if ([key isEqualToString:@"Id"]) {
            propertyValue  = [dataSource valueForKey:@"id"];
        }
        else propertyValue = [dataSource valueForKey:key];
        
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue) {
            if ([key isEqualToString:@"prdLabelsList"]) {
                NSArray *array = (NSArray *)propertyValue;
                if (array.count > 0) {
                    NSMutableArray *temp = [NSMutableArray array];
                    for (NSDictionary *dict in array) {
                        UCFProjectLabel *pLabel = [UCFProjectLabel projectLabelWithDict:dict];
                        [temp addObject:pLabel];
                    }
                    self.prdLabelsList = temp;
                }
            }
            else
                [self setValue:propertyValue forKey:key];
        }
        else {
            if ([key isEqualToString:@"isAnim"]) {
                [self setIsAnim:NO];
            }
            else
                [self setValue:@"" forKey:key];
            DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
        
    }
}

@end
