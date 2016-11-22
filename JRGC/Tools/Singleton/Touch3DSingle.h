//
//  Touch3DSingle.h
//  JRGC
//
//  Created by biyuhuaping on 15/11/3.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Touch3DSingle : NSObject

@property (nonatomic) BOOL isLoad;//是否已加载过
@property (assign, nonatomic) BOOL isShowLock;//刮刮卡特殊标记（控制有手势密码时，刮刮卡在手势密码上层显示问题）YES:显示 NO:不显示
@property (strong, nonatomic) NSString *type;//类型

DEFINE_SINGLETON_FOR_HEADER(Touch3DSingle)

@end
