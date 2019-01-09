//
//  UCFTransterBid.m
//  JRGC
//
//  Created by MAC on 14-9-23.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFTransterBid.h"
#import <objc/runtime.h>

@implementation UCFTransterBid

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
        if ([key isEqualToString:@"transtrId"]) {
            propertyValue = [dataSource valueForKey:@"id"];
        }
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue) {
            [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
        } else if ([key isEqualToString:@"isAnim"]) {
            
        } else {
            [self setValue:@"" forKey:key];
            DDLogDebug(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
    }
}

//初始化方法
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

#pragma mark

-(void) encodeWithCoder: (NSCoder *) aCoder{
    for (NSString *key in [self propertyKeys]) {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}
-(id) initWithCoder: (NSCoder *) aDecoder{
    if (self = [super init]) {
        for (NSString *key in [self propertyKeys]) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return (self);
}

@end
