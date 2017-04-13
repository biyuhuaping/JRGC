//
//  UCFAccount.h
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFAccount : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *source_type;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString * isSubmitAppStoreAndTestTime;
@property (nonatomic, copy) NSString *jg_nyscclnjsygjr;

+ (instancetype)accountWithDict:(NSDictionary *)dic;

+ (NSDictionary *)dicWithAccount:(UCFAccount *)account;
@end
