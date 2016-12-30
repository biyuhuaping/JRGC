//
//  UCFDataDetailModel.h
//  JRGC
//
//  Created by njw on 2016/12/30.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFDataDetailModel : NSObject
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *promotionCodeType;

+ (instancetype)dataDetailModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
