//
//  UCFAttachModel.h
//  JRGC
//
//  Created by njw on 2017/9/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFAttachModel : NSObject
@property (copy, nonatomic) NSString *giftName;
@property (copy, nonatomic) NSString *giftNum;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *statusTxt;
@property (copy, nonatomic) NSString *status;

+ (instancetype)attachListWithDict:(NSDictionary *)dict;
@end
