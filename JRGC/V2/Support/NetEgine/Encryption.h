//
//  Encryption.h
//  SDKDemo
//
//  Created by 张瑞超 on 2017/12/25.
//  Copyright © 2017年 zhangruichao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption : NSObject

+ (NSString *)AESWithKey:(NSString *)key WithDic:(NSDictionary *)dic;

/**
 获取设备imei

 @return 设备imei
 */
+ (NSString *)getKeychain;

/**
 获取当前app版本号

 @return app版本号
 */
+ (NSString *)getIOSVersion;


/**
 返回验签串

 @param par 参数字符串
 @return 验签串
 */
+ (NSString *) getSinatureWithPar:(NSString *) par;


+ (NSString *)dictTransToString:(NSDictionary *)dic;

+ (NSString*)dictionaryToJson:(id)dic;


@end
