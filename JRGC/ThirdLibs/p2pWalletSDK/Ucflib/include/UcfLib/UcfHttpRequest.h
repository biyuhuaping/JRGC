//
//  UcfHttpRequest.h
//  UcfLib
//
//  Created by 杨名宇 on 07/04/2017.
//  Copyright © 2017 Ucf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UcfHttpRequest : NSObject

+ (instancetype)shareInstance;

- (void)httpPost:(NSString *)serverUrl
            path:(NSString *)path
      postParams:(NSMutableDictionary *)params
        useHttps:(BOOL)used
   encryptParams:(BOOL)encrypted
        needSign:(BOOL)sign
      ignoreSign:(NSMutableDictionary *)ignores
       successed:(void (^)(NSDictionary *resultDict))successBlock
          failed:(void (^)(NSDictionary *resultDict))failBlock
    rsaPublicKey:(NSString *)rsaKey
      appVersion:(NSString *)appVersion
   serverVersion:(NSString *)serverVersion
         channel:(NSString *)channel
      serverType:(NSString *)serverType;//Java:@"Java",PHP:@"Php"

@end
