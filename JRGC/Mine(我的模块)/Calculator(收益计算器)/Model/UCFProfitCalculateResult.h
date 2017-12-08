//
//  UCFProfitCalculateResult.h
//  JRGC
//
//  Created by njw on 2017/12/8.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFProfitCalculateResult : NSObject
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *interestTotal;
@property (nonatomic, strong) NSNumber *investAmt;
@property (nonatomic, copy) NSString *lastInterest;
@property (nonatomic, strong) NSNumber *payMentMethod;
@property (nonatomic, strong) NSNumber *rate;
@property (nonatomic, strong) NSNumber *term;
@property (nonatomic, copy) NSString *total;

+ (instancetype)profitCalcultateResultWithDict:(NSDictionary *)dict;
@end
