//
//  UIDic+Safe.h
//  JYDReserve
//
//  Created by 卢俊城 on 14-8-6.
//  Copyright (c) 2014年 卢俊城. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)
//key对应的value为字符串  当value为空、null、返回为@"" 空字符串
- (id)objectSafeForKey:(NSString *)key;
//key对应的value为字典   当value为空、null、返回为@{} 空字典
- (id)objectSafeDictionaryForKey:(NSString *)key;
//key对应的value为数组   当value为空、null、返回为@[] 空数组
- (id)objectSafeArrayForKey:(NSString *)key;
//字典中是否存在 key
- (BOOL)isExistenceforKey:(NSString *)key;
@end
