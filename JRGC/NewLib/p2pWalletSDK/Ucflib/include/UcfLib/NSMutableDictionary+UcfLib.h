//
//  NSMutableDictionary+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (UcfLib)

- (NSString *)urlQueryWithAscending:(BOOL)ascending ignoreEmptyParam:(BOOL)ignore ignoreKeySet:(NSSet *)ignoreKeys joinedSeparator:(NSString *)separator;

- (NSString *)urlQueryWithAscending:(BOOL)ascending ignoreEmptyParam:(BOOL)ignore ignoreKeySet:(NSSet *)ignoreKeys;

@end
