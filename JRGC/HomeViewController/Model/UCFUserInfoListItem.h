//
//  UCFUserInfoListItem.h
//  JRGC
//
//  Created by njw on 2017/5/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFSettingItem.h"

@interface UCFUserInfoListItem : UCFSettingItem
@property (nonatomic, assign) Class destVcClass;
@property (nonatomic, assign) BOOL isShow;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;
@end
