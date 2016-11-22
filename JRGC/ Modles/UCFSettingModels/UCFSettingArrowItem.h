//
//  UCFSettingArrowItem.h
//  JRGC
//
//  Created by NJW on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingItem.h"

@interface UCFSettingArrowItem : UCFSettingItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;

@property (nonatomic, copy) NSString    *mainStoryBoardStr;
@property (nonatomic, copy) NSString    *storyId;

//@property (nonatomic, assign)  MJSettingArrowItemVcShowType  vcShowType;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destStoryBoardStr:(NSString *)mainStoryBoard storyIdStr:(NSString *)storyIdStr;
@end
