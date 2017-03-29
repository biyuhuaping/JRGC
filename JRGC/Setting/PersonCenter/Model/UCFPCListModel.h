//
//  UCFPCListModel.h
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFSettingArrowItem.h"

@interface UCFPCListModel : UCFSettingItem
@property (nonatomic, assign) Class destVcClass;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) NSString    *describeWord;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;
@end
