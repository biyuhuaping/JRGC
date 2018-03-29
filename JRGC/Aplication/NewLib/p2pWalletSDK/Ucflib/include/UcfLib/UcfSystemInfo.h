//
//  UcfSystemInfo.h
//  UcfWallet
//
//  Created by 杨名宇 on 16/1/25.
//  Copyright © 2016年 Ucf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UcfSystemInfo : NSObject

+ (NSString *)systemVersion;
+ (NSString *)appVersion;
+ (NSString *)appIdentifier;
+ (NSString *)deviceModel;
+ (NSString *)deviceUUID;

+ (BOOL)isJailBroken;

+ (NSString *)normalizedPlatform;
+ (NSString *)wifiMacAddress;
+ (NSString *)nativeDeviceUUID;

+ (BOOL)isPhoneSize35;
+ (BOOL)isPhoneSizeRetina35;
+ (BOOL)isPhoneSizeRetina4;

@end
