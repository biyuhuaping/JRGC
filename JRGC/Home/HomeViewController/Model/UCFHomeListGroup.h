//
//  UCFHomeListGroup.h
//  JRGC
//
//  Created by njw on 2017/5/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFSettingGroup.h"
#import "UCFHomeListCellModel.h"

@interface UCFHomeListGroup : UCFSettingGroup
// 头部图片
@property (nonatomic, copy) NSString *headerImage;

@property (nonatomic, assign) BOOL showMore;

@property (nonatomic, strong) NSArray *attach;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *prdlist;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconUrl;

+ (instancetype)homeListGroupWithDict:(NSDictionary *)dict;
@end
