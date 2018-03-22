//
//  OriginalObject.h
//  weakCategory
//
//  Created by zrc on 2018/3/22.
//  Copyright © 2018年 zrc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DeallocBlock)(void);
@interface OriginalObject : NSObject
@property (nonatomic,copy) DeallocBlock block;
- (instancetype)initWithBlock:(DeallocBlock)block;
@end
