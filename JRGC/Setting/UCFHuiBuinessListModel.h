//
//  UCFHuiBuinessListModel.h
//  JRGC
//
//  Created by NJW on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFHuiBuinessListModel : NSObject
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *desc;

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)hsAssetBeanWithDict:(NSDictionary *)dict;

@end
