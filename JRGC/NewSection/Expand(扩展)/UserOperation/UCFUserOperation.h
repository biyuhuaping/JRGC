//
//  UCFUserOperation.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UCFLoginData;
NS_ASSUME_NONNULL_BEGIN

@interface UCFUserOperation : NSObject


+ (void)setUserData:(UCFLoginData *) loginData;

+ (UCFLoginData *)getUserData;

+ (void)deleteUserData;

//保存最后一次登录的账号
+ (void)saveLoginPhoneNum:(NSDictionary *)dic;

+ (NSDictionary *)getLoginPhoneNum;

//同盾
+ (NSString *) didReceiveDeviceBlackBox;
@end

NS_ASSUME_NONNULL_END
