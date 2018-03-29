//
//  UcfCKeyChainStore.h
//  UcfCKeyChainStore
//
//  Created by Kishikawa Katsumi on 11/11/20.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UcfCKeyChainStore : NSObject

@property (nonatomic, readonly) NSString *service;
@property (nonatomic, readonly) NSString *accessGroup;

+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (void)setString:(NSString *)value forKey:(NSString *)key;
+ (void)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service;
+ (void)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (NSData *)dataForKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (void)setData:(NSData *)data forKey:(NSString *)key;
+ (void)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service;
+ (void)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (void)removeItemForKey:(NSString *)key;
+ (void)removeItemForKey:(NSString *)key service:(NSString *)service;
+ (void)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (void)removeAllItems;
+ (void)removeAllItemsForService:(NSString *)service;
+ (void)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (UcfCKeyChainStore *)keyChainStore;
+ (UcfCKeyChainStore *)keyChainStoreWithService:(NSString *)service;
+ (UcfCKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup;
- (id)init;
- (id)initWithService:(NSString *)service;
- (id)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (void)setString:(NSString *)string forKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;

- (void)setData:(NSData *)data forKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;

- (void)removeItemForKey:(NSString *)key;
- (void)removeAllItems;

- (void)synchronize;

@end
