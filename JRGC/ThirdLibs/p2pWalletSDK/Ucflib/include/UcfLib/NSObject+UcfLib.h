//
//  NSObject+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UcfLib)

- (id)associatedObjectForKey:(NSString*)key;
- (void)setAssociatedObject:(id)object forKey:(NSString*)key;

@end
