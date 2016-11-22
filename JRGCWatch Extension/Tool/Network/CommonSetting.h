//
//  CommonSetting.h
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#ifndef CommonSetting_h
#define CommonSetting_h

#define SIGNATUREAPP       @"signature"

#define WEAKSELF(CLASSNAME) __weak CLASSNAME *weakSelf = self;

#define UIColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif /* CommonSetting_h */
