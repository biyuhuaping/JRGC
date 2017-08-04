//
//  UCFConstractModel.h
//  JRGC
//
//  Created by NJW on 15/5/12.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFConstractModel : NSObject
// 合同id
@property (nonatomic, copy) NSString *Id;
// 合同名称
@property (nonatomic, copy) NSString *contracttitle;
// 合同状态
@property (nonatomic, copy) NSString *signStatus;
// 合同内容
@property (nonatomic, copy) NSString *contractContent;
// 合同类型
@property (nonatomic, copy) NSString *contractType;
// 合同Url
@property (nonatomic, copy) NSString *contractDownUrl;
/*
 
 "contracttitle":"出借咨询与服务协议","contractType":"5","signStatus":"1","contractContent":""
 */

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)constractWithDict:(NSDictionary *)dict;
@end
