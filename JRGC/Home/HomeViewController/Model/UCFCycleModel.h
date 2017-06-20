//
//  UCFCycleModel.h
//  JRGC
//
//  Created by 金融工场 on 15/1/16.
//  Copyright (c) 2015年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFCycleModel : NSObject
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *dumps;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *is_activity;
@property (nonatomic,copy) NSString *down_time;
@property (nonatomic,copy) NSString *publish_time;

+ (UCFCycleModel *)getCycleModelByDataDict:(NSDictionary *)dataDict;
@end
