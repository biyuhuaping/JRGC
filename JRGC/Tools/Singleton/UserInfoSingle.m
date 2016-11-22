//
//  UserInfoSingle.m
//  JRGC
//
//  Created by 金融工场 on 16/8/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UserInfoSingle.h"
#import <objc/runtime.h>
@implementation UserInfoSingle

+ (UserInfoSingle *)sharedManager
{
    static UserInfoSingle *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

#pragma mark - set
- (void)setOpenStatus:(NSInteger)states {
    _openStatus = states;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:states] forKey:OPENSTATUS];
}

- (void)setRealName:(NSString *)realName {
    _realName = realName;
    [[NSUserDefaults standardUserDefaults] setValue:realName forKey:REALNAME];
}

- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    [[NSUserDefaults standardUserDefaults] setValue:mobile forKey:PHONENUM];
}


- (void)setUserData:(NSDictionary *)dict {
    [self reflectDataFromOtherObject:dict];
    [self storeUserCache:dict];
}
//程序启动的时候 获取用户对象数据
- (void)getUserData
{
    self.userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    self.time = [[[NSUserDefaults standardUserDefaults] valueForKey:TIME] integerValue];
    self.jg_ckie = [[NSUserDefaults standardUserDefaults] valueForKey:DOPA];
    self.loginName = [[NSUserDefaults standardUserDefaults] valueForKey:LOGINNAME];
    self.headerUrl = [[NSUserDefaults standardUserDefaults] valueForKey:HEADURL];
    _mobile = [[NSUserDefaults standardUserDefaults] valueForKey:PHONENUM];
    _realName = [[NSUserDefaults standardUserDefaults] valueForKey:REALNAME];
    _openStatus = [[[NSUserDefaults standardUserDefaults] valueForKey:OPENSTATUS] integerValue];
    self.companyAgent = [[[NSUserDefaults standardUserDefaults] valueForKey:COMPANYAGENT] boolValue];
}
//存储用户信息
- (void)storeUserCache:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"userId"] forKey:UUID];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"time"] forKey:TIME];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"jg_ckie"] forKey:DOPA];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"loginName"] forKey:LOGINNAME];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"headerUrl"] forKey:HEADURL];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"mobile"] forKey:PHONENUM];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"realName"] forKey:REALNAME];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"openStatus"] forKey:OPENSTATUS];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"isCompanyAgent"] forKey:COMPANYAGENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeUserInfo
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UUID];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:TIME];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:DOPA];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LOGINNAME];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:HEADURL];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:PHONENUM];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:REALNAME];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:OPENSTATUS];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:COMPANYAGENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.userId = nil;
    self.time = -1;
    self.jg_ckie = nil;
    self.loginName = nil;
    self.headerUrl = nil;
    _mobile = nil;
    _realName = nil;
    _openStatus = -1;
    self.companyAgent = NO;
}
- (void)updateOpenStatus:(NSInteger)openStatus
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:openStatus] forKey:OPENSTATUS];
    self.openStatus = openStatus;
}
-(NSArray*)propertyKeys
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

-(BOOL)reflectDataFromOtherObject:(NSObject*)dataSource
{
    BOOL ret = NO;
    for (NSString *key in [self propertyKeys]) {
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            //该值不为NSNULL，并且也不为nil
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                [self setValue:propertyValue forKey:key];
            }
        }
    }
    return ret;
}

@end
