//
//  UCFRefundDetailModel.h
//  JRGC
//
//  Created by NJW on 15/5/12.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFRefundDetailModel : NSObject
// 回款时间
@property (nonatomic, copy) NSString *repayPerDate;
// 回款类型
@property (nonatomic, copy) NSString *type;
// 回款金额
@property (nonatomic, strong) NSString *interest;
// 回款状态
@property (nonatomic, copy) NSString *status;

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)refundDetailWithDict:(NSDictionary *)dict;
@end
