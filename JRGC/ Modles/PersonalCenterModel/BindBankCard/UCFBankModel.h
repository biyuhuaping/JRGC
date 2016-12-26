//
//  UCFBankModel.h
//  JRGC
//
//  Created by NJW on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFBankModel : NSObject
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isSupportQuickPay;

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)bankWithDict:(NSDictionary *)dict;
@end
