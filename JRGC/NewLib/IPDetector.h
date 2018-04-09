//
//  IPDetector.h
//  WhatIsMyIP
//
//  Created by ly on 14-2-24.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPDetector : NSObject

+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion;

+ (NSDictionary *)deviceWANIPAdress;

@end
