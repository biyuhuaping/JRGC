//
//  UCFAttachModel.m
//  JRGC
//
//  Created by njw on 2017/9/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFAttachModel.h"
#import <objc/runtime.h>

@implementation UCFAttachModel
+ (instancetype)attachListWithDict:(NSDictionary *)dict
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
            [self setValue:propertyValue forKey:key];
        }
        else {
            [self setValue:@"" forKey:key];
        }
        
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
