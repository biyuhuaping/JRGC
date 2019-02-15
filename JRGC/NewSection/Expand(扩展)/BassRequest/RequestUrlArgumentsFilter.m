//
//  RequestUrlArgumentsFilter.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "RequestUrlArgumentsFilter.h"

#import "AFURLRequestSerialization.h"
#import "Encryption.h"

@implementation RequestUrlArgumentsFilter
{
    NSDictionary *_arguments;
}

+ (RequestUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    return [self urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}

- (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *paraUrlString = AFQueryStringFromParameters(parameters);
    
    if (!(paraUrlString.length > 0)) {
        return originUrlString;
    }
    
    BOOL useDummyUrl = NO;
    static NSString *dummyUrl = nil;
    NSURLComponents *components = [NSURLComponents componentsWithString:originUrlString];
    if (!components) {
        useDummyUrl = YES;
        if (!dummyUrl) {
            dummyUrl = SERVER_IP;
        }
        components = [NSURLComponents componentsWithString:dummyUrl];
    }
    
    NSString *queryString = components.query ?: @"";
    NSString *newQueryString = [queryString stringByAppendingFormat:queryString.length > 0 ? @"&%@" : @"%@", paraUrlString];
    
    components.query = newQueryString;
    
    if (useDummyUrl) {
        return [components.URL.absoluteString substringFromIndex:dummyUrl.length - 1];
    } else {
//        return components.URL.absoluteString;
        return components.path;
    }
}


- (NSDictionary *)filterParameters:(NSDictionary *)originParameters withRequest:(YTKBaseRequest *)request
{
    return [self parametersStringWithOriginParametersString:originParameters appendParameters:_arguments withRequest:request];
}
- (NSDictionary *)parametersStringWithOriginParametersString:(NSDictionary *)originParameters appendParameters:(NSDictionary *)parameters withRequest:(YTKBaseRequest *)request{
    
    NSMutableDictionary *tempParametersDic = [NSMutableDictionary dictionary];
    [tempParametersDic addEntriesFromDictionary:originParameters];
    [tempParametersDic addEntriesFromDictionary:parameters];
    if (SingleUserInfo.loginData.userInfo.userId) {
        [tempParametersDic setValue:SingleUserInfo.loginData.userInfo.userId forKey:@"userId"];
    }
    NSDictionary *parametersDic = [Encryption getSinaturDictWithOrginalDict:tempParametersDic];
    NSString *encryptParam  = [Encryption AESWithKey:AES_TESTKEY WithDic:parametersDic];
    NSDictionary *postDict = [NSDictionary dictionaryWithObject:encryptParam forKey:@"encryptParam"];
    return postDict;
}

@end
