//
//  UCFMicroMoneyGroup.h
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFSettingGroup.h"

@interface UCFMicroMoneyGroup : UCFSettingGroup
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *prdlist;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) BOOL showMore;

+ (instancetype)microMoneyGroupWithDict:(NSDictionary *)dict;
@end
