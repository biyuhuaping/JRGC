//
//  UCFTransterBidHeadDetail.m
//  JRGC
//
//  Created by MAC on 14-9-26.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFTransterBidHeadDetail.h"
#import <objc/runtime.h>

@implementation UCFTransterBidHeadDetail

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
            [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:key];
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

@end
