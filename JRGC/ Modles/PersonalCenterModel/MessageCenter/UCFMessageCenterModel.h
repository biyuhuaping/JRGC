//
//  UCFMessageCenterModel.h
//  JRGC
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFMessageCenterModel : NSObject

// 用户id
@property(nonatomic, copy)NSString *userId;
// 是否已读
@property(nonatomic, copy)NSString *isUse;
// 消息标题
@property(nonatomic, copy)NSString *title;
// 消息内容有链接 
@property(nonatomic, copy)NSString *content;
// 消息内容删除点击查看链接
@property(nonatomic, copy)NSString *delHTMLTagContent;
// 创建时间
@property(nonatomic, copy)NSString *createTime;
// 消息id
@property(nonatomic, copy)NSString *messageId;


- (instancetype)initWithMessageDict:(NSDictionary *)dict;
+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
