//
//  UCFExchangeModel.h
//  JRGC
//
//  Created by biyuhuaping on 16/4/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFExchangeModel : NSObject

@property (strong, nonatomic) NSString *amount;     //兑换券金额
@property (strong, nonatomic) NSString *couponUrl;  //商品详情基本url
@property (strong, nonatomic) NSString *prdName;    //商品名称
@property (strong, nonatomic) NSString *prdState;   //商品状态
@property (strong, nonatomic) NSString *prided;     //优惠券id
@property (strong, nonatomic) NSString *remarks;    //备注
@property (strong, nonatomic) NSString *source;     //商品来源
@property (strong, nonatomic) NSString *validityDate;//有效期
@property (strong, nonatomic) NSString *usedTime;    //使用时间
@property (strong, nonatomic) NSString *pointsPrice;//工分（积分）
@property (assign, nonatomic) NSInteger state;

- (id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)couponWithDict:(NSDictionary *)dict;

@end
