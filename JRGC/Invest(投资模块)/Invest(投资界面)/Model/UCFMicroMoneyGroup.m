//
//  UCFMicroMoneyGroup.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMicroMoneyGroup.h"
#import <objc/runtime.h>
#import "UCFMicroMoneyModel.h"

@implementation UCFMicroMoneyGroup

+ (instancetype)microMoneyGroupWithDict:(NSDictionary *)dict
{
    return [self homeListGroupWithDict:dict];
}

+ (instancetype)homeListGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
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
            if ([key isEqualToString:@"prdlist"]) {
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                for (NSDictionary *tempDict in propertyValue) {
                    UCFMicroMoneyModel *model = [UCFMicroMoneyModel microMoneyModelWithDict:tempDict];
                    [temp addObject:model];
                }
                self.prdlist = temp;
            }
            else
                [self setValue:propertyValue forKey:key];
        } else {
            if ([key isEqualToString:@"showMore"]) {
                [self setShowMore:[propertyValue boolValue]];
            }
            else
                [self setValue:@"" forKey:key];
            DDLogDebug(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
