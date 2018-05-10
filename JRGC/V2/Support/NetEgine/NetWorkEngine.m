//
//  NetWorkEngine.m
//  ZXB
//
//  Created by zrc on 2018/2/23.
//  Copyright © 2018年 UCFGROUP. All rights reserved.
//

#import "NetWorkEngine.h"
#import "NetWorkingManager.h"
#import "Encryption.h"
#import "API_Container.h"

@implementation NetWorkEngine

+ (NetWorkEngine *)sharedManager
{
    static NetWorkEngine *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (void)postRequestByServiceApi:(NSString *)api
                      andParams:(NSDictionary *)params
                  andIsSinature:(BOOL)isSignature
                       andType:(SelectAccoutType)type
             andSuccessCallBack:(void (^)(BOOL isSuccess, id responseObject))success
               andErrorCallBack:(void(^) (NSError *error))failure
{
    //给原有参数字典添加公共参数
    if (!params) {
        params = [NSDictionary dictionary];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setValue:@"1" forKey:@"sourceType"];
    NSString *tmpKeychain = [Encryption getKeychain];
    [dict setValue:tmpKeychain forKey:@"imei"];
    [dict setValue:[Encryption getIOSVersion] forKey:@"version"];
    switch (type) {
        case SelectAccoutTypeP2P:
            [dict setValue:@"1" forKey:@"fromSite"];
            break;
        case SelectAccoutTypeHoner:
            [dict setValue:@"2" forKey:@"fromSite"];
            break;
        case SelectAccoutDefault:
            break;
        default:
            break;
    }
    if(isSignature) //是否需要验签
    {
        NSString *signature = [Encryption getSinatureWithPar:[self newGetParStr:dict]];
        [dict setValue:signature forKey:@"signature"];
    }
    NSString *encryptParam  = [Encryption AESWithKey:AES_TESTKEY WithDic:dict];
    NSDictionary *postDict = [NSDictionary dictionaryWithObject:encryptParam forKey:@"encryptParam"];
    [NetWorkingManager sendPOSTDataWithPath:[NSString stringWithFormat:@"%@%@",SERVER_IP_ONLINE_P2P,api] withParamters:postDict withProgress:nil success:success failure:failure];
}



- (void)postRequestByServiceApi:(NSString *)api
                      andParams:(NSDictionary *)params
                    andProgress:(void (^)(float progress))progress
             andSuccessCallBack:(void (^)(BOOL isSuccess, id responseObject))success
               andErrorCallBack:(void (^)(NSError *error))failure
{
    //给原有参数字典添加公共参数
    if (!params) {
        params = [NSDictionary dictionary];
    }
        
    if ([[params allKeys] containsObject:@"userId"]) {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [tmpDict removeObjectForKey:@"imgCode"];
        NSString *encryptParam  = [Encryption AESWithKey:AES_TESTKEY WithDic:tmpDict];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionaryWithDictionary:tmpDict];
        [parmDict setValue:encryptParam forKey:@"encryptParam"];
        [parmDict setValue:params[@"imgCode"] forKey:@"imgCode"];
    }
}
- (void)cancleRequestApiName:(NSString *)apiName
{
    [NetWorkingManager cancelHttpRequestWithType:@"PSOT" WithPath:apiName];
}
//新版通过字典获取值拼成的字符串
- (NSString *)newGetParStr:(NSDictionary *)dataDict
{
    NSArray *valuesArr = [dataDict allValues];
    NSString *lastStr = @"";
    if (!valuesArr || valuesArr.count > 0) {
        for (int i = 0; i< valuesArr.count; i++) {
            lastStr = [lastStr stringByAppendingString:[valuesArr objectAtIndex:i]];
        }
    }
    return lastStr;
}
@end
