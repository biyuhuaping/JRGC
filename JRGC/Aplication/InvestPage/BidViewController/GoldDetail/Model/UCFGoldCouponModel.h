//
//  UCFGoldCouponModel.h
//  JRGC
//
//  Created by hanqiyuan on 2017/8/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldCouponModel : NSObject
/*
 
 goldAccount	返金克重	string
 goldCouponId	黄金券ID	string
 investMin	最小投资克重	string
 investPeriod	投资期限	string
 issueTime	券发放时间	string
 overdueTime	过期时间	string
 remark	备注字段	string
 validityStatus	是否即将过期	string	0是，1否
 */
@property(nonatomic,copy) NSString *goldAccount;//返金克重

@property(nonatomic,copy) NSString *goldCouponId;//黄金券ID

@property(nonatomic,copy) NSString *investMin;//最小投资克重	string;

@property(nonatomic,copy) NSString *investPeriod;//投资期限	string;

@property(nonatomic,copy)NSString *issueTime;//券发放时间	string;

@property(nonatomic,copy)NSString *overdueTime;//过期时间	string;

@property(nonatomic,copy)NSString *remark;//备注字段	string;

@property(nonatomic,copy)NSString *validityStatus;//是否即将过期	string	0是，1否;

@property(nonatomic,assign)BOOL isSelectedStatus;//该返金券是否被选中
//初始化方法
- (id)initWithDictionary:(NSDictionary *)dicJson;
@end
