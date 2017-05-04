//
//  MongoliaLayerCenter.h
//  JRGC
//
//  Created by 张瑞超 on 2017/5/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MongoliaLayerCenter : NSObject
//蒙层显示数组
@property (nonatomic, strong) NSMutableDictionary *mongoliaLayerDic;

+ (MongoliaLayerCenter *)sharedManager;
- (void)showLogic;

@end
