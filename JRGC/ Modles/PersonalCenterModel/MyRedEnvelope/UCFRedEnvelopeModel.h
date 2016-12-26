//
//  UCFRedEnvelopeModel.h
//  JRGC
//
//  Created by NJW on 15/5/14.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

typedef enum : NSUInteger {
    UCFRedEnvelopeStateSent,
    UCFRedEnvelopeStateknocked
} UCFRedEnvelopeState;

#import <Foundation/Foundation.h>

@interface UCFRedEnvelopeModel : NSObject
@property (nonatomic, copy) NSString *beanAmount;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, strong) NSNumber *drewardamt;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *readyCount;
@property (nonatomic, copy) NSString *redCount;
@property (nonatomic, copy) NSString *redInvest;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) UCFRedEnvelopeState redEnvelopeType;



-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)redEnvelopeWithDict:(NSDictionary *)dict;
@end
