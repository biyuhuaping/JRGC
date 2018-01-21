//
//  UserInfoSingle.m
//  JRGC
//
//  Created by 金融工场 on 16/8/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UserInfoSingle.h"
#import <objc/runtime.h>
#import "Growing.h"
#import "MongoliaLayerCenter.h"
#import "JSONKit.h"
#import "UIDic+Safe.h"
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
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRealName:(NSString *)realName {
    _realName = realName;
    [[NSUserDefaults standardUserDefaults] setValue:realName forKey:REALNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setIsRisk:(BOOL)isRisk
{
    _isRisk = isRisk;
    [[NSUserDefaults standardUserDefaults] setBool:isRisk forKey:@"isRisk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsAutoBid:(BOOL)isAutoBid
{
    _isAutoBid = isAutoBid;
    [[NSUserDefaults standardUserDefaults] setBool:isAutoBid forKey:@"isAutoBid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsSpecial:(BOOL)isSpecial {
    _isSpecial = isSpecial;
//    [[NSUserDefaults standardUserDefaults] setValue:isSpecial forKey:@"isSpecial"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setCompanyAgent:(BOOL)companyAgent{
    _companyAgent = companyAgent;
}

- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    [[NSUserDefaults standardUserDefaults] setValue:mobile forKey:PHONENUM];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)setEnjoyOpenStatus:(NSInteger)states
{
    _enjoyOpenStatus = states;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:states] forKey:EnjoyState];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)setUserData:(NSDictionary *)dict {
    [self reflectDataFromOtherObject:dict];
    [self storeUserCache:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userisloginandcheckgrade" object:@(YES)];
}

- (void)setGcm_code:(NSString *)gcm_code
{
    _gcm_code = gcm_code;
    [[NSUserDefaults standardUserDefaults] setValue:gcm_code forKey:GCMCODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    self.enjoyOpenStatus = [[[NSUserDefaults standardUserDefaults] valueForKey:EnjoyState] integerValue];
    self.zxAuthorization = [[[NSUserDefaults standardUserDefaults]valueForKey:HONERAUTHORIZATION] boolValue];
    self.goldAuthorization = [[[NSUserDefaults standardUserDefaults]valueForKey:GOldAUTHORIZATION] boolValue];
//    self.userLevel = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LEVEL];
    self.isRisk = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRisk"];
    self.isAutoBid = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoBid"];
    self.gcm_code = [[NSUserDefaults standardUserDefaults]valueForKey:GCMCODE];
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
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"enjoyOpenStatus"] forKey:EnjoyState];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"nmAuthorization"] forKey:GOldAUTHORIZATION];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"zxAuthorization"] forKey:HONERAUTHORIZATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //  GrowingIO添加字段
    [Growing setCS1Value:dict[@"userId"] forKey:@"user_Id"];
    [Growing setCS2Value:[[NSUserDefaults standardUserDefaults] objectForKey:GCMCODE] forKey:@"user_gcm"];
    if (dict[@"realName"] == nil || [dict[@"realName"] isEqualToString:@""]) {
        [Growing setCS3Value:@"" forKey:@"user_name"];
    }
    else {
        [Growing setCS3Value:dict[@"realName"] forKey:@"user_name"];
    }
}

//- (void)setUserLevel:(NSString *)userLevel
//{
//    _userLevel = userLevel;
//    [[NSUserDefaults standardUserDefaults] setValue:userLevel forKey:USER_LEVEL];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

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
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_LEVEL];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:GOldAUTHORIZATION];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:GCMCODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //  GrowingIO删除字段
    [Growing setCS1Value:nil forKey:@"user_Id"];
    [Growing setCS2Value:nil forKey:@"user_gcm"];
    [Growing setCS3Value:nil forKey:@"user_name"];
    self.userId = nil;
    self.time = -1;
    self.jg_ckie = nil;
    self.loginName = nil;
    self.headerUrl = nil;
    _mobile = nil;
    _realName = nil;
    _openStatus = -1;
    self.companyAgent = NO;
    self.isRisk = NO;
    self.isAutoBid = NO;
    self.zxAuthorization = NO;
//    self.userLevel = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userisloginandcheckgrade" object:@(NO)];
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
            
            //该e值不为NSNULL，并且也不为nil
           if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
               if ([key isEqualToString:@"isSpecial"]) {
                   [self setIsSpecial:[propertyValue boolValue]];
               }
               else
                   [self setValue:propertyValue forKey:key];
           }
        }
    }
    return ret;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
#warning about supervise
        self.superviseSwitch = YES;
        self.level = 1;
        self.goldIsNew = YES;
        self.zxIsNew = YES;
    }
    return self;
}

#warning check userinfo on supervise
- (void)checkUserLevelOnSupervise {
    if (!self.userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId": self.userId} tag:kSXTagSuperviseUserInfo owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    if (tag.integerValue == kSXTagSuperviseUserInfo) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSDictionary *res = [dic objectSafeDictionaryForKey:@"data"];
            NSString *compliance = [res objectSafeForKey:@"compliance"];
            if ([compliance isEqualToString:@"1"]) {
                self.superviseSwitch = NO;
            }
            else if ([compliance isEqualToString:@"2"]) {
                self.superviseSwitch = YES;
            }
            else {
                self.superviseSwitch = YES;
            }
            self.level = [[res objectSafeForKey:@"level"] intValue];
            self.goldIsNew = [[res objectSafeForKey:@"goldIsNew"] boolValue];
            self.zxIsNew = [[res objectSafeForKey:@"zxIsNew"] boolValue];
//            self.level = 1;
//            self.goldIsNew = YES;
//            self.zxIsNew = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSuperviseView" object:nil];
            
        }else {
            self.superviseSwitch = YES;
            self.level = 1;
            self.goldIsNew = YES;
            self.zxIsNew = YES;
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    if (tag.integerValue == kSXTagSuperviseUserInfo) {
        self.superviseSwitch = YES;
        self.level = 1;
        self.goldIsNew = YES;
        self.zxIsNew = YES;
    }
}

@end
