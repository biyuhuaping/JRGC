//
//  LockFlagSingle.h
//  JRGC
//  用于标示   密码输入页 的一些标记位
//  Created by 金融工场 on 15/9/16.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UILockShowWhatSection) {
    LockDefault = 0,        //默认样式
    LockGesture,            //手势页
    LockFingerprint,        //指纹页
};

typedef NS_ENUM(NSInteger, DisappearType) {
    DisDefault = 0,        //默认样式
    DisHome                //通过home键推到后台
};
@interface LockFlagSingle : NSObject

@property(nonatomic)UILockShowWhatSection      showSection;
@property(nonatomic)DisappearType              disappearType;
@property(nonatomic,copy) NSString             *netVersion;
/**
 *  单利对象获取
 *
 *  @return 单利对象
 */
+ (LockFlagSingle *)sharedManager;
@end
