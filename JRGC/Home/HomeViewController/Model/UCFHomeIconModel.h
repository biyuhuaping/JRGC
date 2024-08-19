//
//  UCFHomeIconModel.h
//  JRGC
//
//  Created by njw on 2017/9/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFHomeIconModel : NSObject
+ (instancetype)homeIconListWithDict:(NSDictionary *)dict;

@property (copy, nonatomic) NSString *desction;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *productName;
@property (copy, nonatomic) NSString *productNum;
@property (strong, nonatomic) NSNumber *type;
@property (copy, nonatomic) NSString *url;
@end
