//
//  UCFLockConfig.h
//  JRGC
//
//  Created by zrc on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#ifndef UCFLockConfig_h
#define UCFLockConfig_h

typedef enum {
    RCLockViewTypeCheck,  // 检查手势密码
    RCLockViewTypeCreate, // 创建手势密码
    RCLockViewTypeModify, // 修改
    RCLockViewTypeClean,  // 清除
}RCLockViewType;

#define WidthScale  [[UIScreen mainScreen] bounds].size.width/375.0f
#define HeightScale [[UIScreen mainScreen] bounds].size.height/812.0f

#endif /* UCFLockConfig_h */

