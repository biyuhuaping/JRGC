//
//  UCFAccountTool.h
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UCFAccount;
@interface UCFAccountTool : NSObject
+ (void)saveAccount:(UCFAccount *)account;
+ (UCFAccount *)account;
+ (void)deleteAccout;
@end
