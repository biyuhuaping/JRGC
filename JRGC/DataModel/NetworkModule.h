//
//  NetworkModule.h
//  test
//
//  Created by JasonWong on 13-12-21.
//  Copyright (c) 2013年 Maxitech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "TypeDefine.h"
#import "PostRequest.h"

@interface NetworkModule : NSObject <ASIHTTPRequestDelegate>
{
    NSMutableDictionary* queue;
}
+ (NetworkModule*)sharedNetworkModule;
- (void)postReq:(NSString*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner;
- (void)postReq2:(NSDictionary*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner;
- (void)postData:(NSString*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner url:(NSString*)url;
- (void)cancel:(kSXTag)tag;
- (void)getReqData:(NSDictionary *)dataDict tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner;



#pragma mark NewPostMethod
/**
 *  新接口业务参数
 *
 *  @param data 业务参数字典
 *
 *  @param tag 接口请求标示
 *
 *  @param owner 当前VC
 *
 *  @param isSignature 当前接口是否需要验签
 *
 */
- (void)newPostReq:(NSDictionary*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner signature:(BOOL)isSignature;
@end
