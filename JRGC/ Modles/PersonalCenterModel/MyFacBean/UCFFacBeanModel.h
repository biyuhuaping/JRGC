//
//  UCFFacBeanModel.h
//  JRGC
//
//  Created by NJW on 15/5/12.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UCFMyFacBeanStateUnused=0,
    UCFMyFacBeanStateOverdue,
    UCFMyFacBeanStateUsed,
    UCFMyFacBeanStateOverduing
} MyFacBeanCurrentState;

@interface UCFFacBeanModel : NSObject
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *investMultip;
@property (nonatomic, copy) NSString *overdueTime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *useInvest;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *useTime;
@property (nonatomic, copy) NSString *issue_time;

@property (nonatomic, assign) MyFacBeanCurrentState state;

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)facBeanWithDict:(NSDictionary *)dict;
@end
