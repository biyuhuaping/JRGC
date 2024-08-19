//
//  HUDManager.h
//
//  Created by biyuhuaping on 2016/11/8.
//  Copyright © 2018年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDManager : NSObject

+ (instancetype)manager;
- (void)showHUDWithView:(UIView *)view;
- (void)showHudWithText:(NSString *)text;
- (void)showHudWithCode:(NSInteger)code WithText:(NSString *)text;
- (void)hide;

@end
