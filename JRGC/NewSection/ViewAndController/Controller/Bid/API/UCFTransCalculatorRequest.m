//
//  UCFTransCalculatorRequest.m
//  JRGC
//
//  Created by zrc on 2019/4/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransCalculatorRequest.h"
@interface UCFTransCalculatorRequest()

@property(nonatomic, strong)NSDictionary *dataDict;

@end

@implementation UCFTransCalculatorRequest

- (instancetype)initWithParmDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.dataDict = dict;
    }
    return self;
}
- (NSString *)requestUrl
{
    return @"newprdTransfer/newCompensateInterest";
}
- (id)requestArgument {
    return self.dataDict;
}
- (NSString *)modelClass
{
    //    添加新model
    return @"UCFCalulatorModel";
}

- (BOOL)oldGCApi
{
    // 添加新model
    return YES;
}
@end
