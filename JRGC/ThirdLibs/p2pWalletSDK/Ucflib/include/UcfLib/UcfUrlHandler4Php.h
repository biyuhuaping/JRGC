//
//  UcfUrlHandler4Php.h
//  UcfLib
//
//  Created by 杨名宇 on 07/04/2017.
//  Copyright © 2017 Ucf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UcfUrlHandler4Php : NSObject

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
