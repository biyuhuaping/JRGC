//
//  UCFMyInvestment.m
//  JRGC
//
//  Created by MAC on 14-10-8.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFMyInvestment.h"
#import <objc/runtime.h>

@implementation UCFMyInvestment

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

- (void)reflectDataFromOtherObject:(NSObject*)dataSource  dataType:(NSInteger)type

{
    for (NSString *key in [self propertyKeys]) {
        if (type == 1) {
            if ([key isEqualToString:@"completeLoan"]) {
                continue;
            }
        }
        id propertyValue = [dataSource valueForKey:key];
        //该值不为NSNULL，并且也不为nil
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
            [self setValue:[NSString stringWithFormat:@"%@", propertyValue] forKey:key];
        }else {
            [self setValue:@"" forKey:key];
            DLog(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
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
        [self reflectDataFromOtherObject:dicJson dataType:1];
    }
    return self;
}

-(id)initWithBorrowDictionary:(NSDictionary *)dicJson
{
    if (self = [super init])
    {
        if (![dicJson isKindOfClass:[NSDictionary class]])
        {
            return self;
        }
        [self reflectDataFromOtherObject:dicJson dataType:2];
    }
    return self;
}
@end
