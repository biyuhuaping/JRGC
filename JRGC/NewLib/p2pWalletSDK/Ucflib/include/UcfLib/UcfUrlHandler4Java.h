//
//  UcfUrlHandler.h
//  UcfPaySDK
//
//  Created by vinn on 5/21/14.
//  Copyright (c) 2014 UCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UcfUrlHandler4Java : NSObject

+ (NSString *)urlHandler:(NSString *)baseUrl
                    path:(NSString *)path
             queryParams:(NSMutableDictionary *)params
                useHttps:(BOOL)https
            encryptQuery:(BOOL)encrypted
                needSign:(BOOL)sign
              ignoreSign:(NSMutableDictionary *)ignores
                     key:(NSString *)pwd
                 session:(NSString *)skey
            rsaPublicKey:(NSString *)rsaKey
              appVersion:(NSString *)appVersion
           serverVersion:(NSString *)serverVersion
                 channel:(NSString *)channel;

@end
