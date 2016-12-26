//
//  FundsDetailModel.h
//  JRGC
//
//  Created by NJW on 15/4/28.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundsDetailModel : NSObject
@property (nonatomic, copy) NSString *waterTypeName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *cashValue;
@property (nonatomic, copy) NSString *frozen;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *actType;
@property (nonatomic, copy) NSString *yearMonth;

+ (instancetype)fundDetailModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
