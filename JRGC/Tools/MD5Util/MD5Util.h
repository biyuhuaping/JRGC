//
//  MD5Util.h
//  JRGC
//
//  Created by 金融工场 on 16/8/10.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Util : NSObject
/**
 *  返回加密后的密码
 *
 *  @param originalPwd 原始密码
 *
 *  @return 加密后密码
 */
+ (NSString *)MD5Pwd:(NSString *)originalPwd;
@end
