//
//  UCFFriendRegisterListModel.h
//  JRGC
//
//  Created by 金融工场 on 14/11/28.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFFriendRegisterListModel : NSObject

//名字
@property(nonatomic, copy)NSString *loginName;
@property(nonatomic, copy)NSString *realName;
@property(nonatomic, copy)NSString *numPhone;
@property(nonatomic, copy)NSString *createTime;

- (instancetype)initWithRegisterDict:(NSDictionary *)dict;
+ (instancetype)friendRegistWithDict:(NSDictionary *)dict;

@end
