//
//  UCFNetwork.h
//  Test01
//
//  Created by NJW on 16/10/19.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkSetting.h"

#define TIMEOUT  60 //请求超时 时长

@class AFNetworking;
@interface UCFNetwork : NSObject
#pragma mark - 监测网络状态
+ (void)netWorkStatus;

#pragma mark - GET请求
+ (void)GETWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(void (^)(id json))success fail:(void (^)())fail;

#pragma mark - POST请求
+ (void)POSTWithUrl:(NSString *)url parameters:(NSDictionary *)dict isNew:(BOOL)isNew success:(void (^)(id json))success fail:(void (^)())fail;
@end
