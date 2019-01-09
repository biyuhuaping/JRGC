//
//  UCFPersonalInfoModel.m
//  JRGC
//
//  Created by NJW on 15/4/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFPersonalInfoModel.h"
#import <objc/runtime.h>
#import "Common.h"

@implementation UCFPersonalInfoModel
+ (instancetype)personalInfoModelWithDict:(NSDictionary *)dict
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
//        [self saveUserInfoWith:self];
    }
    
    return self;
}

//+ (instancetype)defaultPersonalInfo
//{
//    NSString *filePath = [Common filePathWithFileName:@"personalInfo.arc"];
//    BOOL b = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//    if (b) {
//        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//    }
//    return nil;
//}
//
//// 存储用户信息
//- (void)saveUserInfoWith:(id)model
//{
//    NSString *filePath = [Common filePathWithFileName:@"personalInfo.arc"];
//    BOOL b = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//    if (b) {
//        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//    }
//    [NSKeyedArchiver archiveRootObject:model toFile:filePath];
//}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if (self) {
//        _prdOrderCount = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:@"prdOrderCount"]];
//        _cashBalance = [aDecoder decodeObjectForKey:@"cashBalance"];
//        _headurl = [aDecoder decodeObjectForKey:@"headurl"];
//        _interests = [aDecoder decodeObjectForKey:@"interests"];
//        _loginName = [aDecoder decodeObjectForKey:@"loginName"];
//        _principal = [aDecoder decodeObjectForKey:@"principal"];
//        _sex = [aDecoder decodeObjectForKey:@"sex"];
//        _state = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:@"state"]];
//        _userId = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:@"userId"]];
//        _userName = [aDecoder decodeObjectForKey:@"userName"];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeInteger:[_prdOrderCount integerValue] forKey:@"prdOrderCount"];
//    [aCoder encodeObject:_cashBalance forKey:@"cashBalance"];
//    [aCoder encodeObject:_headurl forKey:@"headurl"];
//    [aCoder encodeObject:_interests forKey:@"interests"];
//    [aCoder encodeObject:_loginName forKey:@"loginName"];
//    [aCoder encodeObject:_principal forKey:@"principal"];
//    [aCoder encodeObject:_sex forKey:@"sex"];
//    [aCoder encodeInteger:[_state integerValue] forKey:@"state"];
//    [aCoder encodeInteger:[_userId integerValue] forKey:@"userId"];
//    [aCoder encodeObject:_userName forKey:@"userName"];
//}

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
        if ([key isEqualToString:@"prdOrderCount"]) {
            propertyValue = [dataSource valueForKey:@"PrdOrderCount"];
        }
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue) {
            [self setValue:propertyValue forKey:key];
        }
        else {
            [self setValue:@"" forKey:key];
            DDLogDebug(@"%@",[NSString stringWithFormat:@"字段值%@读取异常(字段不存在或者值为空)",key]);
        }
        
    }
}
@end
