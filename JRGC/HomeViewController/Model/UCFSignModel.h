//
//  UCFSignModel.h
//  JRGC
//
//  Created by njw on 2017/4/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFSignModel : NSObject

@property (nonatomic, copy) NSString *isOpen;
@property (nonatomic, copy) NSString *nextDayBeans;
@property (nonatomic, copy) NSString *returnAmount;
@property (nonatomic, copy) NSString *rewardAmt;
@property (nonatomic, copy) NSString *signDays;
@property (nonatomic, copy) NSString *totalCanUseScore;
@property (nonatomic, assign) BOOL win;
@property (nonatomic, copy) NSString *winAmount;

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)signWithDict:(NSDictionary *)dict;
@end
