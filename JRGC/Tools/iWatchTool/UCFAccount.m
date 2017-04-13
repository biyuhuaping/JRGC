//
//  UCFAccount.m
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFAccount.h"

#define UCFAccountId @"accountId"
#define UCFSourceType @"sourceType"
#define UCFSourceImei @"sourceImei"
#define UCFAppVersion @"appviersion"
#define UCFAccountSignature @"accountSignature"
#define UCFisSubmitAppStoreAndTestTime @"isSubmitAppStoreAndTestTime"
#define UCFJg_nyscclnjsygjr  @"jg_nyscclnjsygjr"

@implementation UCFAccount
+ (instancetype)accountWithDict:(NSDictionary *)dic{
    UCFAccount *account = [[self alloc] init];
    [account setValuesForKeysWithDictionary:dic];
    return account;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (NSDictionary *)dicWithAccount:(UCFAccount *)account{
    NSDictionary *dic = @{
           @"userId": account.userId != nil ? account.userId : @"",
           @"source_type" : account.source_type != nil ? account.source_type : @"",
           @"imei" : account.imei != nil ? account.imei : @"",
           @"version" : account.version != nil ? account.version : @"",
           @"signature" : account.signature != nil ? account.signature : @"",
           @"isSubmitAppStoreAndTestTime": account.isSubmitAppStoreAndTestTime != nil? account.isSubmitAppStoreAndTestTime:@"",
           @"jg_nyscclnjsygjr": account.jg_nyscclnjsygjr != nil ? account.jg_nyscclnjsygjr :@""
           };
    return dic;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_userId forKey:UCFAccountId];
    [aCoder encodeObject:_source_type forKey:UCFSourceType];
    [aCoder encodeObject:_imei forKey:UCFSourceImei];
    [aCoder encodeObject:_version forKey:UCFAppVersion];
    [aCoder encodeObject:_signature forKey:UCFAccountSignature];
    [aCoder encodeObject:_isSubmitAppStoreAndTestTime forKey:UCFisSubmitAppStoreAndTestTime];
    [aCoder encodeObject:_jg_nyscclnjsygjr forKey:UCFJg_nyscclnjsygjr];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _userId = [aDecoder decodeObjectForKey:UCFAccountId];
        _source_type = [aDecoder decodeObjectForKey:UCFSourceType];
        _imei = [aDecoder decodeObjectForKey:UCFSourceImei];
        _version = [aDecoder decodeObjectForKey:UCFAppVersion];
        _signature = [aDecoder decodeObjectForKey:UCFAccountSignature];
        _isSubmitAppStoreAndTestTime = [aDecoder decodeObjectForKey:UCFisSubmitAppStoreAndTestTime];
        _jg_nyscclnjsygjr = [aDecoder decodeObjectForKey:UCFJg_nyscclnjsygjr];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"account dealloc");
}
@end
