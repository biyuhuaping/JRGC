//
//  UCFGDYouHuiModel.h
//  JRGC
//
//  Created by HeJing on 15/1/5.
//  Copyright (c) 2015年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGDYouHuiModel : NSObject

// 发放类型
@property(nonatomic, copy)NSString *fafangStyle;
// 发放时间
@property(nonatomic, copy)NSString *fafangTime;
// 工豆总数
@property(nonatomic, copy)NSString *gongDouCount;
// 已用
@property(nonatomic, copy)NSString *alreadyUse;
// 未用
@property(nonatomic, copy)NSString *noUse;
// 已过期
@property(nonatomic, copy)NSString *alreadyExpired;
//有效期至
@property(nonatomic, copy)NSString *youxiao;

- (instancetype)initWithGongDouDict:(NSDictionary *)dict;
+ (instancetype)gongDouWithDict:(NSDictionary *)dict;

@end
