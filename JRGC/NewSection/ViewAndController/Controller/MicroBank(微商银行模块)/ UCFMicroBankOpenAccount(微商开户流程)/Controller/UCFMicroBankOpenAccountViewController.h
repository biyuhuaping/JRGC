//
//  UCFMicroBankOpenAccountViewController.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountViewController : UCFBaseViewController
//尊享已经不可能再有新用户或者白名单用户,去开户或者设置交易密码,所以开户流程里把尊享去掉,但是尊享用户还可以修改交易密码

@property (nonatomic, assign) BOOL openAccountSucceed;//开户成功

//@property (nonatomic, assign) BOOL tradersPasswordSucceed;//设置交易密码成功
@end

NS_ASSUME_NONNULL_END
