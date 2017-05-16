//
//  UCFDataStaticsModel.h
//  JRGC
//
//  Created by njw on 2016/12/30.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFDataDetailModel.h"

@interface UCFDataStaticsModel : NSObject
@property (nonatomic, strong) NSArray *chartDetail;
@property (nonatomic, copy) NSString *searchMonth;
@property (nonatomic, strong) NSNumber *totalAmount;
@property (nonatomic, copy) NSString *type;

+ (instancetype)dataStaticsModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
